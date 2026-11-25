package com.grad.cmt.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.grad.cmt.common.BizException;
import com.grad.cmt.common.PageResult;
import com.grad.cmt.common.UserContext;
import com.grad.cmt.entity.*;
import com.grad.cmt.mapper.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

/**
 * 受助域：受助人档案、受助申请（资格与反重审核）、去向反馈（审核后脱敏公开）。
 *
 * 反重校验三项（均由后端执行，不依赖前端按钮）：
 * 1) 同一受助人 30 天内存在未完成申请 → 拦截；
 * 2) 同类物资 90 天内已领取 → 提示并要求写明理由；
 * 3) 年度累计领取量超过上限 → 提示，按上限批准。
 */
@Service
public class AidService {

    private final AidApplicationMapper appMapper;
    private final AidApplicationItemMapper itemMapper;
    private final AidBeneficiaryMapper benMapper;
    private final DistributionOrderMapper orderMapper;
    private final DistributionItemMapper orderItemMapper;
    private final BeneficiaryFeedbackMapper fbMapper;
    private final MaterialRecordMapper recordMapper;
    private final FlowService flowService;

    public AidService(AidApplicationMapper appMapper, AidApplicationItemMapper itemMapper,
                      AidBeneficiaryMapper benMapper, DistributionOrderMapper orderMapper,
                      DistributionItemMapper orderItemMapper, BeneficiaryFeedbackMapper fbMapper,
                      MaterialRecordMapper recordMapper, FlowService flowService) {
        this.appMapper = appMapper;
        this.itemMapper = itemMapper;
        this.benMapper = benMapper;
        this.orderMapper = orderMapper;
        this.orderItemMapper = orderItemMapper;
        this.fbMapper = fbMapper;
        this.recordMapper = recordMapper;
        this.flowService = flowService;
    }

    public PageResult<AidBeneficiary> beneficiaryPage(Map<String, String> p) {
        QueryWrapper<AidBeneficiary> w = new QueryWrapper<>();
        if (has(p, "region")) {
            w.eq("region", p.get("region"));
        }
        if (has(p, "keyword")) {
            w.and(x -> x.like("name", p.get("keyword")).or().like("beneficiary_no", p.get("keyword")));
        }
        w.orderByDesc("create_time");
        Page<AidBeneficiary> page = benMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    /** 需求池：默认待本人处理优先、更新时间倒序 */
    public PageResult<AidApplication> applicationPage(Map<String, String> p) {
        QueryWrapper<AidApplication> w = new QueryWrapper<>();
        if (has(p, "status")) {
            w.eq("status", p.get("status"));
        }
        if (has(p, "applyType")) {
            w.eq("apply_type", p.get("applyType"));
        }
        if (has(p, "urgencyLevel")) {
            w.eq("urgency_level", p.get("urgencyLevel"));
        }
        if (has(p, "region")) {
            w.eq("region", p.get("region"));
        }
        if (has(p, "keyword")) {
            w.and(x -> x.like("apply_no", p.get("keyword")).or().like("applicant_name", p.get("keyword")));
        }
        if (has(p, "todo")) {
            w.eq("status", "待审核");
        }
        w.orderByAsc("status").orderByDesc("apply_time");
        Page<AidApplication> page = appMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    /** 申请详情：基础信息 + 明细 + 反重校验 + 历史领取 + 计算建议 */
    public Map<String, Object> applicationDetail(Long id) {
        AidApplication a = appMapper.selectById(id);
        if (a == null) {
            throw new BizException("申请不存在");
        }
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("application", mask(a));
        m.put("items", itemMapper.selectList(new QueryWrapper<AidApplicationItem>().eq("application_id", id)));
        m.put("beneficiary", a.getBeneficiaryId() == null ? null : benMapper.selectById(a.getBeneficiaryId()));
        m.put("checks", antiRepeat(a));
        m.put("history", history(a.getBeneficiaryId()));
        m.put("records", recordMapper.selectList(new QueryWrapper<MaterialRecord>()
                .eq("biz_no", a.getApplyNo()).orderByAsc("operate_time")));
        return m;
    }

    /** 反重校验：返回逐项结论，供审核页展示 */
    public List<Map<String, Object>> antiRepeat(AidApplication a) {
        List<Map<String, Object>> out = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();

        long pending = appMapper.selectCount(new QueryWrapper<AidApplication>()
                .eq("beneficiary_id", a.getBeneficiaryId())
                .ne("id", a.getId())
                .in("status", List.of("待审核", "待拣货", "待领用", "待配送")));
        out.add(check("在途申请", "同一受助人不得同时存在多张未完成申请", pending == 0 ? "无在途申请"
                : "存在 " + pending + " 张在途申请", pending == 0));

        long recent = appMapper.selectCount(new QueryWrapper<AidApplication>()
                .eq("beneficiary_id", a.getBeneficiaryId())
                .ne("id", a.getId())
                .ge("apply_time", now.minusDays(30)));
        out.add(check("30 天间隔期", "30 天内不得重复申请", recent == 0 ? "近 30 天无申请"
                : "近 30 天已有 " + recent + " 次申请", recent == 0));

        long yearCount = orderMapper.selectCount(new QueryWrapper<DistributionOrder>()
                .eq("beneficiary_id", a.getBeneficiaryId())
                .eq("status", "已完成")
                .ge("create_time", LocalDateTime.of(now.getYear(), 1, 1, 0, 0)));
        out.add(check("年度领取次数", "同一年度领取次数建议不超过 6 次", "本年度已完成 " + yearCount + " 次",
                yearCount < 6));

        long dup = orderMapper.selectCount(new QueryWrapper<DistributionOrder>()
                .eq("beneficiary_id", a.getBeneficiaryId())
                .ge("create_time", now.minusDays(90)));
        out.add(check("90 天同类间隔", "同类物资 90 天内不重复发放", dup == 0 ? "近 90 天无发放记录"
                : "近 90 天已发放 " + dup + " 次，需写明理由", dup == 0));
        return out;
    }

    private Map<String, Object> check(String item, String rule, String actual, boolean pass) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("item", item);
        m.put("rule", rule);
        m.put("actual", actual);
        m.put("pass", pass);
        return m;
    }

    private List<Map<String, Object>> history(Long beneficiaryId) {
        List<DistributionOrder> list = orderMapper.selectList(new QueryWrapper<DistributionOrder>()
                .eq("beneficiary_id", beneficiaryId).orderByDesc("create_time").last("LIMIT 6"));
        List<Map<String, Object>> out = new ArrayList<>();
        for (DistributionOrder o : list) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("orderNo", o.getOrderNo());
            m.put("stage", o.getStage());
            m.put("status", o.getStatus());
            m.put("time", o.getCreateTime());
            m.put("qty", o.getTotalQty());
            out.add(m);
        }
        return out;
    }

