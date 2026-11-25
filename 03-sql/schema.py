#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""NEW-030 公益物资捐赠与发放追踪系统 —— 表结构单一来源。
同时生成：sql/init.sql（DDL + 种子数据）、Java 实体与 Mapper。"""
import os
import random

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
JAVA = os.path.join(BASE, "backend/src/main/java/com/grad/cmt")
SQL = os.path.join(BASE, "sql")

SQLMAP = {
    "str10": "varchar(10)", "str20": "varchar(20)", "str50": "varchar(50)", "str64": "varchar(64)", "str100": "varchar(100)",
    "str200": "varchar(200)", "str500": "varchar(500)", "text": "text",
    "int": "int", "big": "bigint", "dec": "decimal(12,2)",
    "date": "date", "dt": "datetime", "flag": "tinyint",
}
JMAP = {
    "str50": "String", "str64": "String", "str100": "String", "str200": "String",
    "str10": "String", "str20": "String", "str500": "String", "text": "String", "int": "Integer", "big": "Long",
    "dec": "java.math.BigDecimal", "date": "java.time.LocalDate",
    "dt": "java.time.LocalDateTime", "flag": "Integer",
}

# (表名, 实体类名, 中文名, 字段列表[(列名, 类型, 注释)])
TABLES = [
    ("donation_project", "DonationProject", "捐赠项目", [
        ("project_no", "str50", "项目编号"), ("title", "str200", "项目主题"),
        ("service_target", "str50", "服务对象"), ("category", "str50", "物资类别"),
        ("unit", "str20", "计量单位"), ("target_qty", "int", "目标数量"),
        ("received_qty", "int", "已接收数量"), ("distributed_qty", "int", "已发放数量"),
        ("warehouse_id", "big", "承接仓库"), ("contact_name", "str50", "联系人"),
        ("contact_phone", "str20", "联系电话"), ("deadline", "date", "截止日期"),
        ("public_desc", "text", "公开说明"), ("cover_image", "str200", "项目封面"),
        ("status", "str20", "项目状态"), ("publisher_id", "big", "发布人"),
    ]),
    ("material_demand", "MaterialDemand", "物资与需求", [
        ("demand_no", "str50", "需求编号"), ("project_id", "big", "关联项目"),
        ("material_name", "str100", "物资名称"), ("category", "str50", "物资类别"),
        ("spec", "str100", "规格"), ("unit", "str20", "单位"),
        ("accept_quality", "str50", "可接收质量"), ("shelf_life_req", "str100", "保质期要求"),
        ("demand_qty", "int", "需求数量"), ("received_qty", "int", "已入库数量"),
        ("gap_qty", "int", "当前缺口"), ("urgency", "str20", "紧迫度"),
        ("status", "str20", "状态"), ("remark", "str500", "备注"),
    ]),
    ("donation_intent", "DonationIntent", "捐赠意向", [
        ("intent_no", "str50", "意向编号"), ("project_id", "big", "关联项目"),
        ("donor_id", "big", "捐赠人账号"), ("donor_name", "str100", "捐赠人/单位"),
        ("donor_type", "str20", "捐赠人类型"), ("material_name", "str100", "物资名称"),
        ("category", "str50", "物资类别"), ("spec", "str100", "规格"), ("unit", "str20", "单位"),
        ("est_qty", "int", "预估数量"), ("quality_level", "str50", "新旧程度"),
        ("delivery_type", "str50", "送达方式"), ("appoint_time", "dt", "预约送达时间"),
        ("contact_phone", "str20", "联系电话"), ("status", "str20", "意向状态"),
        ("precheck_opinion", "str500", "预审意见"), ("position", "str50", "预计仓位"),
        ("reject_reason", "str500", "拒收理由"), ("auditor_id", "big", "预审人"),
    ]),
    ("receiving_record", "ReceivingRecord", "收货验收", [
        ("receive_no", "str50", "收货单号"), ("intent_id", "big", "关联意向"),
        ("warehouse_id", "big", "收货仓库"), ("receive_user_id", "big", "验收人"),
        ("receive_time", "dt", "验收时间"), ("expect_qty", "int", "应收数量"),
        ("actual_qty", "int", "实收数量"), ("qualified_qty", "int", "合格数量"),
        ("unqualified_qty", "int", "不合格数量"), ("unqualified_rate", "dec", "不合格率"),
        ("quality_level", "str50", "质量等级"), ("expire_date", "date", "有效期至"),
        ("photos", "text", "现场照片"), ("diff_reason", "str500", "差异说明"),
        ("result", "str20", "接收结论"), ("status", "str20", "状态"),
    ]),
    ("receiving_item", "ReceivingItem", "收货明细", [
        ("receive_id", "big", "收货单"), ("material_name", "str100", "实际品名"),
        ("category", "str50", "物资类别"), ("spec", "str100", "规格"), ("unit", "str20", "单位"),
        ("expect_qty", "int", "应收"), ("actual_qty", "int", "实收"),
        ("quality_level", "str50", "质量等级"), ("expire_date", "date", "有效期至"),
        ("unqualified_qty", "int", "不合格数"), ("diff_qty", "int", "差异"),
    ]),
    ("inventory_batch", "InventoryBatch", "物资入库批次", [
        ("batch_no", "str50", "批次编号"), ("material_name", "str100", "物资名称"),
        ("category", "str50", "物资类别"), ("spec", "str100", "规格"), ("unit", "str20", "单位"),
        ("project_id", "big", "来源项目"), ("intent_id", "big", "来源意向"),
        ("receive_id", "big", "来源收货单"), ("donor_name", "str100", "捐赠方"),
        ("warehouse_id", "big", "所在仓库"), ("position", "str50", "货位"),
        ("in_qty", "int", "入库数量"), ("available_qty", "int", "可用数量"),
        ("locked_qty", "int", "锁定数量"), ("quality_level", "str50", "质量等级"),
        ("material_image", "str200", "物资图片"), ("produce_date", "date", "生产日期"),
        ("expire_date", "date", "有效期至"), ("in_time", "dt", "入库时间"),
        ("status", "str20", "库存状态"), ("issue_status", "str20", "发放状态"),
        ("check_user_id", "big", "验收人"), ("price_ref", "dec", "参考单价"),
    ]),
    ("aid_beneficiary", "AidBeneficiary", "受助人档案", [
        ("beneficiary_no", "str50", "档案编号"), ("name", "str50", "姓名"),
        ("id_card", "str50", "身份证号"), ("phone", "str20", "联系电话"),
        ("gender", "str10", "性别"), ("birth_year", "int", "出生年份"),
        ("family_size", "int", "家庭人数"), ("address", "str200", "家庭住址"),
        ("region", "str50", "所属区域"), ("org_id", "big", "所属组织"),
        ("family_income", "dec", "家庭月收入"), ("qualified", "flag", "是否资格认定"),
        ("qualified_date", "date", "认定日期"), ("cert_files", "text", "证明材料"),
        ("urgent_level", "str20", "紧迫等级"), ("status", "str20", "状态"),
    ]),
    ("aid_application", "AidApplication", "受助申请", [
        ("apply_no", "str50", "申请编号"), ("beneficiary_id", "big", "受助人"),
        ("apply_type", "str20", "申请类型"), ("applicant_name", "str50", "申请人"),
        ("id_card", "str50", "身份证号"), ("phone", "str20", "联系电话"),
        ("family_size", "int", "家庭人数"), ("region", "str50", "所属区域"),
        ("urgency_level", "str20", "紧迫等级"), ("purpose", "str500", "用途说明"),
        ("cert_files", "text", "证明材料"), ("apply_time", "dt", "申请时间"),
        ("status", "str20", "申请状态"), ("auditor_id", "big", "审核员"),
        ("audit_time", "dt", "审核时间"), ("audit_opinion", "str500", "审核意见"),
        ("reject_reason", "str500", "退回理由"), ("distribute_type", "str20", "发放方式"),
        ("agent_name", "str50", "代办人"),
    ]),
    ("aid_application_item", "AidApplicationItem", "申请需求明细", [
        ("application_id", "big", "受助申请"), ("material_name", "str100", "物资名称"),
        ("category", "str50", "物资类别"), ("spec", "str100", "规格"), ("unit", "str20", "单位"),
        ("apply_qty", "int", "申请数量"), ("approve_qty", "int", "批准数量"),
        ("remark", "str200", "说明"),
    ]),
    ("distribution_order", "DistributionOrder", "发放追踪单", [
        ("order_no", "str50", "发放单号"), ("application_id", "big", "受助申请"),
        ("beneficiary_id", "big", "受助人"), ("receiver_name", "str50", "领取人"),
        ("receiver_phone", "str20", "联系电话"), ("region", "str50", "所属区域"),
        ("stage", "str20", "当前阶段"), ("status", "str20", "单据状态"),
        ("warehouse_id", "big", "发放仓库"), ("owner_id", "big", "责任人"),
        ("deliver_type", "str20", "发放方式"), ("deliver_address", "str200", "配送地址"),
        ("carrier", "str50", "运送人"), ("total_qty", "int", "合计数量"),
        ("deadline", "dt", "截止时间"), ("finish_time", "dt", "完成时间"),
        ("cancel_reason", "str500", "作废/取消原因"), ("score_id", "big", "分配建议"),
    ]),
    ("distribution_item", "DistributionItem", "发放明细", [
        ("order_id", "big", "发放单"), ("batch_id", "big", "批次"),
        ("material_name", "str100", "物资名称"), ("spec", "str100", "规格"),
        ("unit", "str20", "单位"), ("plan_qty", "int", "计划数量"),
        ("actual_qty", "int", "实际数量"), ("pick_time", "dt", "拣货时间"),
        ("remark", "str200", "备注"),
    ]),
    ("beneficiary_feedback", "BeneficiaryFeedback", "去向反馈", [
        ("feedback_no", "str50", "反馈编号"), ("order_id", "big", "发放单"),
        ("application_id", "big", "受助申请"), ("submitter", "str50", "提交人"),
        ("submitter_type", "str20", "提交人类型"), ("feedback_type", "str20", "反馈类型"),
        ("content", "str500", "反馈内容"), ("photos", "text", "照片"),
        ("public_flag", "flag", "是否同意公开"), ("audit_status", "str20", "审核状态"),
        ("audit_user_id", "big", "审核人"), ("audit_time", "dt", "审核时间"),
        ("audit_opinion", "str500", "审核意见"), ("sensitive_hit", "str200", "敏感词命中"),
        ("region", "str50", "所属区域"),
    ]),
    ("charity_material_record", "MaterialRecord", "过程记录与状态流转", [
        ("biz_type", "str50", "业务类型"), ("biz_id", "big", "业务主键"),
        ("biz_no", "str50", "业务编号"), ("from_status", "str50", "变更前状态"),
        ("to_status", "str50", "变更后状态"), ("action", "str50", "操作动作"),
        ("reason", "str500", "原因"), ("operator_id", "big", "操作人"),
        ("operator_name", "str50", "操作人姓名"), ("operate_time", "dt", "操作时间"),
        ("remark", "str500", "备注"),
    ]),
    ("charity_material_attachment", "MaterialAttachment", "附件与图片", [
        ("biz_type", "str50", "业务类型"), ("biz_id", "big", "业务主键"),
        ("file_name", "str200", "原始文件名"), ("file_path", "str200", "相对路径"),
        ("file_size", "big", "文件大小"), ("content_type", "str50", "文件类型"),
        ("uploader_id", "big", "上传人"), ("upload_time", "dt", "上传时间"),
    ]),
    ("charity_material_rule", "MaterialRule", "分配规则", [
        ("rule_no", "str50", "规则编号"), ("rule_name", "str100", "规则名称"),
        ("rule_version", "str20", "版本号"), ("factor_json", "text", "因素与权重"),
        ("weight_total", "dec", "权重合计"), ("threshold_json", "text", "等级阈值"),
        ("status", "str20", "状态"), ("effect_time", "dt", "生效时间"),
        ("publisher_id", "big", "发布人"), ("change_note", "str500", "变更说明"),
    ]),
    ("charity_material_score", "MaterialScore", "分配建议计算", [
        ("score_no", "str50", "计算编号"), ("application_id", "big", "受助申请"),
        ("order_id", "big", "发放单"), ("rule_id", "big", "规则"),
        ("rule_version", "str20", "规则版本"), ("snapshot_json", "text", "输入快照"),
        ("factor_json", "text", "逐项得分"), ("total_score", "dec", "总分"),
        ("result_level", "str20", "结果等级"), ("suggestion", "str500", "建议发放"),
        ("unmet", "str500", "未满足条件"), ("improve", "str500", "可改进项"),
        ("calc_time", "dt", "计算时间"), ("adjust_flag", "flag", "是否人工调整"),
        ("adjust_reason", "str500", "调整原因"), ("adjust_user_id", "big", "调整人"),
        ("adjust_time", "dt", "调整时间"),
    ]),
    ("inventory_check", "InventoryCheck", "库存盘点", [
        ("check_no", "str50", "盘点单号"), ("warehouse_id", "big", "仓库"),
        ("position", "str50", "货位"), ("batch_id", "big", "批次"),
        ("book_qty", "int", "账面数量"), ("real_qty", "int", "实盘数量"),
        ("diff_qty", "int", "差异数量"), ("check_user_id", "big", "盘点人"),
        ("check_time", "dt", "盘点时间"), ("status", "str20", "状态"),
        ("remark", "str200", "备注"),
    ]),
    ("sys_user", "SysUser", "用户", [
        ("username", "str50", "登录账号"), ("password", "str100", "密码（BCrypt）"),
        ("real_name", "str50", "姓名"), ("avatar", "str200", "头像"),
        ("phone", "str20", "手机号"), ("email", "str100", "邮箱"),
        ("org_id", "big", "所属组织"), ("role_id", "big", "角色"),
        ("role_code", "str50", "角色编码"), ("data_scope", "str20", "数据范围"),
        ("status", "str20", "状态"), ("login_fail_count", "int", "连续失败次数"),
        ("lock_time", "dt", "锁定时间"), ("last_login_time", "dt", "最近登录"),
    ]),
    ("sys_org", "SysOrg", "组织", [
        ("org_name", "str100", "组织名称"), ("org_code", "str50", "组织编码"),
        ("org_type", "str20", "组织类型"), ("parent_id", "big", "上级组织"),
        ("delivery_capacity", "str20", "配送能力"), ("address", "str200", "地址"),
        ("leader", "str50", "负责人"), ("phone", "str20", "联系电话"),
        ("status", "str20", "状态"),
    ]),
    ("sys_role", "SysRole", "角色", [
        ("role_code", "str50", "角色编码"), ("role_name", "str50", "角色名称"),
        ("data_scope", "str20", "数据范围"), ("remark", "str200", "说明"),
        ("status", "str20", "状态"),
    ]),
    ("sys_menu", "SysMenu", "菜单", [
        ("parent_id", "big", "上级菜单"), ("menu_name", "str50", "菜单名称"),
        ("menu_type", "str20", "类型"), ("path", "str100", "路由"),
        ("perms", "str100", "权限标识"), ("icon", "str50", "图标"),
        ("sort_no", "int", "排序"), ("visible", "flag", "是否可见"),
        ("status", "str20", "状态"),
    ]),
    ("sys_role_menu", "SysRoleMenu", "角色菜单", [
        ("role_id", "big", "角色"), ("menu_id", "big", "菜单"),
    ]),
    ("sys_message", "SysMessage", "站内消息", [
        ("title", "str100", "标题"), ("content", "str500", "内容"),
        ("msg_type", "str20", "消息类型"), ("biz_type", "str50", "业务类型"),
        ("biz_no", "str50", "业务编号"), ("biz_id", "big", "业务主键"),
        ("biz_url", "str200", "详情跳转"), ("receiver_id", "big", "接收人"),
        ("read_flag", "flag", "是否已读"), ("read_time", "dt", "阅读时间"),
    ]),
    ("sys_dict", "SysDict", "数据字典", [
        ("dict_type", "str50", "字典类型"), ("dict_code", "str50", "字典编码"),
        ("dict_label", "str50", "字典名称"), ("sort_no", "int", "排序"),
        ("status", "str20", "状态"),
    ]),
    ("sys_file", "SysFile", "文件", [
        ("file_name", "str200", "原始文件名"), ("file_path", "str200", "相对路径"),
        ("file_size", "big", "文件大小"), ("content_type", "str50", "文件类型"),
        ("biz_type", "str50", "业务类型"), ("uploader_id", "big", "上传人"),
        ("upload_time", "dt", "上传时间"),
    ]),
    ("sys_oper_log", "SysOperLog", "操作日志", [
        ("user_id", "big", "操作人"), ("user_name", "str50", "操作人姓名"),
        ("role_code", "str50", "角色"), ("module", "str50", "模块"),
        ("action", "str50", "操作"), ("biz_no", "str50", "业务编号"),
        ("from_status", "str50", "原状态"), ("to_status", "str50", "新状态"),
        ("ip", "str50", "IP"), ("result", "str50", "结果"),
        ("operate_time", "dt", "操作时间"),
    ]),
]

CN = {t[0]: t[2] for t in TABLES}
CLS = {t[0]: t[1] for t in TABLES}


def camel(s):
    parts = s.split("_")
    return parts[0] + "".join(p.capitalize() for p in parts[1:])


def ddl(t):
    name, _, cn, fields = t
    cols = ["  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',"]
    for col, typ, cmt in fields:
        sql_type = SQLMAP[typ]
        default = ""
        if typ == "int":
            default = " DEFAULT 0"
        elif typ == "flag":
            default = " DEFAULT 0"
        cols.append("  %s %s%s COMMENT '%s'," % (col, sql_type, default, cmt))
    cols.append("  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',")
    cols.append("  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',")
    cols.append("  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',")
    cols.append("  version int NOT NULL DEFAULT 0 COMMENT '版本号',")
    cols.append("  PRIMARY KEY (id)")
    return "DROP TABLE IF EXISTS `%s`;\nCREATE TABLE `%s` (\n%s\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='%s';\n" % (
        name, name, "\n".join(cols), cn)


def entity(t):
    name, cls, cn, fields = t
    lines = ["package com.grad.cmt.entity;", "",
             "import com.baomidou.mybatisplus.annotation.*;",
             "import lombok.Data;", "import java.time.*;", "import java.math.BigDecimal;", "",
             "/**", " * %s（表 %s）" % (cn, name), " */",
             "@Data", '@TableName("%s")' % name, "public class %s {" % cls, "",
             "    @TableId(type = IdType.AUTO)", "    private Long id;", ""]
    for col, typ, cmt in fields:
        lines.append("    /** %s */" % cmt)
        if col == "deleted":
            lines.append("    @TableLogic")
        lines.append("    private %s %s;" % (JMAP[typ], camel(col)))
        lines.append("")
    lines.append("    private LocalDateTime createTime;")
    lines.append("    private LocalDateTime updateTime;")
    lines.append("    @TableLogic")
    lines.append("    private Integer deleted;")
    lines.append("    private Integer version;")
    lines.append("}")
    return "\n".join(lines) + "\n"


def mapper(t):
    name, cls = t[0], t[1]
    return """package com.grad.cmt.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.grad.cmt.entity.%s;
import org.apache.ibatis.annotations.Mapper;

/** %s Mapper */
@Mapper
public interface %sMapper extends BaseMapper<%s> {
}
""" % (cls, CN[name], cls, cls)


def main():
    os.makedirs(os.path.join(JAVA, "entity"), exist_ok=True)
    os.makedirs(os.path.join(JAVA, "mapper"), exist_ok=True)
    os.makedirs(SQL, exist_ok=True)
    for t in TABLES:
        with open(os.path.join(JAVA, "entity", t[1] + ".java"), "w", encoding="utf-8") as f:
            f.write(entity(t))
        with open(os.path.join(JAVA, "mapper", t[1] + "Mapper.java"), "w", encoding="utf-8") as f:
            f.write(mapper(t))
    print("entities+ mappers: %d" % len(TABLES))
    return TABLES


if __name__ == "__main__":
    main()
