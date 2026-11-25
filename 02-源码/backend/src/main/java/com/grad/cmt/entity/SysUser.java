package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 用户（表 sys_user）
 */
@Data
@TableName("sys_user")
public class SysUser {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 登录账号 */
    private String username;

    /** 密码（BCrypt） */
    private String password;

    /** 姓名 */
    private String realName;

    /** 头像 */
    private String avatar;

    /** 手机号 */
    private String phone;

    /** 邮箱 */
    private String email;

    /** 所属组织 */
    private Long orgId;

    /** 角色 */
    private Long roleId;

    /** 角色编码 */
    private String roleCode;

    /** 数据范围 */
    private String dataScope;

    /** 状态 */
    private String status;

    /** 连续失败次数 */
    private Integer loginFailCount;

    /** 锁定时间 */
    private java.time.LocalDateTime lockTime;

    /** 最近登录 */
    private java.time.LocalDateTime lastLoginTime;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
