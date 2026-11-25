#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成 NEW-030 公益物资捐赠与发放追踪系统的 design/ 可点击 HTML mock。
视觉方向：数据钢蓝 #19324A，圆角 6-8px，后台 + 门户双风格。"""
import os

BASE = os.path.dirname(os.path.abspath(__file__))

ICONS = {
    "grid": '<svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><rect x="1" y="1" width="6" height="6" rx="1"/><rect x="9" y="1" width="6" height="6" rx="1"/><rect x="1" y="9" width="6" height="6" rx="1"/><rect x="9" y="9" width="6" height="6" rx="1"/></svg>',
    "heart": '<svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M8 14S1.5 9.9 1.5 5.9A3.4 3.4 0 0 1 8 4a3.4 3.4 0 0 1 6.5 1.9C14.5 9.9 8 14 8 14z"/></svg>',
    "box": '<svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M8 1l6 3v8l-6 3-6-3V4l6-3zm0 1.6L3.9 4.6 8 6.5l4.1-1.9L8 2.6zM3 5.9v5.4l4 2v-5.4L3 5.9zm6 7.4l4-2V5.9l-4 2v5.4z"/></svg>',
    "doc": '<svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M3 1h6l4 4v10H3V1zm6 1.5V5h2.5L9 2.5zM5 8h6v1H5V8zm0 2.5h6v1H5v-1z"/></svg>',
    "user": '<svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><circle cx="8" cy="4.6" r="2.8"/><path d="M2 14c0-3 2.7-5 6-5s6 2 6 5H2z"/></svg>',
    "chart": '<svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><rect x="1.5" y="9" width="3" height="6"/><rect x="6.5" y="4" width="3" height="11"/><rect x="11.5" y="6.5" width="3" height="8.5"/></svg>',
    "gear": '<svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M8 5.4A2.6 2.6 0 1 0 8 10.6 2.6 2.6 0 0 0 8 5.4zM13 8c0-.4 0-.7-.1-1l1.4-1-1.3-2.2-1.6.6a4.9 4.9 0 0 0-1.7-1L9.4 1.6H7.2l-.3 1.8a4.9 4.9 0 0 0-1.7 1l-1.6-.6L2.3 6l1.4 1c-.1.3-.1.6-.1 1s0 .7.1 1l-1.4 1 1.3 2.2 1.6-.6c.5.4 1 .7 1.7 1l.3 1.8h2.2l.3-1.8c.6-.2 1.2-.5 1.7-1l1.6.6 1.3-2.2-1.4-1c.1-.3.1-.6.1-1z"/></svg>',
    "bell": '<svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M8 1.5a4 4 0 0 1 4 4v3l1.4 2.2H2.6L4 8.5v-3a4 4 0 0 1 4-4zM6.4 12h3.2a1.6 1.6 0 0 1-3.2 0z"/></svg>',
    "help": '<svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><circle cx="8" cy="8" r="6.6" fill="none" stroke="currentColor" stroke-width="1.3"/><path d="M6.2 6.2A1.9 1.9 0 0 1 9.8 6.6c0 1.2-1.6 1.5-1.6 2.7h-1.2c0-1.7 1.5-1.9 1.5-2.7a.8.8 0 0 0-1.5-.3l-1-.3zM7 11.4h1.3V12.6H7z"/></svg>',
}

MENU_ADMIN = [
    ("", "总览", ""),
    ("dashboard.html", "公益物资看板", "grid"),
    ("", "捐赠管理", ""),
    ("project-list.html", "捐赠项目", "heart"),
    ("demand-list.html", "物资与需求", "box"),
    ("intent-list.html", "捐赠意向", "doc"),
    ("", "仓储管理", ""),
    ("receiving.html", "收货验收", "box"),
    ("batch-list.html", "物资批次台账", "box"),
    ("distribute.html", "拣货发放", "doc"),
    ("", "受助管理", ""),
    ("application-list.html", "受助需求池", "user"),
    ("application-review.html", "资格与反重审核", "user"),
    ("distribution-list.html", "发放追踪单", "doc"),
    ("feedback-list.html", "去向反馈", "doc"),
    ("", "创新模块", ""),
    ("rule-config.html", "分配规则配置", "gear"),
    ("score-detail.html", "分配建议解释", "chart"),
    ("", "公开与报表", ""),
    ("report.html", "公开报表", "chart"),
    ("", "系统管理", ""),
    ("user-list.html", "用户管理", "user"),
    ("role-list.html", "角色管理", "user"),
    ("menu-list.html", "菜单管理", "gear"),
    ("log-list.html", "操作日志", "doc"),
]

MENU_VOL = [
    ("", "志愿服务", ""),
    ("volunteer.html", "志愿者工作台", "grid"),
    ("receiving.html", "待收货验收", "box"),
    ("batch-list.html", "在库批次", "box"),
    ("distribute.html", "待拣货发放", "doc"),
    ("", "其他", ""),
    ("message.html", "消息中心", "bell"),
    ("profile.html", "个人中心", "user"),
]

TAG = {
    "待预审": "tag-warn", "待送达": "tag-info", "待验收": "tag-warn", "已入库": "tag-success",
    "部分接收": "tag-sub", "已拒收": "tag-danger", "待审核": "tag-warn", "待拣货": "tag-info",
    "待领用": "tag-info", "待配送": "tag-info", "待反馈": "tag-sub", "已完成": "tag-success",
    "已退回": "tag-danger", "已取消": "tag-gray", "进行中": "tag-info", "已归档": "tag-success",
    "正常": "tag-success", "临期": "tag-warn", "过期": "tag-danger", "锁定": "tag-gray",
    "不合格": "tag-danger", "启用": "tag-success", "停用": "tag-gray",
}


def tag(text):
    return '<span class="tag %s">%s</span>' % (TAG.get(text, "tag-gray"), text)


