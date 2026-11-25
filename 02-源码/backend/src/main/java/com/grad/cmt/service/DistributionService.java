package com.grad.cmt.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.grad.cmt.common.BizException;
import com.grad.cmt.common.PageResult;
import com.grad.cmt.common.UserContext;
import com.grad.cmt.entity.*;
import com.grad.cmt.mapper.*;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

/**
 * 发放域：发放追踪单的拣货、签收、归档与作废。
 *
 * 先到期先出库（FEFO）：按有效期升序、入库时间升序推荐批次，
 * 排除过期 / 锁定 / 不合格 / 可用量为 0 的批次。
 * 出库扣减使用条件更新 available_qty >= 数量，影响行数为 0 即抛异常回滚，杜绝超发。
 */
@Service
public class DistributionService {

    private final DistributionOrderMapper orderMapper;
    private final DistributionItemMapper itemMapper;
    private final InventoryBatchMapper batchMapper;
    private final AidApplicationMapper appMapper;
    private final MaterialRecordMapper recordMapper;
    private final FlowService flowService;
    private final JdbcTemplate jdbc;

    public DistributionService(DistributionOrderMapper orderMapper, DistributionItemMapper itemMapper,
                               InventoryBatchMapper batchMapper, AidApplicationMapper appMapper,
                               MaterialRecordMapper recordMapper, FlowService flowService, JdbcTemplate jdbc) {
        this.orderMapper = orderMapper;
        this.itemMapper = itemMapper;
        this.batchMapper = batchMapper;
        this.appMapper = appMapper;
        this.recordMapper = recordMapper;
        this.flowService = flowService;
        this.jdbc = jdbc;
    }

