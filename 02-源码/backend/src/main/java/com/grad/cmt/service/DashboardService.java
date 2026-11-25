package com.grad.cmt.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * 看板统计：6 个核心指标 + 6 组图表数据。
 * 全部由后端聚合，前端不做二次汇总，保证图表值与明细总数一致。
 */
@Service
public class DashboardService {

    private final JdbcTemplate jdbc;

    public DashboardService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public Map<String, Object> stats(String range) {
        // 默认按近 90 天口径统计：公益仓入库集中在季度性募集，30 天窗口常常没有出库，指标会失真
        int days = switch (range == null ? "quarter" : range) {
            case "quarter" -> 90;
            case "year" -> 365;
            case "month" -> 30;
            default -> 90;
        };
        Map<String, Object> m = new LinkedHashMap<>();

        m.put("inQty", num("SELECT COALESCE(SUM(in_qty),0) FROM inventory_batch WHERE deleted=0 "
                + "AND in_time >= DATE_SUB(NOW(), INTERVAL " + days + " DAY)"));
        m.put("outQty", num("SELECT COALESCE(SUM(actual_qty),0) FROM distribution_item WHERE deleted=0 "
                + "AND pick_time >= DATE_SUB(NOW(), INTERVAL " + days + " DAY)"));
        m.put("turnoverDays", num("SELECT ROUND(COALESCE(SUM(available_qty),0) / "
                + "GREATEST((SELECT COALESCE(SUM(actual_qty),0) FROM distribution_item WHERE deleted=0 "
                + "AND pick_time >= DATE_SUB(NOW(), INTERVAL " + days + " DAY)) / " + days + ", 1), 1) "
                + "FROM inventory_batch WHERE deleted=0 AND status IN ('正常','临期')"));
        m.put("expiringCount", num("SELECT COUNT(*) FROM inventory_batch WHERE deleted=0 "
                + "AND expire_date IS NOT NULL AND expire_date BETWEEN CURDATE() "
                + "AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)"));
        m.put("orderTotal", num("SELECT COUNT(*) FROM distribution_order WHERE deleted=0"));
        m.put("orderDone", num("SELECT COUNT(*) FROM distribution_order WHERE deleted=0 AND status='已完成'"));
        m.put("signRate", num("SELECT ROUND(100 * SUM(status='已完成') / GREATEST(COUNT(*),1), 1) "
                + "FROM distribution_order WHERE deleted=0"));
        m.put("regionPersons", num("SELECT COALESCE(SUM(family_size),0) FROM aid_application "
                + "WHERE deleted=0 AND status IN ('已完成','待反馈')"));
        m.put("projectCount", num("SELECT COUNT(*) FROM donation_project WHERE deleted=0 AND status='进行中'"));
        m.put("intentPending", num("SELECT COUNT(*) FROM donation_intent WHERE deleted=0 AND status='待预审'"));
        m.put("applicationPending", num("SELECT COUNT(*) FROM aid_application WHERE deleted=0 AND status='待审核'"));
        m.put("feedbackPending", num("SELECT COUNT(*) FROM beneficiary_feedback WHERE deleted=0 AND audit_status='待审核'"));
        m.put("stockTotal", num("SELECT COALESCE(SUM(available_qty),0) FROM inventory_batch "
                + "WHERE deleted=0 AND status IN ('正常','临期')"));

        m.put("statusDist", jdbc.queryForList("SELECT status AS name, COUNT(*) AS cnt FROM distribution_order "
                + "WHERE deleted=0 GROUP BY status"));
        m.put("categoryIn", jdbc.queryForList("SELECT category AS name, SUM(in_qty) AS cnt FROM inventory_batch "
                + "WHERE deleted=0 GROUP BY category ORDER BY cnt DESC"));
        m.put("regionRank", jdbc.queryForList("SELECT region AS name, COUNT(*) AS cnt FROM distribution_order "
                + "WHERE deleted=0 AND status='已完成' GROUP BY region ORDER BY cnt DESC"));
        m.put("levelDist", jdbc.queryForList("SELECT result_level AS name, COUNT(*) AS cnt "
                + "FROM charity_material_score WHERE deleted=0 GROUP BY result_level"));
        m.put("warehousePerf", jdbc.queryForList("SELECT o.org_name AS name, COUNT(r.id) AS batches, "
                + "COALESCE(SUM(r.unqualified_qty),0) AS unqualified, "
                + "ROUND(COALESCE(AVG(TIMESTAMPDIFF(HOUR, r.receive_time, r.create_time)),0),1) AS hours "
                + "FROM sys_org o LEFT JOIN receiving_record r ON r.warehouse_id = o.id "
                + "AND r.deleted = 0 WHERE o.deleted = 0 GROUP BY o.id, o.org_name ORDER BY batches DESC LIMIT 6"));
        m.put("trend", jdbc.queryForList("SELECT DATE_FORMAT(in_time,'%Y-%m') AS ym, SUM(in_qty) AS inQty "
                + "FROM inventory_batch WHERE deleted=0 AND in_time >= DATE_SUB(NOW(), INTERVAL 6 MONTH) "
                + "GROUP BY ym ORDER BY ym"));
        m.put("adoptRate", num("SELECT ROUND(100 * SUM(adjust_flag=0) / GREATEST(COUNT(*),1), 1) "
                + "FROM charity_material_score WHERE deleted=0"));
        m.put("adjustRate", num("SELECT ROUND(100 * SUM(adjust_flag=1) / GREATEST(COUNT(*),1), 1) "
                + "FROM charity_material_score WHERE deleted=0"));
        return m;
    }

    private long num(String sql) {
        try {
            Number n = jdbc.queryForObject(sql, Number.class);
            return n == null ? 0 : n.longValue();
        } catch (Exception e) {
            return 0;
        }
    }
}