def admin_shell(active, body, crumb, role="项目管理员", menus=None, uname="陈砚秋"):
    menus = menus or MENU_ADMIN
    items = []
    for href, label, icon in menus:
        if not href:
            items.append('      <div class="menu-group">%s</div>' % label)
            continue
        cls = "menu-item active" if href == active else "menu-item"
        badge = '<span class="badge">6</span>' if href == "intent-list.html" else ""
        items.append(
            '      <a class="%s" href="%s"><span class="ic">%s</span>%s%s</a>'
            % (cls, href, ICONS.get(icon, ICONS["doc"]), label, badge)
        )
    return """<!doctype html>
<html lang="zh-CN"><head><meta charset="utf-8">
<title>%(title)s — 公益物资捐赠与发放追踪系统</title>
<link rel="stylesheet" href="mock.css"></head>
<body><div class="app">
  <aside class="sidebar">
    <div class="logo"><div class="mark">慈</div>
      <div class="name">公益物资追踪<small>CHARITY MATERIAL TRACKING</small></div></div>
    <nav class="menu">
%(items)s
    </nav>
  </aside>
  <div class="main">
    <header class="topbar">
      <div class="crumb"><b>%(crumb0)s</b><span>/</span>%(crumb1)s</div>
      <div class="topbar-right">
        <div class="icon-btn">%(bell)s<span class="dot"></span></div>
        <div class="icon-btn">%(help)s</div>
        <div class="user"><div class="avatar">陈</div>
          <div><div class="nm">%(uname)s</div><div class="rl">%(role)s</div></div></div>
      </div>
    </header>
    <main class="content">
%(body)s
    </main>
  </div>
</div></body></html>""" % {
        "title": crumb[1] if len(crumb) > 1 else crumb[0],
        "items": "\n".join(items),
        "crumb0": crumb[0], "crumb1": crumb[1] if len(crumb) > 1 else "",
        "body": body, "role": role, "uname": uname,
        "bell": ICONS["bell"], "help": ICONS["help"],
    }


def portal_shell(active, body, title, navs=None, right=""):
    navs = navs or [("portal.html", "首页"), ("project-list.html", "捐赠项目"),
                    ("intent-list.html", "我的捐赠"), ("report.html", "公开去向")]
    links = "".join('<a class="%s" href="%s">%s</a>' % ("on" if h == active else "", h, t)
                    for h, t in navs)
    return """<!doctype html>
<html lang="zh-CN"><head><meta charset="utf-8">
<title>%(title)s — 公益物资捐赠与发放追踪系统</title>
<link rel="stylesheet" href="mock.css"></head>
<body><div class="portal">
  <header class="pnav">
    <div class="brand"><div class="mark">慈</div>公益物资追踪平台</div>
    <nav class="navs">%(links)s</nav>
    <div class="right">%(right)s
      <div class="user"><div class="avatar">%(av)s</div><span>%(nm)s</span></div>
    </div>
  </header>
  <div class="pwrap">
%(body)s
  </div>
</div></body></html>""" % {"title": title, "links": links, "body": body,
                           "right": right, "nm": "林素心", "av": "林"}


