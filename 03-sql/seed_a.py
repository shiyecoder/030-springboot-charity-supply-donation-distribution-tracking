#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成 init.sql 的种子数据：26 张表全部有数据，时间分散在近 6 个月。"""
import os, random, datetime

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SQL = os.path.join(BASE, "sql")
random.seed(30)

D0 = datetime.date(2026, 5, 1)
D1 = datetime.date(2026, 11, 1)


def d(offset=None):
    if offset is None:
        offset = random.randint(0, (D1 - D0).days)
    return (D0 + datetime.timedelta(days=offset)).strftime("%Y-%m-%d")


def dt(offset=None, hour=None, minute=None):
    if offset is None:
        offset = random.randint(0, (D1 - D0).days)
    day = D0 + datetime.timedelta(days=offset)
    h = random.randint(8, 19) if hour is None else hour
    m = random.randint(0, 59) if minute is None else minute
    return "%s %02d:%02d:%02d" % (day.strftime("%Y-%m-%d"), h, m, random.randint(0, 59))


def past(days):
    return (D1 - datetime.timedelta(days=days)).strftime("%Y-%m-%d")


def future(days):
    return (D1 + datetime.timedelta(days=days)).strftime("%Y-%m-%d")


def q(v):
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(v)
    return "'" + str(v).replace("\\", "\\\\").replace("'", "''") + "'"


OUT = []


def ins(table, cols, rows):
    if not rows:
        return
    OUT.append("-- %s: %d 行" % (table, len(rows)))
    for r in rows:
        assert len(r) == len(cols), "%s 列数不匹配: %d vs %d -> %s" % (table, len(r), len(cols), r[:3])
        vals = ",".join(q(x) for x in r)
        OUT.append("INSERT INTO `%s` (%s) VALUES (%s);" % (
            table, ",".join("`%s`" % c for c in cols), vals))


# ---------------------------------------------------------------- 组织
ORGS = [
    (1, "总会秘书处", "ORG-001", "总会", 0, "高", "杭州市拱墅区公益路 18 号", "陈砚秋", "0571-88010001"),
    (2, "城西公益仓", "ORG-002", "仓库", 1, "高", "杭州市西湖区文一西路 826 号", "周慧兰", "0571-88010002"),
    (3, "东湖公益仓", "ORG-003", "仓库", 1, "中", "杭州市临平区东湖街道兴国路 66 号", "周慧兰", "0571-88010003"),
    (4, "南苑公益仓", "ORG-004", "仓库", 1, "中", "杭州市上城区南苑街道秋涛路 128 号", "许文山", "0571-88010004"),
    (5, "北岭服务站", "ORG-005", "服务站", 1, "低", "杭州市拱墅区北岭街道石桥路 32 号", "柳知远", "0571-88010005"),
    (6, "开发区驿站", "ORG-006", "服务站", 1, "低", "杭州市钱塘区下沙街道学源街 8 号", "王凤娟", "0571-88010006"),
]
ins("sys_org", ["id", "org_name", "org_code", "org_type", "parent_id", "delivery_capacity",
                "address", "leader", "phone", "status", "create_time"],
    [(o[0], o[1], o[2], o[3], o[4], o[5], o[6], o[7], o[8], "启用", dt(10 + o[0])) for o in ORGS])

# ---------------------------------------------------------------- 角色
ROLES = [(1, "ADMIN", "项目管理员", "ALL", "发布需求、管理项目与仓库、审批与公开报表"),
         (2, "VOLUNTEER", "仓储志愿者", "SELF", "收货验收、分批入库、拣货盘点"),
         (3, "AUDITOR", "受助审核员", "DEPT", "资格与反重审核、批准数量"),
         (4, "DONOR", "捐赠人/单位", "SELF", "查看需求、提交捐赠意向、查看去向反馈")]
ins("sys_role", ["id", "role_code", "role_name", "data_scope", "remark", "status", "create_time"],
    [(r[0], r[1], r[2], r[3], r[4], "启用", dt(12)) for r in ROLES])

