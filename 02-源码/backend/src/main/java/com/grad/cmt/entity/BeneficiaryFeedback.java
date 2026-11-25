package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 去向反馈（表 beneficiary_feedback）
 */
@Data
@TableName("beneficiary_feedback")
public class BeneficiaryFeedback {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 反馈编号 */
    private String feedbackNo;

    /** 发放单 */
    private Long orderId;

    /** 受助申请 */
    private Long applicationId;

    /** 提交人 */
    private String submitter;

    /** 提交人类型 */
    private String submitterType;

    /** 反馈类型 */
    private String feedbackType;

    /** 反馈内容 */
    private String content;

    /** 照片 */
    private String photos;

    /** 是否同意公开 */
    private Integer publicFlag;

    /** 审核状态 */
    private String auditStatus;

    /** 审核人 */
    private Long auditUserId;

    /** 审核时间 */
    private java.time.LocalDateTime auditTime;

    /** 审核意见 */
    private String auditOpinion;

    /** 敏感词命中 */
    private String sensitiveHit;

    /** 所属区域 */
    private String region;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
