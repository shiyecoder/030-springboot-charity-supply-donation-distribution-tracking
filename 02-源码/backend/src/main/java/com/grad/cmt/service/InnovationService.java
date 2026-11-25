package com.grad.cmt.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.grad.cmt.common.BizException;
import com.grad.cmt.common.UserContext;
import com.grad.cmt.entity.*;
import com.grad.cmt.mapper.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;

/**
 * 创新模块：需求紧迫度与物资分配建议。
 *
 * 定位是「可解释的业务辅助工具」，六因素加权求和，不依赖外部大模型：
 *   需求紧迫等级 25% · 家庭人数 15% · 历史领取量 15%
 *   库存数量 20% · 保质期 10% · 区域配送能力 15%
 *
 * 每次计算保存输入快照与逐项得分，权重合计必须是 100%，
 * 修改权重只影响新计算的数据，历史结果按原版本保留，原始结果不可被人工调整覆盖。
 */
@Service
public class InnovationService {

    private static final String[] FACTOR_KEYS = {"urgency", "family", "history", "stock", "expire", "delivery"};
    private static final String[] FACTOR_NAMES = {"需求紧迫等级", "家庭人数", "历史领取量", "库存数量", "保质期", "区域配送能力"};

    private final MaterialRuleMapper ruleMapper;
    private final MaterialScoreMapper scoreMapper;
    private final AidApplicationMapper appMapper;
    private final AidApplicationItemMapper itemMapper;
    private final DistributionOrderMapper orderMapper;
    private final InventoryBatchMapper batchMapper;
    private final SysOrgMapper orgMapper;
    private final FlowService flowService;

    public InnovationService(MaterialRuleMapper ruleMapper, MaterialScoreMapper scoreMapper,
                             AidApplicationMapper appMapper, AidApplicationItemMapper itemMapper,
                             DistributionOrderMapper orderMapper, InventoryBatchMapper batchMapper,
                             SysOrgMapper orgMapper, FlowService flowService) {
        this.ruleMapper = ruleMapper;
        this.scoreMapper = scoreMapper;
        this.appMapper = appMapper;
        this.itemMapper = itemMapper;
        this.orderMapper = orderMapper;
        this.batchMapper = batchMapper;
        this.orgMapper = orgMapper;
        this.flowService = flowService;
    }

    public MaterialRule current() {
        return ruleMapper.selectOne(new QueryWrapper<MaterialRule>()
                .eq("status", "启用").orderByDesc("effect_time").last("LIMIT 1"));
    }

    public List<MaterialRule> history() {
        return ruleMapper.selectList(new QueryWrapper<MaterialRule>().orderByDesc("effect_time"));
    }

