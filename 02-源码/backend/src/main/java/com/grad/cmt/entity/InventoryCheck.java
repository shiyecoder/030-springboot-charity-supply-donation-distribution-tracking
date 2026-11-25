package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 库存盘点（表 inventory_check）
 */
@Data
@TableName("inventory_check")
public class InventoryCheck {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 盘点单号 */
    private String checkNo;

    /** 仓库 */
    private Long warehouseId;

    /** 货位 */
    private String position;

    /** 批次 */
    private Long batchId;

    /** 账面数量 */
    private Integer bookQty;

    /** 实盘数量 */
    private Integer realQty;

    /** 差异数量 */
    private Integer diffQty;

    /** 盘点人 */
    private Long checkUserId;

    /** 盘点时间 */
    private java.time.LocalDateTime checkTime;

    /** 状态 */
    private String status;

    /** 备注 */
    private String remark;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
