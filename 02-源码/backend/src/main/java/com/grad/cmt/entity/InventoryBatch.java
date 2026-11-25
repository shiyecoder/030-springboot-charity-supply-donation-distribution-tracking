package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 物资入库批次（表 inventory_batch）
 */
@Data
@TableName("inventory_batch")
public class InventoryBatch {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 批次编号 */
    private String batchNo;

    /** 物资名称 */
    private String materialName;

    /** 物资类别 */
    private String category;

    /** 规格 */
    private String spec;

    /** 单位 */
    private String unit;

    /** 来源项目 */
    private Long projectId;

    /** 来源意向 */
    private Long intentId;

    /** 来源收货单 */
    private Long receiveId;

    /** 捐赠方 */
    private String donorName;

    /** 所在仓库 */
    private Long warehouseId;

    /** 货位 */
    private String position;

    /** 入库数量 */
    private Integer inQty;

    /** 可用数量 */
    private Integer availableQty;

    /** 锁定数量 */
    private Integer lockedQty;

    /** 质量等级 */
    private String qualityLevel;

    /** 物资图片 */
    private String materialImage;

    /** 生产日期 */
    private java.time.LocalDate produceDate;

    /** 有效期至 */
    private java.time.LocalDate expireDate;

    /** 入库时间 */
    private java.time.LocalDateTime inTime;

    /** 库存状态 */
    private String status;

    /** 发放状态 */
    private String issueStatus;

    /** 验收人 */
    private Long checkUserId;

    /** 参考单价 */
    private java.math.BigDecimal priceRef;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
