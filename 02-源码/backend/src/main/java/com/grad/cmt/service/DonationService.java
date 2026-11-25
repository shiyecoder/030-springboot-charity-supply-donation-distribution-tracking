package com.grad.cmt.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.grad.cmt.common.BizException;
import com.grad.cmt.common.PageResult;
import com.grad.cmt.common.UserContext;
import com.grad.cmt.entity.*;
import com.grad.cmt.mapper.*;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 捐赠域：捐赠项目、物资与需求、捐赠意向（含预审）。
 * 缺口 = 需求数量 - 已入库数量，由后端计算后写入 gap_qty，前端只展示。
 */
@Service
public class DonationService {

    private final DonationProjectMapper projectMapper;
    private final MaterialDemandMapper demandMapper;
    private final DonationIntentMapper intentMapper;
    private final InventoryBatchMapper batchMapper;
    private final FlowService flowService;

    public DonationService(DonationProjectMapper projectMapper, MaterialDemandMapper demandMapper,
                           DonationIntentMapper intentMapper, InventoryBatchMapper batchMapper,
                           FlowService flowService) {
        this.projectMapper = projectMapper;
        this.demandMapper = demandMapper;
        this.intentMapper = intentMapper;
        this.batchMapper = batchMapper;
        this.flowService = flowService;
    }

    public PageResult<DonationProject> projectPage(Map<String, String> p) {
        QueryWrapper<DonationProject> w = new QueryWrapper<>();
        if (has(p, "status")) {
            w.eq("status", p.get("status"));
        }
        if (has(p, "serviceTarget")) {
            w.eq("service_target", p.get("serviceTarget"));
        }
        if (has(p, "warehouseId")) {
            w.eq("warehouse_id", p.get("warehouseId"));
        }
        if (has(p, "keyword")) {
            w.and(x -> x.like("title", p.get("keyword")).or().like("project_no", p.get("keyword")));
        }
        w.orderByDesc("create_time");
        Page<DonationProject> page = projectMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    public DonationProject project(Long id) {
        return projectMapper.selectById(id);
    }

    public void saveProject(DonationProject project) {
        if (project.getTitle() == null || project.getTitle().isBlank()) {
            throw new BizException("项目主题不能为空");
        }
        if (project.getId() == null) {
            if (project.getProjectNo() == null || project.getProjectNo().isBlank()) {
                project.setProjectNo("PRJ-" + LocalDateTime.now().getYear() + "-"
                        + String.format("%03d", projectMapper.selectCount(null) + 1));
            }
            project.setReceivedQty(0);
            project.setDistributedQty(0);
            projectMapper.insert(project);
        } else {
            projectMapper.updateById(project);
        }
    }

    public PageResult<MaterialDemand> demandPage(Map<String, String> p) {
        QueryWrapper<MaterialDemand> w = new QueryWrapper<>();
        if (has(p, "category")) {
            w.eq("category", p.get("category"));
        }
        if (has(p, "keyword")) {
            w.like("material_name", p.get("keyword"));
        }
        if (has(p, "gapStatus")) {
            String g = p.get("gapStatus");
            if ("缺口较大".equals(g)) {
                w.gt("gap_qty", 300);
            } else if ("接近达标".equals(g)) {
                w.le("gap_qty", 300);
            } else if ("已满足".equals(g)) {
                w.le("gap_qty", 0);
            }
        }
        w.orderByDesc("gap_qty");
        Page<MaterialDemand> page = demandMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    public PageResult<DonationIntent> intentPage(Map<String, String> p) {
        QueryWrapper<DonationIntent> w = new QueryWrapper<>();
        if (has(p, "status")) {
            w.eq("status", p.get("status"));
        }
        if (has(p, "projectId")) {
            w.eq("project_id", p.get("projectId"));
        }
        if (has(p, "deliveryType")) {
            w.eq("delivery_type", p.get("deliveryType"));
        }
        if (has(p, "keyword")) {
            w.and(x -> x.like("intent_no", p.get("keyword")).or().like("donor_name", p.get("keyword")));
        }
        // 数据范围：捐赠人只看本人提交的意向
        if ("DONOR".equals(UserContext.role())) {
            w.eq("donor_id", UserContext.userId());
        }
        w.orderByAsc("status").orderByDesc("create_time");
        Page<DonationIntent> page = intentMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    public DonationIntent intent(Long id) {
        return intentMapper.selectById(id);
    }

    /** 新增捐赠意向：编号后端生成，状态固定为待预审 */
    public DonationIntent createIntent(DonationIntent in) {
        if (in.getMaterialName() == null || in.getMaterialName().isBlank()) {
            throw new BizException("物资名称不能为空");
        }
        if (in.getEstQty() == null || in.getEstQty() <= 0) {
            throw new BizException("预估数量必须大于 0");
        }
        in.setIntentNo("INT-" + String.format("%04d", 900 + intentMapper.selectCount(null)));
        in.setStatus("待预审");
        in.setDonorId(UserContext.userId());
        if (in.getDonorName() == null) {
            in.setDonorName(UserContext.name());
        }
        intentMapper.insert(in);
        flowService.record("捐赠意向", in.getId(), in.getIntentNo(), "—", "待预审", "提交意向", null);
        return in;
    }

    /**
     * 预审：接收 → 待送达；不接收 → 已拒收（必须写不少于 5 字的理由）。
     * 同时回填预计仓位与验收要求。
     */
    public void precheck(Long id, String result, String position, String opinion, String rejectReason) {
        DonationIntent in = intentMapper.selectById(id);
        if (in == null) {
            throw new BizException("意向不存在");
        }
        if (!"待预审".equals(in.getStatus())) {
            throw new BizException("当前状态为「" + in.getStatus() + "」，只有待预审的意向可以预审");
        }
        if ("不接收".equals(result)) {
            if (rejectReason == null || rejectReason.trim().length() < 5) {
                throw new BizException("不接收时必须填写不少于 5 个字的理由");
            }
            in.setStatus("已拒收");
            in.setRejectReason(rejectReason.trim());
        } else {
            in.setStatus("待送达");
            in.setPosition(position);
            in.setPrecheckOpinion(opinion);
        }
        in.setAuditorId(UserContext.userId());
        intentMapper.updateById(in);
        flowService.record("捐赠意向", id, in.getIntentNo(), "待预审", in.getStatus(),
                "预审" + result, rejectReason == null ? opinion : rejectReason);
        flowService.notify(in.getDonorId(), "待送达".equals(in.getStatus()) ? "预审通过" : "已退回",
                "捐赠意向预审结果", "意向 " + in.getIntentNo() + " 预审结果：" + in.getStatus(),
                "intent", in.getIntentNo(), id, "/intent-list");
    }

    private boolean has(Map<String, String> p, String k) {
        return p != null && p.get(k) != null && !p.get(k).isBlank() && !"全部".equals(p.get(k))
                && !"全部状态".equals(p.get(k)) && !"全部类别".equals(p.get(k));
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
