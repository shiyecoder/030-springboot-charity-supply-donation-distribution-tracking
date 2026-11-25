package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 发放追踪单（表 distribution_order）
 */
@Data
@TableName("distribution_order")
public class DistributionOrder {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 发放单号 */
    private String orderNo;

    /** 受助申请 */
    private Long applicationId;

    /** 受助人 */
    private Long beneficiaryId;

    /** 领取人 */
    private String receiverName;

    /** 联系电话 */
    private String receiverPhone;

    /** 所属区域 */
    private String region;

    /** 当前阶段 */
    private String stage;

    /** 单据状态 */
    private String status;

    /** 发放仓库 */
    private Long warehouseId;

    /** 责任人 */
    private Long ownerId;

    /** 发放方式 */
    private String deliverType;

    /** 配送地址 */
    private String deliverAddress;

    /** 运送人 */
    private String carrier;

    /** 合计数量 */
    private Integer totalQty;

    /** 截止时间 */
    private java.time.LocalDateTime deadline;

    /** 完成时间 */
    private java.time.LocalDateTime finishTime;

    /** 作废/取消原因 */
    private String cancelReason;

    /** 分配建议 */
    private Long scoreId;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