# ---------------------------------------------------------------- 用户
AV = ["/uploads/seed/avatar/%02d.jpg" % i for i in range(1, 7)]
USERS = [
    (1, "admin", "陈砚秋", 1, "ADMIN", "ALL", "13800130021", "chenyq@charity.org.cn"),
    (2, "chenyq2", "陈立群", 1, "ADMIN", "ALL", "13800130022", "chenlq@charity.org.cn"),
    (3, "zhouhl", "周慧兰", 2, "AUDITOR", "DEPT", "13900134417", "zhouhl@charity.org.cn"),
    (4, "qianxy", "钱雪莹", 3, "AUDITOR", "DEPT", "13900134418", "qianxy@charity.org.cn"),
    (5, "xuwsh", "许文山", 2, "VOLUNTEER", "SELF", "13700138823", "xuwsh@charity.org.cn"),
    (6, "liuzy", "柳知远", 5, "VOLUNTEER", "SELF", "13600131109", "liuzy@charity.org.cn"),
    (7, "wangfj", "王凤娟", 4, "VOLUNTEER", "SELF", "13300137781", "wangfj@charity.org.cn"),
    (8, "guomz", "郭明泽", 1, "DONOR", "SELF", "13500136602", "guomz@qinghe.com"),
    (9, "linsx", "林素心", 1, "DONOR", "SELF", "18800133345", "linsx@163.com"),
    (10, "zhaoyq", "赵雨琪", 1, "DONOR", "SELF", "18800133346", "zhaoyq@163.com"),
    (11, "sunq", "孙启明", 1, "DONOR", "SELF", "18800133347", "sunqm@163.com"),
    (12, "hejy", "何佳颖", 1, "DONOR", "SELF", "18800133348", "hejy@163.com"),
]
ins("sys_user", ["id", "username", "password", "real_name", "avatar", "phone", "email",
                 "org_id", "role_id", "role_code", "data_scope", "status",
                 "login_fail_count", "last_login_time", "create_time"],
    [(u[0], u[1], "admin123" if u[0] == 1 else "123456", u[2], AV[(u[0] * 7) % 6],
      u[6], u[7], u[3], {1: 1, 2: 2, 3: 3, 4: 4}.get(u[4] == "ADMIN" and 1 or
                                                    {"ADMIN": 1, "AUDITOR": 3, "VOLUNTEER": 2, "DONOR": 4}[u[4]]),
      u[4], u[5], "启用", 0, dt(random.randint(0, 3)), dt(5 + u[0])) for u in USERS])

# ---------------------------------------------------------------- 菜单
MENUS = [
    (1, 0, "公益物资看板", "菜单", "/dashboard", "dashboard:view", "grid", 1),
    (2, 0, "捐赠管理", "目录", "donation", "", "heart", 2),
    (3, 2, "捐赠项目", "菜单", "/project-list", "project:list", "", 1),
    (4, 2, "物资与需求", "菜单", "/demand-list", "demand:list", "", 2),
    (5, 2, "捐赠意向", "菜单", "/intent-list", "intent:list", "", 3),
    (6, 0, "仓储管理", "目录", "warehouse", "", "box", 3),
    (7, 6, "收货验收", "菜单", "/receiving", "receiving:list", "", 1),
    (8, 6, "物资批次台账", "菜单", "/batch-list", "batch:list", "", 2),
    (9, 6, "拣货发放", "菜单", "/distribute", "distribute:list", "", 3),
    (10, 0, "受助管理", "目录", "aid", "", "user", 4),
    (11, 10, "受助需求池", "菜单", "/application-list", "application:list", "", 1),
    (12, 10, "资格与反重审核", "菜单", "/application-review", "application:review", "", 2),
    (13, 10, "发放追踪单", "菜单", "/distribution-list", "distribution:list", "", 3),
    (14, 10, "去向反馈", "菜单", "/feedback-list", "feedback:list", "", 4),
    (15, 0, "创新模块", "目录", "innovation", "", "chart", 5),
    (16, 15, "分配规则配置", "菜单", "/rule-config", "rule:config", "", 1),
    (17, 15, "分配建议解释", "菜单", "/score-detail", "score:detail", "", 2),
    (18, 0, "公开与报表", "目录", "report", "", "chart", 6),
    (19, 18, "公开报表", "菜单", "/report", "report:view", "", 1),
    (20, 0, "系统管理", "目录", "system", "", "gear", 9),
    (21, 20, "用户管理", "菜单", "/user-list", "user:list", "", 1),
    (22, 20, "角色管理", "菜单", "/role-list", "role:list", "", 2),
    (23, 20, "菜单管理", "菜单", "/menu-list", "menu:list", "", 3),
    (24, 20, "操作日志", "菜单", "/log-list", "log:list", "", 4),
    (25, 0, "消息中心", "菜单", "/message", "message:list", "bell", 7),
    (26, 0, "个人中心", "菜单", "/profile", "profile:view", "user", 8),
    (27, 6, "库存盘点", "菜单", "/inventory-check", "check:list", "", 4),
    (28, 10, "受助人档案", "菜单", "/beneficiary-list", "beneficiary:list", "", 5),
]
ins("sys_menu", ["id", "parent_id", "menu_name", "menu_type", "path", "perms", "icon",
                 "sort_no", "visible", "status"],
    [(m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], 0 if m[0] == 23 else 1, "启用") for m in MENUS])