    public PageResult<DistributionOrder> orderPage(Map<String, String> p) {
        QueryWrapper<DistributionOrder> w = new QueryWrapper<>();
        if (has(p, "stage")) {
            w.eq("stage", p.get("stage"));
        }
        if (has(p, "status")) {
            w.eq("status", p.get("status"));
        }
        if (has(p, "ownerId")) {
            w.eq("owner_id", p.get("ownerId"));
        }
        if (has(p, "warehouseId")) {
            w.eq("warehouse_id", p.get("warehouseId"));
        }
        if (has(p, "keyword")) {
            w.and(x -> x.like("order_no", p.get("keyword")).or().like("receiver_name", p.get("keyword")));
        }
        w.orderByAsc("status").orderByDesc("create_time");
        Page<DistributionOrder> page = orderMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    public Map<String, Object> orderDetail(Long id) {
        DistributionOrder o = orderMapper.selectById(id);
        if (o == null) {
            throw new BizException("发放单不存在");
        }
        Map<String, Object> m = new LinkedHashMap<>();
        Map<String, Object> head = new LinkedHashMap<>();
        head.put("id", o.getId());
        head.put("orderNo", o.getOrderNo());
        head.put("receiverName", AidService.maskName(o.getReceiverName()));
        head.put("receiverPhone", AidService.maskPhone(o.getReceiverPhone()));
        head.put("region", o.getRegion());
        head.put("stage", o.getStage());
        head.put("status", o.getStatus());
        head.put("deliverType", o.getDeliverType());
        head.put("deliverAddress", o.getDeliverAddress());
        head.put("carrier", o.getCarrier());
        head.put("totalQty", o.getTotalQty());
        head.put("deadline", o.getDeadline());
        head.put("finishTime", o.getFinishTime());
        head.put("createTime", o.getCreateTime());
        head.put("updateTime", o.getUpdateTime());
        head.put("version", o.getVersion());
        m.put("order", head);
        m.put("items", itemMapper.selectList(new QueryWrapper<DistributionItem>().eq("order_id", id)));
        m.put("records", recordMapper.selectList(new QueryWrapper<MaterialRecord>()
                .eq("biz_no", o.getOrderNo()).orderByAsc("operate_time")));
        m.put("recommend", recommend(id));
        m.put("application", o.getApplicationId() == null ? null
                : appMapper.selectById(o.getApplicationId()));
        return m;
    }

    /** FEFO 推荐：每个待拣明细给出按有效期排序的可用批次 */
    public List<Map<String, Object>> recommend(Long orderId) {
        List<DistributionItem> items = itemMapper.selectList(
                new QueryWrapper<DistributionItem>().eq("order_id", orderId));
        List<Map<String, Object>> out = new ArrayList<>();
        for (DistributionItem it : items) {
            List<InventoryBatch> batches = batchMapper.selectList(new QueryWrapper<InventoryBatch>()
                    .eq("material_name", it.getMaterialName())
                    .gt("available_qty", 0)
                    .notIn("status", List.of("过期", "锁定", "不合格"))
                    .orderByAsc("expire_date").orderByAsc("in_time")
                    .last("LIMIT 3"));
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("materialName", it.getMaterialName());
            m.put("planQty", it.getPlanQty());
            m.put("unit", it.getUnit());
            m.put("batches", batches);
            out.add(m);
        }
        return out;
    }

    /**
     * 拣货：按明细逐条扣减可用量（事务）。
     * 若批次可用量不足则整单回滚，并提示具体物资。
     */
    @Transactional
    public Map<String, Object> pick(Long orderId, List<Map<String, Object>> picks) {
        DistributionOrder o = orderMapper.selectById(orderId);
        if (o == null) {
            throw new BizException("发放单不存在");
        }
        if ("已完成".equals(o.getStatus()) || "已取消".equals(o.getStatus())) {
            throw new BizException("该发放单已结束，无法拣货");
        }
        if (picks == null || picks.isEmpty()) {
            throw new BizException("请选择要拣货的批次");
        }
        for (Map<String, Object> pk : picks) {
            Long batchId = WarehouseService.toLong(pk.get("batchId"));
            int qty = WarehouseService.toInt(pk.get("qty"));
            if (batchId == null || qty <= 0) {
                throw new BizException("拣货数量必须大于 0");
            }
            InventoryBatch b = batchMapper.selectById(batchId);
            if (b == null) {
                throw new BizException("批次不存在");
            }
            if (List.of("过期", "锁定", "不合格").contains(b.getStatus())) {
                throw new BizException("批次 " + b.getBatchNo() + " 状态为「" + b.getStatus() + "」，不可出库");
            }
            // 条件更新保证并发下不超发：可用量不足时影响行数为 0
            int rows = jdbc.update("UPDATE inventory_batch SET available_qty = available_qty - ? "
                    + "WHERE id = ? AND available_qty >= ? AND status NOT IN ('过期','锁定','不合格')",
                    qty, batchId, qty);
            if (rows == 0) {
                throw new BizException("批次 " + b.getBatchNo() + " 可用量不足，当前仅剩 "
                        + b.getAvailableQty() + " " + b.getUnit());
            }
            jdbc.update("UPDATE inventory_batch SET issue_status = CASE WHEN available_qty = 0 THEN '已发完' "
                    + "WHEN available_qty < in_qty THEN '部分发放' ELSE issue_status END WHERE id = ?", batchId);

            DistributionItem it = itemMapper.selectOne(new QueryWrapper<DistributionItem>()
                    .eq("order_id", orderId).eq("material_name", b.getMaterialName()).last("LIMIT 1"));
            if (it != null) {
                it.setBatchId(batchId);
                it.setActualQty((it.getActualQty() == null ? 0 : it.getActualQty()) + qty);
                it.setPickTime(LocalDateTime.now());
                it.setRemark("FEFO 推荐批次");
                itemMapper.updateById(it);
            }
        }
        o.setStage("签收回执");
        o.setStatus("处理中");
        orderMapper.updateById(o);
        flowService.record("发放追踪单", orderId, o.getOrderNo(), "分配出库", "签收回执", "拣货完成",
                "按先到期先出库扣减库存，共 " + picks.size() + " 个批次");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("stage", o.getStage());
        res.put("picked", picks.size());
        return res;
    }

    /**
     * 状态推进：签收（签收回执→追踪归档）、归档（→已完成）、取消/作废。
     * 取消与作废必须写不少于 5 字的原因。
     */
    public void transition(Long id, String action, String reason) {
        DistributionOrder o = orderMapper.selectById(id);
        if (o == null) {
            throw new BizException("发放单不存在");
        }
        String from = o.getStage();
        switch (action) {
            case "sign", "签收" -> {
                if (!"签收回执".equals(o.getStage())) {
                    throw new BizException("当前阶段为「" + o.getStage() + "」，只有签收回执阶段可以签收");
                }
                o.setStage("追踪归档");
                o.setStatus("处理中");
            }
            case "archive", "归档" -> {
                if (!"追踪归档".equals(o.getStage())) {
                    throw new BizException("当前阶段为「" + o.getStage() + "」，只有追踪归档阶段可以归档");
                }
                o.setStatus("已完成");
                o.setFinishTime(LocalDateTime.now());
            }
            case "cancel", "取消", "作废" -> {
                if (reason == null || reason.trim().length() < 5) {
                    throw new BizException("取消或作废必须填写不少于 5 个字的原因");
                }
                if ("已完成".equals(o.getStatus())) {
                    throw new BizException("已完成的发放单不能作废");
                }
                o.setStatus("已取消");
                o.setCancelReason(reason.trim());
            }
            default -> throw new BizException("不支持的操作：" + action);
        }
        // 并发校验：基于版本号条件更新，被他人先改过则提示刷新，不覆盖提交
        int rows = jdbc.update("UPDATE distribution_order SET version = version + 1 WHERE id = ? AND version = ?",
                id, o.getVersion() == null ? 0 : o.getVersion());
        if (rows == 0) {
            throw new BizException("该单据已被他人更新，请刷新后重试");
        }
        o.setVersion((o.getVersion() == null ? 0 : o.getVersion()) + 1);
        orderMapper.updateById(o);
        flowService.record("发放追踪单", id, o.getOrderNo(), from, o.getStage(),
                "签收".equals(action) || "sign".equals(action) ? "签收回执"
                        : ("归档".equals(action) || "archive".equals(action) ? "追踪归档" : "作废"), reason);
        if (o.getApplicationId() != null) {
            AidApplication a = appMapper.selectById(o.getApplicationId());
            if (a != null) {
                if ("已完成".equals(o.getStatus())) {
                    a.setStatus("已完成");
                } else if ("追踪归档".equals(o.getStage())) {
                    a.setStatus("待反馈");
                } else if ("已取消".equals(o.getStatus())) {
                    a.setStatus("已取消");
                }
                appMapper.updateById(a);
            }
        }
    }

    /** 公开报表（脱敏）：不含姓名、联系方式、住址与证明文件 */
    public Map<String, Object> publicReport() {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("regionRank", jdbc.queryForList(
                "SELECT region AS name, COUNT(*) AS cnt FROM distribution_order "
                        + "WHERE status='已完成' GROUP BY region ORDER BY cnt DESC"));
        m.put("categoryIn", jdbc.queryForList(
                "SELECT category AS name, SUM(in_qty) AS cnt FROM inventory_batch "
                        + "WHERE deleted=0 GROUP BY category ORDER BY cnt DESC"));
        m.put("projects", jdbc.queryForList(
                "SELECT p.title AS title, p.target_qty AS target, p.received_qty AS received, "
                        + "p.status AS status FROM donation_project p ORDER BY p.id DESC"));
        m.put("records", jdbc.queryForList(
                "SELECT o.order_no AS orderNo, a.region AS region, d.material_name AS material, "
                        + "d.actual_qty AS qty, o.finish_time AS finishTime, CONCAT(LEFT(a.applicant_name,1),'**') AS person "
                        + "FROM distribution_order o JOIN aid_application a ON a.id = o.application_id "
                        + "LEFT JOIN distribution_item d ON d.order_id = o.id "
                        + "WHERE o.status='已完成' ORDER BY o.finish_time DESC LIMIT 50"));
        return m;
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
}
