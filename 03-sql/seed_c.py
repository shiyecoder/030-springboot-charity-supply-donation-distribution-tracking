#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""种子数据 C 部分 + 拼装 init.sql。"""
import os, sys, random
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from seed_b import OUT, ins, q, dt, past, future, random  # noqa
import schema

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MATS = ["一级压榨菜籽油", "东北长粒香米", "加厚羽绒服（成人）", "儿童棉衣", "学生护眼台灯",
        "课外读物", "洗衣液（家庭装）", "成人尿布裤", "轮椅", "棉被"]
MATS[7] = "成人纸尿裤"
REGIONS = ["城西街道", "东湖街道", "南苑街道", "北岭街道", "开发区"]
OP = ["许文山", "柳知远", "王凤娟", "周慧兰", "陈砚秋"]

# ---------------------------------------------------------------- 过程记录
REC_ACT = [("捐赠意向", "提交意向", "—", "待预审"), ("捐赠意向", "预审通过", "待预审", "待送达"),
           ("收货验收", "提交验收", "待验收", "已入库"), ("受助申请", "资格审核", "待审核", "待拣货"),
           ("发放追踪单", "拣货完成", "待拣货", "待领用"), ("发放追踪单", "签收回执", "待领用", "待反馈"),
           ("发放追踪单", "追踪归档", "待反馈", "已完成"), ("受助申请", "退回申请", "待审核", "已退回")]
recs = []
for i in range(60):
    a = REC_ACT[i % len(REC_ACT)]
    off = 160 - i * 2
    recs.append((a[0], (i % 32) + 1, "%s-%04d" % (["INT", "RCV", "AID", "DO"][i % 4], 862 - i),
                 a[2], a[3], a[1],
                 ["物资符合需求，仓位已预留", "实收与应收差异 2 件，已现场拍照", "资格符合，按限领规则批准",
                  "FEFO 推荐批次可用量充足", "受助人本人到场领取", "反馈审核通过并公开"][i % 6],
                 (i % 5) + 2, OP[i % 5], dt(max(off, 1), 9 + i % 9, i % 60), None))
ins("charity_material_record", ["biz_type", "biz_id", "biz_no", "from_status", "to_status",
                                "action", "reason", "operator_id", "operator_name",
                                "operate_time", "remark", "create_time"],
    [(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[9]) for r in recs])

# ---------------------------------------------------------------- 规则版本
FACTOR_V32 = ('[{"key":"urgency","name":"需求紧迫等级","weight":25,"source":"aid_application.urgency_level"},'
              '{"key":"family","name":"家庭人数","weight":15,"source":"aid_application.family_size"},'
              '{"key":"history","name":"历史领取量","weight":15,"source":"distribution_order 近12月"},'
              '{"key":"stock","name":"库存数量","weight":20,"source":"inventory_batch 可用量"},'
              '{"key":"expire","name":"保质期","weight":10,"source":"inventory_batch.expire_date"},'
              '{"key":"delivery","name":"区域配送能力","weight":15,"source":"sys_org.delivery_capacity"}]')
FACTOR_V31 = FACTOR_V32.replace('"weight":20', '"weight":15').replace('"weight":15,"source":"distribution_order 近12月"',
                                                                       '"weight":20,"source":"distribution_order 近12月"')
FACTOR_V30 = FACTOR_V32.replace('"weight":25', '"weight":35')
THRESH = '{"A":80,"B":60,"C":40}'
ins("charity_material_rule", ["id", "rule_no", "rule_name", "rule_version", "factor_json",
                              "weight_total", "threshold_json", "status", "effect_time",
                              "publisher_id", "change_note", "create_time"],
    [(1, "RULE-001", "需求紧迫度与物资分配建议", "v3.0", FACTOR_V30, 100, THRESH, "停用",
      dt(120, 9, 0), 1, "首次引入六因素加权模型，替代原单一紧迫度排序", dt(120)),
     (2, "RULE-002", "需求紧迫度与物资分配建议", "v3.1", FACTOR_V31, 100, THRESH, "停用",
      dt(70, 9, 0), 1, "修正保质期评分阈值，临期批次优先出库", dt(70)),
     (3, "RULE-003", "需求紧迫度与物资分配建议", "v3.2", FACTOR_V32, 100, THRESH, "启用",
      dt(24, 9, 0), 1, "提高紧迫等级权重至 25%，新增区域配送能力因素", dt(24))])

