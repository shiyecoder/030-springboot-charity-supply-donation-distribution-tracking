package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 菜单（表 sys_menu）
 */
@Data
@TableName("sys_menu")
public class SysMenu {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 上级菜单 */
    private Long parentId;

    /** 菜单名称 */
    private String menuName;

    /** 类型 */
    private String menuType;

    /** 路由 */
    private String path;

    /** 权限标识 */
    private String perms;

    /** 图标 */
    private String icon;

    /** 排序 */
    private Integer sortNo;

    /** 是否可见 */
    private Integer visible;

    /** 状态 */
    private String status;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
