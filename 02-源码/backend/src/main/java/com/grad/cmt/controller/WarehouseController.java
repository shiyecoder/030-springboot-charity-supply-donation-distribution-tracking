package com.grad.cmt.controller;

import com.grad.cmt.common.PageResult;
import com.grad.cmt.common.R;
import com.grad.cmt.entity.InventoryBatch;
import com.grad.cmt.entity.InventoryCheck;
import com.grad.cmt.entity.ReceivingRecord;
import com.grad.cmt.service.WarehouseService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/** 仓储域接口：收货验收、批次台账、库存盘点。 */
@RestController
@RequestMapping("/api")
public class WarehouseController {

    private final WarehouseService service;

    public WarehouseController(WarehouseService service) {
        this.service = service;
    }

    @GetMapping("/receiving/page")
    public R<PageResult<ReceivingRecord>> receivingPage(@RequestParam Map<String, String> p) {
        return R.ok(service.receivingPage(p));
    }

    @GetMapping("/receiving/{id}")
    public R<Map<String, Object>> receiving(@PathVariable Long id) {
        return R.ok(service.receivingDetail(id));
    }

    @PostMapping("/receiving/submit")
    public R<Map<String, Object>> submit(@RequestBody Map<String, Object> body) {
        return R.ok(service.submitReceiving(body));
    }

    @GetMapping("/batch/page")
    public R<PageResult<InventoryBatch>> batchPage(@RequestParam Map<String, String> p) {
        return R.ok(service.batchPage(p));
    }

    @GetMapping("/batch/{id}")
    public R<Map<String, Object>> batch(@PathVariable Long id) {
        return R.ok(service.batchDetail(id));
    }

    @PostMapping("/batch/{id}/lock")
    public R<Void> lock(@PathVariable Long id, @RequestBody Map<String, String> body) {
        service.toggleLock(id, true, body.get("reason"));
        return R.ok();
    }

    @PostMapping("/batch/{id}/unlock")
    public R<Void> unlock(@PathVariable Long id, @RequestBody(required = false) Map<String, String> body) {
        service.toggleLock(id, false, body == null ? null : body.get("reason"));
        return R.ok();
    }

    @GetMapping("/inventory-check/page")
    public R<PageResult<InventoryCheck>> checkPage(@RequestParam Map<String, String> p) {
        return R.ok(service.checkPage(p));
    }
}
