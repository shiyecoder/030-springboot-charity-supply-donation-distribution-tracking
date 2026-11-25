package com.grad.cmt.controller;

import com.grad.cmt.common.R;
import com.grad.cmt.entity.MaterialRule;
import com.grad.cmt.entity.MaterialScore;
import com.grad.cmt.service.InnovationService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/** 创新模块接口：规则版本、权重发布、分配建议计算与人工调整。 */
@RestController
@RequestMapping("/api")
public class InnovationController {

    private final InnovationService service;

    public InnovationController(InnovationService service) {
        this.service = service;
    }

    @GetMapping("/rule/current")
    public R<MaterialRule> current() {
        return R.ok(service.current());
    }

    @GetMapping("/rule/history")
    public R<List<MaterialRule>> history() {
        return R.ok(service.history());
    }

    @SuppressWarnings("unchecked")
    @PostMapping("/rule")
    public R<MaterialRule> publish(@RequestBody Map<String, Object> body) {
        List<Map<String, Object>> factors = (List<Map<String, Object>>) body.get("factors");
        return R.ok(service.saveRule(factors, (String) body.get("changeNote")));
    }

    @PostMapping("/score/evaluate")
    public R<Map<String, Object>> evaluate(@RequestBody Map<String, Object> body) {
        Long appId = body.get("applicationId") == null ? null
                : Long.valueOf(String.valueOf(body.get("applicationId")));
        Long orderId = body.get("orderId") == null ? null
                : Long.valueOf(String.valueOf(body.get("orderId")));
        if (appId == null) {
            throw new com.grad.cmt.common.BizException("请指定受助申请");
        }
        return R.ok(service.evaluate(appId, orderId));
    }

    @GetMapping("/score/{id}")
    public R<MaterialScore> score(@PathVariable Long id) {
        return R.ok(service.score(id));
    }

    @GetMapping("/score/list")
    public R<List<MaterialScore>> list(@RequestParam(required = false) Long applicationId) {
        return R.ok(service.scoreList(applicationId));
    }

    @PostMapping("/score/{id}/adjust")
    public R<Void> adjust(@PathVariable Long id, @RequestBody Map<String, String> body) {
        service.adjust(id, body.get("level"), body.get("suggestion"), body.get("reason"));
        return R.ok();
    }
}