ADMIN_MENUS = [m[0] for m in MENUS]
AUDITOR_MENUS = [1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 28]
VOL_MENUS = [1, 6, 7, 8, 9, 25, 26, 27]
DONOR_MENUS = [1, 2, 3, 4, 5, 18, 19, 25, 26]
rm = []
mid = 1
for rid, mset in [(1, ADMIN_MENUS), (2, VOL_MENUS), (3, AUDITOR_MENUS), (4, DONOR_MENUS)]:
    for m in mset:
        rm.append((mid, rid, m))
        mid += 1
ins("sys_role_menu", ["id", "role_id", "menu_id"], rm)

# ---------------------------------------------------------------- 字典
DICTS = []
CATS = ["米面粮油", "御寒衣物", "学习用品", "日用清洁", "医疗护理", "其他"]
REGIONS = ["城西街道", "东湖街道", "南苑街道", "北岭街道", "开发区"]
for i, c in enumerate(CATS, 1):
    DICTS.append((i, "material_category", "C%02d" % i, c, i))
DICTS += [
    (11, "intent_status", "S01", "待预审", 1), (12, "intent_status", "S02", "待送达", 2),
    (13, "intent_status", "S03", "待验收", 3), (14, "intent_status", "S04", "已入库", 4),
    (15, "intent_status", "S05", "部分接收", 5), (16, "intent_status", "S06", "已拒收", 6),
    (17, "apply_status", "A01", "待审核", 1), (18, "apply_status", "A02", "待拣货", 2),
    (19, "apply_status", "A03", "待领用", 3), (20, "apply_status", "A04", "待配送", 4),
    (21, "apply_status", "A05", "待反馈", 5), (22, "apply_status", "A06", "已完成", 6),
    (23, "apply_status", "A07", "已退回", 7), (24, "apply_status", "A08", "已取消", 8),
    (25, "batch_status", "B01", "正常", 1), (26, "batch_status", "B02", "临期", 2),
    (27, "batch_status", "B03", "过期", 3), (28, "batch_status", "B04", "锁定", 4),
    (29, "urgency_level", "U01", "特急", 1), (30, "urgency_level", "U02", "紧急", 2),
    (31, "urgency_level", "U03", "一般", 3),
    (32, "quality_level", "Q01", "A 级", 1), (33, "quality_level", "Q02", "B 级", 2),
    (34, "quality_level", "Q03", "C 级", 3),
    (35, "deliver_type", "D01", "现场领用", 1), (36, "deliver_type", "D02", "配送上门", 2),
]
for i, r in enumerate(REGIONS, 40):
    DICTS.append((i, "region", "R%02d" % (i - 39), r, i - 39))
ins("sys_dict", ["id", "dict_type", "dict_code", "dict_label", "sort_no", "status"],
    [(x[0], x[1], x[2], x[3], x[4], "启用") for x in DICTS])

