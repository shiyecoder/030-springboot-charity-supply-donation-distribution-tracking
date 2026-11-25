package com.grad.cmt.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.grad.cmt.common.BizException;
import com.grad.cmt.common.PageResult;
import com.grad.cmt.entity.*;
import com.grad.cmt.mapper.*;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * 仓储域：收货验收（差异登记 + 生成批次）、批次台账、库存盘点。
 *
 * 库存状态自动判定：有效期已过 → 过期；剩余 ≤30 天 → 临期；手工锁定优先。
 * 过期、锁定、不合格批次不可出库，由 DistributionService 在拣货时再次校验。
 */
@Service
public class WarehouseService {

    private final ReceivingRecordMapper recordMapper;
    private final ReceivingItemMapper itemMapper;
    private final InventoryBatchMapper batchMapper;
    private final DonationIntentMapper intentMapper;
    private final DonationProjectMapper projectMapper;
    private final MaterialDemandMapper demandMapper;
    private final InventoryCheckMapper checkMapper;
    private final FlowService flowService;
    private final JdbcTemplate jdbc;

    public WarehouseService(ReceivingRecordMapper recordMapper, ReceivingItemMapper itemMapper,
                            InventoryBatchMapper batchMapper, DonationIntentMapper intentMapper,
                            DonationProjectMapper projectMapper, MaterialDemandMapper demandMapper,
                            InventoryCheckMapper checkMapper, FlowService flowService, JdbcTemplate jdbc) {
        this.recordMapper = recordMapper;
        this.itemMapper = itemMapper;
        this.batchMapper = batchMapper;
        this.intentMapper = intentMapper;
        this.projectMapper = projectMapper;
        this.demandMapper = demandMapper;
        this.checkMapper = checkMapper;
        this.flowService = flowService;
        this.jdbc = jdbc;
    }

    /** 按有效期刷新批次库存状态（锁定状态不覆盖） */
    public void refreshBatchStatus() {
        jdbc.update("UPDATE inventory_batch SET status='过期' WHERE deleted=0 AND expire_date IS NOT NULL "
                + "AND expire_date < CURDATE() AND status NOT IN ('锁定')");
        jdbc.update("UPDATE inventory_batch SET status='临期' WHERE deleted=0 AND expire_date IS NOT NULL "
                + "AND expire_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY) "
                + "AND status NOT IN ('锁定','过期')");
        jdbc.update("UPDATE inventory_batch SET status='正常' WHERE deleted=0 AND status='临期' "
                + "AND (expire_date IS NULL OR expire_date > DATE_ADD(CURDATE(), INTERVAL 30 DAY))");
    }

