#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""design 生成器 第三部分：公开报表、系统管理、门户与登录页，并落地全部 HTML。"""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_part1 import (PAGES, head, pager, tag, admin_shell, portal_shell, ICONS,
                       MENU_ADMIN, MENU_VOL, BASE)
import gen_part2  # noqa: F401  触发注册

# ---------------------------------------------------------------- 15 公开报表
PAGES["report.html"] = ("总览", "公开报表", head(
    "公开报表与物资去向", "对外公开的脱敏数据，捐赠人可查看物资最终流向与项目达成情况",
    '<button class="btn">导出 PDF</button><button class="btn">生成分享链接</button>') + """
<div class="rule-note" style="margin-bottom:14px">
  本页数据已脱敏：不展示受助人姓名、身份证号、联系方式、家庭住址与证明文件，仅展示街道级区域、物资类别、数量与发放时间。
</div>
<div class="kpi-grid" style="grid-template-columns:repeat(4,1fr)">
  <div class="kpi"><div class="lb">累计接收捐赠</div><div class="val">28,462<small>件</small></div><div class="tr">来自 1,286 位捐赠人 / 42 家单位</div></div>
  <div class="kpi"><div class="lb">已发放到人</div><div class="val">24,186<small>件</small></div><div class="tr">覆盖 2,846 人 / 23 个社区</div></div>
  <div class="kpi"><div class="lb">项目平均达成率</div><div class="val">82.6<small>%</small></div><div class="tr">7 个进行中项目</div></div>
  <div class="kpi"><div class="lb">平均签收时长</div><div class="val">2.4<small>天</small></div><div class="tr">从分配到受助人签收</div></div>
</div>
<div class="grid-2">
  <div class="card"><div class="card-head"><h2>物资去向 · 按区域</h2><span class="sub">最近 90 天</span></div>
    <div class="hbars">
      <div class="hbar"><span class="nm">城西街道</span><span class="track"><span class="fill" style="width:96%"></span></span><span class="vl">6,842</span></div>
      <div class="hbar"><span class="nm">东湖街道</span><span class="track"><span class="fill" style="width:81%"></span></span><span class="vl">5,760</span></div>
      <div class="hbar"><span class="nm">南苑街道</span><span class="track"><span class="fill" style="width:64%"></span></span><span class="vl">4,538</span></div>
      <div class="hbar"><span class="nm">北岭街道</span><span class="track"><span class="fill" style="width:47%"></span></span><span class="vl">3,316</span></div>
      <div class="hbar"><span class="nm">开发区</span><span class="track"><span class="fill" style="width:28%"></span></span><span class="vl">1,982</span></div>
      <div class="hbar"><span class="nm">其他区域</span><span class="track"><span class="fill" style="width:25%"></span></span><span class="vl">1,748</span></div>
    </div>
    <div class="hint-line mt12">点击区域可查看该区域已公开的发放明细（脱敏）</div>
  </div>
  <div class="card"><div class="card-head"><h2>项目达成率</h2><span class="sub">目标数量 vs 已接收</span></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>项目</th><th>目标</th><th>已收</th><th>达成率</th><th>状态</th></tr></thead>
    <tbody>
      <tr><td>暖冬计划·御寒物资包</td><td class="num">2,000</td><td class="num">1,486</td>
        <td><div class="progress" style="width:82px"><div class="fill" style="width:74%"></div></div></td><td>"""+tag("进行中")+"""</td></tr>
      <tr><td>开学第一课·学习用品</td><td class="num">1,500</td><td class="num">1,502</td>
        <td><div class="progress" style="width:82px"><div class="fill" style="width:100%;background:#2B7955"></div></div></td><td>"""+tag("进行中")+"""</td></tr>
      <tr><td>银龄关怀·营养补给</td><td class="num">900</td><td class="num">612</td>
        <td><div class="progress" style="width:82px"><div class="fill" style="width:68%"></div></div></td><td>"""+tag("进行中")+"""</td></tr>
      <tr><td>无障碍生活·辅具支持</td><td class="num">320</td><td class="num">148</td>
        <td><div class="progress" style="width:82px"><div class="fill" style="width:46%"></div></div></td><td>"""+tag("进行中")+"""</td></tr>
      <tr><td>盛夏清凉·防暑物资</td><td class="num">1,200</td><td class="num">1,196</td>
        <td><div class="progress" style="width:82px"><div class="fill" style="width:100%;background:#2B7955"></div></div></td><td>"""+tag("已归档")+"""</td></tr>
    </tbody></table></div>
  </div>
</div>
<div class="card"><div class="card-head"><h2>已公开的发放记录</h2><span class="sub">受助人信息已脱敏 · 共 190 条</span>
    <div class="actions"><span class="muted small">按发放时间倒序</span></div></div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th>发放编号</th><th>受助对象（脱敏）</th><th>区域</th><th>物资</th><th>数量</th>
    <th>捐赠来源</th><th>发放时间</th><th>反馈</th></tr></thead>
  <tbody>
    <tr><td class="mono">PU-2026-0403</td><td>陈**（家庭）</td><td>城西街道</td><td>一级压榨菜籽油 5L</td><td class="num">3 桶</td>
      <td>青禾商贸</td><td class="num">2026-10-29 09:30</td><td class="small">已收到，包装完好</td></tr>
    <tr><td class="mono">PU-2026-0391</td><td>东湖街道养老服务中心</td><td>东湖街道</td><td>成人纸尿裤 L 码</td><td class="num">40 包</td>
      <td>李泽川</td><td class="num">2026-10-27 14:12</td><td class="small">已签收</td></tr>
    <tr><td class="mono">PU-2026-0386</td><td>王**（家庭）</td><td>城西街道</td><td>东北长粒香米 10kg</td><td class="num">2 袋</td>
      <td>匿名爱心人士</td><td class="num">2026-10-25 10:20</td><td class="small">已收到，志愿者送到家</td></tr>
    <tr><td class="mono">PU-2026-0384</td><td>城西街道××社区</td><td>城西街道</td><td>洗衣液（家庭装）3kg</td><td class="num">80 瓶</td>
      <td>城西社区爱心志愿队</td><td class="num">2026-10-25 09:18</td><td class="small">已入库社区爱心角</td></tr>
    <tr><td class="mono">PU-2026-0372</td><td>张**（家庭）</td><td>北岭街道</td><td>学生护眼台灯</td><td class="num">2 台</td>
      <td>明远律师事务所</td><td class="num">2026-10-21 16:40</td><td class="small">孩子已开始使用</td></tr>
    <tr><td class="mono">PU-2026-0358</td><td>南苑社区服务中心</td><td>南苑街道</td><td>加厚羽绒服（成人）</td><td class="num">12 件</td>
      <td>周慧兰</td><td class="num">2026-10-19 11:05</td><td class="small">已发放至独居老人</td></tr>
  </tbody></table></div>
  """ + pager(190) + """
</div>""")

