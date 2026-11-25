package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 站内消息（表 sys_message）
 */
@Data
@TableName("sys_message")
public class SysMessage {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 标题 */
    private String title;

    /** 内容 */
    private String content;

    /** 消息类型 */
    private String msgType;

    /** 业务类型 */
    private String bizType;

    /** 业务编号 */
    private String bizNo;

    /** 业务主键 */
    private Long bizId;

    /** 详情跳转 */
    private String bizUrl;

    /** 接收人 */
    private Long receiverId;

    /** 是否已读 */
    private Integer readFlag;

    /** 阅读时间 */
    private java.time.LocalDateTime readTime;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
