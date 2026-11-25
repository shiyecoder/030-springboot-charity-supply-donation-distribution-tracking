package com.grad.cmt.controller;

import com.grad.cmt.common.PageResult;
import com.grad.cmt.common.R;
import com.grad.cmt.entity.*;
import com.grad.cmt.service.SystemService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/** 系统管理接口：用户、角色、菜单、字典、日志、消息。 */
@RestController
@RequestMapping("/api")
public class SystemController {

    private final SystemService service;

    public SystemController(SystemService service) {
        this.service = service;
    }

    @GetMapping("/system/user/page")
    public R<PageResult<Map<String, Object>>> userPage(@RequestParam Map<String, String> p) {
        return R.ok(service.userPage(p));
    }

    @PostMapping("/system/user")
    public R<Void> saveUser(@RequestBody SysUser user) {
        service.saveUser(user);
        return R.ok();
    }

    @PostMapping("/system/user/{id}/status")
    public R<Void> toggle(@PathVariable Long id, @RequestBody Map<String, String> body) {
        service.toggleUser(id, body.getOrDefault("status", "启用"));
        return R.ok();
    }

    @GetMapping("/system/role/list")
    public R<List<SysRole>> roles() {
        return R.ok(service.roles());
    }

    @GetMapping("/system/org/list")
    public R<List<SysOrg>> orgs() {
        return R.ok(service.orgs());
    }

    @GetMapping("/system/menu/tree")
    public R<List<Map<String, Object>>> menuTree() {
        return R.ok(service.menuTree());
    }

    @GetMapping("/system/role/{id}/menus")
    public R<Map<String, Object>> roleMenus(@PathVariable Long id) {
        return R.ok(service.roleMenus(id));
    }

    @PostMapping("/system/role/{id}/menus")
    public R<Void> assign(@PathVariable Long id, @RequestBody Map<String, List<Long>> body) {
        service.assignMenus(id, body.get("menuIds"));
        return R.ok();
    }

    @GetMapping("/system/log/page")
    public R<PageResult<SysOperLog>> logs(@RequestParam Map<String, String> p) {
        return R.ok(service.logPage(p));
    }

    @GetMapping("/system/dict")
    public R<List<SysDict>> dicts(@RequestParam(required = false) String type) {
        return R.ok(service.dicts(type));
    }

    @GetMapping("/message/page")
    public R<PageResult<SysMessage>> messages(@RequestParam Map<String, String> p) {
        return R.ok(service.messagePage(p));
    }

    @PostMapping("/message/{id}/read")
    public R<Void> read(@PathVariable Long id) {
        service.readMessage(id);
        return R.ok();
    }

    @PostMapping("/message/read-all")
    public R<Void> readAll() {
        service.readAll();
        return R.ok();
    }
}