# ---------------------------------------------------------------- 16 用户管理
PAGES["user-list.html"] = ("总览", "用户管理", head(
    "用户管理", "四类角色账号、所属组织与数据范围（本人 / 本部门 / 授权组织）",
    '<button class="btn">批量启停</button><button class="btn btn-primary">+ 新增用户</button>') + """
<div class="card">
  <div class="filter-bar">
    <div class="filter-item"><label>角色</label><select class="select"><option>全部角色</option><option>捐赠人/单位</option><option>仓储志愿者</option><option>受助审核员</option><option>项目管理员</option></select></div>
    <div class="filter-item"><label>所属组织</label><select class="select"><option>全部组织</option><option>城西公益仓</option><option>东湖公益仓</option><option>南苑公益仓</option><option>北岭服务站</option></select></div>
    <div class="filter-item"><label>账号状态</label><select class="select"><option>全部</option><option>启用</option><option>停用</option><option>锁定</option></select></div>
    <div class="filter-item"><input class="input w-md" placeholder="姓名 / 账号 / 手机号"></div>
    <button class="btn btn-sub">查询</button><button class="btn">重置</button>
  </div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th style="width:34px"><input type="checkbox"></th><th>账号</th><th>姓名</th><th>角色</th>
    <th>所属组织</th><th>数据范围</th><th>手机号</th><th>最近登录</th><th>状态</th><th>操作</th></tr></thead>
  <tbody>
    <tr><td><input type="checkbox"></td><td class="mono">admin</td><td><div class="cell-main"><div class="avatar" style="width:26px;height:26px;font-size:11px">陈</div>陈砚秋</div></td>
      <td>项目管理员</td><td>总会秘书处</td><td>全部组织</td><td class="num">138****0021</td><td class="num">2026-11-01 09:41</td><td>"""+tag("启用")+"""</td>
      <td><span class="link-op">编辑</span><span class="link-op">分配角色</span></td></tr>
    <tr><td><input type="checkbox"></td><td class="mono">zhouhl</td><td><div class="cell-main"><div class="avatar" style="width:26px;height:26px;font-size:11px;background:#456C7E">周</div>周慧兰</div></td>
      <td>受助审核员</td><td>城西公益仓</td><td>本部门</td><td class="num">139****4417</td><td class="num">2026-11-01 09:35</td><td>"""+tag("启用")+"""</td>
      <td><span class="link-op">编辑</span><span class="link-op">分配角色</span></td></tr>
    <tr><td><input type="checkbox"></td><td class="mono">xuwsh</td><td><div class="cell-main"><div class="avatar" style="width:26px;height:26px;font-size:11px;background:#356A7A">许</div>许文山</div></td>
      <td>仓储志愿者</td><td>城西公益仓</td><td>本人</td><td class="num">137****8823</td><td class="num">2026-11-01 10:26</td><td>"""+tag("启用")+"""</td>
      <td><span class="link-op">编辑</span><span class="link-op">分配角色</span></td></tr>
    <tr><td><input type="checkbox"></td><td class="mono">liuzy</td><td><div class="cell-main"><div class="avatar" style="width:26px;height:26px;font-size:11px;background:#2B7955">柳</div>柳知远</div></td>
      <td>仓储志愿者</td><td>北岭服务站</td><td>本人</td><td class="num">136****1109</td><td class="num">2026-10-31 17:52</td><td>"""+tag("启用")+"""</td>
      <td><span class="link-op">编辑</span><span class="link-op">分配角色</span></td></tr>
    <tr><td><input type="checkbox"></td><td class="mono">guomz</td><td><div class="cell-main"><div class="avatar" style="width:26px;height:26px;font-size:11px;background:#8A6E3C">郭</div>郭明泽</div></td>
      <td>捐赠人/单位</td><td>青禾商贸</td><td>本人</td><td class="num">135****6602</td><td class="num">2026-11-01 09:24</td><td>"""+tag("启用")+"""</td>
      <td><span class="link-op">编辑</span><span class="link-op">分配角色</span></td></tr>
    <tr><td><input type="checkbox"></td><td class="mono">linsx</td><td><div class="cell-main"><div class="avatar" style="width:26px;height:26px;font-size:11px;background:#5B6B7A">林</div>林素心</div></td>
      <td>捐赠人/单位</td><td>个人捐赠</td><td>本人</td><td class="num">188****3345</td><td class="num">2026-10-30 20:11</td><td>"""+tag("启用")+"""</td>
      <td><span class="link-op">编辑</span><span class="link-op">分配角色</span></td></tr>
    <tr><td><input type="checkbox"></td><td class="mono">wangfj</td><td><div class="cell-main"><div class="avatar" style="width:26px;height:26px;font-size:11px;background:#B02A37">王</div>王凤娟</div></td>
      <td>仓储志愿者</td><td>南苑公益仓</td><td>本人</td><td class="num">133****7781</td><td class="num">2026-10-18 08:30</td><td>"""+tag("锁定")+"""</td>
      <td><span class="link-op">解锁</span><span class="link-op danger">停用</span></td></tr>
  </tbody></table></div>
  """ + pager(28) + """
</div>""")