# ---------------------------------------------------------------- 捐赠项目
PROJ = [
    ("PRJ-2026-001", "春苗阅读·图书角", "留守儿童", "学习用品", "册", 600, 604, 604, 3, "已归档", "/uploads/seed/project/01.jpg"),
    ("PRJ-2026-002", "清凉一夏·防暑物资", "户外劳动者", "日用清洁", "件", 900, 906, 906, 3, "已归档", "/uploads/seed/project/02.jpg"),
    ("PRJ-2026-003", "银龄关怀·营养补给", "独居老人", "米面粮油", "件", 900, 612, 486, 5, "进行中", "/uploads/seed/project/03.jpg"),
    ("PRJ-2026-004", "无障碍生活·辅具支持", "残障人士", "医疗护理", "件", 320, 148, 96, 5, "进行中", "/uploads/seed/project/04.jpg"),
    ("PRJ-2026-005", "开学第一课·学习用品", "留守儿童", "学习用品", "件", 1500, 1502, 1386, 3, "进行中", "/uploads/seed/project/01.jpg"),
    ("PRJ-2026-006", "暖冬计划·御寒物资包", "低保家庭", "御寒衣物", "件", 2000, 1486, 1032, 2, "进行中", "/uploads/seed/project/02.jpg"),
    ("PRJ-2026-007", "社区爱心角·日常补给", "社区居民", "日用清洁", "件", 1200, 842, 690, 4, "进行中", "/uploads/seed/project/03.jpg"),
    ("PRJ-2026-008", "困境儿童·营养早餐", "困境儿童", "米面粮油", "件", 800, 486, 372, 4, "进行中", "/uploads/seed/project/04.jpg"),
    ("PRJ-2026-009", "失能老人·护理支持", "失能老人", "医疗护理", "件", 600, 214, 128, 2, "进行中", "/uploads/seed/project/01.jpg"),
    ("PRJ-2026-010", "新市民·安家物资", "新市民家庭", "米面粮油", "件", 500, 268, 180, 5, "进行中", "/uploads/seed/project/02.jpg"),
    ("PRJ-2026-011", "暖冬计划·儿童棉衣", "困境儿童", "御寒衣物", "件", 700, 312, 204, 2, "进行中", "/uploads/seed/project/03.jpg"),
    ("PRJ-2026-012", "书香社区·共享阅读", "社区居民", "学习用品", "册", 400, 402, 402, 3, "已归档", "/uploads/seed/project/04.jpg"),
    ("PRJ-2026-013", "环卫工人·冬日关怀", "户外劳动者", "御寒衣物", "件", 300, 128, 62, 5, "进行中", "/uploads/seed/project/01.jpg"),
    ("PRJ-2026-014", "应急储备·家庭物资包", "应急家庭", "米面粮油", "件", 1000, 615, 420, 4, "进行中", "/uploads/seed/project/02.jpg"),
]
ins("donation_project", ["project_no", "title", "service_target", "category", "unit",
                         "target_qty", "received_qty", "distributed_qty", "warehouse_id",
                         "contact_name", "contact_phone", "deadline", "public_desc",
                         "cover_image", "status", "publisher_id", "create_time", "update_time"],
    [(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8],
      ["陈砚秋", "周慧兰", "许文山"][i % 3], "0571-880100%02d" % (i + 1),
      future(20 + i * 5) if p[9] == "进行中" else past(40 + i),
      "本项目面向%s，募集%s类物资，由%s承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。" % (p[2], p[3], ["城西公益仓", "东湖公益仓", "南苑公益仓", "北岭服务站"][p[8] - 2]),
      p[10], p[9], 1, dt(i * 8 + 2), dt(i * 8 + 6)) for i, p in enumerate(PROJ)])