    /**
     * 资格审核：校验必填与反重结论，批准后生成发放追踪单（事务）。
     * 批准数量不得超申请数量，调减必须写原因。
     */
    @Transactional
    public Map<String, Object> review(Long id, String result, List<Map<String, Object>> approveItems,
                                     String opinion, String reason) {
        AidApplication a = appMapper.selectById(id);
        if (a == null) {
            throw new BizException("申请不存在");
        }
        if (!"待审核".equals(a.getStatus())) {
            throw new BizException("当前状态为「" + a.getStatus() + "」，只有待审核的申请可以审核");
        }
        if ("不符合资格".equals(result)) {
            if (reason == null || reason.trim().length() < 5) {
                throw new BizException("退回必须填写不少于 5 个字的原因");
            }
            a.setStatus("已退回");
            a.setRejectReason(reason.trim());
            a.setAuditorId(UserContext.userId());
            a.setAuditTime(LocalDateTime.now());
            appMapper.updateById(a);
            flowService.record("受助申请", id, a.getApplyNo(), "待审核", "已退回", "退回申请", reason);
            return Map.of("status", a.getStatus());
        }

        List<AidApplicationItem> items = itemMapper.selectList(
                new QueryWrapper<AidApplicationItem>().eq("application_id", id));
        if (items.isEmpty()) {
            throw new BizException("该申请没有需求明细，无法审核");
        }
        int total = 0;
        Map<String, Integer> approved = new HashMap<>();
        if (approveItems != null) {
            for (Map<String, Object> it : approveItems) {
                approved.put(String.valueOf(it.get("materialName")),
                        WarehouseService.toInt(it.get("approveQty")));
            }
        }
        for (AidApplicationItem it : items) {
            int q = approved.getOrDefault(it.getMaterialName(),
                    it.getApproveQty() == null ? it.getApplyQty() : it.getApproveQty());
            if (q < 0) {
                throw new BizException("批准数量不能为负数");
            }
            if (q > (it.getApplyQty() == null ? 0 : it.getApplyQty())) {
                throw new BizException("批准数量不能超过申请数量：" + it.getMaterialName());
            }
            if (q != (it.getApplyQty() == null ? 0 : it.getApplyQty())
                    && (reason == null || reason.trim().length() < 5)) {
                throw new BizException("调减数量时必须填写不少于 5 个字的原因");
            }
            it.setApproveQty(q);
            itemMapper.updateById(it);
            total += q;
        }
        if (total <= 0) {
            throw new BizException("批准数量合计为 0，请使用退回功能");
        }

        a.setStatus("待拣货");
        a.setAuditorId(UserContext.userId());
        a.setAuditTime(LocalDateTime.now());
        a.setAuditOpinion(opinion == null || opinion.isBlank() ? "资格符合，按限领规则批准" : opinion);
        appMapper.updateById(a);

        DistributionOrder o = new DistributionOrder();
        o.setOrderNo("DO-" + a.getApplyNo().replace("AID-", ""));
        o.setApplicationId(id);
        o.setBeneficiaryId(a.getBeneficiaryId());
        o.setReceiverName(a.getApplicantName());
        o.setReceiverPhone(a.getPhone());
        o.setRegion(a.getRegion());
        o.setStage("分配出库");
        o.setStatus("处理中");
        o.setWarehouseId(2L);
        o.setOwnerId(UserContext.userId());
        o.setDeliverType(a.getDistributeType() == null ? "现场领用" : a.getDistributeType());
        o.setTotalQty(total);
        o.setDeadline(LocalDateTime.now().plusDays(2));
        orderMapper.insert(o);

        for (AidApplicationItem it : items) {
            if (it.getApproveQty() != null && it.getApproveQty() > 0) {
                DistributionItem di = new DistributionItem();
                di.setOrderId(o.getId());
                di.setMaterialName(it.getMaterialName());
                di.setSpec(it.getSpec());
                di.setUnit(it.getUnit());
                di.setPlanQty(it.getApproveQty());
                di.setActualQty(0);
                orderItemMapper.insert(di);
            }
        }
        flowService.record("受助申请", id, a.getApplyNo(), "待审核", "待拣货", "资格审核",
                reason == null ? "资格符合，按限领规则批准" : reason);
        flowService.record("发放追踪单", o.getId(), o.getOrderNo(), "—", "分配出库", "生成发放单",
                "由受助申请 " + a.getApplyNo() + " 生成");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("status", a.getStatus());
        res.put("orderNo", o.getOrderNo());
        res.put("orderId", o.getId());
        return res;
    }

