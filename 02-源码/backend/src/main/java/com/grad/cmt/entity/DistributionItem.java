package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 发放明细（表 distribution_item）
 */
@Data
@TableName("distribution_item")
public class DistributionItem {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 发放单 */
    private Long orderId;

    /** 批次 */
    private Long batchId;

    /** 物资名称 */
    private String materialName;

    /** 规格 */
    private String spec;

    /** 单位 */
    private String unit;

    /** 计划数量 */
    private Integer planQty;

    /** 实际数量 */
    private Integer actualQty;

    /** 拣货时间 */
    private java.time.LocalDateTime pickTime;

    /** 备注 */
    private String remark;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
