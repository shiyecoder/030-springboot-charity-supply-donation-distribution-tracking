package com.grad.cmt.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.grad.cmt.common.BizException;
import com.grad.cmt.common.PageResult;
import com.grad.cmt.common.UserContext;
import com.grad.cmt.entity.*;
import com.grad.cmt.mapper.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

/**
 * 系统管理：用户、角色、菜单、字典、操作日志、站内消息。
 * 菜单按角色动态下发；「菜单管理」项对所有非管理员角色隐藏。
 */
@Service
public class SystemService {

    private final SysUserMapper userMapper;
    private final SysRoleMapper roleMapper;
    private final SysMenuMapper menuMapper;
    private final SysRoleMenuMapper roleMenuMapper;
    private final SysDictMapper dictMapper;
    private final SysOperLogMapper logMapper;
    private final SysMessageMapper messageMapper;
    private final SysOrgMapper orgMapper;
    private final PasswordEncoder encoder;

    public SystemService(SysUserMapper userMapper, SysRoleMapper roleMapper, SysMenuMapper menuMapper,
                         SysRoleMenuMapper roleMenuMapper, SysDictMapper dictMapper, SysOperLogMapper logMapper,
                         SysMessageMapper messageMapper, SysOrgMapper orgMapper, PasswordEncoder encoder) {
        this.userMapper = userMapper;
        this.roleMapper = roleMapper;
        this.menuMapper = menuMapper;
        this.roleMenuMapper = roleMenuMapper;
        this.dictMapper = dictMapper;
        this.logMapper = logMapper;
        this.messageMapper = messageMapper;
        this.orgMapper = orgMapper;
        this.encoder = encoder;
    }

