package com.grad.cmt.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.grad.cmt.common.BizException;
import com.grad.cmt.common.JwtUtil;
import com.grad.cmt.common.UserContext;
import com.grad.cmt.entity.*;
import com.grad.cmt.mapper.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

/**
 * 认证与权限：登录失败计数锁定、JWT 签发、按角色动态返回菜单树、个人资料与密码修改。
 * 任何返回体都不包含密码字段。
 */
@Service
public class AuthService {

    private final SysUserMapper userMapper;
    private final SysRoleMapper roleMapper;
    private final SysMenuMapper menuMapper;
    private final SysRoleMenuMapper roleMenuMapper;
    private final SysOrgMapper orgMapper;
    private final SysMessageMapper messageMapper;
    private final PasswordEncoder encoder;
    private final JwtUtil jwtUtil;

    @Value("${app.login-fail-limit:5}")
    private int failLimit;
    @Value("${app.login-lock-minutes:10}")
    private int lockMinutes;

    public AuthService(SysUserMapper userMapper, SysRoleMapper roleMapper, SysMenuMapper menuMapper,
                       SysRoleMenuMapper roleMenuMapper, SysOrgMapper orgMapper,
                       SysMessageMapper messageMapper, PasswordEncoder encoder, JwtUtil jwtUtil) {
        this.userMapper = userMapper;
        this.roleMapper = roleMapper;
        this.menuMapper = menuMapper;
        this.roleMenuMapper = roleMenuMapper;
        this.orgMapper = orgMapper;
        this.messageMapper = messageMapper;
        this.encoder = encoder;
        this.jwtUtil = jwtUtil;
    }

    /** 登录：连续失败达阈值锁定一段时间，成功后清零失败计数 */
    public Map<String, Object> login(String username, String password) {
        if (username == null || password == null) {
            throw new BizException("请输入账号和密码");
        }
        SysUser user = userMapper.selectOne(new QueryWrapper<SysUser>().eq("username", username.trim()));
        if (user == null) {
            throw new BizException("账号或密码错误");
        }
        if (user.getLockTime() != null && user.getLockTime().plusMinutes(lockMinutes).isAfter(LocalDateTime.now())) {
            throw new BizException("账号已锁定，请 " + lockMinutes + " 分钟后再试");
        }
        if (!encoder.matches(password, user.getPassword())) {
            int fail = (user.getLoginFailCount() == null ? 0 : user.getLoginFailCount()) + 1;
            user.setLoginFailCount(fail);
            if (fail >= failLimit) {
                user.setLockTime(LocalDateTime.now());
            }
            userMapper.updateById(user);
            throw new BizException(fail >= failLimit
                    ? "密码错误次数过多，账号已锁定 " + lockMinutes + " 分钟"
                    : "账号或密码错误，还可尝试 " + (failLimit - fail) + " 次");
        }
        if (!"启用".equals(user.getStatus())) {
            throw new BizException("账号已停用，请联系管理员");
        }
        user.setLoginFailCount(0);
        user.setLockTime(null);
        user.setLastLoginTime(LocalDateTime.now());
        userMapper.updateById(user);

        String token = jwtUtil.create(user.getId(), user.getRealName(), user.getRoleCode(),
                user.getOrgId(), user.getDataScope());
        Map<String, Object> res = new HashMap<>();
        res.put("token", token);
        res.put("user", brief(user));
        res.put("menus", menus(user.getRoleId()));
        return res;
    }

    /** 用户简要信息（不含密码） */
    public Map<String, Object> brief(SysUser u) {
        Map<String, Object> m = new HashMap<>();
        m.put("id", u.getId());
        m.put("username", u.getUsername());
        m.put("realName", u.getRealName());
        m.put("avatar", u.getAvatar());
        m.put("phone", u.getPhone());
        m.put("email", u.getEmail());
        m.put("roleCode", u.getRoleCode());
        m.put("dataScope", u.getDataScope());
        m.put("orgId", u.getOrgId());
        SysOrg org = u.getOrgId() == null ? null : orgMapper.selectById(u.getOrgId());
        m.put("orgName", org == null ? "" : org.getOrgName());
        SysRole role = u.getRoleId() == null ? null : roleMapper.selectById(u.getRoleId());
        m.put("roleName", role == null ? "" : role.getRoleName());
        return m;
    }

