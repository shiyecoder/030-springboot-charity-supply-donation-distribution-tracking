package com.grad.cmt.controller;

import com.grad.cmt.common.PageResult;
import com.grad.cmt.common.R;
import com.grad.cmt.entity.DistributionOrder;
import com.grad.cmt.service.DistributionService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/** 发放域接口：发放追踪单、FEFO 推荐、拣货、签收归档、公开报表。 */
@RestController
@RequestMapping("/api")
public class DistributionController {

    private final DistributionService service;

    public DistributionController(DistributionService service) {
        this.service = service;
    }

    @GetMapping("/distribution/page")
    public R<PageResult<DistributionOrder>> page(@RequestParam Map<String, String> p) {
        return R.ok(service.orderPage(p));
    }

    @GetMapping("/distribution/{id}")
    public R<Map<String, Object>> detail(@PathVariable Long id) {
        return R.ok(service.orderDetail(id));
    }

    @GetMapping("/distribution/{id}/recommend")
    public R<List<Map<String, Object>>> recommend(@PathVariable Long id) {
        return R.ok(service.recommend(id));
    }

    @SuppressWarnings("unchecked")
    @PostMapping("/distribution/{id}/pick")
    public R<Map<String, Object>> pick(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        List<Map<String, Object>> picks = (List<Map<String, Object>>) body.get("picks");
        return R.ok(service.pick(id, picks));
    }

    @PostMapping("/distribution/{id}/transition")
    public R<Void> transition(@PathVariable Long id, @RequestBody Map<String, String> body) {
        service.transition(id, body.getOrDefault("action", "sign"), body.get("reason"));
        return R.ok();
    }

    @GetMapping("/report/public")
    public R<Map<String, Object>> publicReport() {
        return R.ok(service.publicReport());
    }
}