    /** 用户列表：不返回密码字段 */
    public PageResult<Map<String, Object>> userPage(Map<String, String> p) {
        QueryWrapper<SysUser> w = new QueryWrapper<>();
        if (has(p, "roleCode")) {
            w.eq("role_code", p.get("roleCode"));
        }
        if (has(p, "orgId")) {
            w.eq("org_id", p.get("orgId"));
        }
        if (has(p, "status")) {
            w.eq("status", p.get("status"));
        }
        if (has(p, "keyword")) {
            w.and(x -> x.like("username", p.get("keyword")).or().like("real_name", p.get("keyword")));
        }
        w.orderByDesc("create_time");
        Page<SysUser> page = userMapper.selectPage(page(p), w);
        List<Map<String, Object>> list = new ArrayList<>();
        for (SysUser u : page.getRecords()) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", u.getId());
            m.put("username", u.getUsername());
            m.put("realName", u.getRealName());
            m.put("avatar", u.getAvatar());
            m.put("phone", AidService.maskPhone(u.getPhone()));
            m.put("roleCode", u.getRoleCode());
            m.put("dataScope", u.getDataScope());
            m.put("status", u.getStatus());
            m.put("lastLoginTime", u.getLastLoginTime());
            SysOrg org = u.getOrgId() == null ? null : orgMapper.selectById(u.getOrgId());
            m.put("orgName", org == null ? "" : org.getOrgName());
            SysRole role = u.getRoleId() == null ? null : roleMapper.selectById(u.getRoleId());
            m.put("roleName", role == null ? "" : role.getRoleName());
            list.add(m);
        }
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), list);
    }

    public void saveUser(SysUser u) {
        if (u.getUsername() == null || u.getUsername().isBlank()) {
            throw new BizException("登录账号不能为空");
        }
        if (u.getId() == null) {
            Long cnt = userMapper.selectCount(new QueryWrapper<SysUser>().eq("username", u.getUsername().trim()));
            if (cnt != null && cnt > 0) {
                throw new BizException("该账号已存在");
            }
            u.setUsername(u.getUsername().trim());
            String pwd = u.getPassword() == null || u.getPassword().isBlank() ? "123456" : u.getPassword();
            u.setPassword(encoder.encode(pwd));
            u.setLoginFailCount(0);
            if (u.getStatus() == null) {
                u.setStatus("启用");
            }
            userMapper.insert(u);
        } else {
            SysUser old = userMapper.selectById(u.getId());
            if (old == null) {
                throw new BizException("用户不存在");
            }
            old.setRealName(u.getRealName());
            old.setPhone(u.getPhone());
            old.setEmail(u.getEmail());
            old.setOrgId(u.getOrgId());
            old.setRoleId(u.getRoleId());
            old.setRoleCode(u.getRoleCode());
            old.setDataScope(u.getDataScope());
            old.setStatus(u.getStatus());
            if (u.getAvatar() != null) {
                old.setAvatar(u.getAvatar());
            }
            userMapper.updateById(old);
        }
    }

    public void toggleUser(Long id, String status) {
        SysUser u = userMapper.selectById(id);
        if (u == null) {
            throw new BizException("用户不存在");
        }
        if (u.getId() == 1L && "停用".equals(status)) {
            throw new BizException("不能停用默认管理员");
        }
        u.setStatus(status);
        if ("启用".equals(status)) {
            u.setLoginFailCount(0);
            u.setLockTime(null);
        }
        userMapper.updateById(u);
    }

    public List<SysRole> roles() {
        return roleMapper.selectList(new QueryWrapper<SysRole>().eq("status", "启用"));
    }

    public List<SysOrg> orgs() {
        return orgMapper.selectList(new QueryWrapper<SysOrg>().eq("status", "启用"));
    }

    /** 角色菜单：返回已分配菜单 id，便于前端勾选 */
    public Map<String, Object> roleMenus(Long roleId) {
        List<SysRoleMenu> links = roleMenuMapper.selectList(new QueryWrapper<SysRoleMenu>().eq("role_id", roleId));
        List<Long> ids = links.stream().map(SysRoleMenu::getMenuId).toList();
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("menuIds", ids);
        m.put("menus", menuTree());
        return m;
    }

    public List<Map<String, Object>> menuTree() {
        return tree(menuMapper.selectList(new QueryWrapper<SysMenu>().orderByAsc("sort_no")), 0L);
    }

    private List<Map<String, Object>> tree(List<SysMenu> all, Long parent) {
        List<Map<String, Object>> out = new ArrayList<>();
        for (SysMenu m : all) {
            if (!Objects.equals(m.getParentId(), parent)) {
                continue;
            }
            Map<String, Object> n = new LinkedHashMap<>();
            n.put("id", m.getId());
            n.put("name", m.getMenuName());
            n.put("type", m.getMenuType());
            n.put("path", m.getPath());
            n.put("perms", m.getPerms());
            n.put("icon", m.getIcon());
            n.put("sortNo", m.getSortNo());
            n.put("visible", m.getVisible());
            n.put("status", m.getStatus());
            List<Map<String, Object>> children = tree(all, m.getId());
            if (!children.isEmpty()) {
                n.put("children", children);
            }
            out.add(n);
        }
        return out;
    }

    /** 保存角色菜单：先清后插，保证分配结果与勾选一致 */
    public void assignMenus(Long roleId, List<Long> menuIds) {
        if (roleId == null) {
            throw new BizException("请选择角色");
        }
        roleMenuMapper.delete(new QueryWrapper<SysRoleMenu>().eq("role_id", roleId));
        if (menuIds != null) {
            for (Long mid : menuIds) {
                SysRoleMenu rm = new SysRoleMenu();
                rm.setRoleId(roleId);
                rm.setMenuId(mid);
                roleMenuMapper.insert(rm);
            }
        }
    }

    public PageResult<SysOperLog> logPage(Map<String, String> p) {
        QueryWrapper<SysOperLog> w = new QueryWrapper<>();
        if (has(p, "module")) {
            w.eq("module", p.get("module"));
        }
        if (has(p, "userName")) {
            w.like("user_name", p.get("userName"));
        }
        if (has(p, "keyword")) {
            w.and(x -> x.like("biz_no", p.get("keyword")).or().like("action", p.get("keyword")));
        }
        w.orderByDesc("operate_time");
        Page<SysOperLog> page = logMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    public List<SysDict> dicts(String type) {
        return dictMapper.selectList(new QueryWrapper<SysDict>()
                .eq(type != null && !type.isBlank(), "dict_type", type)
                .eq("status", "启用").orderByAsc("sort_no"));
    }

    public PageResult<SysMessage> messagePage(Map<String, String> p) {
        QueryWrapper<SysMessage> w = new QueryWrapper<SysMessage>()
                .eq("receiver_id", UserContext.userId());
        if (p != null && "unread".equals(p.get("type"))) {
            w.eq("read_flag", 0);
        }
        if (has(p, "msgType")) {
            w.eq("msg_type", p.get("msgType"));
        }
        w.orderByAsc("read_flag").orderByDesc("create_time");
        Page<SysMessage> page = messageMapper.selectPage(page(p), w);
        return new PageResult<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }

    public void readMessage(Long id) {
        SysMessage m = messageMapper.selectById(id);
        if (m == null) {
            throw new BizException("消息不存在");
        }
        if (!Objects.equals(m.getReceiverId(), UserContext.userId())) {
            throw new BizException("只能操作自己的消息");
        }
        m.setReadFlag(1);
        m.setReadTime(LocalDateTime.now());
        messageMapper.updateById(m);
    }

    public void readAll() {
        List<SysMessage> list = messageMapper.selectList(new QueryWrapper<SysMessage>()
                .eq("receiver_id", UserContext.userId()).eq("read_flag", 0));
        for (SysMessage m : list) {
            m.setReadFlag(1);
            m.setReadTime(LocalDateTime.now());
            messageMapper.updateById(m);
        }
    }

    private boolean has(Map<String, String> p, String k) {
        return p != null && p.get(k) != null && !p.get(k).isBlank() && !p.get(k).startsWith("全部");
    }

    private <T> Page<T> page(Map<String, String> p) {
        long page = 1, size = 10;
        try {
            if (p != null && p.get("page") != null) {
                page = Math.max(1, Long.parseLong(p.get("page")));
            }
            if (p != null && p.get("size") != null) {
                size = Math.min(100, Math.max(1, Long.parseLong(p.get("size"))));
            }
        } catch (NumberFormatException ignored) {
        }
        return new Page<>(page, size);
    }
}