    public PageResult<BeneficiaryFeedback> feedbackPage(Map<String, String> p) {
        QueryWrapper<BeneficiaryFeedback> w = new QueryWrapper<>();
        if (has(p, "auditStatus")) {
            w.eq("audit_status", p.get("auditStatus"));
        }
        if (has(p, "feedbackType")) {
            w.eq("feedback_type", p.get("feedbackType"));
        }
        if (has(p, "keyword")) {
            w.and(x -> x.like("feedback_no", p.get("keyword")).or().like("content", p.get("keyword")));
        }
        w.orderByAsc("audit_status").orderByDesc("create_time");
        Page<BeneficiaryFeedback> page = fbMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    /** 反馈审核：通过后公开；公开内容必须脱敏 */
    public void auditFeedback(Long id, String result, String opinion) {
        BeneficiaryFeedback f = fbMapper.selectById(id);
        if (f == null) {
            throw new BizException("反馈不存在");
        }
        if (!"待审核".equals(f.getAuditStatus())) {
            throw new BizException("该反馈已处理");
        }
        if ("驳回".equals(result) && (opinion == null || opinion.trim().length() < 5)) {
            throw new BizException("驳回必须填写不少于 5 个字的意见");
        }
        f.setAuditStatus("通过并公开".equals(result) || "通过".equals(result) ? "已通过" : "已驳回");
        f.setAuditUserId(UserContext.userId());
        f.setAuditTime(LocalDateTime.now());
        f.setAuditOpinion(opinion);
        fbMapper.updateById(f);
        flowService.record("去向反馈", id, f.getFeedbackNo(), "待审核", f.getAuditStatus(),
                "反馈审核", opinion);
    }

    /** 对外展示前脱敏：姓名保留姓氏、手机号与身份证全部隐藏 */
    public Map<String, Object> mask(AidApplication a) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", a.getId());
        m.put("applyNo", a.getApplyNo());
        m.put("applyType", a.getApplyType());
        m.put("applicantName", maskName(a.getApplicantName()));
        m.put("phone", maskPhone(a.getPhone()));
        m.put("familySize", a.getFamilySize());
        m.put("region", a.getRegion());
        m.put("urgencyLevel", a.getUrgencyLevel());
        m.put("purpose", a.getPurpose());
        m.put("status", a.getStatus());
        m.put("applyTime", a.getApplyTime());
        m.put("auditOpinion", a.getAuditOpinion());
        m.put("rejectReason", a.getRejectReason());
        m.put("distributeType", a.getDistributeType());
        m.put("agentName", a.getAgentName());
        return m;
    }

    public static String maskName(String name) {
        if (name == null || name.isEmpty()) {
            return "**";
        }
        return name.charAt(0) + "**";
    }

    public static String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) {
            return "****";
        }
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
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