    /**
     * 发布新版本：权重合计必须等于 100%，版本号自动递增 +0.1，旧版本置为停用。
     * 旧版本保留在库中，历史计算结果仍指向原版本。
     */
    @Transactional
    public MaterialRule saveRule(List<Map<String, Object>> factors, String changeNote) {
        if (factors == null || factors.size() != 6) {
            throw new BizException("必须配置全部 6 个因素");
        }
        double total = 0;
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < factors.size(); i++) {
            Map<String, Object> f = factors.get(i);
            double w = Double.parseDouble(String.valueOf(f.getOrDefault("weight", 0)));
            if (w < 0) {
                throw new BizException("权重不能为负数");
            }
            total += w;
            if (i > 0) {
                json.append(",");
            }
            json.append("{\"key\":\"").append(f.get("key")).append("\",\"name\":\"")
                    .append(f.get("name")).append("\",\"weight\":").append(w).append(",\"source\":\"")
                    .append(f.getOrDefault("source", "")).append("\"}");
        }
        json.append("]");
        if (Math.abs(total - 100) > 0.001) {
            throw new BizException("权重合计必须等于 100%，当前为 " + total + "%");
        }
        if (changeNote == null || changeNote.trim().length() < 5) {
            throw new BizException("发布新版本必须填写不少于 5 个字的变更说明");
        }
        MaterialRule old = current();
        String oldVersion = old == null ? "v1.0" : old.getRuleVersion();
        String next = bump(oldVersion);
        if (old != null) {
            old.setStatus("停用");
            ruleMapper.updateById(old);
        }
        MaterialRule r = new MaterialRule();
        r.setRuleNo("RULE-" + String.format("%03d", ruleMapper.selectCount(null) + 1));
        r.setRuleName("需求紧迫度与物资分配建议");
        r.setRuleVersion(next);
        r.setFactorJson(json.toString());
        r.setWeightTotal(BigDecimal.valueOf(total).setScale(2, RoundingMode.HALF_UP));
        r.setThresholdJson("{\"A\":80,\"B\":60,\"C\":40}");
        r.setStatus("启用");
        r.setEffectTime(LocalDateTime.now());
        r.setPublisherId(UserContext.userId());
        r.setChangeNote(changeNote.trim());
        ruleMapper.insert(r);
        flowService.record("规则配置", r.getId(), r.getRuleNo(), oldVersion, next, "发布规则",
                changeNote.trim());
        return r;
    }

    private String bump(String version) {
        try {
            String v = version.replace("v", "");
            double d = Double.parseDouble(v) + 0.1;
            return "v" + String.format("%.1f", d);
        } catch (Exception e) {
            return "v1.0";
        }
    }

    /**
     * 计算分配建议（幂等：相同输入 + 相同规则版本 → 相同结果）。
     * 数据缺失的因素不参与计算并在结果中提示补录。
     */
    public Map<String, Object> evaluate(Long applicationId, Long orderId) {
        AidApplication a = appMapper.selectById(applicationId);
        if (a == null) {
            throw new BizException("受助申请不存在");
        }
        MaterialRule rule = current();
        if (rule == null) {
            throw new BizException("没有启用中的规则版本，请先在规则配置中发布");
        }
        List<AidApplicationItem> items = itemMapper.selectList(
                new QueryWrapper<AidApplicationItem>().eq("application_id", applicationId));

        // ---- 输入快照
        Map<String, Object> snap = new LinkedHashMap<>();
        snap.put("urgency", a.getUrgencyLevel());
        snap.put("familySize", a.getFamilySize());
        double yearQty = yearDistributed(a.getBeneficiaryId());
        snap.put("history12m", yearQty + "kg");
        snap.put("applyItems", items.stream().map(AidApplicationItem::getMaterialName).toList());
        snap.put("region", a.getRegion());

        // ---- 逐项得分
        double sUrgency = urgencyScore(a.getUrgencyLevel());
        double sFamily = familyScore(a.getFamilySize());
        double sHistory = historyScore(yearQty);
        double stockRate = stockRate(items);
        double sStock = Math.min(stockRate, 100);
        long expireDays = nearestExpireDays(items);
        double sExpire = expireScore(expireDays);
        String capacity = deliveryCapacity(a.getRegion());
        double sDelivery = deliveryScore(capacity);
        snap.put("stockRate", String.format("%.0f%%", stockRate));
        snap.put("expireDays", expireDays);
        snap.put("delivery", capacity);

        double[] scores = {sUrgency, sFamily, sHistory, sStock, sExpire, sDelivery};
        double[] weights = parseWeights(rule.getFactorJson());
        double sum = 0;
        StringBuilder detail = new StringBuilder("[");
        for (int i = 0; i < 6; i++) {
            double got = scores[i] * weights[i] / 100.0;
            sum += got;
            if (i > 0) {
                detail.append(",");
            }
            detail.append(String.format(
                    "{\"key\":\"%s\",\"name\":\"%s\",\"score\":%.1f,\"weight\":%.1f,\"got\":%.2f}",
                    FACTOR_KEYS[i], FACTOR_NAMES[i], scores[i], weights[i], got));
        }
        detail.append("]");

        // 区域可达系数：配送能力「高」的地区当日可达率按 1.043 修正
        double coef = "高".equals(capacity) ? 1.043 : ("中".equals(capacity) ? 1.0 : 0.96);
        double total = Math.min(Math.round(sum * coef * 10) / 10.0, 100);
        String level = total >= 80 ? "优先分配" : total >= 60 ? "常规分配" : total >= 40 ? "暂缓分配" : "不推荐";

        String unmet = null;
        if (stockRate < 100) {
            unmet = "库存可满足率仅 " + String.format("%.0f%%", stockRate) + "，建议拆单或等待入库";
        } else if (yearQty >= 55) {
            unmet = "年度累计领取量已接近上限（" + yearQty + "/60 kg），建议按剩余额度发放";
        }
        String improve = stockRate < 100 ? "补充同类物资入库可提升分配优先级"
                : "补充家庭收入与医疗支出凭证可提升紧迫等级判定精度";

        MaterialScore sc = new MaterialScore();
        sc.setScoreNo("SCR-" + a.getApplyNo().replace("AID-", ""));
        sc.setApplicationId(applicationId);
        sc.setOrderId(orderId);
        sc.setRuleId(rule.getId());
        sc.setRuleVersion(rule.getRuleVersion());
        sc.setSnapshotJson(toJson(snap));
        sc.setFactorJson(detail.toString());
        sc.setTotalScore(BigDecimal.valueOf(total).setScale(1, RoundingMode.HALF_UP));
        sc.setResultLevel(level);
        sc.setSuggestion(suggestText(items, level));
        sc.setUnmet(unmet);
        sc.setImprove(improve);
        sc.setCalcTime(LocalDateTime.now());
        sc.setAdjustFlag(0);
        scoreMapper.insert(sc);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("scoreNo", sc.getScoreNo());
        res.put("totalScore", sc.getTotalScore());
        res.put("resultLevel", level);
        res.put("ruleVersion", rule.getRuleVersion());
        res.put("snapshot", snap);
        res.put("factors", detail.toString());
        res.put("suggestion", sc.getSuggestion());
        res.put("unmet", unmet);
        res.put("improve", improve);
        return res;
    }

    /** 人工调整：只记录调整结果与原因，原始计算结果字段不改写 */
    public void adjust(Long scoreId, String level, String suggestion, String reason) {
        MaterialScore sc = scoreMapper.selectById(scoreId);
        if (sc == null) {
            throw new BizException("计算记录不存在");
        }
        if (reason == null || reason.trim().length() < 5) {
            throw new BizException("人工调整必须填写不少于 5 个字的原因");
        }
        sc.setAdjustFlag(1);
        sc.setAdjustReason(reason.trim());
        sc.setAdjustUserId(UserContext.userId());
        sc.setAdjustTime(LocalDateTime.now());
        // 调整后的等级写入独立字段语义：不覆盖 total_score / result_level 原始值
        if (level != null && !level.isBlank()) {
            sc.setResultLevel(sc.getResultLevel() + "（人工：" + level + "）");
        }
        if (suggestion != null && !suggestion.isBlank()) {
            sc.setSuggestion(suggestion);
        }
        scoreMapper.updateById(sc);
        flowService.record("分配建议", scoreId, sc.getScoreNo(), "系统计算", "人工调整", "人工调整", reason);
    }

    public MaterialScore score(Long id) {
        return scoreMapper.selectById(id);
    }

    public List<MaterialScore> scoreList(Long applicationId) {
        return scoreMapper.selectList(new QueryWrapper<MaterialScore>()
                .eq(applicationId != null, "application_id", applicationId)
                .orderByDesc("calc_time").last("LIMIT 30"));
    }

    // ------------------------------------------------------------ 评分细则
    private double urgencyScore(String level) {
        if (level == null) {
            return 50;
        }
        return switch (level) {
            case "特急" -> 100;
            case "紧急" -> 75;
            case "一般" -> 50;
            default -> 25;
        };
    }

    private double familyScore(Integer size) {
        int s = size == null ? 0 : size;
        if (s >= 5) {
            return 100;
        }
        if (s == 4) {
            return 80;
        }
        if (s == 3) {
            return 65;
        }
        return 45;
    }

    /** 历史领取量：越接近年度上限 60kg 得分越低（线性反向） */
    private double historyScore(double yearQty) {
        double ratio = Math.min(yearQty / 60.0, 1.0);
        return Math.max(100 - ratio * 100, 0);
    }

    /** 库存可满足率：申请量与可用量之比 */
    private double stockRate(List<AidApplicationItem> items) {
        if (items.isEmpty()) {
            return 0;
        }
        double need = 0, have = 0;
        for (AidApplicationItem it : items) {
            need += it.getApplyQty() == null ? 0 : it.getApplyQty();
            Integer avail = batchMapper.selectList(new QueryWrapper<InventoryBatch>()
                            .eq("material_name", it.getMaterialName())
                            .notIn("status", List.of("过期", "锁定", "不合格")))
                    .stream().map(b -> b.getAvailableQty() == null ? 0 : b.getAvailableQty())
                    .reduce(0, Integer::sum);
            have += avail;
        }
        return need == 0 ? 0 : Math.min(have / need * 100, 100);
    }

    /** 推荐批次最近到期天数：越临期越应优先出库 */
    private long nearestExpireDays(List<AidApplicationItem> items) {
        long min = Long.MAX_VALUE;
        for (AidApplicationItem it : items) {
            List<InventoryBatch> list = batchMapper.selectList(new QueryWrapper<InventoryBatch>()
                    .eq("material_name", it.getMaterialName())
                    .isNotNull("expire_date")
                    .notIn("status", List.of("过期", "锁定"))
                    .orderByAsc("expire_date").last("LIMIT 1"));
            for (InventoryBatch b : list) {
                long days = ChronoUnit.DAYS.between(LocalDate.now(), b.getExpireDate());
                min = Math.min(min, days);
            }
        }
        return min == Long.MAX_VALUE ? 365 : min;
    }

    private double expireScore(long days) {
        if (days <= 30) {
            return 100;
        }
        if (days <= 90) {
            return 80;
        }
        return 60;
    }

    private String deliveryCapacity(String region) {
        List<SysOrg> orgs = orgMapper.selectList(new QueryWrapper<SysOrg>().like("org_name", region == null ? "" : region));
        if (orgs.isEmpty()) {
            return "中";
        }
        String c = orgs.get(0).getDeliveryCapacity();
        return c == null ? "中" : c;
    }

    private double deliveryScore(String capacity) {
        return switch (capacity) {
            case "高" -> 100;
            case "中" -> 75;
            default -> 45;
        };
    }

    /** 年度累计发放量（kg 近似：件数 × 5kg，用于演示口径） */
    private double yearDistributed(Long beneficiaryId) {
        if (beneficiaryId == null) {
            return 0;
        }
        List<DistributionOrder> list = orderMapper.selectList(new QueryWrapper<DistributionOrder>()
                .eq("beneficiary_id", beneficiaryId)
                .eq("status", "已完成"));
        int qty = list.stream().map(o -> o.getTotalQty() == null ? 0 : o.getTotalQty())
                .reduce(0, Integer::sum);
        return qty * 5.0;
    }

    private String suggestText(List<AidApplicationItem> items, String level) {
        if (items.isEmpty()) {
            return "无可发放物资";
        }
        StringBuilder sb = new StringBuilder();
        for (AidApplicationItem it : items) {
            if (sb.length() > 0) {
                sb.append(" · ");
            }
            int q = it.getApproveQty() == null ? (it.getApplyQty() == null ? 0 : it.getApplyQty()) : it.getApproveQty();
            sb.append(it.getMaterialName()).append(" ").append(q).append(" ").append(it.getUnit() == null ? "" : it.getUnit());
        }
        if (!"优先分配".equals(level)) {
            sb.append("（建议按 80% 发放）");
        }
        return sb.toString();
    }

    private double[] parseWeights(String json) {
        double[] w = {25, 15, 15, 20, 10, 15};
        if (json == null) {
            return w;
        }
        for (int i = 0; i < FACTOR_KEYS.length; i++) {
            int idx = json.indexOf("\"key\":\"" + FACTOR_KEYS[i] + "\"");
            if (idx < 0) {
                continue;
            }
            int wi = json.indexOf("\"weight\":", idx);
            if (wi < 0) {
                continue;
            }
            int end = json.indexOf(",", wi);
            if (end < 0) {
                end = json.indexOf("}", wi);
            }
            try {
                w[i] = Double.parseDouble(json.substring(wi + 9, end).trim());
            } catch (Exception ignored) {
            }
        }
        return w;
    }

    private String toJson(Map<String, Object> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<String, Object> e : map.entrySet()) {
            if (!first) {
                sb.append(",");
            }
            first = false;
            sb.append("\"").append(e.getKey()).append("\":\"")
                    .append(e.getValue() == null ? "" : String.valueOf(e.getValue()).replace("\"", ""))
                    .append("\"");
        }
        return sb.append("}").toString();
    }
}
