package com.grad.cmt.controller;

import com.grad.cmt.common.PageResult;
import com.grad.cmt.common.R;
import com.grad.cmt.entity.DonationIntent;
import com.grad.cmt.entity.DonationProject;
import com.grad.cmt.entity.MaterialDemand;
import com.grad.cmt.service.DonationService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/** 捐赠域接口：项目、物资需求、捐赠意向与预审。 */
@RestController
@RequestMapping("/api")
public class DonationController {

    private final DonationService service;

    public DonationController(DonationService service) {
        this.service = service;
    }

    @GetMapping("/project/page")
    public R<PageResult<DonationProject>> projectPage(@RequestParam Map<String, String> p) {
        return R.ok(service.projectPage(p));
    }

    @GetMapping("/project/{id}")
    public R<DonationProject> project(@PathVariable Long id) {
        return R.ok(service.project(id));
    }

    @PostMapping("/project")
    public R<Void> createProject(@RequestBody DonationProject project) {
        service.saveProject(project);
        return R.ok();
    }

    @PutMapping("/project/{id}")
    public R<Void> updateProject(@PathVariable Long id, @RequestBody DonationProject project) {
        project.setId(id);
        service.saveProject(project);
        return R.ok();
    }

    @GetMapping("/demand/page")
    public R<PageResult<MaterialDemand>> demandPage(@RequestParam Map<String, String> p) {
        return R.ok(service.demandPage(p));
    }

    @GetMapping("/intent/page")
    public R<PageResult<DonationIntent>> intentPage(@RequestParam Map<String, String> p) {
        return R.ok(service.intentPage(p));
    }

    @GetMapping("/intent/{id}")
    public R<DonationIntent> intent(@PathVariable Long id) {
        return R.ok(service.intent(id));
    }

    @PostMapping("/intent")
    public R<DonationIntent> createIntent(@RequestBody DonationIntent intent) {
        return R.ok(service.createIntent(intent));
    }

    /** 预审：body 含 result(接收/部分接收/不接收)、position、opinion、rejectReason */
    @PostMapping("/intent/{id}/precheck")
    public R<Void> precheck(@PathVariable Long id, @RequestBody Map<String, String> body) {
        service.precheck(id, body.getOrDefault("result", "接收"), body.get("position"),
                body.get("opinion"), body.get("rejectReason"));
        return R.ok();
    }
}
