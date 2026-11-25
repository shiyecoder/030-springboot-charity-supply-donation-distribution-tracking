package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 分配规则（表 charity_material_rule）
 */
@Data
@TableName("charity_material_rule")
public class MaterialRule {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 规则编号 */
    private String ruleNo;

    /** 规则名称 */
    private String ruleName;

    /** 版本号 */
    private String ruleVersion;

    /** 因素与权重 */
    private String factorJson;

    /** 权重合计 */
    private java.math.BigDecimal weightTotal;

    /** 等级阈值 */
    private String thresholdJson;

    /** 状态 */
    private String status;

    /** 生效时间 */
    private java.time.LocalDateTime effectTime;

    /** 发布人 */
    private Long publisherId;

    /** 变更说明 */
    private String changeNote;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