    public PageResult<ReceivingRecord> receivingPage(Map<String, String> p) {
        QueryWrapper<ReceivingRecord> w = new QueryWrapper<>();
        if (has(p, "status")) {
            w.eq("status", p.get("status"));
        }
        if (has(p, "result")) {
            w.eq("result", p.get("result"));
        }
        if (has(p, "keyword")) {
            w.like("receive_no", p.get("keyword"));
        }
        w.orderByDesc("receive_time");
        Page<ReceivingRecord> page = recordMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    public Map<String, Object> receivingDetail(Long id) {
        ReceivingRecord r = recordMapper.selectById(id);
        if (r == null) {
            throw new BizException("收货单不存在");
        }
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("record", r);
        m.put("items", itemMapper.selectList(new QueryWrapper<ReceivingItem>().eq("receive_id", id)));
        m.put("intent", r.getIntentId() == null ? null : intentMapper.selectById(r.getIntentId()));
        m.put("batches", batchMapper.selectList(new QueryWrapper<InventoryBatch>().eq("receive_id", id)));
        return m;
    }

    /**
     * 提交验收并生成批次（事务）：
     * 1) 汇总实收/合格/不合格并计算不合格率；
     * 2) 每条明细生成一个入库批次，可用量 = 合格数量；
     * 3) 回写意向状态、需求已入库量与项目已接收量；
     * 4) 落状态流转记录。
     */
    @Transactional
    public Map<String, Object> submitReceiving(Map<String, Object> body) {
        Long recordId = toLong(body.get("recordId"));
        ReceivingRecord r = recordMapper.selectById(recordId);
        if (r == null) {
            throw new BizException("收货单不存在");
        }
        if ("已入库".equals(r.getStatus())) {
            throw new BizException("该收货单已完成验收，不能重复提交");
        }
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> items = (List<Map<String, Object>>) body.get("items");
        if (items == null || items.isEmpty()) {
            throw new BizException("请至少填写一条验收明细");
        }

        int actual = 0, unqualified = 0;
        List<InventoryBatch> created = new ArrayList<>();
        for (Map<String, Object> it : items) {
            String name = str(it.get("materialName"));
            if (name == null || name.isBlank()) {
                throw new BizException("明细中的物资名称不能为空");
            }
            int ac = toInt(it.get("actualQty"));
            int unq = toInt(it.get("unqualifiedQty"));
            if (ac < 0 || unq < 0) {
                throw new BizException("数量不能为负数");
            }
            if (unq > ac) {
                throw new BizException("不合格数不能大于实收数量");
            }
            actual += ac;
            unqualified += unq;

            ReceivingItem ri = new ReceivingItem();
            ri.setReceiveId(recordId);
            ri.setMaterialName(name);
            ri.setCategory(str(it.get("category")));
            ri.setSpec(str(it.get("spec")));
            ri.setUnit(str(it.get("unit")));
            ri.setExpectQty(toInt(it.get("expectQty")));
            ri.setActualQty(ac);
            ri.setQualityLevel(str(it.get("qualityLevel")));
            ri.setExpireDate(toDate(it.get("expireDate")));
            ri.setUnqualifiedQty(unq);
            ri.setDiffQty(ac - ri.getExpectQty());
            itemMapper.insert(ri);

            InventoryBatch b = new InventoryBatch();
            b.setBatchNo("BAT-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyMMdd"))
                    + "-" + String.format("%02d", new Random().nextInt(90) + 10));
            b.setMaterialName(name);
            b.setCategory(ri.getCategory());
            b.setSpec(ri.getSpec());
            b.setUnit(ri.getUnit());
            b.setReceiveId(recordId);
            b.setIntentId(r.getIntentId());
            b.setWarehouseId(r.getWarehouseId());
            b.setPosition(str(it.get("position")) == null ? "待分配" : str(it.get("position")));
            b.setInQty(ac);
            b.setAvailableQty(Math.max(ac - unq, 0));
            b.setLockedQty(unq);
            b.setQualityLevel(ri.getQualityLevel());
            b.setMaterialImage(str(it.get("materialImage")));
            b.setExpireDate(ri.getExpireDate());
            b.setInTime(LocalDateTime.now());
            b.setStatus("正常");
            b.setIssueStatus("未发放");
            b.setCheckUserId(r.getReceiveUserId());
            if (r.getIntentId() != null) {
                DonationIntent in = intentMapper.selectById(r.getIntentId());
                if (in != null) {
                    b.setDonorName(in.getDonorName());
                    b.setProjectId(in.getProjectId());
                }
            }
            batchMapper.insert(b);
            created.add(b);
        }

        BigDecimal rate = actual == 0 ? BigDecimal.ZERO
                : BigDecimal.valueOf(unqualified * 100.0 / actual).setScale(2, RoundingMode.HALF_UP);
        r.setActualQty(actual);
        r.setUnqualifiedQty(unqualified);
        r.setQualifiedQty(actual - unqualified);
        r.setUnqualifiedRate(rate);
        r.setResult(rate.compareTo(BigDecimal.valueOf(2)) > 0 ? "部分接收" : "接收");
        r.setStatus("已入库");
        recordMapper.updateById(r);

        if (r.getIntentId() != null) {
            DonationIntent in = intentMapper.selectById(r.getIntentId());
            if (in != null) {
                in.setStatus("部分接收".equals(r.getResult()) ? "部分接收" : "已入库");
                intentMapper.updateById(in);
                if (in.getProjectId() != null) {
                    DonationProject pj = projectMapper.selectById(in.getProjectId());
                    if (pj != null) {
                        pj.setReceivedQty((pj.getReceivedQty() == null ? 0 : pj.getReceivedQty()) + r.getQualifiedQty());
                        projectMapper.updateById(pj);
                    }
                }
                // 需求缺口同步（同项目 + 同品名）
                List<MaterialDemand> ds = demandMapper.selectList(new QueryWrapper<MaterialDemand>()
                        .eq("material_name", created.isEmpty() ? "" : created.get(0).getMaterialName())
                        .eq(in.getProjectId() != null, "project_id", in.getProjectId()));
                for (MaterialDemand d : ds) {
                    d.setReceivedQty((d.getReceivedQty() == null ? 0 : d.getReceivedQty()) + r.getQualifiedQty());
                    d.setGapQty(Math.max((d.getDemandQty() == null ? 0 : d.getDemandQty()) - d.getReceivedQty(), 0));
                    demandMapper.updateById(d);
                }
            }
        }

