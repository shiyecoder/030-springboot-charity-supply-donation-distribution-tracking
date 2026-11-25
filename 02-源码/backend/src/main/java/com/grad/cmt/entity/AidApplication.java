package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 受助申请（表 aid_application）
 */
@Data
@TableName("aid_application")
public class AidApplication {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 申请编号 */
    private String applyNo;

    /** 受助人 */
    private Long beneficiaryId;

    /** 申请类型 */
    private String applyType;

    /** 申请人 */
    private String applicantName;

    /** 身份证号 */
    private String idCard;

    /** 联系电话 */
    private String phone;

    /** 家庭人数 */
    private Integer familySize;

    /** 所属区域 */
    private String region;

    /** 紧迫等级 */
    private String urgencyLevel;

    /** 用途说明 */
    private String purpose;

    /** 证明材料 */
    private String certFiles;

    /** 申请时间 */
    private java.time.LocalDateTime applyTime;

    /** 申请状态 */
    private String status;

    /** 审核员 */
    private Long auditorId;

    /** 审核时间 */
    private java.time.LocalDateTime auditTime;

    /** 审核意见 */
    private String auditOpinion;

    /** 退回理由 */
    private String rejectReason;

    /** 发放方式 */
    private String distributeType;

    /** 代办人 */
    private String agentName;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