# ---------------------------------------------------------------- 分配建议
LEVELS = ["优先分配", "常规分配", "暂缓分配", "不推荐"]
LEVEL_SCORE = {"优先分配": (82, 96), "常规分配": (62, 79), "暂缓分配": (42, 58), "不推荐": (26, 39)}
sc_rows = []
for i in range(30):
    lv = LEVELS[i % 4] if i % 7 else LEVELS[(i + 1) % 4]
    lo, hi = LEVEL_SCORE[lv]
    total = round(random.uniform(lo, hi), 1)
    off = 150 - i * 4
    sc_rows.append(("SCR-2026-%04d" % (418 - i), i + 1, i + 1 if i < 30 else None, 3, "v3.2",
                    '{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}',
                    '[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},'
                    '{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},'
                    '{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',
                    total, lv,
                    "菜籽油 3 桶 · 大米 1 袋 · 羽绒服 1 件" if lv == "优先分配" else "按申请数量 80% 发放",
                    "年度累计领取量已接近上限（米面粮油 42/60 kg）" if i % 3 == 0 else None,
                    "补充家庭收入流水可提升紧迫等级判定精度" if i % 2 == 0 else None,
                    dt(max(off, 1), 9 + i % 8, i % 60), 1 if i % 6 == 0 else 0,
                    "按年度累计上限调整，保障后续月份可领" if i % 6 == 0 else None,
                    3 if i % 6 == 0 else None, dt(max(off, 1), 10, 5) if i % 6 == 0 else None))
ins("charity_material_score", ["score_no", "application_id", "order_id", "rule_id", "rule_version",
                               "snapshot_json", "factor_json", "total_score", "result_level",
                               "suggestion", "unmet", "improve", "calc_time", "adjust_flag",
                               "adjust_reason", "adjust_user_id", "adjust_time"], sc_rows)

# ---------------------------------------------------------------- 盘点
chk_rows = []
CHK_ST = ["正常"] * 14 + ["差异待复核"] * 4 + ["已调整"] * 2
for i in range(20):
    book = random.randint(10, 220)
    diff = 0 if CHK_ST[i] == "正常" else random.choice([-3, -2, -1, 1, 2])
    chk_rows.append(("CHK-2026-%04d" % (120 - i), (i % 5) + 2,
                     "%s-%02d-%02d" % ("ABCDE"[i % 5], (i % 6) + 1, (i % 4) + 1),
                     (i % 24) + 1, book, book + diff, diff, [5, 6, 7][i % 3],
                     dt(max(120 - i * 5, 1), 14 + i % 4, i % 60), CHK_ST[i],
                     "账面与实盘不符，待复核" if diff else None))
ins("inventory_check", ["check_no", "warehouse_id", "position", "batch_id", "book_qty",
                        "real_qty", "diff_qty", "check_user_id", "check_time", "status",
                        "remark", "create_time"],
    [(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[8]) for r in chk_rows])

# ---------------------------------------------------------------- 消息
MSG = [("待审批", "捐赠意向 INT-0862（青禾商贸，菜籽油 200 桶）待您预审，预约送达时间 2026-11-03 09:00。", "INT-0862"),
       ("即将超时", "发放追踪单 DO-2026-0418 距截止时间不足 32 小时，当前阶段「分配出库」。", "DO-2026-0418"),
       ("待验收", "收货任务 RCV-2026-1031-018（城西社区爱心志愿队，洗衣液 150 瓶）已到仓，请验收。", "RCV-2026-1031-018"),
       ("已退回", "受助申请 AID-2026-0398 被退回：年度累计领取量已超上限，请补充材料后重新提交。", "AID-2026-0398"),
       ("已完成", "发放追踪单 DO-2026-0403 已完成归档，受助人反馈已审核通过并公开。", "DO-2026-0403"),
       ("待审批", "去向反馈 FB-2026-0306 待审核，提交人 陈**，含 2 张照片。", "FB-2026-0306"),
       ("异常", "批次 BAT-260802-03（东北长粒香米）已过期，系统已自动锁定，请登记处置方式。", "BAT-260802-03")]
msgs = []
for i in range(20):
    m = MSG[i % 7]
    msgs.append((m[0] + "提醒", m[1], m[0], m[2].split("-")[0],
                 m[2], (i % 32) + 1, {"待审批": "intent", "即将超时": "distribution", "待验收": "receiving",
                                      "已退回": "application", "已完成": "distribution",
                                      "异常": "batch"}[m[0]],
                 1 if i < 6 else (2 if i % 3 else 1), 0 if i < 6 else 1,
                 dt(max(120 - i * 5, 1), 9 + i % 9, i % 60)))
ins("sys_message", ["title", "content", "msg_type", "biz_type", "biz_no", "biz_id", "biz_url",
                    "receiver_id", "read_flag", "create_time"],
    [(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9]) for r in msgs])