# ---------------------------------------------------------------- 17 角色管理
PAGES["role-list.html"] = ("总览", "角色管理", head(
    "角色管理", "角色决定菜单权限与操作权限，数据范围单独配置",
    '<button class="btn btn-primary">+ 新增角色</button>') + """
<div class="grid-23">
  <div class="card"><div class="card-head"><h2>角色列表</h2></div>
    <div class="table-wrap"><table class="table"><thead><tr><th>角色</th><th>用户数</th></tr></thead><tbody>
      <tr style="background:#F0F5F7"><td><b>项目管理员</b><div class="small muted">PROJECT_ADMIN</div></td><td class="num">3</td></tr>
      <tr><td>仓储志愿者<div class="small muted">WAREHOUSE_VOLUNTEER</div></td><td class="num">12</td></tr>
      <tr><td>受助审核员<div class="small muted">AID_AUDITOR</div></td><td class="num">6</td></tr>
      <tr><td>捐赠人/单位<div class="small muted">DONOR</div></td><td class="num">7</td></tr>
    </tbody></table></div>
  </div>
  <div class="card"><div class="card-head"><h2>项目管理员 · 权限配置</h2>
      <span class="sub">菜单权限与操作权限分别控制，只有菜单权限不能调用写接口</span>
      <div class="actions"><button class="btn btn-sm">复制权限</button><button class="btn btn-primary btn-sm">保存</button></div></div>
    <div class="grid-2">
      <div>
        <div class="small muted" style="margin-bottom:8px">菜单权限</div>
        <div class="table-wrap"><table class="table"><tbody>
          <tr><td><input type="checkbox" checked> 公益物资看板</td></tr>
          <tr><td><input type="checkbox" checked> 捐赠管理（项目 / 需求 / 意向）</td></tr>
          <tr><td><input type="checkbox" checked> 仓储管理（验收 / 批次 / 拣货）</td></tr>
          <tr><td><input type="checkbox" checked> 受助管理（需求池 / 审核 / 发放）</td></tr>
          <tr><td><input type="checkbox" checked> 去向反馈</td></tr>
          <tr><td><input type="checkbox" checked> 分配规则配置</td></tr>
          <tr><td><input type="checkbox" checked> 公开报表</td></tr>
          <tr><td><input type="checkbox" checked> 系统管理（用户 / 角色 / 日志）</td></tr>
        </tbody></table></div>
      </div>
      <div>
        <div class="small muted" style="margin-bottom:8px">操作权限</div>
        <div class="table-wrap"><table class="table"><thead><tr><th>模块</th><th>查看</th><th>新增</th><th>编辑</th><th>删除</th><th>审批</th></tr></thead><tbody>
          <tr><td>捐赠项目</td><td><input type="checkbox" checked></td><td><input type="checkbox" checked></td><td><input type="checkbox" checked></td><td><input type="checkbox"></td><td><input type="checkbox" checked></td></tr>
          <tr><td>物资批次</td><td><input type="checkbox" checked></td><td><input type="checkbox" checked></td><td><input type="checkbox" checked></td><td><input type="checkbox"></td><td><input type="checkbox" checked></td></tr>
          <tr><td>受助申请</td><td><input type="checkbox" checked></td><td><input type="checkbox" checked></td><td><input type="checkbox" checked></td><td><input type="checkbox"></td><td><input type="checkbox" checked></td></tr>
          <tr><td>发放追踪单</td><td><input type="checkbox" checked></td><td><input type="checkbox" checked></td><td><input type="checkbox" checked></td><td><input type="checkbox"></td><td><input type="checkbox" checked></td></tr>
          <tr><td>去向反馈</td><td><input type="checkbox" checked></td><td><input type="checkbox"></td><td><input type="checkbox" checked></td><td><input type="checkbox"></td><td><input type="checkbox" checked></td></tr>
          <tr><td>规则配置</td><td><input type="checkbox" checked></td><td><input type="checkbox" checked></td><td><input type="checkbox" checked></td><td><input type="checkbox"></td><td><input type="checkbox" checked></td></tr>
        </tbody></table></div>
        <div class="small muted mt16" style="margin-bottom:8px">数据范围</div>
        <select class="select" style="width:100%"><option>全部组织</option><option>本部门</option><option>本人</option><option>指定组织</option></select>
        <div class="hint-line mt8">所选范围同时作用于列表查询与详情访问，越权访问返回 403 并记录操作日志。</div>
      </div>
    </div>
  </div>
</div>""")

# ---------------------------------------------------------------- 18 菜单管理
PAGES["menu-list.html"] = ("总览", "菜单管理", head(
    "菜单管理", "菜单按角色权限动态获取；「菜单管理」与「分配菜单」项对普通角色隐藏",
    '<button class="btn">展开全部</button><button class="btn btn-primary">+ 新增菜单</button>') + """
<div class="card">
  <div class="table-wrap"><table class="table"><thead><tr>
    <th style="width:220px">菜单名称</th><th>类型</th><th>路由 / 权限标识</th><th>图标</th>
    <th>排序</th><th>可见</th><th>状态</th><th>操作</th></tr></thead>
  <tbody>
    <tr><td><b>公益物资看板</b></td><td><span class="tag tag-plain tag-sub">目录</span></td><td class="mono">/dashboard</td><td>grid</td><td class="num">1</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">新增子项</span></td></tr>
    <tr><td style="padding-left:32px">捐赠管理</td><td><span class="tag tag-plain tag-sub">目录</span></td><td class="mono">donation</td><td>heart</td><td class="num">2</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">新增子项</span></td></tr>
    <tr><td style="padding-left:52px">捐赠项目</td><td><span class="tag tag-plain tag-info">菜单</span></td><td class="mono">/project-list</td><td>—</td><td class="num">1</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">按钮权限</span></td></tr>
    <tr><td style="padding-left:52px">物资与需求</td><td><span class="tag tag-plain tag-info">菜单</span></td><td class="mono">/demand-list</td><td>—</td><td class="num">2</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">按钮权限</span></td></tr>
    <tr><td style="padding-left:52px">捐赠意向</td><td><span class="tag tag-plain tag-info">菜单</span></td><td class="mono">/intent-list</td><td>—</td><td class="num">3</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">按钮权限</span></td></tr>
    <tr><td style="padding-left:32px">仓储管理</td><td><span class="tag tag-plain tag-sub">目录</span></td><td class="mono">warehouse</td><td>box</td><td class="num">3</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">新增子项</span></td></tr>
    <tr><td style="padding-left:52px">收货验收</td><td><span class="tag tag-plain tag-info">菜单</span></td><td class="mono">/receiving</td><td>—</td><td class="num">1</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">按钮权限</span></td></tr>
    <tr><td style="padding-left:52px">物资批次台账</td><td><span class="tag tag-plain tag-info">菜单</span></td><td class="mono">/batch-list</td><td>—</td><td class="num">2</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">按钮权限</span></td></tr>
    <tr><td style="padding-left:52px">拣货发放</td><td><span class="tag tag-plain tag-info">菜单</span></td><td class="mono">/distribute</td><td>—</td><td class="num">3</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">按钮权限</span></td></tr>
    <tr><td style="padding-left:32px">系统管理</td><td><span class="tag tag-plain tag-sub">目录</span></td><td class="mono">system</td><td>gear</td><td class="num">9</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">新增子项</span></td></tr>
    <tr><td style="padding-left:52px">用户管理</td><td><span class="tag tag-plain tag-info">菜单</span></td><td class="mono">/user-list</td><td>—</td><td class="num">1</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">按钮权限</span></td></tr>
    <tr><td style="padding-left:52px">角色管理</td><td><span class="tag tag-plain tag-info">菜单</span></td><td class="mono">/role-list</td><td>—</td><td class="num">2</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">按钮权限</span></td></tr>
    <tr style="background:#FAFBFC"><td style="padding-left:52px">菜单管理 <span class="small muted">（对非管理员角色隐藏）</span></td>
      <td><span class="tag tag-plain tag-info">菜单</span></td><td class="mono">/menu-list</td><td>—</td><td class="num">3</td><td>否</td><td>"""+tag("启用")+"""</td>
      <td><span class="link-op">编辑</span><span class="link-op">按钮权限</span></td></tr>
    <tr><td style="padding-left:52px">操作日志</td><td><span class="tag tag-plain tag-info">菜单</span></td><td class="mono">/log-list</td><td>—</td><td class="num">4</td><td>是</td><td>"""+tag("启用")+"""</td><td><span class="link-op">编辑</span><span class="link-op">按钮权限</span></td></tr>
  </tbody></table></div>
</div>""")

