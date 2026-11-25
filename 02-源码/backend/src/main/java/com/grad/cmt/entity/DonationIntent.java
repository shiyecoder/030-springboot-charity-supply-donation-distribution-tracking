package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 捐赠意向（表 donation_intent）
 */
@Data
@TableName("donation_intent")
public class DonationIntent {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 意向编号 */
    private String intentNo;

    /** 关联项目 */
    private Long projectId;

    /** 捐赠人账号 */
    private Long donorId;

    /** 捐赠人/单位 */
    private String donorName;

    /** 捐赠人类型 */
    private String donorType;

    /** 物资名称 */
    private String materialName;

    /** 物资类别 */
    private String category;

    /** 规格 */
    private String spec;

    /** 单位 */
    private String unit;

    /** 预估数量 */
    private Integer estQty;

    /** 新旧程度 */
    private String qualityLevel;

    /** 送达方式 */
    private String deliveryType;

    /** 预约送达时间 */
    private java.time.LocalDateTime appointTime;

    /** 联系电话 */
    private String contactPhone;

    /** 意向状态 */
    private String status;

    /** 预审意见 */
    private String precheckOpinion;

    /** 预计仓位 */
    private String position;

    /** 拒收理由 */
    private String rejectReason;

    /** 预审人 */
    private Long auditorId;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