        refreshBatchStatus();
        flowService.record("收货验收", recordId, r.getReceiveNo(), "待验收", "已入库",
                "提交验收", "实收 " + actual + " 件，不合格 " + unqualified + " 件，不合格率 " + rate + "%");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("record", r);
        res.put("batchCount", created.size());
        return res;
    }

    public PageResult<InventoryBatch> batchPage(Map<String, String> p) {
        refreshBatchStatus();
        QueryWrapper<InventoryBatch> w = new QueryWrapper<>();
        if (has(p, "category")) {
            w.eq("category", p.get("category"));
        }
        if (has(p, "donorName")) {
            w.like("donor_name", p.get("donorName"));
        }
        if (has(p, "status")) {
            w.eq("status", p.get("status"));
        }
        if (has(p, "issueStatus")) {
            w.eq("issue_status", p.get("issueStatus"));
        }
        if (has(p, "keyword")) {
            w.and(x -> x.like("batch_no", p.get("keyword")).or().like("material_name", p.get("keyword")));
        }
        if (has(p, "expireScope")) {
            String s = p.get("expireScope");
            if ("临期".equals(s)) {
                w.isNotNull("expire_date").le("expire_date", LocalDate.now().plusDays(30));
            } else if ("已过期".equals(s)) {
                w.isNotNull("expire_date").lt("expire_date", LocalDate.now());
            } else if ("充足".equals(s)) {
                w.and(x -> x.isNull("expire_date").or().gt("expire_date", LocalDate.now().plusDays(30)));
            }
        }
        w.orderByAsc("expire_date").orderByDesc("in_time");
        Page<InventoryBatch> page = batchMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    public Map<String, Object> batchDetail(Long id) {
        InventoryBatch b = batchMapper.selectById(id);
        if (b == null) {
            throw new BizException("批次不存在");
        }
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("batch", b);
        m.put("records", jdbc.queryForList("SELECT * FROM charity_material_record WHERE biz_no=? ORDER BY operate_time",
                b.getBatchNo()));
        return m;
    }

    /** 锁定/解锁批次：锁定后不可出库 */
    public void toggleLock(Long id, boolean lock, String reason) {
        InventoryBatch b = batchMapper.selectById(id);
        if (b == null) {
            throw new BizException("批次不存在");
        }
        if (lock && !"正常".equals(b.getStatus()) && !"临期".equals(b.getStatus())) {
            throw new BizException("只有正常或临期批次可以锁定");
        }
        if (lock && (reason == null || reason.trim().length() < 5)) {
            throw new BizException("锁定批次必须填写不少于 5 个字的原因");
        }
        b.setStatus(lock ? "锁定" : "正常");
        batchMapper.updateById(b);
        flowService.record("物资批次", id, b.getBatchNo(), lock ? "正常" : "锁定",
                b.getStatus(), lock ? "锁定" : "解锁", reason);
    }

    public PageResult<InventoryCheck> checkPage(Map<String, String> p) {
        QueryWrapper<InventoryCheck> w = new QueryWrapper<>();
        if (has(p, "status")) {
            w.eq("status", p.get("status"));
        }
        w.orderByDesc("check_time");
        Page<InventoryCheck> page = checkMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    private boolean has(Map<String, String> p, String k) {
        return p != null && p.get(k) != null && !p.get(k).isBlank() && !p.get(k).startsWith("全部");
    }

    private <T> Page<T> page(Map<String, String> p) {
        long page = 1, size = 10;
        try {
            if (p != null && p.get("page") != null) {
                page = Math.max(1, Long.parseLong(p.get("page")));
            }
            if (p != null && p.get("size") != null) {
                size = Math.min(100, Math.max(1, Long.parseLong(p.get("size"))));
            }
        } catch (NumberFormatException ignored) {
        }
        return new Page<>(page, size);
    }

    static String str(Object o) {
        return o == null ? null : String.valueOf(o);
    }

    static int toInt(Object o) {
        if (o == null || String.valueOf(o).isBlank()) {
            return 0;
        }
        return (int) Double.parseDouble(String.valueOf(o));
    }

    static Long toLong(Object o) {
        if (o == null || String.valueOf(o).isBlank()) {
            return null;
        }
        return (long) Double.parseDouble(String.valueOf(o));
    }

    static LocalDate toDate(Object o) {
        if (o == null || String.valueOf(o).isBlank()) {
            return null;
        }
        String s = String.valueOf(o);
        try {
            return LocalDate.parse(s.length() > 10 ? s.substring(0, 10) : s);
        } catch (Exception e) {
            return null;
        }
    }
}
