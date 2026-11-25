package com.grad.cmt.controller;

import com.grad.cmt.common.R;
import com.grad.cmt.service.DashboardService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/** 看板接口：指标与图表数据一次返回，避免前端多次请求再聚合。 */
@RestController
@RequestMapping("/api")
public class DashboardController {

    private final DashboardService service;

    public DashboardController(DashboardService service) {
        this.service = service;
    }

    @GetMapping("/dashboard")
    public R<Map<String, Object>> dashboard(@RequestParam(required = false) String range) {
        return R.ok(service.stats(range));
    }
}