# ---------------------------------------------------------------- 19 操作日志
PAGES["log-list.html"] = ("总览", "操作日志", head(
    "操作日志", "记录关键业务操作与状态流转前后值，普通用户不可修改",
    '<button class="btn">导出</button>') + """
<div class="card">
  <div class="filter-bar">
    <div class="filter-item"><label>操作类型</label><select class="select"><option>全部类型</option><option>登录</option><option>新增</option><option>编辑</option><option>状态流转</option><option>审核</option><option>导出</option></select></div>
    <div class="filter-item"><label>操作人</label><select class="select"><option>全部操作人</option><option>陈砚秋</option><option>周慧兰</option><option>许文山</option><option>柳知远</option></select></div>
    <div class="filter-item"><label>业务模块</label><select class="select"><option>全部模块</option><option>捐赠意向</option><option>收货验收</option><option>受助申请</option><option>发放追踪单</option><option>规则配置</option></select></div>
    <div class="filter-item"><label>时间</label><input class="input w-md" value="2026-10-31 至 2026-11-01"></div>
    <button class="btn btn-sub">查询</button><button class="btn">重置</button>
  </div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th>时间</th><th>操作人</th><th>角色</th><th>模块</th><th>操作</th><th>业务编号</th>
    <th>状态变化</th><th>IP</th><th>结果</th></tr></thead>
  <tbody>
    <tr><td class="num">2026-11-01 10:26:02</td><td>许文山</td><td>仓储志愿者</td><td>拣货发放</td><td>扫码拣货</td>
      <td class="mono">DO-2026-0418</td><td class="small">待拣货 → 待复核</td><td class="num">192.168.1.34</td><td>"""+tag("正常")+"""</td></tr>
    <tr><td class="num">2026-11-01 09:41:12</td><td>陈砚秋</td><td>项目管理员</td><td>系统登录</td><td>登录</td>
      <td class="mono">—</td><td class="small">—</td><td class="num">192.168.1.12</td><td>"""+tag("正常")+"""</td></tr>
    <tr><td class="num">2026-11-01 09:36:04</td><td>周慧兰</td><td>受助审核员</td><td>受助申请</td><td>人工调整</td>
      <td class="mono">SCR-2026-0418</td><td class="small">发放数量 2 袋 → 1 袋</td><td class="num">192.168.1.28</td><td>"""+tag("正常")+"""</td></tr>
    <tr><td class="num">2026-11-01 09:32:48</td><td>周慧兰</td><td>受助审核员</td><td>受助申请</td><td>资格审核</td>
      <td class="mono">AID-2026-0418</td><td class="small">待审核 → 待拣货</td><td class="num">192.168.1.28</td><td>"""+tag("正常")+"""</td></tr>
    <tr><td class="num">2026-11-01 09:24:37</td><td>郭明泽</td><td>捐赠人/单位</td><td>捐赠意向</td><td>新增</td>
      <td class="mono">INT-0862</td><td class="small">— → 待预审</td><td class="num">10.12.88.201</td><td>"""+tag("正常")+"""</td></tr>
    <tr><td class="num">2026-11-01 08:52:19</td><td>王凤娟</td><td>仓储志愿者</td><td>系统登录</td><td>登录</td>
      <td class="mono">—</td><td class="small">—</td><td class="num">192.168.1.77</td><td><span class="tag tag-danger">密码错误（第 5 次，已锁定）</span></td></tr>
    <tr><td class="num">2026-10-31 17:52:06</td><td>柳知远</td><td>仓储志愿者</td><td>收货验收</td><td>提交验收</td>
      <td class="mono">RCV-2026-1031-017</td><td class="small">待验收 → 已入库</td><td class="num">192.168.1.41</td><td>"""+tag("正常")+"""</td></tr>
    <tr><td class="num">2026-10-31 16:22:41</td><td>陈砚秋</td><td>项目管理员</td><td>规则配置</td><td>发布规则</td>
      <td class="mono">RULE-v3.2</td><td class="small">v3.1 → v3.2（权重合计 100%）</td><td class="num">192.168.1.12</td><td>"""+tag("正常")+"""</td></tr>
    <tr><td class="num">2026-10-31 15:08:33</td><td>周慧兰</td><td>受助审核员</td><td>受助申请</td><td>退回</td>
      <td class="mono">AID-2026-0398</td><td class="small">待审核 → 已退回</td><td class="num">192.168.1.28</td><td>"""+tag("正常")+"""</td></tr>
  </tbody></table></div>
  """ + pager(1842) + """
</div>""")

