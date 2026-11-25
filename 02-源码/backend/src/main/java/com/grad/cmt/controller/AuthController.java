package com.grad.cmt.controller;

import com.grad.cmt.common.R;
import com.grad.cmt.service.AuthService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/** 认证接口：登录、当前用户、菜单、资料与密码。 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public R<Map<String, Object>> login(@RequestBody Map<String, String> body) {
        return R.ok(authService.login(body.get("username"), body.get("password")));
    }

    @PostMapping("/register")
    public R<Void> register(@RequestBody Map<String, String> body) {
        authService.register(body.get("username"), body.get("password"),
                body.get("realName"), body.get("phone"));
        return R.ok();
    }

    @GetMapping("/me")
    public R<Map<String, Object>> me() {
        return R.ok(authService.me());
    }

    @GetMapping("/menus")
    public R<Object> menus() {
        return R.ok(authService.me().get("menus"));
    }

    @PostMapping("/logout")
    public R<Void> logout() {
        return R.ok();
    }

    @PutMapping("/profile")
    public R<Void> profile(@RequestBody Map<String, String> body) {
        authService.updateProfile(body.get("realName"), body.get("phone"),
                body.get("email"), body.get("avatar"));
        return R.ok();
    }

    @PutMapping("/password")
    public R<Void> password(@RequestBody Map<String, String> body) {
        authService.changePassword(body.get("oldPassword"), body.get("newPassword"));
        return R.ok();
    }
}