# ---------------------------------------------------------------- 物资与需求
MATS = [("一级压榨菜籽油", "米面粮油", "5L / 桶", "桶", "全新", "≥ 12 个月"),
        ("东北长粒香米", "米面粮油", "10kg / 袋", "袋", "全新", "≥ 10 个月"),
        ("加厚羽绒服（成人）", "御寒衣物", "M/L/XL", "件", "九成新以上", "不适用"),
        ("儿童棉衣", "御寒衣物", "110-150", "件", "九成新以上", "不适用"),
        ("学生护眼台灯", "学习用品", "USB 供电", "台", "全新", "不适用"),
        ("课外读物", "学习用品", "适龄读物", "册", "八成新以上", "不适用"),
        ("洗衣液（家庭装）", "日用清洁", "3kg / 瓶", "瓶", "全新", "≥ 24 个月"),
        ("成人纸尿裤", "医疗护理", "L 码 20 片", "包", "全新", "≥ 18 个月"),
        ("轮椅", "医疗护理", "折叠式", "台", "八成新以上", "不适用"),
        ("棉被", "御寒衣物", "200×230", "床", "九成新以上", "不适用")]
demand_rows = []
for i in range(26):
    m = MATS[i % len(MATS)]
    dem = random.randint(200, 1500)
    rec = int(dem * random.uniform(0.2, 0.95))
    demand_rows.append(("DMD-%04d" % (301 + i), (i % 14) + 1, m[0], m[1], m[2], m[3], m[4], m[5],
                        dem, rec, dem - rec, ["特急", "紧急", "一般"][i % 3],
                        "已满足" if dem - rec <= 0 else "缺口", dt(i * 6)))
ins("material_demand", ["demand_no", "project_id", "material_name", "category", "spec", "unit",
                        "accept_quality", "shelf_life_req", "demand_qty", "received_qty",
                        "gap_qty", "urgency", "status", "create_time"],
    [r[:8] + (r[8], r[9], r[10], r[11], r[12], r[13]) for r in demand_rows])

# ---------------------------------------------------------------- 捐赠意向
DONORS = [("杭州市临平区青禾商贸", "企业"), ("周慧兰（个人）", "个人"),
          ("浙江明远律师事务所", "企业"), ("城西社区爱心志愿队", "社会组织"),
          ("李泽川（个人）", "个人"), ("匿名爱心人士", "个人"),
          ("杭州云栖科技有限公司", "企业"), ("孙启明（个人）", "个人"),
          ("何佳颖（个人）", "个人"), ("赵雨琪（个人）", "个人")]
INTENT_ST = ["已入库"] * 22 + ["部分接收"] * 3 + ["待预审"] * 6 + ["待送达"] * 8 + ["待验收"] * 5 + ["已拒收"] * 2
random.shuffle(INTENT_ST)
intent_rows = []
for i in range(46):
    m = MATS[i % len(MATS)]
    donor = DONORS[i % len(DONORS)]
    st = INTENT_ST[i]
    off = 170 - i * 3 if i < 40 else 2
    intent_rows.append(("INT-%04d" % (862 - i), (i % 14) + 1, (i % 12) + 1, donor[0], donor[1],
                        m[0], m[1], m[2], m[3], random.randint(20, 300), m[4],
                        ["自送到仓", "志愿者上门取件", "物流到付"][i % 3],
                        dt(max(off, 0), 9 + i % 8, 0), "138****%04d" % (1000 + i),
                        st, "物资符合需求，仓位已预留" if st not in ("已拒收", "待预审") else None,
                        ["A 区 03 货位", "B 区 02 货位", "C 区 01 货位"][i % 3],
                        "物资为六成新棉被，超出可接收质量等级（需九成新以上）" if st == "已拒收" else None,
                        1 if st != "待预审" else None))
ins("donation_intent", ["intent_no", "project_id", "donor_id", "donor_name", "donor_type",
                        "material_name", "category", "spec", "unit", "est_qty", "quality_level",
                        "delivery_type", "appoint_time", "contact_phone", "status",
                        "precheck_opinion", "position", "reject_reason", "auditor_id", "create_time"],
    [(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13],
      r[14], r[15], r[16], r[17], r[18], dt(max(165 - i * 3, 0))) for i, r in enumerate(intent_rows)])

print("part A ok")