# ---------------------------------------------------------------- 20 消息中心
PAGES["message.html"] = ("总览", "消息中心", head(
    "消息中心", "待审批、即将超时、已退回、待验收与处理完成消息，均含业务编号与详情跳转",
    '<button class="btn">全部标为已读</button>') + """
<div class="card">
  <div class="flex gap8" style="margin-bottom:14px">
    <span class="tag tag-plain tag-info">全部 36</span>
    <span class="tag tag-plain tag-warn">待审批 6</span>
    <span class="tag tag-plain tag-danger">即将超时 3</span>
    <span class="tag tag-plain tag-gray">已退回 2</span>
    <span class="tag tag-plain tag-sub">待验收 4</span>
    <span class="tag tag-plain tag-success">已完成 21</span>
  </div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th style="width:60px">类型</th><th>消息内容</th><th>业务编号</th><th>时间</th><th>状态</th><th>操作</th></tr></thead>
  <tbody>
    <tr><td><span class="tag tag-plain tag-warn">待审批</span></td>
      <td>捐赠意向 INT-0862（青禾商贸，菜籽油 200 桶）待您预审，预约送达时间 2026-11-03 09:00。</td>
      <td class="mono">INT-0862</td><td class="num">2026-11-01 09:24</td><td><span class="tag tag-plain tag-warn">未读</span></td>
      <td><a class="link-op" href="intent-list.html">去处理</a></td></tr>
    <tr><td><span class="tag tag-plain tag-danger">即将超时</span></td>
      <td>发放追踪单 DO-2026-0418 距截止时间不足 32 小时，当前阶段「分配出库」。</td>
      <td class="mono">DO-2026-0418</td><td class="num">2026-11-01 09:00</td><td><span class="tag tag-plain tag-warn">未读</span></td>
      <td><a class="link-op" href="distribution-detail.html">去处理</a></td></tr>
    <tr><td><span class="tag tag-plain tag-sub">待验收</span></td>
      <td>收货任务 RCV-2026-1031-018（城西社区爱心志愿队，洗衣液 150 瓶）已到仓，请验收。</td>
      <td class="mono">RCV-2026-1031-018</td><td class="num">2026-10-31 15:12</td><td><span class="tag tag-plain tag-warn">未读</span></td>
      <td><a class="link-op" href="receiving.html">去验收</a></td></tr>
    <tr><td><span class="tag tag-plain tag-gray">已退回</span></td>
      <td>受助申请 AID-2026-0398 被退回：年度累计领取量已超上限，请补充材料后重新提交。</td>
      <td class="mono">AID-2026-0398</td><td class="num">2026-10-31 15:08</td><td><span class="tag tag-plain tag-gray">已读</span></td>
      <td><a class="link-op" href="application-list.html">查看</a></td></tr>
    <tr><td><span class="tag tag-plain tag-success">已完成</span></td>
      <td>发放追踪单 DO-2026-0403 已完成归档，受助人反馈已审核通过并公开。</td>
      <td class="mono">DO-2026-0403</td><td class="num">2026-10-30 19:40</td><td><span class="tag tag-plain tag-gray">已读</span></td>
      <td><a class="link-op" href="distribution-detail.html">查看</a></td></tr>
    <tr><td><span class="tag tag-plain tag-warn">待审批</span></td>
      <td>去向反馈 FB-2026-0306 待审核，提交人 陈**，含 2 张照片。</td>
      <td class="mono">FB-2026-0306</td><td class="num">2026-10-30 19:22</td><td><span class="tag tag-plain tag-warn">未读</span></td>
      <td><a class="link-op" href="feedback-list.html">去审核</a></td></tr>
    <tr><td><span class="tag tag-plain tag-danger">异常</span></td>
      <td>批次 BAT-260802-03（东北长粒香米）已过期，系统已自动锁定，请登记处置方式。</td>
      <td class="mono">BAT-260802-03</td><td class="num">2026-10-21 00:05</td><td><span class="tag tag-plain tag-gray">已读</span></td>
      <td><a class="link-op" href="batch-list.html">去处置</a></td></tr>
  </tbody></table></div>
  """ + pager(36) + """
</div>""")

# ---------------------------------------------------------------- 21 个人中心
PAGES["profile.html"] = ("总览", "个人中心", head(
    "个人中心", "修改资料、密码与头像，头像上传后右上角立即同步") + """
<div class="grid-23">
  <div class="card"><div class="card-head"><h2>头像</h2></div>
    <div style="text-align:center;padding:10px 0">
      <div class="avatar" style="width:88px;height:88px;font-size:30px;margin:0 auto">陈</div>
      <div class="mt12"><button class="btn btn-sm">上传新头像</button></div>
      <div class="hint-line mt8">JPG / PNG，≤2MB，建议 400×400</div>
    </div>
    <div class="card-head mt16" style="margin-bottom:10px"><h2>账号信息</h2></div>
    <dl class="dl" style="grid-template-columns:76px 1fr">
      <dt>登录账号</dt><dd class="mono">admin</dd>
      <dt>角色</dt><dd>项目管理员</dd>
      <dt>所属组织</dt><dd>总会秘书处</dd>
      <dt>数据范围</dt><dd>全部组织</dd>
      <dt>最近登录</dt><dd class="num">2026-11-01 09:41:12</dd>
      <dt>登录 IP</dt><dd class="num">192.168.1.12</dd>
    </dl>
  </div>
  <div>
    <div class="card"><div class="card-head"><h2>基本资料</h2><div class="actions"><button class="btn btn-primary btn-sm">保存修改</button></div></div>
      <div class="form-grid">
        <div class="form-item"><label>姓名<em>*</em></label><input class="input" value="陈砚秋"></div>
        <div class="form-item"><label>手机号<em>*</em></label><input class="input" value="13800130021"></div>
        <div class="form-item"><label>电子邮箱</label><input class="input" value="chenyq@charity.org.cn"></div>
        <div class="form-item"><label>所属组织</label><select class="select"><option>总会秘书处</option><option>城西公益仓</option></select></div>
        <div class="form-item full"><label>负责业务</label><input class="input" value="捐赠项目发布、物资分配审批、公开报表审核"></div>
      </div>
    </div>
    <div class="card"><div class="card-head"><h2>修改密码</h2><span class="sub">密码使用 BCrypt 保存，任何接口不返回密码字段</span></div>
      <div class="form-grid">
        <div class="form-item"><label>当前密码<em>*</em></label><input class="input" type="password" value="········"></div>
        <div class="form-item"><label>新密码<em>*</em></label><input class="input" type="password" value="········"></div>
        <div class="form-item"><label>确认新密码<em>*</em></label><input class="input" type="password" value="········"></div>
        <div class="form-item"><label>&nbsp;</label><button class="btn btn-primary">更新密码</button></div>
      </div>
      <div class="hint-line">密码需 8 位以上，包含字母与数字；连续 5 次登录失败将锁定 10 分钟。</div>
    </div>
    <div class="card"><div class="card-head"><h2>消息订阅</h2></div>
      <div class="grid-2">
        <div class="flex gap8"><input type="checkbox" checked><span>待审批消息</span></div>
        <div class="flex gap8"><input type="checkbox" checked><span>即将超时提醒</span></div>
        <div class="flex gap8"><input type="checkbox" checked><span>批次临期提醒</span></div>
        <div class="flex gap8"><input type="checkbox"><span>每周统计简报</span></div>
      </div>
    </div>
  </div>
</div>""")