    /** 按角色动态构建菜单树；菜单管理项对非管理员隐藏 */
    public List<Map<String, Object>> menus(Long roleId) {
        if (roleId == null) {
            return List.of();
        }
        List<SysRoleMenu> links = roleMenuMapper.selectList(new QueryWrapper<SysRoleMenu>().eq("role_id", roleId));
        Set<Long> ids = new HashSet<>();
        links.forEach(l -> ids.add(l.getMenuId()));
        if (ids.isEmpty()) {
            return List.of();
        }
        List<SysMenu> all = menuMapper.selectList(new QueryWrapper<SysMenu>()
                .in("id", ids).eq("status", "启用").orderByAsc("sort_no"));
        // 非项目管理员不返回「菜单管理」项，避免越权可见
        SysRole role = roleMapper.selectById(roleId);
        boolean admin = role != null && "ADMIN".equals(role.getRoleCode());
        List<SysMenu> visible = new ArrayList<>();
        for (SysMenu m : all) {
            if (!admin && "菜单管理".equals(m.getMenuName())) {
                continue;
            }
            if (m.getVisible() != null && m.getVisible() == 0) {
                continue;
            }
            visible.add(m);
        }
        return buildTree(visible, 0L);
    }

    private List<Map<String, Object>> buildTree(List<SysMenu> list, Long parent) {
        List<Map<String, Object>> out = new ArrayList<>();
        for (SysMenu m : list) {
            if (!Objects.equals(m.getParentId(), parent)) {
                continue;
            }
            Map<String, Object> node = new LinkedHashMap<>();
            node.put("id", m.getId());
            node.put("name", m.getMenuName());
            node.put("path", m.getPath());
            node.put("icon", m.getIcon());
            node.put("type", m.getMenuType());
            node.put("perms", m.getPerms());
            List<Map<String, Object>> children = buildTree(list, m.getId());
            if (!children.isEmpty()) {
                node.put("children", children);
            }
            out.add(node);
        }
        return out;
    }

    public Map<String, Object> me() {
        SysUser u = userMapper.selectById(UserContext.userId());
        if (u == null) {
            throw new BizException("用户不存在");
        }
        Map<String, Object> m = brief(u);
        m.put("menus", menus(u.getRoleId()));
        m.put("unread", messageMapper.selectCount(new QueryWrapper<SysMessage>()
                .eq("receiver_id", u.getId()).eq("read_flag", 0)));
        return m;
    }

    public void updateProfile(String realName, String phone, String email, String avatar) {
        SysUser u = userMapper.selectById(UserContext.userId());
        if (realName != null && !realName.isBlank()) {
            u.setRealName(realName.trim());
        }
        u.setPhone(phone);
        u.setEmail(email);
        if (avatar != null && !avatar.isBlank()) {
            u.setAvatar(avatar);
        }
        userMapper.updateById(u);
    }

    public void changePassword(String oldPwd, String newPwd) {
        if (newPwd == null || newPwd.length() < 6) {
            throw new BizException("新密码至少 6 位");
        }
        SysUser u = userMapper.selectById(UserContext.userId());
        if (!encoder.matches(oldPwd == null ? "" : oldPwd, u.getPassword())) {
            throw new BizException("当前密码不正确");
        }
        u.setPassword(encoder.encode(newPwd));
        userMapper.updateById(u);
    }

    /** 注册仅开放捐赠人角色 */
    public void register(String username, String password, String realName, String phone) {
        if (username == null || username.isBlank() || password == null || password.length() < 6) {
            throw new BizException("账号不能为空，密码至少 6 位");
        }
        Long exists = userMapper.selectCount(new QueryWrapper<SysUser>().eq("username", username.trim()));
        if (exists != null && exists > 0) {
            throw new BizException("该账号已存在");
        }
        SysRole donor = roleMapper.selectOne(new QueryWrapper<SysRole>().eq("role_code", "DONOR"));
        SysUser u = new SysUser();
        u.setUsername(username.trim());
        u.setPassword(encoder.encode(password));
        u.setRealName(realName == null ? username : realName);
        u.setPhone(phone);
        u.setRoleId(donor == null ? 4L : donor.getId());
        u.setRoleCode("DONOR");
        u.setDataScope("SELF");
        u.setOrgId(1L);
        u.setStatus("启用");
        u.setLoginFailCount(0);
        userMapper.insert(u);
    }
}
