#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""种子数据 B 部分 + 生成 init.sql（DDL + 全部 INSERT）。"""
import os, sys, random, datetime
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from seed_a import OUT, ins, q, dt, d, past, future, random  # noqa

MATS = [("一级压榨菜籽油", "米面粮油", "5L / 桶", "桶"),
        ("东北长粒香米", "米面粮油", "10kg / 袋", "袋"),
        ("加厚羽绒服（成人）", "御寒衣物", "M/L/XL", "件"),
        ("儿童棉衣", "御寒衣物", "110-150", "件"),
        ("学生护眼台灯", "学习用品", "USB 供电", "台"),
        ("课外读物", "学习用品", "适龄读物", "册"),
        ("洗衣液（家庭装）", "日用清洁", "3kg / 瓶", "瓶"),
        ("成人纸尿裤", "医疗护理", "L 码 20 片", "包"),
        ("轮椅", "医疗护理", "折叠式", "台"),
        ("棉被", "御寒衣物", "200×230", "床")]
MAT_IMG = ["/uploads/seed/material/%02d.jpg" % i for i in range(1, 7)]
SCENE = ["/uploads/seed/scene/%02d.jpg" % i for i in range(1, 5)]
REGIONS = ["城西街道", "东湖街道", "南苑街道", "北岭街道", "开发区"]
SURNAME = ["王", "李", "张", "赵", "陈", "刘", "杨", "黄", "周", "吴"]
GIVEN = ["秀兰", "建国", "桂英", "志强", "美华", "德明", "素芬", "海涛", "玉梅", "国庆"]

# ---------------------------------------------------------------- 收货验收
rec_rows, rec_items = [], []
RESULT = ["接收"] * 20 + ["部分接收"] * 7 + ["拒收"] * 3
for i in range(30):
    m = MATS[i % len(MATS)]
    expect = random.randint(40, 300)
    res = RESULT[i]
    unq = 0 if res == "接收" else (expect if res == "拒收" else random.randint(2, 8))
    actual = expect if res == "接收" else expect - random.randint(0, 4)
    off = 168 - i * 5
    rec_rows.append(("RCV-%s%s-%02d" % (past(max(off, 1))[2:4], past(max(off, 1))[5:7], i + 1),
                     i + 1, (i % 5) + 2, [5, 6, 7][i % 3], dt(max(off, 1), 9 + i % 9, i % 60),
                     expect, actual, max(actual - unq, 0), unq,
                     round(unq * 100.0 / max(actual, 1), 2), ["A 级", "B 级", "C 级"][0 if res == "接收" else i % 3],
                     future(200 + i * 10) if m[1] in ("米面粮油", "日用清洁", "医疗护理") else None,
                     ",".join(SCENE[(i * 7) % 4:(i * 7) % 4 + 2]) or SCENE[0],
                     "实收与应收差异 %d 件，%s" % (abs(expect - actual), "外包装破损已退回" if unq else "无差异"),
                     res, "已入库" if res != "拒收" else "已拒收"))
ins("receiving_record", ["receive_no", "intent_id", "warehouse_id", "receive_user_id",
                         "receive_time", "expect_qty", "actual_qty", "qualified_qty",
                         "unqualified_qty", "unqualified_rate", "quality_level", "expire_date",
                         "photos", "diff_reason", "result", "status", "create_time"],
    [(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13],
      r[14], r[15], r[4]) for r in rec_rows])

for i in range(30):
    m = MATS[i % len(MATS)]
    rid = i + 1
    ex = rec_rows[i][5]
    ac = rec_rows[i][6]
    rec_items.append((rid, m[0], m[1], m[2], m[3], ex, ac, "A 级" if i % 5 else "B 级",
                      rec_rows[i][11], rec_rows[i][8], ac - ex))
ins("receiving_item", ["receive_id", "material_name", "category", "spec", "unit", "expect_qty",
                       "actual_qty", "quality_level", "expire_date", "unqualified_qty", "diff_qty"],
    rec_items)