# ---------------------------------------------------------------- 22 捐赠人门户
PAGES["portal.html"] = ("捐赠人门户", "portal", """<div class="phero">
  <div><h2>让每一件物资都可被追溯</h2>
    <p>您捐赠的物资从入库批次、质量分级到最终领用人，全流程留痕。当前有 7 个公益项目正在募集，最紧缺的是米面粮油与御寒衣物。</p></div>
  <div class="stats">
    <div><b>2,846</b><span>已帮助人数</span></div>
    <div><b>14</b><span>进行中项目</span></div>
    <div><b>96.8%</b><span>签收率</span></div>
  </div>
</div>
<div class="grid-2 mt16">
  <div class="pcard"><div class="card-head"><h2>我的捐赠</h2><span class="sub">青禾商贸 · 累计 3 次</span>
      <div class="actions"><a class="link-op" href="intent-list.html">查看全部</a></div></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>意向编号</th><th>物资</th><th>数量</th><th>状态</th><th>去向</th></tr></thead>
    <tbody>
      <tr><td class="mono">INT-0862</td><td>一级压榨菜籽油 5L</td><td class="num">200 桶</td>
        <td>"""+tag("待预审")+"""</td><td class="small muted">待入库</td></tr>
      <tr><td class="mono">INT-0784</td><td>东北长粒香米 10kg</td><td class="num">120 袋</td>
        <td>"""+tag("已入库")+"""</td><td><a class="link-op" href="report.html">已发放 96 袋</a></td></tr>
      <tr><td class="mono">INT-0651</td><td>学生护眼台灯</td><td class="num">60 台</td>
        <td>"""+tag("已入库")+"""</td><td><a class="link-op" href="report.html">已发放 60 台</a></td></tr>
    </tbody></table></div>
    <div class="rule-note mt12">受助人信息已脱敏：您可以看到物资流向的街道、数量与时间，但不会看到受助人的姓名、住址与联系方式。</div>
  </div>
  <div class="pcard"><div class="card-head"><h2>正在募集的项目</h2>
      <div class="actions"><a class="link-op" href="project-list.html">全部项目</a></div></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>项目</th><th>缺口物资</th><th>缺口</th><th>截止</th><th>操作</th></tr></thead>
    <tbody>
      <tr><td>暖冬计划·御寒物资包</td><td>加厚羽绒服</td><td class="num" style="color:#B02A37">484 件</td><td class="num">2026-12-31</td><td><span class="link-op">我要捐赠</span></td></tr>
      <tr><td>银龄关怀·营养补给</td><td>成人纸尿裤</td><td class="num" style="color:#B02A37">386 包</td><td class="num">2026-11-30</td><td><span class="link-op">我要捐赠</span></td></tr>
      <tr><td>暖冬计划·御寒物资包</td><td>一级压榨菜籽油</td><td class="num" style="color:#B02A37">458 桶</td><td class="num">2026-12-31</td><td><span class="link-op">我要捐赠</span></td></tr>
      <tr><td>开学第一课·学习用品</td><td>学生护眼台灯</td><td class="num" style="color:#A8761C">12 台</td><td class="num">2026-11-15</td><td><span class="link-op">我要捐赠</span></td></tr>
      <tr><td>无障碍生活·辅具支持</td><td>轮椅 / 助行器</td><td class="num" style="color:#B02A37">172 件</td><td class="num">2026-12-15</td><td><span class="link-op">我要捐赠</span></td></tr>
    </tbody></table></div>
    <div class="hint-line mt12">缺口数据由「物资与需求」实时计算，捐赠意向提交后进入预审，管理员确认接收仓位与验收要求。</div>
  </div>
</div>
<div class="mt16"><div class="card-head"><h2>项目进展</h2><span class="sub">点击卡片查看公开说明</span></div>
  <div class="tile-grid">
    <div class="tile"><div class="cover" style="background:linear-gradient(135deg,#356A7A,#19324A)">
        <span class="tag tag-plain tag-success">进行中</span></div>
      <div class="bd"><h3>暖冬计划·御寒物资包</h3>
        <div class="m"><span>目标 2,000 件</span><span>已收 1,486 件</span></div>
        <div class="progress"><div class="fill" style="width:74%"></div></div>
        <div class="m"><span>城西公益仓</span><span>截止 2026-12-31</span></div></div></div>
    <div class="tile"><div class="cover" style="background:linear-gradient(135deg,#456C7E,#2C5A6A)">
        <span class="tag tag-plain tag-success">进行中</span></div>
      <div class="bd"><h3>开学第一课·学习用品</h3>
        <div class="m"><span>目标 1,500 件</span><span>已收 1,502 件</span></div>
        <div class="progress"><div class="fill" style="width:100%;background:#2B7955"></div></div>
        <div class="m"><span>东湖公益仓</span><span>截止 2026-09-30</span></div></div></div>
    <div class="tile"><div class="cover" style="background:linear-gradient(135deg,#2B7955,#356A7A)">
        <span class="tag tag-plain tag-success">进行中</span></div>
      <div class="bd"><h3>银龄关怀·营养补给</h3>
        <div class="m"><span>目标 900 件</span><span>已收 612 件</span></div>
        <div class="progress"><div class="fill" style="width:68%"></div></div>
        <div class="m"><span>南苑公益仓</span><span>截止 2026-11-30</span></div></div></div>
  </div>
</div>""")

