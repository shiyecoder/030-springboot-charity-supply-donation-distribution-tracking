package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 捐赠项目（表 donation_project）
 */
@Data
@TableName("donation_project")
public class DonationProject {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 项目编号 */
    private String projectNo;

    /** 项目主题 */
    private String title;

    /** 服务对象 */
    private String serviceTarget;

    /** 物资类别 */
    private String category;

    /** 计量单位 */
    private String unit;

    /** 目标数量 */
    private Integer targetQty;

    /** 已接收数量 */
    private Integer receivedQty;

    /** 已发放数量 */
    private Integer distributedQty;

    /** 承接仓库 */
    private Long warehouseId;

    /** 联系人 */
    private String contactName;

    /** 联系电话 */
    private String contactPhone;

    /** 截止日期 */
    private java.time.LocalDate deadline;

    /** 公开说明 */
    private String publicDesc;

    /** 项目封面 */
    private String coverImage;

    /** 项目状态 */
    private String status;

    /** 发布人 */
    private Long publisherId;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
