package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 受助人档案（表 aid_beneficiary）
 */
@Data
@TableName("aid_beneficiary")
public class AidBeneficiary {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 档案编号 */
    private String beneficiaryNo;

    /** 姓名 */
    private String name;

    /** 身份证号 */
    private String idCard;

    /** 联系电话 */
    private String phone;

    /** 性别 */
    private String gender;

    /** 出生年份 */
    private Integer birthYear;

    /** 家庭人数 */
    private Integer familySize;

    /** 家庭住址 */
    private String address;

    /** 所属区域 */
    private String region;

    /** 所属组织 */
    private Long orgId;

    /** 家庭月收入 */
    private java.math.BigDecimal familyIncome;

    /** 是否资格认定 */
    private Integer qualified;

    /** 认定日期 */
    private java.time.LocalDate qualifiedDate;

    /** 证明材料 */
    private String certFiles;

    /** 紧迫等级 */
    private String urgentLevel;

    /** 状态 */
    private String status;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}