# ---------------------------------------------------------------- 23 志愿者工作台
PAGES["volunteer.html"] = ("志愿服务", "volunteer", """<div class="page-head" style="max-width:1220px;margin:0 auto 16px">
  <div><h1>仓储志愿者工作台</h1><p>许文山 · 城西公益仓 · 今日待办 7 项，其中 2 项即将超时</p></div>
  <div class="actions"><button class="btn">打印拣货单</button><button class="btn btn-primary">开始批量验收</button></div>
</div>
<div class="kpi-grid" style="grid-template-columns:repeat(4,1fr)">
  <div class="kpi"><div class="lb">今日收货任务</div><div class="val">3<small>单</small></div><div class="tr">合计 386 件</div></div>
  <div class="kpi"><div class="lb">待拣货任务</div><div class="val" style="color:#A8761C">4<small>单</small></div><div class="tr">2 单即将超时</div></div>
  <div class="kpi"><div class="lb">负责货位</div><div class="val">12<small>个</small></div><div class="tr">A 区 6 / B 区 4 / C 区 2</div></div>
  <div class="kpi"><div class="lb">本月完成</div><div class="val">86<small>单</small></div><div class="tr">平均验收时长 6.2 小时</div></div>
</div>
<div class="grid-2">
  <div class="card"><div class="card-head"><h2>待收货验收</h2><span class="sub">按预约送达时间排序</span></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>收货单号</th><th>捐赠方</th><th>物资 / 数量</th><th>预约时间</th><th>状态</th><th>操作</th></tr></thead>
    <tbody>
      <tr><td class="mono">RCV-1031-018</td><td>城西社区爱心志愿队</td><td>洗衣液 150 瓶</td><td class="num">10-29 15:00</td>
        <td>"""+tag("待验收")+"""</td><td><a class="link-op" href="receiving.html">验收</a></td></tr>
      <tr><td class="mono">RCV-1101-021</td><td>杭州青禾商贸</td><td>菜籽油 200 桶</td><td class="num">11-03 09:00</td>
        <td>"""+tag("待送达")+"""</td><td><span class="link-op">查看</span></td></tr>
      <tr><td class="mono">RCV-1101-022</td><td>周慧兰（个人）</td><td>羽绒服 36 件</td><td class="num">11-02 14:30</td>
        <td>"""+tag("待送达")+"""</td><td><span class="link-op">安排上门</span></td></tr>
    </tbody></table></div>
  </div>
  <div class="card"><div class="card-head"><h2>待拣货发放</h2><span class="sub">系统已按先到期先出库推荐批次</span></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>发放单号</th><th>领取人</th><th>物资 / 数量</th><th>截止</th><th>状态</th><th>操作</th></tr></thead>
    <tbody>
      <tr><td class="mono">DO-0418</td><td>王**（城西）</td><td>菜籽油 3 桶 / 大米 1 袋</td><td class="num">11-02 18:00</td>
        <td><span class="tag tag-danger">即将超时</span></td><td><a class="link-op" href="distribute.html">拣货</a></td></tr>
      <tr><td class="mono">DO-0415</td><td>南苑社区服务中心</td><td>洗衣液 60 瓶</td><td class="num">11-03 12:00</td>
        <td>"""+tag("待拣货")+"""</td><td><a class="link-op" href="distribute.html">拣货</a></td></tr>
      <tr><td class="mono">DO-0412</td><td>张**（北岭）</td><td>护眼台灯 2 台</td><td class="num">11-02 18:00</td>
        <td>"""+tag("待领用")+"""</td><td><span class="link-op">登记领用</span></td></tr>
    </tbody></table></div>
  </div>
</div>
<div class="grid-2 mt16">
  <div class="card"><div class="card-head"><h2>本仓临期批次</h2><span class="sub">≤30 天，建议优先出库</span></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>批次编号</th><th>物资</th><th>可用</th><th>货位</th><th>有效期至</th><th>操作</th></tr></thead>
    <tbody>
      <tr><td class="mono">BAT-261029-05</td><td>洗衣液（家庭装）</td><td class="num">6 瓶</td><td>B-02-02</td>
        <td class="num" style="color:#A8761C">2026-11-28</td><td><span class="link-op">优先出库</span></td></tr>
      <tr><td class="mono">BAT-260402-11</td><td>一级压榨菜籽油</td><td class="num">48 桶</td><td>A-03-01</td>
        <td class="num" style="color:#A8761C">2026-12-20</td><td><span class="link-op">优先出库</span></td></tr>
    </tbody></table></div>
  </div>
  <div class="card"><div class="card-head"><h2>今日盘点任务</h2></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>货位</th><th>账面数量</th><th>实盘数量</th><th>差异</th><th>状态</th></tr></thead>
    <tbody>
      <tr><td class="mono">A-03-01</td><td class="num">48</td><td class="num">48</td><td class="num">0</td><td>"""+tag("正常")+"""</td></tr>
      <tr><td class="mono">A-03-02</td><td class="num">200</td><td class="num">198</td><td class="num" style="color:#B02A37">-2</td><td><span class="tag tag-warn">待复核</span></td></tr>
      <tr><td class="mono">B-02-01</td><td class="num">96</td><td class="num">96</td><td class="num">0</td><td>"""+tag("正常")+"""</td></tr>
    </tbody></table></div>
  </div>
</div>""")

