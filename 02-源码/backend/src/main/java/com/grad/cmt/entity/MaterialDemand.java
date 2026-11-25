package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 物资与需求（表 material_demand）
 */
@Data
@TableName("material_demand")
public class MaterialDemand {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 需求编号 */
    private String demandNo;

    /** 关联项目 */
    private Long projectId;

    /** 物资名称 */
    private String materialName;

    /** 物资类别 */
    private String category;

    /** 规格 */
    private String spec;

    /** 单位 */
    private String unit;

    /** 可接收质量 */
    private String acceptQuality;

    /** 保质期要求 */
    private String shelfLifeReq;

    /** 需求数量 */
    private Integer demandQty;

    /** 已入库数量 */
    private Integer receivedQty;

    /** 当前缺口 */
    private Integer gapQty;

    /** 紧迫度 */
    private String urgency;

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
