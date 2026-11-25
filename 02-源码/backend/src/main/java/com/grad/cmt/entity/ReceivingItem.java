package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 收货明细（表 receiving_item）
 */
@Data
@TableName("receiving_item")
public class ReceivingItem {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 收货单 */
    private Long receiveId;

    /** 实际品名 */
    private String materialName;

    /** 物资类别 */
    private String category;

    /** 规格 */
    private String spec;

    /** 单位 */
    private String unit;

    /** 应收 */
    private Integer expectQty;

    /** 实收 */
    private Integer actualQty;

    /** 质量等级 */
    private String qualityLevel;

    /** 有效期至 */
    private java.time.LocalDate expireDate;

    /** 不合格数 */
    private Integer unqualifiedQty;

    /** 差异 */
    private Integer diffQty;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
