package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 组织（表 sys_org）
 */
@Data
@TableName("sys_org")
public class SysOrg {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 组织名称 */
    private String orgName;

    /** 组织编码 */
    private String orgCode;

    /** 组织类型 */
    private String orgType;

    /** 上级组织 */
    private Long parentId;

    /** 配送能力 */
    private String deliveryCapacity;

    /** 地址 */
    private String address;

    /** 负责人 */
    private String leader;

    /** 联系电话 */
    private String phone;

    /** 状态 */
    private String status;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