# ---------------------------------------------------------------- 入库批次
BAT_ST = ["正常"] * 16 + ["临期"] * 5 + ["过期"] * 2 + ["锁定"] * 1
bat_rows = []
for i in range(24):
    m = MATS[i % len(MATS)]
    qty = [200, 150, 36, 120, 118, 90, 152, 60, 8, 48][i % 10]
    st = BAT_ST[i]
    if st == "过期":
        exp = past(3 + i)
    elif st == "临期":
        exp = future(6 + i * 3)
    else:
        exp = future(60 + i * 20) if m[1] in ("米面粮油", "日用清洁", "医疗护理") else None
    avail = 0 if st in ("过期", "锁定") else max(qty - random.randint(0, qty // 2), 0)
    off = 165 - i * 6
    bat_rows.append(("BAT-%s-%02d" % (past(max(off, 1))[2:].replace("-", ""), i + 1), m[0], m[1],
                     m[2], m[3], (i % 14) + 1, i + 1, i + 1,
                     ["杭州市临平区青禾商贸", "周慧兰（个人）", "浙江明远律师事务所",
                      "城西社区爱心志愿队", "李泽川（个人）", "匿名爱心人士"][i % 6],
                     (i % 5) + 2, "%s-%02d-%02d" % ("ABCDE"[i % 5], (i % 6) + 1, (i % 4) + 1),
                     qty, avail, qty - avail if st == "锁定" else 0,
                     ["A 级", "A 级", "B 级", "九成新"][i % 4],
                     MAT_IMG[(i * 7) % 6], past(max(off + 30, 1)), exp, dt(max(off, 1), 10 + i % 8, i % 60),
                     st, "已发完" if avail == 0 and st == "正常" else ("部分发放" if avail < qty * 0.5 else "未发放"),
                     [5, 6, 7][i % 3], round(random.uniform(8, 260), 2)))
ins("inventory_batch", ["batch_no", "material_name", "category", "spec", "unit", "project_id",
                        "intent_id", "receive_id", "donor_name", "warehouse_id", "position",
                        "in_qty", "available_qty", "locked_qty", "quality_level", "material_image",
                        "produce_date", "expire_date", "in_time", "status", "issue_status",
                        "check_user_id", "price_ref", "create_time"],
    [(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13],
      r[14], r[15], r[16], r[17], r[18], r[19], r[20], r[21], r[22], r[18]) for r in bat_rows])

# ---------------------------------------------------------------- 受助人档案
ben_rows = []
for i in range(30):
    nm = SURNAME[i % 10] + GIVEN[(i * 3) % 10]
    fs = random.randint(1, 6)
    ben_rows.append(("BEN-2026-%04d" % (i + 1), nm,
                     "3301%s****%s" % (["02", "03", "05", "06"][i % 4], "%04d" % (1800 + i * 37)),
                     "138****%04d" % (6000 + i * 11), "男" if i % 2 else "女",
                     1940 + i * 2, fs, "%s××社区××路 %d 号" % (REGIONS[i % 5], 8 + i),
                     REGIONS[i % 5], (i % 5) + 2, round(random.uniform(800, 4200), 2), 1,
                     past(200 - i * 5), ",".join(SCENE[(i * 7) % 4:(i * 7) % 4 + 2]) or SCENE[0],
                     ["特急", "紧急", "一般"][i % 3], "正常" if i % 8 else "停用"))
ins("aid_beneficiary", ["beneficiary_no", "name", "id_card", "phone", "gender", "birth_year",
                        "family_size", "address", "region", "org_id", "family_income",
                        "qualified", "qualified_date", "cert_files", "urgent_level", "status",
                        "create_time"],
    [(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13],
      r[14], r[15], dt(max(200 - i * 5, 1))) for r in ben_rows])

# ---------------------------------------------------------------- 受助申请
APP_ST = (["待审核"] * 6 + ["待拣货"] * 5 + ["待领用"] * 4 + ["待配送"] * 3 +
          ["待反馈"] * 4 + ["已完成"] * 8 + ["已退回"] * 1 + ["已取消"] * 1)
random.shuffle(APP_ST)
app_rows, app_items = [], []
for i in range(32):
    m = MATS[i % len(MATS)]
    fs = random.randint(1, 6)
    st = APP_ST[i]
    off = 160 - i * 4
    app_rows.append(("AID-2026-%04d" % (418 - i), i + 1, ["个人", "家庭", "机构"][i % 3],
                     ben_rows[i % len(ben_rows)][1], ben_rows[i % len(ben_rows)][2], ben_rows[i % len(ben_rows)][3], fs, REGIONS[i % 5],
                     ["特急", "紧急", "一般"][i % 3],
                     "家庭日常食用与保暖需求" if i % 2 else "机构统一分发至服务对象",
                     ",".join(SCENE[(i * 3) % 4:(i * 3) % 4 + 2]) or SCENE[0],
                     dt(max(off, 1), 9 + i % 8, i % 60), st,
                     3 if st not in ("待审核",) else None,
                     dt(max(off - 1, 1), 10 + i % 6, i % 60) if st not in ("待审核",) else None,
                     "资格符合，按限领规则批准" if st not in ("待审核", "已退回") else None,
                     "同户 30 天内已领取同类物资，间隔期未满" if st == "已退回" else None,
                     ["现场领用", "配送上门"][i % 2],
                     "社区网格员 柳知远" if i % 3 == 0 else None))
ins("aid_application", ["apply_no", "beneficiary_id", "apply_type", "applicant_name", "id_card",
                        "phone", "family_size", "region", "urgency_level", "purpose",
                        "cert_files", "apply_time", "status", "auditor_id", "audit_time",
                        "audit_opinion", "reject_reason", "distribute_type", "agent_name",
                        "create_time"],
    [(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13],
      r[14], r[15], r[16], r[17], r[18], r[11]) for r in app_rows])

