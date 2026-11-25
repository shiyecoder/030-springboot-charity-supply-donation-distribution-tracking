package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 操作日志（表 sys_oper_log）
 */
@Data
@TableName("sys_oper_log")
public class SysOperLog {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 操作人 */
    private Long userId;

    /** 操作人姓名 */
    private String userName;

    /** 角色 */
    private String roleCode;

    /** 模块 */
    private String module;

    /** 操作 */
    private String action;

    /** 业务编号 */
    private String bizNo;

    /** 原状态 */
    private String fromStatus;

    /** 新状态 */
    private String toStatus;

    /** IP */
    private String ip;

    /** 结果 */
    private String result;

    /** 操作时间 */
    private java.time.LocalDateTime operateTime;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
