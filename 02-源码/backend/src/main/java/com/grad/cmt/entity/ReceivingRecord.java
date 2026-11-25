package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 收货验收（表 receiving_record）
 */
@Data
@TableName("receiving_record")
public class ReceivingRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 收货单号 */
    private String receiveNo;

    /** 关联意向 */
    private Long intentId;

    /** 收货仓库 */
    private Long warehouseId;

    /** 验收人 */
    private Long receiveUserId;

    /** 验收时间 */
    private java.time.LocalDateTime receiveTime;

    /** 应收数量 */
    private Integer expectQty;

    /** 实收数量 */
    private Integer actualQty;

    /** 合格数量 */
    private Integer qualifiedQty;

    /** 不合格数量 */
    private Integer unqualifiedQty;

    /** 不合格率 */
    private java.math.BigDecimal unqualifiedRate;

    /** 质量等级 */
    private String qualityLevel;

    /** 有效期至 */
    private java.time.LocalDate expireDate;

    /** 现场照片 */
    private String photos;

    /** 差异说明 */
    private String diffReason;

    /** 接收结论 */
    private String result;

    /** 状态 */
    private String status;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