for i in range(32):
    m = MATS[i % len(MATS)]
    apply_qty = random.randint(1, 5)
    approve = apply_qty if APP_ST[i] != "已退回" else 0
    app_items.append((i + 1, m[0], m[1], m[2], m[3], apply_qty, approve,
                      "按年度上限调整" if approve < apply_qty else None))
ins("aid_application_item", ["application_id", "material_name", "category", "spec", "unit",
                             "apply_qty", "approve_qty", "remark"], app_items)

# ---------------------------------------------------------------- 发放追踪单
STAGE = ["捐赠登记", "质检入库", "需求审核", "分配出库", "签收回执", "追踪归档"]
ord_rows, ord_items = [], []
for i in range(32):
    st = APP_ST[i]
    if st == "待审核":
        stage, status = "需求审核", "待处理"
    elif st == "待拣货":
        stage, status = "分配出库", "处理中"
    elif st in ("待领用", "待配送"):
        stage, status = "签收回执", "处理中"
    elif st == "待反馈":
        stage, status = "追踪归档", "处理中"
    elif st == "已完成":
        stage, status = "追踪归档", "已完成"
    elif st == "已退回":
        stage, status = "需求审核", "已退回"
    else:
        stage, status = "分配出库", "已取消"
    off = 150 - i * 4
    ord_rows.append(("DO-2026-%04d" % (418 - i), i + 1, i + 1, ben_rows[i % len(ben_rows)][1], ben_rows[i % len(ben_rows)][3],
                     REGIONS[i % 5], stage, status, (i % 5) + 2,
                     [5, 6, 7, 3][i % 4], ["现场领用", "配送上门"][i % 2],
                     "%s××社区××路 %d 号" % (REGIONS[i % 5], 8 + i) if i % 2 else None,
                     "运送人 何志远" if i % 2 else None, random.randint(1, 8),
                     dt(max(off - 2, 1), 18, 0), dt(max(off - 3, 1), 15, 20) if status == "已完成" else None,
                     "受助人已由社区统一安置，无需发放" if status == "已取消" else None,
                     i + 1 if i < 30 else None))
ins("distribution_order", ["order_no", "application_id", "beneficiary_id", "receiver_name",
                           "receiver_phone", "region", "stage", "status", "warehouse_id",
                           "owner_id", "deliver_type", "deliver_address", "carrier", "total_qty",
                           "deadline", "finish_time", "cancel_reason", "score_id", "create_time"],
    [(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13],
      r[14], r[15], r[16], r[17], dt(max(148 - i * 4, 1), 9 + i % 8, i % 60)) for i, r in enumerate(ord_rows)])

for i in range(32):
    m = MATS[i % len(MATS)]
    ord_items.append((i + 1, (i % 24) + 1, m[0], m[2], m[3], random.randint(1, 4),
                      random.randint(1, 4), dt(max(148 - i * 4, 1), 10 + i % 6, i % 60),
                      "FEFO 推荐批次" if i % 3 == 0 else None))
ins("distribution_item", ["order_id", "batch_id", "material_name", "spec", "unit", "plan_qty",
                          "actual_qty", "pick_time", "remark"], ord_items)

# ---------------------------------------------------------------- 去向反馈
fb_rows = []
FB_ST = ["待审核"] * 6 + ["已通过"] * 14 + ["已驳回"] * 4
for i in range(24):
    st = FB_ST[i]
    off = 140 - i * 5
    fb_rows.append(("FB-2026-%04d" % (306 - i), (i % 32) + 1, (i % 32) + 1,
                    ben_rows[i % len(ben_rows)][1], ["受助人", "项目人员"][i % 2],
                    ["收到确认", "使用反馈", "问题反馈"][i % 3],
                    ["物资已全部收到，包装完好，感谢捐赠人的关心。",
                     "羽绒服已穿用，尺码合适，老人说很暖和。",
                     "其中 2 包外包装有轻微破损，内部完好。",
                     "大米与食用油已收到，社区志愿者送到家门口。"][i % 4],
                    ",".join(SCENE[(i * 3) % 4:(i * 3) % 4 + 2]) or SCENE[0], 1,
                    st, 5 if st != "待审核" else None,
                    dt(max(off - 1, 1), 15 + i % 4, i % 60) if st != "待审核" else None,
                    "内容属实，脱敏后公开" if st == "已通过" else ("含他人信息，驳回修改" if st == "已驳回" else None),
                    None if st != "已驳回" else "手机号", REGIONS[i % 5], dt(max(off, 1), 8 + i % 10, i % 60)))
ins("beneficiary_feedback", ["feedback_no", "order_id", "application_id", "submitter",
                             "submitter_type", "feedback_type", "content", "photos",
                             "public_flag", "audit_status", "audit_user_id", "audit_time",
                             "audit_opinion", "sensitive_hit", "region", "create_time"], fb_rows)

print("part B ok")