def pager(total, page=1, size=10):
    pages = max(1, (total + size - 1) // size)
    nums = "".join('<span class="pg%s">%d</span>' % (" on" if i == page else "", i)
                   for i in range(1, min(pages, 6) + 1))
    return ('<div class="pager"><span class="total">共 %d 条</span>'
            '<select class="select" style="min-width:110px;height:27px">'
            '<option>10 条/页</option><option>20 条/页</option><option>50 条/页</option></select>'
            '<span class="pg">上一页</span>%s<span class="pg">下一页</span></div>' % (total, nums))


def head(title, desc, actions=""):
    return ('<div class="page-head"><div><h1>%s</h1><p>%s</p></div>%s</div>'
            % (title, desc, ('<div class="actions">%s</div>' % actions) if actions else ""))


PAGES = {}

# ---------------------------------------------------------------- 1 看板
PAGES["dashboard.html"] = ("总览", "公益物资看板", """<div class="page-head">
  <div><h1>公益物资看板</h1><p>统计区间 2026-10-02 至 2026-11-01（最近 30 天）· 数据每分钟刷新</p></div>
  <div class="actions"><span class="tag tag-plain tag-info">本季度</span><span class="tag tag-plain tag-gray">本月</span>
    <span class="tag tag-plain tag-gray">本年</span><button class="btn">自定义日期</button>
    <button class="btn btn-primary">导出报表</button></div>
</div>
<div class="kpi-grid">
  <div class="kpi"><div class="lb">入库数量</div><div class="val">12,486<small>件</small></div><div class="tr"><i>↑ 8.4%</i> 环比上月</div></div>
  <div class="kpi"><div class="lb">发放数量</div><div class="val">9,742<small>件</small></div><div class="tr"><i>↑ 12.1%</i> 环比上月</div></div>
  <div class="kpi"><div class="lb">库存周转天数</div><div class="val">18.6<small>天</small></div><div class="tr"><i class="dn">↓ 2.3 天</i> 周转加快</div></div>
  <div class="kpi"><div class="lb">临期物资数</div><div class="val">37<small>批次</small></div><div class="tr"><i class="dn">↑ 5 批</i> 需优先出库</div></div>
  <div class="kpi"><div class="lb">签收率</div><div class="val">96.8<small>%</small></div><div class="tr"><i>↑ 1.2 pt</i> 已签收 318/328</div></div>
  <div class="kpi"><div class="lb">区域覆盖人数</div><div class="val">2,846<small>人</small></div><div class="tr">涉及 7 个街道 / 23 个社区</div></div>
</div>
<div class="chart-grid">
  <div class="chart-box" style="grid-column:span 2">
    <h3>捐赠入库与发放趋势</h3><div class="hint">近 12 周 · 单位：件 · 点击折线可查看对应周明细</div>
    <svg class="spark" style="height:96px" viewBox="0 0 620 110" preserveAspectRatio="none">
      <g stroke="#EDF1F4" stroke-width="1"><line x1="0" y1="18" x2="620" y2="18"/><line x1="0" y1="46" x2="620" y2="46"/><line x1="0" y1="74" x2="620" y2="74"/><line x1="0" y1="102" x2="620" y2="102"/></g>
      <polyline fill="none" stroke="#19324A" stroke-width="2" points="8,82 60,74 112,78 164,62 216,58 268,66 320,48 372,42 424,50 476,34 528,30 580,22"/>
      <polyline fill="none" stroke="#356A7A" stroke-width="2" stroke-dasharray="5 3" points="8,94 60,88 112,90 164,80 216,74 268,78 320,66 372,58 424,62 476,50 528,44 580,38"/>
      <g fill="#19324A"><circle cx="8" cy="82" r="2.6"/><circle cx="164" cy="62" r="2.6"/><circle cx="320" cy="48" r="2.6"/><circle cx="476" cy="34" r="2.6"/><circle cx="580" cy="22" r="2.6"/></g>
    </svg>
    <div class="flex gap12 small muted" style="margin-top:6px">
      <span style="color:#19324A">■ 入库数量</span><span style="color:#356A7A">■ 发放数量</span>
      <span class="spacer"></span><span>W1 8/10</span><span>W6 9/14</span><span>W12 11/01</span></div>
  </div>
  <div class="chart-box"><h3>发放单状态分布</h3><div class="hint">共 328 张发放追踪单</div>
    <div class="donut-wrap"><div class="donut" style="background:conic-gradient(#2B7955 0 58%,#356A7A 58% 76%,#A8761C 76% 89%,#B02A37 89% 96%,#CBD5DE 96% 100%)">
      <div class="ctr"><b>328</b><span>发放单</span></div></div>
      <div class="legend"><div><i style="background:#2B7955"></i>已完成<b>190</b></div>
        <div><i style="background:#356A7A"></i>处理中<b>59</b></div>
        <div><i style="background:#A8761C"></i>待审核<b>43</b></div>
        <div><i style="background:#B02A37"></i>异常退回<b>23</b></div>
        <div><i style="background:#CBD5DE"></i>已取消<b>13</b></div></div></div></div>

  <div class="chart-box"><h3>物资类别入库构成</h3><div class="hint">单位：件</div>
    <div class="bars">
      <div class="bar-col"><span class="bar-vl">3.2k</span><div class="bar" style="height:86%"></div><span class="bar-lb">米面粮油</span></div>
      <div class="bar-col"><span class="bar-vl">2.4k</span><div class="bar" style="height:64%"></div><span class="bar-lb">御寒衣物</span></div>
      <div class="bar-col"><span class="bar-vl">1.9k</span><div class="bar lt" style="height:51%"></div><span class="bar-lb">学习用品</span></div>
      <div class="bar-col"><span class="bar-vl">1.4k</span><div class="bar lt" style="height:38%"></div><span class="bar-lb">日用清洁</span></div>
      <div class="bar-col"><span class="bar-vl">1.1k</span><div class="bar lt" style="height:29%"></div><span class="bar-lb">医疗护理</span></div>
      <div class="bar-col"><span class="bar-vl">0.5k</span><div class="bar lt" style="height:14%"></div><span class="bar-lb">其他</span></div>
    </div></div>
  <div class="chart-box"><h3>责任单位发放排行</h3><div class="hint">按已签收件数</div>
    <div class="hbars">
      <div class="hbar"><span class="nm">城西驿站</span><span class="track"><span class="fill" style="width:94%"></span></span><span class="vl">2,614</span></div>
      <div class="hbar"><span class="nm">东湖服务站</span><span class="track"><span class="fill" style="width:78%"></span></span><span class="vl">2,183</span></div>
      <div class="hbar"><span class="nm">南苑公益仓</span><span class="track"><span class="fill" style="width:61%"></span></span><span class="vl">1,706</span></div>
      <div class="hbar"><span class="nm">北岭服务站</span><span class="track"><span class="fill" style="width:44%"></span></span><span class="vl">1,238</span></div>
      <div class="hbar"><span class="nm">开发区驿站</span><span class="track"><span class="fill" style="width:29%"></span></span><span class="vl">812</span></div>
    </div></div>
  <div class="chart-box"><h3>创新模块分配建议结果分布</h3><div class="hint">推荐采纳率 78.4% · 人工调整率 13.2%</div>
    <div class="gauge-row"><span class="lb">优先分配</span><span class="track"><span class="fill" style="width:38%;background:#2B7955"></span></span><span class="vl">124</span></div>
    <div class="gauge-row"><span class="lb">常规分配</span><span class="track"><span class="fill" style="width:46%;background:#356A7A"></span></span><span class="vl">151</span></div>
    <div class="gauge-row"><span class="lb">暂缓分配</span><span class="track"><span class="fill" style="width:11%;background:#A8761C"></span></span><span class="vl">36</span></div>
    <div class="gauge-row"><span class="lb">不推荐</span><span class="track"><span class="fill" style="width:5%;background:#B02A37"></span></span><span class="vl">17</span></div>
    <div class="rule-note small">规则版本 v3.2 生效于 2026-10-08，权重合计 100%</div></div>
  <div class="chart-box" style="grid-column:span 2"><h3>收货验收时效与不合格率<span class="sub" style="font-weight:400;font-size:11px;color:#8A99A6;margin-left:8px">验收时长单位：小时</span></h3>
    <div style="height:8px"></div>
    <table class="table tight"><thead><tr><th>仓库</th><th>平均验收时长</th><th>收货批次</th><th>不合格件数</th><th>不合格率</th><th>趋势</th></tr></thead>
    <tbody>
      <tr><td>城西公益仓</td><td class="num">6.2 h</td><td class="num">42</td><td class="num">186</td><td class="num">1.6%</td><td>"""+tag("正常")+"""</td></tr>
      <tr><td>东湖公益仓</td><td class="num">7.8 h</td><td class="num">37</td><td class="num">254</td><td class="num">2.4%</td><td>"""+tag("正常")+"""</td></tr>
      <tr><td>南苑公益仓</td><td class="num">11.4 h</td><td class="num">28</td><td class="num">418</td><td class="num">4.1%</td><td>"""+tag("临期")+"""</td></tr>
    </tbody></table></div>
</div>""")

# ---------------------------------------------------------------- 2 捐赠项目
PAGES["project-list.html"] = ("总览", "捐赠项目", head(
    "捐赠项目", "维护公益捐赠项目的主题、服务对象、目标数量与达成进度",
    '<button class="btn">批量导出</button><button class="btn btn-primary">+ 新建捐赠项目</button>') + """
<div class="card">
  <div class="filter-bar">
    <div class="filter-item"><label>项目状态</label><select class="select"><option>全部状态</option><option>进行中</option><option>已结束</option></select></div>
    <div class="filter-item"><label>服务对象</label><select class="select"><option>全部对象</option><option>低保家庭</option><option>留守儿童</option><option>独居老人</option><option>残障人士</option></select></div>
    <div class="filter-item"><label>承接仓库</label><select class="select"><option>全部仓库</option><option>城西公益仓</option><option>东湖公益仓</option></select></div>
    <div class="filter-item"><label>截止日期</label><input class="input w-md" value="2026-05-01 至 2026-12-31"></div>
    <div class="filter-item"><input class="input w-md" placeholder="项目名称 / 编号 / 联系人"></div>
    <button class="btn btn-sub">查询</button><button class="btn">重置</button>
    <span class="spacer"></span><span class="muted small">共 14 个项目 · 7 个进行中</span>
  </div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th>项目编号</th><th>项目主题</th><th>服务对象</th><th>目标 / 已收</th><th>达成率</th>
    <th>承接仓库</th><th>联系人</th><th>截止日期</th><th>状态</th><th>操作</th></tr></thead>
  <tbody>
  <tr><td class="mono">PRJ-2026-014</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#356A7A,#19324A)"></div>
      <div class="two-line"><b>暖冬计划·御寒物资包</b><span>冬季入户发放 · 公开说明已发布</span></div></div></td>
    <td>低保家庭</td><td class="num">2,000 / 1,486</td>
    <td><div style="min-width:96px"><div class="progress"><div class="fill" style="width:74%"></div></div><span class="small muted">74.3%</span></div></td>
    <td>城西公益仓</td><td>陈砚秋</td><td>2026-12-31</td><td>"""+tag("进行中")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">编辑</span></td></tr>
  <tr><td class="mono">PRJ-2026-013</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#456C7E,#2C5A6A)"></div>
      <div class="two-line"><b>开学第一课·学习用品</b><span>覆盖 8 所社区小学</span></div></div></td>
    <td>留守儿童</td><td class="num">1,500 / 1,502</td>
    <td><div style="min-width:96px"><div class="progress"><div class="fill" style="width:100%;background:#2B7955"></div></div><span class="small muted">100.1%</span></div></td>
    <td>东湖公益仓</td><td>周慧兰</td><td>2026-09-30</td><td>"""+tag("进行中")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">编辑</span></td></tr>
  <tr><td class="mono">PRJ-2026-011</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#2B7955,#356A7A)"></div>
      <div class="two-line"><b>银龄关怀·营养补给</b><span>独居老人月度配送</span></div></div></td>
    <td>独居老人</td><td class="num">900 / 612</td>
    <td><div style="min-width:96px"><div class="progress"><div class="fill" style="width:68%"></div></div><span class="small muted">68.0%</span></div></td>
    <td>南苑公益仓</td><td>许文山</td><td>2026-11-30</td><td>"""+tag("进行中")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">编辑</span></td></tr>
  <tr><td class="mono">PRJ-2026-009</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#A8761C,#8A6420)"></div>
      <div class="two-line"><b>无障碍生活·辅具支持</b><span>轮椅、助行器定向募集</span></div></div></td>
    <td>残障人士</td><td class="num">320 / 148</td>
    <td><div style="min-width:96px"><div class="progress"><div class="fill" style="width:46%"></div></div><span class="small muted">46.3%</span></div></td>
    <td>北岭服务站</td><td>柳知远</td><td>2026-12-15</td><td>"""+tag("进行中")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">编辑</span></td></tr>
  <tr><td class="mono">PRJ-2026-006</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#5B6B7A,#19324A)"></div>
      <div class="two-line"><b>盛夏清凉·防暑物资</b><span>已于 8 月完成结项</span></div></div></td>
    <td>户外劳动者</td><td class="num">1,200 / 1,196</td>
    <td><div style="min-width:96px"><div class="progress"><div class="fill" style="width:100%;background:#2B7955"></div></div><span class="small muted">99.7%</span></div></td>
    <td>城西公益仓</td><td>陈砚秋</td><td>2026-08-31</td><td>"""+tag("已归档")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">编辑</span></td></tr>
  <tr><td class="mono">PRJ-2026-004</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#356A7A,#456C7E)"></div>
      <div class="two-line"><b>春苗阅读·图书角</b><span>社区图书角共建</span></div></div></td>
    <td>留守儿童</td><td class="num">600 / 604</td>
    <td><div style="min-width:96px"><div class="progress"><div class="fill" style="width:100%;background:#2B7955"></div></div><span class="small muted">100.7%</span></div></td>
    <td>东湖公益仓</td><td>周慧兰</td><td>2026-06-30</td><td>"""+tag("已归档")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">编辑</span></td></tr>
  </tbody></table></div>
  """ + pager(14) + """
</div>""")

# ---------------------------------------------------------------- 3 物资与需求
PAGES["demand-list.html"] = ("总览", "物资与需求", head(
    "物资与需求", "维护物资类别、规格单位、可接收质量与当前缺口，缺口驱动捐赠意向预审",
    '<button class="btn">导出当前筛选</button><button class="btn btn-primary">+ 新增物资需求</button>') + """
<div class="card">
  <div class="filter-bar">
    <div class="filter-item"><label>物资类别</label><select class="select"><option>全部类别</option><option>米面粮油</option><option>御寒衣物</option><option>学习用品</option><option>日用清洁</option><option>医疗护理</option></select></div>
    <div class="filter-item"><label>缺口状态</label><select class="select"><option>全部</option><option>缺口较大</option><option>接近达标</option><option>已满足</option></select></div>
    <div class="filter-item"><label>可接收质量</label><select class="select"><option>全部</option><option>全新</option><option>九成新以上</option><option>八成新以上</option></select></div>
    <div class="filter-item"><input class="input w-md" placeholder="品名 / 规格"></div>
    <button class="btn btn-sub">查询</button><button class="btn">重置</button>
  </div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th>需求编号</th><th>品名 / 规格</th><th>类别</th><th>单位</th><th>可接收质量</th>
    <th>保质期要求</th><th>需求 / 已入库</th><th>当前缺口</th><th>紧迫度</th><th>操作</th></tr></thead>
  <tbody>
  <tr><td class="mono">DMD-0301</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#8A6E3C,#5B4520)"></div>
      <div class="two-line"><b>一级压榨菜籽油</b><span>5L / 桶</span></div></div></td>
    <td>米面粮油</td><td>桶</td><td>全新</td><td>≥ 12 个月</td>
    <td class="num">1,200 / 742</td><td class="num" style="color:#B02A37;font-weight:600">458</td>
    <td>"""+tag("临期")+"""</td><td><span class="link-op">详情</span><span class="link-op">调缺口</span></td></tr>
  <tr><td class="mono">DMD-0302</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#2C4A63,#19324A)"></div>
      <div class="two-line"><b>加厚羽绒服（成人）</b><span>M / L / XL 三码</span></div></div></td>
    <td>御寒衣物</td><td>件</td><td>九成新以上</td><td>不适用</td>
    <td class="num">800 / 316</td><td class="num" style="color:#B02A37;font-weight:600">484</td>
    <td>"""+tag("临期")+"""</td><td><span class="link-op">详情</span><span class="link-op">调缺口</span></td></tr>
  <tr><td class="mono">DMD-0303</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#356A7A,#2B7955)"></div>
      <div class="two-line"><b>学生护眼台灯</b><span>USB 供电 / 三档调光</span></div></div></td>
    <td>学习用品</td><td>台</td><td>全新</td><td>不适用</td>
    <td class="num">400 / 388</td><td class="num" style="color:#A8761C;font-weight:600">12</td>
    <td>"""+tag("正常")+"""</td><td><span class="link-op">详情</span><span class="link-op">调缺口</span></td></tr>
  <tr><td class="mono">DMD-0304</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#4B5F6E,#33454F)"></div>
      <div class="two-line"><b>成人纸尿裤</b><span>L 码 / 20 片装</span></div></div></td>
    <td>医疗护理</td><td>包</td><td>全新</td><td>≥ 18 个月</td>
    <td class="num">600 / 214</td><td class="num" style="color:#B02A37;font-weight:600">386</td>
    <td>"""+tag("临期")+"""</td><td><span class="link-op">详情</span><span class="link-op">调缺口</span></td></tr>
  <tr><td class="mono">DMD-0305</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#6E7F8C,#4B5F6E)"></div>
      <div class="two-line"><b>洗衣液（家庭装）</b><span>3kg / 瓶</span></div></div></td>
    <td>日用清洁</td><td>瓶</td><td>全新</td><td>≥ 24 个月</td>
    <td class="num">900 / 902</td><td class="num" style="color:#2B7955;font-weight:600">0</td>
    <td>"""+tag("正常")+"""</td><td><span class="link-op">详情</span><span class="link-op">调缺口</span></td></tr>
  <tr><td class="mono">DMD-0306</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#8A6E3C,#6E5528)"></div>
      <div class="two-line"><b>东北长粒香米</b><span>10kg / 袋</span></div></div></td>
    <td>米面粮油</td><td>袋</td><td>全新</td><td>≥ 10 个月</td>
    <td class="num">1,500 / 1,126</td><td class="num" style="color:#A8761C;font-weight:600">374</td>
    <td>"""+tag("正常")+"""</td><td><span class="link-op">详情</span><span class="link-op">调缺口</span></td></tr>
  </tbody></table></div>
  """ + pager(26) + """
</div>""")

# ---------------------------------------------------------------- 4 捐赠意向
PAGES["intent-list.html"] = ("总览", "捐赠意向", head(
    "捐赠意向", "捐赠人提交的物资意向，需管理员预审后进入待送达环节",
    '<button class="btn">批量预审</button><button class="btn btn-primary">+ 代录捐赠意向</button>') + """
<div class="card">
  <div class="filter-bar">
    <div class="filter-item"><label>意向状态</label><select class="select"><option>全部状态</option><option>待预审</option><option>待送达</option><option>待验收</option><option>已入库</option><option>已拒收</option></select></div>
    <div class="filter-item"><label>关联项目</label><select class="select"><option>全部项目</option><option>暖冬计划·御寒物资包</option><option>开学第一课·学习用品</option><option>银龄关怀·营养补给</option></select></div>
    <div class="filter-item"><label>送达方式</label><select class="select"><option>全部</option><option>自送到仓</option><option>志愿者上门取件</option><option>物流到付</option></select></div>
    <div class="filter-item"><input class="input w-md" placeholder="意向编号 / 捐赠人"></div>
    <button class="btn btn-sub">查询</button><button class="btn">重置</button>
    <span class="spacer"></span><span class="tag tag-plain tag-warn">待预审 6 条</span>
  </div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th>意向编号</th><th>捐赠人 / 单位</th><th>物资</th><th>预估数量</th><th>新旧程度</th>
    <th>送达方式</th><th>预约时间</th><th>提交时间</th><th>状态</th><th>操作</th></tr></thead>
  <tbody>
  <tr><td class="mono">INT-0862</td><td><div class="two-line"><b>杭州市临平区青禾商贸</b><span>企业 · 联系人 郭明泽</span></div></td>
    <td>一级压榨菜籽油 5L</td><td class="num">200 桶</td><td>全新</td><td>自送到仓</td><td>2026-11-03 09:00</td>
    <td class="num">2026-11-01 09:24</td><td>"""+tag("待预审")+"""</td>
    <td><span class="link-op">预审</span><span class="link-op">详情</span></td></tr>
  <tr><td class="mono">INT-0861</td><td><div class="two-line"><b>周慧兰（个人）</b><span>个人捐赠 · 累计 3 次</span></div></td>
    <td>加厚羽绒服（成人）</td><td class="num">36 件</td><td>九成新</td><td>志愿者上门取件</td><td>2026-11-02 14:30</td>
    <td class="num">2026-10-31 17:08</td><td>"""+tag("待预审")+"""</td>
    <td><span class="link-op">预审</span><span class="link-op">详情</span></td></tr>
  <tr><td class="mono">INT-0859</td><td><div class="two-line"><b>浙江明远律师事务所</b><span>企业 · 年度合作单位</span></div></td>
    <td>学生护眼台灯</td><td class="num">120 台</td><td>全新</td><td>物流到付</td><td>2026-11-05 10:00</td>
    <td class="num">2026-10-30 11:42</td><td>"""+tag("待送达")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">催办</span></td></tr>
  <tr><td class="mono">INT-0856</td><td><div class="two-line"><b>城西社区爱心志愿队</b><span>社会组织 · 18 名成员</span></div></td>
    <td>洗衣液（家庭装）3kg</td><td class="num">150 瓶</td><td>全新</td><td>自送到仓</td><td>2026-10-29 15:00</td>
    <td class="num">2026-10-28 08:15</td><td>"""+tag("待验收")+"""</td>
    <td><span class="link-op">验收</span><span class="link-op">详情</span></td></tr>
  <tr><td class="mono">INT-0851</td><td><div class="two-line"><b>李泽川（个人）</b><span>个人捐赠 · 首次捐赠</span></div></td>
    <td>成人纸尿裤 L 码</td><td class="num">40 包</td><td>全新</td><td>自送到仓</td><td>2026-10-27 11:00</td>
    <td class="num">2026-10-26 20:33</td><td>"""+tag("已入库")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">批次</span></td></tr>
  <tr><td class="mono">INT-0847</td><td><div class="two-line"><b>匿名爱心人士</b><span>个人捐赠 · 选择匿名公开</span></div></td>
    <td>旧棉被（散装）</td><td class="num">80 床</td><td>六成新</td><td>自送到仓</td><td>2026-10-24 16:00</td>
    <td class="num">2026-10-23 13:50</td><td>"""+tag("已拒收")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op danger">查看理由</span></td></tr>
  </tbody></table></div>
  """ + pager(46) + """
</div>
<div class="drawer-mask"></div>
<div class="drawer">
  <div class="drawer-head"><h3>捐赠意向预审 · INT-0862</h3><span class="x">✕</span></div>
  <div class="drawer-body">
    <div class="summary-box">
      <div class="row"><span>捐赠人</span><b>杭州市临平区青禾商贸（企业）</b></div>
      <div class="row"><span>物资</span><b>一级压榨菜籽油 5L × 200 桶</b></div>
      <div class="row"><span>可接收质量</span><b>全新，保质期需 ≥ 12 个月</b></div>
      <div class="row"><span>关联项目</span><b>暖冬计划·御寒物资包（缺口 458 桶）</b></div>
    </div>
    <div class="form-grid">
      <div class="form-item"><label>是否接收<em>*</em></label>
        <select class="select"><option>接收</option><option>部分接收</option><option>不接收</option></select></div>
      <div class="form-item"><label>预计仓位<em>*</em></label>
        <select class="select"><option>城西公益仓 · A 区 03 货位</option><option>城西公益仓 · B 区 01 货位</option></select></div>
      <div class="form-item full"><label>验收要求</label>
        <div class="textarea">核对生产日期与保质期（≥12 个月）；外包装完好无渗漏；提供批次检验合格证明；到仓后 4 小时内完成验收。</div></div>
      <div class="form-item full"><label>不接收理由（不接收时必填，不少于 5 个字）</label>
        <div class="textarea" style="color:#8A99A6">如物资已过期、包装破损、超出可接收质量等级，请在此说明具体原因。</div></div>
    </div>
    <div class="rule-note mt16">预审通过后意向状态变为「待送达」，系统按预约时间生成收货待办并通知仓储志愿者。</div>
  </div>
  <div class="drawer-foot"><button class="btn">取消</button><button class="btn btn-primary">提交预审</button></div>
</div>""")

# ---------------------------------------------------------------- 5 收货验收
PAGES["receiving.html"] = ("总览", "收货验收", head(
    "收货验收", "按实际品名、数量、质量等级与有效期建立入库批次，差异需当场记录",
    '<button class="btn">打印收货单</button><button class="btn btn-primary">提交验收并生成批次</button>') + """
<div class="detail-hero">
  <div><div class="code">RCV-2026-1031-018</div>
    <div class="small muted" style="margin-top:5px">关联意向 INT-0856 · 城西社区爱心志愿队</div></div>
  <div class="meta">
    <div>状态<b>"""+tag("待验收")+"""</b></div>
    <div>预约送达<b>2026-10-29 15:00</b></div>
    <div>验收人<b>许文山（仓储志愿者）</b></div>
    <div>当前仓位<b>城西公益仓 · B 区 02</b></div>
  </div>
  <div class="actions"><button class="btn">暂存草稿</button><button class="btn btn-danger">整单拒收</button></div>
</div>
<div class="grid-23">
  <div class="card"><div class="card-head"><h2>意向摘要</h2></div>
    <dl class="dl">
      <dt>捐赠方</dt><dd>城西社区爱心志愿队</dd>
      <dt>物资</dt><dd>洗衣液（家庭装）3kg</dd>
      <dt>预估数量</dt><dd>150 瓶</dd>
      <dt>新旧程度</dt><dd>全新</dd>
      <dt>保质期要求</dt><dd>≥ 24 个月</dd>
      <dt>送达方式</dt><dd>自送到仓</dd>
      <dt>预审结论</dt><dd>接收 · 仓位 B 区 02</dd>
      <dt>验收要求</dt><dd class="small">外包装完好、批次一致、生产日期不早于 2026-01</dd>
    </dl>
    <div class="card-head mt16" style="margin-bottom:10px"><h2>现场照片</h2><span class="sub">上传组件 · 最多 6 张</span></div>
    <div class="upload-boxes">
      <div class="upload-box filled" style="background:linear-gradient(135deg,#356A7A,#19324A)"></div>
      <div class="upload-box filled" style="background:linear-gradient(135deg,#5B6B7A,#33454F)"></div>
      <div class="upload-box filled" style="background:linear-gradient(135deg,#6E7F8C,#4B5F6E)"></div>
      <div class="upload-box">＋<span>上传</span></div>
    </div>
    <div class="hint-line mt8">支持 JPG / PNG，单张 ≤ 5MB，上传后自动压缩并记录上传人与时间</div>
  </div>
  <div class="card"><div class="card-head"><h2>验收明细</h2><span class="sub">按实际到货逐项填写，差异自动计算</span>
      <div class="actions"><button class="btn btn-sm">+ 添加明细行</button></div></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>实际品名</th><th>规格</th><th>应收</th><th>实收</th><th>质量等级</th><th>有效期至</th><th>不合格数</th><th>差异</th></tr></thead>
    <tbody>
      <tr><td>洗衣液（家庭装）</td><td>3kg / 瓶</td><td class="num">150</td>
        <td><input class="input" style="width:74px;height:27px" value="148"></td>
        <td><select class="select" style="min-width:96px;height:27px"><option>A 级（合格）</option><option>B 级（降级接收）</option><option>C 级（不合格）</option></select></td>
        <td class="num">2027-09-30</td><td><input class="input" style="width:66px;height:27px" value="2"></td>
        <td class="num" style="color:#B02A37">-2</td></tr>
      <tr><td>洗衣液（家庭装）</td><td>3kg / 瓶</td><td class="num">—</td>
        <td><input class="input" style="width:74px;height:27px" value="6"></td>
        <td><select class="select" style="min-width:96px;height:27px"><option>B 级（降级接收）</option><option>A 级（合格）</option></select></td>
        <td class="num">2027-03-31</td><td><input class="input" style="width:66px;height:27px" value="0"></td>
        <td class="num">+6</td></tr>
    </tbody></table></div>
    <div class="grid-3 mt16">
      <div><label class="small muted">收货汇总（后端重新计算）</label>
        <div class="mt8" style="font-size:20px;font-weight:600;font-variant-numeric:tabular-nums">154 <small class="small muted">瓶</small></div>
        <div class="hint-line">合格 152 · 降级 6 · 不合格 2</div></div>
      <div><label class="small muted">不合格率</label>
        <div class="mt8" style="font-size:20px;font-weight:600;color:#B02A37;font-variant-numeric:tabular-nums">1.30<small class="small muted">%</small></div>
        <div class="hint-line">阈值 2%，未触发整单拒收</div></div>
      <div><label class="small muted">接收结论</label>
        <div class="mt8">"""+tag("部分接收")+"""</div>
        <div class="hint-line">2 瓶破损，按不合格登记并退回捐赠方</div></div>
    </div>
    <div class="card-head mt16" style="margin-bottom:10px"><h2>差异说明</h2><span class="sub">实收与应收不一致时必填</span></div>
    <div class="textarea" style="max-width:100%">应收到货 150 瓶，实际清点 148 瓶，其中 2 瓶外包装破损渗漏，已现场拍照并退回捐赠方随车带回；另接收志愿队追加的 6 瓶短保批次，有效期 2027-03-31，标记为 B 级降级接收，优先出库。</div>
  </div>
</div>""")

# ---------------------------------------------------------------- 6 批次台账
PAGES["batch-list.html"] = ("总览", "物资批次台账", head(
    "物资批次台账", "入库批次是物资追溯的核心主数据，过期、锁定、不合格批次不可出库",
    '<button class="btn">导出当前筛选</button><button class="btn">库存盘点</button><button class="btn btn-primary">+ 手工入库</button>') + """
<div class="kpi-grid" style="grid-template-columns:repeat(5,1fr)">
  <div class="kpi"><div class="lb">在库批次数</div><div class="val">286</div><div class="tr">涉及 6 个仓库 / 24 个货位</div></div>
  <div class="kpi"><div class="lb">可用库存</div><div class="val">18,432<small>件</small></div><div class="tr">已锁定 1,206 件</div></div>
  <div class="kpi"><div class="lb">临期批次（≤30 天）</div><div class="val" style="color:#A8761C">37</div><div class="tr">建议优先出库</div></div>
  <div class="kpi"><div class="lb">已过期批次</div><div class="val" style="color:#B02A37">6</div><div class="tr">已自动锁定，待处置</div></div>
  <div class="kpi"><div class="lb">不合格待处理</div><div class="val">14</div><div class="tr">需登记处置方式</div></div>
</div>
<div class="card">
  <div class="filter-bar">
    <div class="filter-item"><label>物资类别</label><select class="select"><option>全部类别</option><option>米面粮油</option><option>御寒衣物</option><option>医疗护理</option></select></div>
    <div class="filter-item"><label>捐赠方</label><select class="select"><option>全部捐赠方</option><option>青禾商贸</option><option>明远律师事务所</option><option>城西社区爱心志愿队</option></select></div>
    <div class="filter-item"><label>入库日期</label><input class="input w-md" value="2026-05-01 至 2026-11-01"></div>
    <div class="filter-item"><label>保质期</label><select class="select"><option>全部</option><option>临期（≤30 天）</option><option>已过期</option><option>充足</option></select></div>
    <div class="filter-item"><label>库存状态</label><select class="select"><option>全部状态</option><option>正常</option><option>临期</option><option>过期</option><option>锁定</option></select></div>
    <div class="filter-item"><label>发放状态</label><select class="select"><option>全部</option><option>未发放</option><option>部分发放</option><option>已发完</option></select></div>
    <button class="btn btn-sub">查询</button><button class="btn">重置</button>
  </div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th>批次编号</th><th>物资名称</th><th>类别</th><th>捐赠方</th><th>入库 / 可用</th>
    <th>货位</th><th>有效期至</th><th>质量等级</th><th>库存状态</th><th>操作</th></tr></thead>
  <tbody>
  <tr><td class="mono">BAT-261030-07</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#8A6E3C,#5B4520)"></div>
      <div class="two-line"><b>一级压榨菜籽油</b><span>5L / 桶</span></div></div></td>
    <td>米面粮油</td><td>青禾商贸</td><td class="num">200 / 200</td><td>A-03-02</td>
    <td class="num">2027-08-31</td><td>A 级</td><td>"""+tag("正常")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">流水</span></td></tr>
  <tr><td class="mono">BAT-261029-04</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#6E7F8C,#4B5F6E)"></div>
      <div class="two-line"><b>洗衣液（家庭装）</b><span>3kg / 瓶</span></div></div></td>
    <td>日用清洁</td><td>城西社区爱心志愿队</td><td class="num">152 / 96</td><td>B-02-01</td>
    <td class="num">2027-09-30</td><td>A 级</td><td>"""+tag("正常")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">流水</span></td></tr>
  <tr><td class="mono">BAT-261029-05</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#7B8B96,#5B6B7A)"></div>
      <div class="two-line"><b>洗衣液（家庭装）</b><span>短保批次 · 3kg</span></div></div></td>
    <td>日用清洁</td><td>城西社区爱心志愿队</td><td class="num">6 / 6</td><td>B-02-02</td>
    <td class="num" style="color:#A8761C;font-weight:600">2026-11-28</td><td>B 级</td><td>"""+tag("临期")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">优先出库</span></td></tr>
  <tr><td class="mono">BAT-261026-11</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#2C4A63,#19324A)"></div>
      <div class="two-line"><b>加厚羽绒服（成人）</b><span>M / L / XL</span></div></div></td>
    <td>御寒衣物</td><td>周慧兰（个人）</td><td class="num">36 / 36</td><td>C-01-04</td>
    <td class="num">—</td><td>九成新</td><td>"""+tag("正常")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">流水</span></td></tr>
  <tr><td class="mono">BAT-261018-02</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#4B5F6E,#33454F)"></div>
      <div class="two-line"><b>成人纸尿裤 L 码</b><span>20 片 / 包</span></div></div></td>
    <td>医疗护理</td><td>李泽川（个人）</td><td class="num">40 / 0</td><td>A-05-01</td>
    <td class="num">2028-02-29</td><td>A 级</td><td>"""+tag("锁定")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">解锁</span></td></tr>
  <tr><td class="mono">BAT-260914-06</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#356A7A,#2B7955)"></div>
      <div class="two-line"><b>学生护眼台灯</b><span>USB 供电</span></div></div></td>
    <td>学习用品</td><td>明远律师事务所</td><td class="num">120 / 118</td><td>D-01-03</td>
    <td class="num">—</td><td>A 级</td><td>"""+tag("正常")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">流水</span></td></tr>
  <tr><td class="mono">BAT-260802-03</td>
    <td><div class="cell-main"><div class="thumb" style="background:linear-gradient(135deg,#8A6E3C,#6E5528)"></div>
      <div class="two-line"><b>东北长粒香米</b><span>10kg / 袋</span></div></div></td>
    <td>米面粮油</td><td>匿名爱心人士</td><td class="num">120 / 12</td><td>A-01-05</td>
    <td class="num" style="color:#B02A37;font-weight:600">2026-10-20</td><td>B 级</td><td>"""+tag("过期")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op danger">登记处置</span></td></tr>
  </tbody></table></div>
  """ + pager(286) + """
</div>""")

# ---------------------------------------------------------------- 7 受助需求池
PAGES["application-list.html"] = ("总览", "受助需求池", head(
    "受助需求池", "默认「待本人处理优先、更新时间倒序」，批量操作仅在勾选后出现",
    '<button class="btn">导出</button><button class="btn btn-primary">+ 代录受助申请</button>') + """
<div class="card">
  <div class="flex gap8" style="margin-bottom:14px">
    <span class="tag tag-plain tag-info">全部 328</span>
    <span class="tag tag-plain tag-warn">待审核 43</span>
    <span class="tag tag-plain tag-sub">待拣货 27</span>
    <span class="tag tag-plain tag-gray">处理中 59</span>
    <span class="tag tag-plain tag-success">已完成 190</span>
    <span class="tag tag-plain tag-danger">异常 9</span>
    <span class="spacer"></span>
    <span class="muted small">已勾选 0 条，勾选后可批量批准</span>
  </div>
  <div class="filter-bar">
    <div class="filter-item"><label>申请类型</label><select class="select"><option>全部类型</option><option>个人</option><option>家庭</option><option>机构</option></select></div>
    <div class="filter-item"><label>紧迫等级</label><select class="select"><option>全部等级</option><option>特急</option><option>紧急</option><option>一般</option></select></div>
    <div class="filter-item"><label>所属区域</label><select class="select"><option>全部区域</option><option>城西街道</option><option>东湖街道</option><option>南苑街道</option><option>北岭街道</option></select></div>
    <div class="filter-item"><input class="input w-md" placeholder="申请编号 / 申请人（脱敏）"></div>
    <button class="btn btn-sub">查询</button><button class="btn">重置</button>
  </div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th style="width:34px"><input type="checkbox"></th><th>申请编号</th><th>申请人（脱敏）</th><th>类型</th>
    <th>需求物资</th><th>申请数量</th><th>紧迫等级</th><th>区域</th><th>最近更新</th><th>状态</th><th>待办操作</th></tr></thead>
  <tbody>
  <tr><td><input type="checkbox"></td><td class="mono">AID-2026-0418</td>
    <td><div class="two-line"><b>王**</b><span>身份证 3301**********1826</span></div></td>
    <td>家庭</td><td>米面粮油 / 御寒衣物</td><td class="num">6 件</td>
    <td><span class="tag tag-danger">特急</span></td><td>城西街道</td><td class="num">2026-11-01 09:12</td>
    <td>"""+tag("待审核")+"""</td><td><span class="link-op">审核</span><span class="link-op">详情</span></td></tr>
  <tr><td><input type="checkbox"></td><td class="mono">AID-2026-0417</td>
    <td><div class="two-line"><b>李**</b><span>身份证 3301**********0937</span></div></td>
    <td>个人</td><td>成人纸尿裤 L 码</td><td class="num">4 包</td>
    <td><span class="tag tag-warn">紧急</span></td><td>东湖街道</td><td class="num">2026-11-01 08:40</td>
    <td>"""+tag("待审核")+"""</td><td><span class="link-op">审核</span><span class="link-op">详情</span></td></tr>
  <tr><td><input type="checkbox"></td><td class="mono">AID-2026-0415</td>
    <td><div class="two-line"><b>南苑社区服务中心</b><span>机构 · 统一社会信用代码 5233***</span></div></td>
    <td>机构</td><td>洗衣液 / 日用清洁</td><td class="num">60 瓶</td>
    <td><span class="tag tag-info">一般</span></td><td>南苑街道</td><td class="num">2026-10-31 16:22</td>
    <td>"""+tag("待拣货")+"""</td><td><span class="link-op">拣货</span><span class="link-op">详情</span></td></tr>
  <tr><td><input type="checkbox"></td><td class="mono">AID-2026-0412</td>
    <td><div class="two-line"><b>张**</b><span>身份证 3301**********4415</span></div></td>
    <td>家庭</td><td>学生护眼台灯</td><td class="num">2 台</td>
    <td><span class="tag tag-info">一般</span></td><td>北岭街道</td><td class="num">2026-10-31 11:05</td>
    <td>"""+tag("待领用")+"""</td><td><span class="link-op">登记领用</span><span class="link-op">详情</span></td></tr>
  <tr><td><input type="checkbox"></td><td class="mono">AID-2026-0409</td>
    <td><div class="two-line"><b>赵**</b><span>身份证 3301**********7723</span></div></td>
    <td>个人</td><td>加厚羽绒服（成人）</td><td class="num">1 件</td>
    <td><span class="tag tag-warn">紧急</span></td><td>城西街道</td><td class="num">2026-10-30 15:48</td>
    <td>"""+tag("待反馈")+"""</td><td><span class="link-op">催反馈</span><span class="link-op">详情</span></td></tr>
  <tr><td><input type="checkbox"></td><td class="mono">AID-2026-0403</td>
    <td><div class="two-line"><b>陈**</b><span>身份证 3301**********2288</span></div></td>
    <td>家庭</td><td>一级压榨菜籽油</td><td class="num">3 桶</td>
    <td><span class="tag tag-info">一般</span></td><td>东湖街道</td><td class="num">2026-10-29 09:30</td>
    <td>"""+tag("已完成")+"""</td><td><span class="link-op">查看</span></td></tr>
  <tr><td><input type="checkbox"></td><td class="mono">AID-2026-0398</td>
    <td><div class="two-line"><b>刘**</b><span>身份证 3301**********5561</span></div></td>
    <td>个人</td><td>东北长粒香米</td><td class="num">5 袋</td>
    <td><span class="tag tag-info">一般</span></td><td>南苑街道</td><td class="num">2026-10-28 14:12</td>
    <td>"""+tag("已退回")+"""</td><td><span class="link-op">查看理由</span><span class="link-op">重新提交</span></td></tr>
  </tbody></table></div>
  """ + pager(328) + """
</div>""")
print("part1 ok")