# ---------------------------------------------------------------- 操作日志
LOGS = [("捐赠意向", "预审", "待预审", "待送达", "正常"), ("收货验收", "提交验收", "待验收", "已入库", "正常"),
        ("受助申请", "资格审核", "待审核", "待拣货", "正常"), ("受助申请", "人工调整", "—", "—", "正常"),
        ("发放追踪单", "拣货完成", "待拣货", "待领用", "正常"), ("规则配置", "发布规则", "v3.1", "v3.2", "正常"),
        ("系统登录", "登录", "—", "—", "正常"), ("系统登录", "登录", "—", "—", "密码错误，已锁定")]
logs = []
for i in range(30):
    l = LOGS[i % len(LOGS)]
    logs.append(((i % 12) + 1, OP[i % 5],
                 ["项目管理员", "仓储志愿者", "受助审核员"][i % 3], l[0], l[1],
                 "%s-%04d" % (["INT", "RCV", "AID", "DO"][i % 4], 862 - i), l[2], l[3],
                 "192.168.1.%d" % (12 + i), l[4], dt(max(150 - i * 4, 1), 9 + i % 9, i % 60)))
ins("sys_oper_log", ["user_id", "user_name", "role_code", "module", "action", "biz_no",
                     "from_status", "to_status", "ip", "result", "operate_time"], logs)

# ---------------------------------------------------------------- 文件
FILES = [("低保证明.pdf", "/uploads/seed/scene/01.jpg", "application/pdf"),
         ("户口本首页.jpg", "/uploads/seed/scene/02.jpg", "image/jpeg"),
         ("诊断证明.pdf", "/uploads/seed/scene/03.jpg", "application/pdf"),
         ("手写申请.jpg", "/uploads/seed/scene/04.jpg", "image/jpeg"),
         ("验收现场-1.jpg", "/uploads/seed/scene/01.jpg", "image/jpeg"),
         ("验收现场-2.jpg", "/uploads/seed/scene/02.jpg", "image/jpeg"),
         ("签字照片.jpg", "/uploads/seed/scene/03.jpg", "image/jpeg"),
         ("配送凭证.jpg", "/uploads/seed/scene/04.jpg", "image/jpeg"),
         ("物资图片-1.jpg", "/uploads/seed/material/01.jpg", "image/jpeg"),
         ("物资图片-2.jpg", "/uploads/seed/material/02.jpg", "image/jpeg"),
         ("项目封面.jpg", "/uploads/seed/project/01.jpg", "image/jpeg"),
         ("反馈照片.jpg", "/uploads/seed/scene/01.jpg", "image/jpeg")]
ins("sys_file", ["file_name", "file_path", "file_size", "content_type", "biz_type",
                 "uploader_id", "upload_time"],
    [(f[0], f[1], random.randint(80000, 2400000), f[2],
      ["application", "receiving", "feedback", "material"][i % 4], (i % 12) + 1,
      dt(max(150 - i * 6, 1), 10 + i % 8, i % 60)) for i, f in enumerate(FILES)])

# ---------------------------------------------------------------- 拼装 init.sql
head = """-- ============================================================
-- 公益物资捐赠与发放追踪系统 · 数据库初始化脚本
-- 数据库：new_030    字符集：utf8mb4
-- 表数量：26（18 业务 + 8 系统）  测试数据时间跨度：2026-05-01 ~ 2026-11-01
-- 默认管理员：admin / admin123   其余账号密码：123456
-- ============================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS new_030 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE new_030;

"""
ddl_all = "\n".join(schema.ddl(t) for t in schema.TABLES)
body = "\n".join(OUT)

idx = """
-- ---------------- 索引 ----------------
CREATE INDEX idx_intent_status ON donation_intent (status);
CREATE INDEX idx_intent_donor ON donation_intent (donor_id);
CREATE INDEX idx_batch_status ON inventory_batch (status, expire_date);
CREATE INDEX idx_batch_material ON inventory_batch (material_name, warehouse_id);
CREATE INDEX idx_apply_status ON aid_application (status, apply_time);
CREATE INDEX idx_order_stage ON distribution_order (stage, status);
CREATE INDEX idx_order_beneficiary ON distribution_order (beneficiary_id);
CREATE INDEX idx_feedback_audit ON beneficiary_feedback (audit_status);
CREATE INDEX idx_record_biz ON charity_material_record (biz_type, biz_id);
CREATE INDEX idx_score_app ON charity_material_score (application_id);
CREATE INDEX idx_msg_receiver ON sys_message (receiver_id, read_flag);
CREATE INDEX idx_log_user ON sys_oper_log (user_id, operate_time);

SET FOREIGN_KEY_CHECKS = 1;
"""

with open(os.path.join(BASE, "sql/init.sql"), "w", encoding="utf-8") as f:
    f.write(head + ddl_all + "\n" + body + idx)

print("init.sql 写入完成，语句数 %d" % (len(OUT) + 1))
