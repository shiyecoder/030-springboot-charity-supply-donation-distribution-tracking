package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 申请需求明细（表 aid_application_item）
 */
@Data
@TableName("aid_application_item")
public class AidApplicationItem {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 受助申请 */
    private Long applicationId;

    /** 物资名称 */
    private String materialName;

    /** 物资类别 */
    private String category;

    /** 规格 */
    private String spec;

    /** 单位 */
    private String unit;

    /** 申请数量 */
    private Integer applyQty;

    /** 批准数量 */
    private Integer approveQty;

    /** 说明 */
    private String remark;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