# ---------------------------------------------------------------- 24 受助人门户
PAGES["applicant.html"] = ("受助申请", "portal", """<div class="phead" style="margin-bottom:16px">
  <h1>我的受助申请</h1>
  <p>王** · 城西街道 · 已通过资格认定（低保在册）· 本年度累计领取 42kg 米面粮油</p>
</div>
<div class="grid-2">
  <div class="pcard"><div class="card-head"><h2>当前申请进度</h2><span class="sub">AID-2026-0418</span></div>
    <div class="summary-box">
      <div class="row"><span>申请物资</span><b>菜籽油 3 桶 · 大米 1 袋 · 羽绒服 1 件</b></div>
      <div class="row"><span>提交时间</span><b>2026-11-01 09:12</b></div>
      <div class="row"><span>发放方式</span><b>现场领用 · 城西公益仓</b></div>
      <div class="row"><span>当前状态</span><b>"""+tag("待拣货")+"""</b></div>
    </div>
    <div class="steps" style="margin-top:18px">
      <div class="step done"><i>✓</i>提交申请</div>
      <div class="step done"><i>✓</i>资格审核</div>
      <div class="step cur"><i>3</i>拣货出库</div>
      <div class="step"><i>4</i>领取签收</div>
      <div class="step"><i>5</i>提交反馈</div>
    </div>
    <div class="rule-note mt16">物资已拣货完成，请于 2026-11-02 18:00 前到城西公益仓领取，需携带身份证件。如不便前往，可联系网格员改为配送上门。</div>
    <div class="flex gap8 mt12"><button class="btn btn-primary">确认领取时间</button><button class="btn">申请配送上门</button></div>
  </div>
  <div class="pcard"><div class="card-head"><h2>历史领取</h2></div>
    <div class="timeline">
      <div class="tl-item done"><div class="tl-t">2026-07-28　米面粮油</div>
        <div class="tl-m">菜籽油 2 桶 · 大米 2 袋 · 已签收</div>
        <div class="tl-c">请对本批物资提交使用反馈，帮助捐赠人了解去向。</div></div>
      <div class="tl-item done"><div class="tl-t">2026-04-16　御寒衣物</div>
        <div class="tl-m">棉被 2 床 · 已签收 · 反馈已通过</div></div>
      <div class="tl-item done"><div class="tl-t">2025-12-03　米面粮油</div>
        <div class="tl-m">大米 2 袋 · 已签收</div></div>
    </div>
    <div class="card-head mt16" style="margin-bottom:10px"><h2>可申请物资</h2><span class="sub">按当前库存与限领规则</span></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>物资</th><th>可申请</th><th>本年已领</th><th>间隔期</th></tr></thead>
    <tbody>
      <tr><td>一级压榨菜籽油</td><td class="num">3 桶</td><td class="num">5 桶</td><td>已满</td></tr>
      <tr><td>东北长粒香米</td><td class="num">1 袋</td><td class="num">42 kg</td><td>已满</td></tr>
      <tr><td>加厚羽绒服</td><td class="num">1 件</td><td class="num">0</td><td>可申请</td></tr>
      <tr><td>学生护眼台灯</td><td class="num">2 台</td><td class="num">0</td><td>可申请</td></tr>
    </tbody></table></div>
  </div>
</div>
<div class="pcard mt16"><div class="card-head"><h2>提交去向反馈</h2><span class="sub">非敏感内容，审核后向捐赠人展示</span></div>
  <div class="grid-2">
    <div>
      <div class="form-item"><label>反馈类型</label>
        <select class="select" style="width:100%"><option>收到确认</option><option>使用反馈</option><option>问题反馈</option></select></div>
      <div class="form-item mt12"><label>反馈内容</label>
        <div class="textarea" style="max-width:100%;min-height:88px">物资已全部收到，油品包装完好，感谢捐赠人。</div>
        <div class="hint-line">请勿填写身份证号、住址等个人信息，系统会自动扫描并脱敏。</div></div>
    </div>
    <div>
      <div class="form-item"><label>上传照片（选填）</label>
        <div class="upload-zone" style="width:100%"><b>点击或拖拽上传</b><span>JPG / PNG ≤ 5MB，最多 3 张</span></div></div>
      <div class="form-item mt12"><label>公开意愿</label>
        <select class="select" style="width:100%"><option>同意脱敏后公开给捐赠人</option><option>仅内部可见，不公开</option></select></div>
      <button class="btn btn-primary mt16">提交反馈</button>
    </div>
  </div>
</div>""")

# ---------------------------------------------------------------- 25 登录页
LOGIN = """<!doctype html>
<html lang="zh-CN"><head><meta charset="utf-8">
<title>登录 — 公益物资捐赠与发放追踪系统</title>
<link rel="stylesheet" href="mock.css"></head>
<body><div class="login-page">
  <div class="login-left">
    <div class="brand"><div class="mark">慈</div>公益物资捐赠与发放追踪系统</div>
    <h1>每一件物资<br>都能被追溯到去向</h1>
    <p class="sub">从捐赠意向预审、收货验收、批次入库、资格审核，到拣货发放与去向反馈，全过程留痕；受助人身份信息全程脱敏，公开接口不返回任何隐私字段。</p>
    <div class="feats">
      <div><i>1</i><span>捐赠意向预审 · 收货差异登记 · 质量分级入库</span></div>
      <div><i>2</i><span>资格反重校验 · 先到期先出库 · 库存事务扣减</span></div>
      <div><i>3</i><span>分配建议可解释 · 人工调整留痕 · 结果可追溯</span></div>
    </div>
    <div class="facts">
      <div><b>28,462</b><span>累计接收物资（件）</span></div>
      <div><b>2,846</b><span>已帮助人数</span></div>
      <div><b>96.8%</b><span>签收率</span></div>
    </div>
  </div>
  <div class="login-right">
    <form class="login-form">
      <h2>账号登录</h2>
      <div class="tip">请使用组织分配的账号登录，登录行为将被记录</div>
      <div class="fi"><label>账号</label><input class="input" value="admin" placeholder="请输入账号"></div>
      <div class="fi"><label>密码</label><input class="input" type="password" value="········" placeholder="请输入密码"></div>
      <div class="row"><label><input type="checkbox" checked> 记住账号</label><a href="#">忘记密码？</a></div>
      <button class="btn btn-primary" type="button">登 录</button>
      <div class="roles">
        <span>项目管理员</span><span>仓储志愿者</span><span>受助审核员</span><span>捐赠人/单位</span>
      </div>
      <div class="hint-line mt16" style="text-align:center">连续 5 次密码错误将锁定账号 10 分钟</div>
    </form>
  </div>
</div></body></html>"""

# ================================================================ 落地
def write(name, html):
    with open(os.path.join(BASE, name), "w", encoding="utf-8") as f:
        f.write(html)


count = 0
for fname, meta in PAGES.items():
    if meta[1] == "portal":
        html = portal_shell(fname, meta[2], meta[0])
    elif meta[1] == "volunteer":
        html = portal_shell(fname, meta[2], "志愿服务",
                            navs=[("volunteer.html", "工作台"), ("receiving.html", "待收货"),
                                  ("batch-list.html", "在库批次"), ("distribute.html", "待拣货")])
    else:
        html = admin_shell(fname, meta[2], (meta[0], meta[1]))
    write(fname, html)
    count += 1

write("login.html", LOGIN)
count += 1
print("written %d pages" % count)
