package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 分配建议计算（表 charity_material_score）
 */
@Data
@TableName("charity_material_score")
public class MaterialScore {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 计算编号 */
    private String scoreNo;

    /** 受助申请 */
    private Long applicationId;

    /** 发放单 */
    private Long orderId;

    /** 规则 */
    private Long ruleId;

    /** 规则版本 */
    private String ruleVersion;

    /** 输入快照 */
    private String snapshotJson;

    /** 逐项得分 */
    private String factorJson;

    /** 总分 */
    private java.math.BigDecimal totalScore;

    /** 结果等级 */
    private String resultLevel;

    /** 建议发放 */
    private String suggestion;

    /** 未满足条件 */
    private String unmet;

    /** 可改进项 */
    private String improve;

    /** 计算时间 */
    private java.time.LocalDateTime calcTime;

    /** 是否人工调整 */
    private Integer adjustFlag;

    /** 调整原因 */
    private String adjustReason;

    /** 调整人 */
    private Long adjustUserId;

    /** 调整时间 */
    private java.time.LocalDateTime adjustTime;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
