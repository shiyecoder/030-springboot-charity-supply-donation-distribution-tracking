package com.grad.cmt.controller;

import com.grad.cmt.common.PageResult;
import com.grad.cmt.common.R;
import com.grad.cmt.entity.AidApplication;
import com.grad.cmt.entity.AidBeneficiary;
import com.grad.cmt.entity.BeneficiaryFeedback;
import com.grad.cmt.service.AidService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/** 受助域接口：档案、需求池、资格与反重审核、去向反馈。 */
@RestController
@RequestMapping("/api")
public class AidController {

    private final AidService service;

    public AidController(AidService service) {
        this.service = service;
    }

    @GetMapping("/beneficiary/page")
    public R<PageResult<AidBeneficiary>> beneficiaryPage(@RequestParam Map<String, String> p) {
        return R.ok(service.beneficiaryPage(p));
    }

    @GetMapping("/application/page")
    public R<PageResult<AidApplication>> applicationPage(@RequestParam Map<String, String> p) {
        return R.ok(service.applicationPage(p));
    }

    @GetMapping("/application/{id}")
    public R<Map<String, Object>> application(@PathVariable Long id) {
        return R.ok(service.applicationDetail(id));
    }

    @SuppressWarnings("unchecked")
    @PostMapping("/application/{id}/review")
    public R<Map<String, Object>> review(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        List<Map<String, Object>> items = (List<Map<String, Object>>) body.get("items");
        return R.ok(service.review(id, String.valueOf(body.getOrDefault("result", "批准")), items,
                (String) body.get("opinion"), (String) body.get("reason")));
    }

    @GetMapping("/feedback/page")
    public R<PageResult<BeneficiaryFeedback>> feedbackPage(@RequestParam Map<String, String> p) {
        return R.ok(service.feedbackPage(p));
    }

    @PostMapping("/feedback/{id}/audit")
    public R<Void> audit(@PathVariable Long id, @RequestBody Map<String, String> body) {
        service.auditFeedback(id, body.getOrDefault("result", "通过"), body.get("opinion"));
        return R.ok();
    }
}
