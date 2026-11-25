#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""design 生成器 第二部分：审核、发放、创新模块、系统管理、门户与登录页。"""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_part1 import (PAGES, head, pager, tag, admin_shell, portal_shell, ICONS,
                       MENU_ADMIN, MENU_VOL, BASE)

# ---------------------------------------------------------------- 8 资格与反重审核
PAGES["application-review.html"] = ("总览", "资格与反重审核", head(
    "受助资格与反重审核", "审核资格、已领历史与间隔期，按库存与限领规则批准数量",
    '<button class="btn">打印审核表</button><button class="btn btn-danger">退回申请</button><button class="btn btn-primary">批准并生成发放单</button>') + """
<div class="detail-hero">
  <div><div class="code">AID-2026-0418</div>
    <div class="small muted" style="margin-top:5px">王** · 家庭 · 城西街道 · 提交于 2026-11-01 09:12</div></div>
  <div class="meta">
    <div>当前状态<b>"""+tag("待审核")+"""</b></div>
    <div>紧迫等级<b><span class="tag tag-danger">特急</span></b></div>
    <div>审核员<b>周慧兰</b></div>
    <div>间隔期校验<b>通过（距上次 96 天）</b></div>
  </div>
</div>
<div class="grid-32">
  <div>
    <div class="card"><div class="card-head"><h2>申请信息</h2><span class="sub">身份信息已脱敏，仅审核员可见完整字段</span></div>
      <div class="grid-2">
        <dl class="dl">
          <dt>申请人</dt><dd>王**（女，1968 年生）</dd>
          <dt>身份证号</dt><dd>3301**********1826</dd>
          <dt>联系电话</dt><dd>138****6042</dd>
          <dt>家庭住址</dt><dd>城西街道××社区××路 12 号</dd>
          <dt>家庭人数</dt><dd>4 人（含 1 名学龄儿童、1 名失能老人）</dd>
        </dl>
        <dl class="dl">
          <dt>申请类型</dt><dd>家庭</dd>
          <dt>所属区域</dt><dd>城西街道 · 第 3 网格</dd>
          <dt>家庭月收入</dt><dd>2,180 元</dd>
          <dt>低保/特困</dt><dd>低保在册（2024-07 起）</dd>
          <dt>代办人</dt><dd>社区网格员 柳知远</dd>
        </dl>
      </div>
      <div class="card-head mt16" style="margin-bottom:8px"><h2>需求明细</h2></div>
      <div class="table-wrap"><table class="table"><thead><tr>
        <th>物资名称</th><th>规格</th><th>申请数量</th><th>用途说明</th><th>库存可满足</th></tr></thead>
      <tbody>
        <tr><td>一级压榨菜籽油</td><td>5L / 桶</td><td class="num">3 桶</td><td>家庭月度食用油</td><td>"""+tag("正常")+""" 458 桶</td></tr>
        <tr><td>东北长粒香米</td><td>10kg / 袋</td><td class="num">2 袋</td><td>家庭主食</td><td>"""+tag("正常")+""" 374 袋</td></tr>
        <tr><td>加厚羽绒服</td><td>L 码</td><td class="num">1 件</td><td>失能老人保暖</td><td>"""+tag("临期")+""" 仅 3 件</td></tr>
      </tbody></table></div>
      <div class="card-head mt16" style="margin-bottom:8px"><h2>证明材料</h2><span class="sub">上传组件 · 不对公开接口暴露</span></div>
      <div class="upload-boxes">
        <div class="upload-box filled" style="background:linear-gradient(135deg,#4B5F6E,#33454F)"></div>
        <div class="upload-box filled" style="background:linear-gradient(135deg,#5B6B7A,#3F4F5C)"></div>
        <div class="upload-box filled" style="background:linear-gradient(135deg,#6E7F8C,#4B5F6E)"></div>
        <div class="upload-box filled" style="background:linear-gradient(135deg,#7B8B96,#5B6B7A)"></div>
      </div>
      <div class="hint-line mt8">低保证明.pdf · 户口本首页.jpg · 诊断证明.pdf · 手写申请.jpg　（共 4 个文件，2.1 MB）</div>
    </div>

    <div class="card"><div class="card-head"><h2>反重校验</h2><span class="sub">系统按身份证号 + 物资类别自动比对历史领取记录</span></div>
      <div class="table-wrap"><table class="table"><thead><tr>
        <th>比对项</th><th>规则</th><th>本次情况</th><th>结论</th></tr></thead>
      <tbody>
        <tr><td>同一身份证 30 天内重复申请</td><td>禁止</td><td>最近一次 2026-07-28，距今 96 天</td><td>"""+tag("正常")+"""</td></tr>
        <tr><td>同类物资 90 天间隔期</td><td>禁止</td><td>上次领取菜籽油 2026-07-28，间隔 96 天</td><td>"""+tag("正常")+"""</td></tr>
        <tr><td>年度累计领取上限</td><td>米面粮油 ≤ 60kg/年</td><td>本年度已领 42kg，本次申请 60kg</td><td><span class="tag tag-warn">超出 42kg</span></td></tr>
        <tr><td>同户多人重复申请</td><td>禁止</td><td>户内成员 3 人无在途申请</td><td>"""+tag("正常")+"""</td></tr>
        <tr><td>限领规则（家庭 4 人）</td><td>食用油 ≤ 3 桶/次</td><td>申请 3 桶</td><td>"""+tag("正常")+"""</td></tr>
      </tbody></table></div>
      <div class="rule-note mt12">年度上限校验未通过：米面粮油本年度已领 42kg，本次申请 60kg，超出年度上限 42kg。系统建议将大米数量由 2 袋调整为 1 袋，或由审核员填写超限理由后按 1.5 倍上限放行。</div>
    </div>
  </div>

  <div>
    <div class="card"><div class="card-head"><h2>审核结论</h2></div>
      <div class="form-item"><label>资格结论<em>*</em></label>
        <select class="select" style="width:100%"><option>符合资格 · 批准</option><option>部分批准</option><option>不符合资格 · 退回</option></select></div>
      <div class="form-item mt12"><label>批准数量（按限领规则）<em>*</em></label>
        <div class="table-wrap"><table class="table"><tbody>
          <tr><td>一级压榨菜籽油</td><td class="text-r"><input class="input" style="width:62px;height:27px" value="3"></td><td class="small muted">桶</td></tr>
          <tr><td>东北长粒香米</td><td class="text-r"><input class="input" style="width:62px;height:27px" value="1"></td><td class="small muted">袋</td></tr>
          <tr><td>加厚羽绒服 L</td><td class="text-r"><input class="input" style="width:62px;height:27px" value="1"></td><td class="small muted">件</td></tr>
        </tbody></table></div></div>
      <div class="form-item mt12"><label>发放方式<em>*</em></label>
        <select class="select" style="width:100%"><option>现场领用</option><option>配送上门</option></select></div>
      <div class="form-item mt12"><label>调减原因（数量与申请不一致时必填，≥5 字）</label>
        <div class="textarea" style="max-width:100%">大米按年度累计上限调整为 1 袋，其余物资按申请量批准。</div></div>
      <button class="btn btn-primary mt16" style="width:100%;justify-content:center">批准并生成发放追踪单</button>
    </div>
    <div class="card"><div class="card-head"><h2>历史领取记录</h2></div>
      <div class="timeline">
        <div class="tl-item done"><div class="tl-t">2026-07-28　领取米面粮油</div>
          <div class="tl-m">菜籽油 2 桶 · 大米 2 袋 · 发放单 DO-2026-0286</div></div>
        <div class="tl-item done"><div class="tl-t">2026-04-16　领取御寒衣物</div>
          <div class="tl-m">棉被 2 床 · 发放单 DO-2026-0142</div></div>
        <div class="tl-item done"><div class="tl-t">2025-12-03　领取米面粮油</div>
          <div class="tl-m">大米 2 袋 · 发放单 DO-2025-0918</div></div>
        <div class="tl-item"><div class="tl-t">2025-06-21　资格首次认定</div>
          <div class="tl-m">低保在册 · 审核员 周慧兰</div></div>
      </div>
    </div>
    <div class="card"><div class="card-head"><h2>分配建议</h2><span class="sub">创新模块</span></div>
      <div class="score-head" style="padding-top:0"><div class="score-num">86.4<small>/100</small></div>
        <div><div class="score-lv high">优先分配</div>
          <div class="small muted mt8">规则 v3.2 · 2026-10-08 生效</div></div></div>
      <div class="factor"><span class="fn">需求紧迫等级</span><span class="fw">25%</span><span class="ft"><span class="ff" style="width:96%"></span></span><span class="fv">特急</span><span class="fs">24.0</span></div>
      <div class="factor"><span class="fn">家庭人数</span><span class="fw">15%</span><span class="ft"><span class="ff" style="width:80%"></span></span><span class="fv">4 人</span><span class="fs">12.0</span></div>
      <div class="factor"><span class="fn">历史领取量</span><span class="fw">15%</span><span class="ft"><span class="ff" style="width:47%"></span></span><span class="fv">42kg</span><span class="fs">7.1</span></div>
      <div class="factor"><span class="fn">库存数量</span><span class="fw">20%</span><span class="ft"><span class="ff" style="width:88%"></span></span><span class="fv">充足</span><span class="fs">17.6</span></div>
      <div class="factor"><span class="fn">保质期</span><span class="fw">10%</span><span class="ft"><span class="ff" style="width:72%"></span></span><span class="fv">14 月</span><span class="fs">7.2</span></div>
      <div class="factor"><span class="fn">区域配送能力</span><span class="fw">15%</span><span class="ft"><span class="ff" style="width:100%"></span></span><span class="fv">高</span><span class="fs">15.0</span></div>
      <a class="link-op mt12" style="display:block" href="score-detail.html">查看完整计算依据与解释 →</a>
    </div>
  </div>
</div>""")

# ---------------------------------------------------------------- 9 拣货发放
PAGES["distribute.html"] = ("总览", "拣货发放", head(
    "拣货发放", "系统按先到期先出库（FEFO）推荐批次，志愿者扫码或输码拣货并复核",
    '<button class="btn">打印拣货单</button><button class="btn btn-primary">完成拣货并复核</button>') + """
<div class="detail-hero">
  <div><div class="code">DO-2026-0418</div>
    <div class="small muted" style="margin-top:5px">发放追踪单 · 受助申请 AID-2026-0418 · 现场领用</div></div>
  <div class="meta">
    <div>当前状态<b>"""+tag("待拣货")+"""</b></div>
    <div>领取人<b>王**（已脱敏）</b></div>
    <div>发放仓库<b>城西公益仓</b></div>
    <div>拣货人<b>许文山</b></div>
    <div>要求完成<b>2026-11-02 18:00</b></div>
  </div>
</div>
<div class="grid-32">
  <div class="card"><div class="card-head"><h2>拣货任务</h2>
      <span class="sub">推荐策略：先到期先出库（FEFO）· 过期/锁定/不合格批次已排除</span>
      <div class="actions"><button class="btn btn-sm">重新推荐</button></div></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>物资</th><th>需求数量</th><th>推荐批次</th><th>货位</th><th>有效期至</th>
      <th>可用库存</th><th>本次拣货</th><th>库龄</th><th>复核</th></tr></thead>
    <tbody>
      <tr><td><div class="two-line"><b>一级压榨菜籽油</b><span>5L / 桶</span></div></td><td class="num">3 桶</td>
        <td class="mono">BAT-260402-11</td><td>A-03-01</td><td class="num" style="color:#A8761C">2026-12-20</td>
        <td class="num">48</td><td><input class="input" style="width:62px;height:27px" value="3"></td>
        <td class="num">212 天</td><td><input type="checkbox" checked></td></tr>
      <tr><td><div class="two-line"><b>东北长粒香米</b><span>10kg / 袋</span></div></td><td class="num">1 袋</td>
        <td class="mono">BAT-260410-06</td><td>A-01-02</td><td class="num">2027-02-28</td>
        <td class="num">112</td><td><input class="input" style="width:62px;height:27px" value="1"></td>
        <td class="num">204 天</td><td><input type="checkbox" checked></td></tr>
      <tr><td><div class="two-line"><b>加厚羽绒服（成人）</b><span>L 码</span></div></td><td class="num">1 件</td>
        <td class="mono">BAT-261026-11</td><td>C-01-04</td><td class="num">—</td>
        <td class="num">36</td><td><input class="input" style="width:62px;height:27px" value="1"></td>
        <td class="num">6 天</td><td><input type="checkbox" checked></td></tr>
    </tbody></table></div>
    <div class="grid-3 mt16">
      <div class="summary-box" style="margin:0"><div class="row"><span>拣货方式</span><b>扫码拣货</b></div>
        <div class="row"><span>已扫批次</span><b>3 / 3</b></div>
        <div class="row"><span>复核人</span><b>柳知远</b></div></div>
      <div class="summary-box" style="margin:0"><div class="row"><span>合计件数</span><b>5 件</b></div>
        <div class="row"><span>合计重量</span><b>27.5 kg</b></div>
        <div class="row"><span>出库类型</span><b>正常发放</b></div></div>
      <div class="summary-box" style="margin:0"><div class="row"><span>库存事务</span><b>同一事务扣减</b></div>
        <div class="row"><span>锁定校验</span><b>通过</b></div>
        <div class="row"><span>超发校验</span><b>通过</b></div></div>
    </div>
    <div class="card-head mt16" style="margin-bottom:8px"><h2>拣货记录</h2><span class="sub">扫码或手工输码，系统校验批次与数量</span></div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>时间</th><th>批次编号</th><th>货位</th><th>数量</th><th>操作人</th><th>结果</th></tr></thead>
    <tbody>
      <tr><td class="num">2026-11-01 10:22:14</td><td class="mono">BAT-260402-11</td><td>A-03-01</td><td class="num">3</td><td>许文山</td><td>"""+tag("正常")+"""</td></tr>
      <tr><td class="num">2026-11-01 10:24:38</td><td class="mono">BAT-260410-06</td><td>A-01-02</td><td class="num">1</td><td>许文山</td><td>"""+tag("正常")+"""</td></tr>
      <tr><td class="num">2026-11-01 10:26:02</td><td class="mono">BAT-261026-11</td><td>C-01-04</td><td class="num">1</td><td>许文山</td><td>"""+tag("正常")+"""</td></tr>
    </tbody></table></div>
  </div>
  <div>
    <div class="card"><div class="card-head"><h2>扫码区</h2></div>
      <div style="border:1px dashed #CBD5DE;border-radius:7px;padding:22px;text-align:center;background:#FAFBFC">
        <div style="font-size:28px;color:#8A99A6;line-height:1">▣</div>
        <div class="mt8" style="font-size:12.5px;color:#5B6B7A">将批次条码对准扫码枪，或手工输入批次编号</div>
        <input class="input mt12" style="width:100%;text-align:center;font-family:ui-monospace,Menlo,monospace" value="BAT-260402-11">
        <button class="btn btn-sub mt8" style="width:100%;justify-content:center">确认拣货</button>
      </div>
      <div class="hint-line mt12">扫码失败时可直接输入批次编号；系统会校验批次状态、可用数量与是否属于本仓库。</div>
    </div>
    <div class="card"><div class="card-head"><h2>先到期推荐逻辑</h2></div>
      <div class="rule-note">按「有效期升序 → 入库时间升序」排序，跳过状态为过期 / 锁定 / 不合格的批次；当推荐批次可用量不足时自动追加下一批次，并在拣货单标注「拆批」。</div>
      <div class="hbars mt12">
        <div class="hbar"><span class="nm">BAT-260402</span><span class="track"><span class="fill" style="width:100%;background:#2B7955"></span></span><span class="vl">优先</span></div>
        <div class="hbar"><span class="nm">BAT-260510</span><span class="track"><span class="fill" style="width:74%"></span></span><span class="vl">备选</span></div>
        <div class="hbar"><span class="nm">BAT-260718</span><span class="track"><span class="fill" style="width:46%"></span></span><span class="vl">备选</span></div>
        <div class="hbar"><span class="nm">BAT-260802</span><span class="track"><span class="fill" style="width:18%;background:#B02A37"></span></span><span class="vl">排除</span></div>
      </div>
      <div class="hint-line mt8">BAT-260802 已过有效期，纳入不可出库集合</div>
    </div>
    <div class="card"><div class="card-head"><h2>领用确认</h2></div>
      <div class="form-item"><label>领取人签字</label>
        <div class="upload-zone" style="width:100%"><b>点击拍照或上传签字照片</b><span>JPG / PNG ≤ 5MB</span></div></div>
      <div class="form-item mt12"><label>实际领取时间</label><input class="input" value="2026-11-01 14:30"></div>
      <div class="form-item mt12"><label>备注</label><div class="textarea" style="max-width:100%">受助人本人到场领取，社区网格员柳知远陪同。</div></div>
    </div>
  </div>
</div>""")

# ---------------------------------------------------------------- 10 发放追踪单
PAGES["distribution-list.html"] = ("总览", "发放追踪单", head(
    "发放追踪单", "核心过程单据，覆盖 捐赠登记→质检入库→需求审核→分配出库→签收回执→追踪归档",
    '<button class="btn">批量派发</button><button class="btn">导出当前筛选</button>') + """
<div class="card">
  <div class="flex gap8" style="margin-bottom:12px">
    <span class="tag tag-plain tag-info">全部 328</span>
    <span class="tag tag-plain tag-warn">待办 43</span>
    <span class="tag tag-plain tag-gray">处理中 59</span>
    <span class="tag tag-plain tag-success">已完成 190</span>
    <span class="tag tag-plain tag-danger">异常 23</span>
    <span class="spacer"></span>
    <span class="muted small">默认「待本人处理优先、更新时间倒序」</span>
  </div>
  <div class="filter-bar">
    <div class="filter-item"><label>当前阶段</label><select class="select"><option>全部阶段</option><option>捐赠登记</option><option>质检入库</option><option>需求审核</option><option>分配出库</option><option>签收回执</option><option>追踪归档</option></select></div>
    <div class="filter-item"><label>责任人</label><select class="select"><option>全部责任人</option><option>陈砚秋</option><option>周慧兰</option><option>许文山</option><option>柳知远</option></select></div>
    <div class="filter-item"><label>所属仓库</label><select class="select"><option>全部仓库</option><option>城西公益仓</option><option>东湖公益仓</option><option>南苑公益仓</option></select></div>
    <div class="filter-item"><label>更新时间</label><input class="input w-md" value="2026-10-02 至 2026-11-01"></div>
    <div class="filter-item"><input class="input w-md" placeholder="发放单号 / 申请编号"></div>
    <button class="btn btn-sub">查询</button><button class="btn">重置</button>
  </div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th>发放单号</th><th>受助申请</th><th>领取人</th><th>物资 / 数量</th><th>当前阶段</th>
    <th>责任人</th><th>截止时间</th><th>更新时间</th><th>状态</th><th>操作</th></tr></thead>
  <tbody>
  <tr><td class="mono">DO-2026-0418</td><td class="mono">AID-2026-0418</td>
    <td>王**</td><td>菜籽油 3 桶 / 大米 1 袋</td><td>分配出库</td><td>许文山</td>
    <td class="num">2026-11-02 18:00</td><td class="num">2026-11-01 10:26</td><td>"""+tag("待拣货")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">拣货</span></td></tr>
  <tr><td class="mono">DO-2026-0415</td><td class="mono">AID-2026-0415</td>
    <td>南苑社区服务中心</td><td>洗衣液 60 瓶</td><td>分配出库</td><td>许文山</td>
    <td class="num">2026-11-03 12:00</td><td class="num">2026-10-31 16:22</td><td>"""+tag("待拣货")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">拣货</span></td></tr>
  <tr><td class="mono">DO-2026-0412</td><td class="mono">AID-2026-0412</td>
    <td>张**</td><td>护眼台灯 2 台</td><td>签收回执</td><td>柳知远</td>
    <td class="num">2026-11-02 18:00</td><td class="num">2026-10-31 11:05</td><td>"""+tag("待领用")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">登记领用</span></td></tr>
  <tr><td class="mono">DO-2026-0409</td><td class="mono">AID-2026-0409</td>
    <td>赵**</td><td>羽绒服 1 件</td><td>追踪归档</td><td>周慧兰</td>
    <td class="num">2026-11-04 18:00</td><td class="num">2026-10-30 15:48</td><td>"""+tag("待反馈")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">催反馈</span></td></tr>
  <tr><td class="mono">DO-2026-0403</td><td class="mono">AID-2026-0403</td>
    <td>陈**</td><td>菜籽油 3 桶</td><td>追踪归档</td><td>周慧兰</td>
    <td class="num">2026-10-31 18:00</td><td class="num">2026-10-29 09:30</td><td>"""+tag("已完成")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">导出</span></td></tr>
  <tr><td class="mono">DO-2026-0398</td><td class="mono">AID-2026-0398</td>
    <td>刘**</td><td>大米 5 袋</td><td>需求审核</td><td>周慧兰</td>
    <td class="num">2026-10-30 18:00</td><td class="num">2026-10-28 14:12</td><td>"""+tag("已退回")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op danger">查看理由</span></td></tr>
  <tr><td class="mono">DO-2026-0391</td><td class="mono">AID-2026-0391</td>
    <td>东湖街道养老服务中心</td><td>成人纸尿裤 40 包</td><td>签收回执</td><td>柳知远</td>
    <td class="num">2026-10-27 18:00</td><td class="num">2026-10-26 17:40</td><td>"""+tag("待配送")+"""</td>
    <td><span class="link-op">详情</span><span class="link-op">配送确认</span></td></tr>
  <tr><td class="mono">DO-2026-0384</td><td class="mono">AID-2026-0384</td>
    <td>城西街道××社区</td><td>洗衣液 80 瓶</td><td>分配出库</td><td>许文山</td>
    <td class="num">2026-10-26 18:00</td><td class="num">2026-10-25 09:20</td><td>"""+tag("已取消")+"""</td>
    <td><span class="link-op">详情</span></td></tr>
  </tbody></table></div>
  """ + pager(328) + """
</div>""")

# ---------------------------------------------------------------- 11 发放追踪详情
PAGES["distribution-detail.html"] = ("总览", "发放追踪单", head(
    "DO-2026-0418 发放追踪单", "顶部固定编号、状态、责任人与时间；中部关联上下游单据；底部时间轴留痕") + """
<div class="detail-hero">
  <div><div class="code">DO-2026-0418</div>
    <div class="small muted" style="margin-top:5px">受助申请 AID-2026-0418 · 现场领用 · 城西公益仓</div></div>
  <div class="meta">
    <div>当前阶段<b>分配出库</b></div>
    <div>状态<b>"""+tag("待拣货")+"""</b></div>
    <div>责任人<b>许文山</b></div>
    <div>创建时间<b>2026-11-01 09:40</b></div>
    <div>最近更新<b>2026-11-01 10:26</b></div>
  </div>
  <div class="actions"><button class="btn">导出</button><button class="btn btn-danger">作废</button>
    <button class="btn btn-primary">推进到下一阶段</button></div>
</div>
<div class="card mb0" style="margin-bottom:14px">
  <div class="steps">
    <div class="step done"><i>✓</i>捐赠登记</div>
    <div class="step done"><i>✓</i>质检入库</div>
    <div class="step done"><i>✓</i>需求审核</div>
    <div class="step cur"><i>4</i>分配出库</div>
    <div class="step"><i>5</i>签收回执</div>
    <div class="step"><i>6</i>追踪归档</div>
  </div>
</div>
<div class="grid-32">
  <div>
    <div class="grid-2">
      <div class="card"><div class="card-head"><h2>受助信息</h2><span class="sub">已脱敏</span></div>
        <dl class="dl">
          <dt>领取人</dt><dd>王**（家庭，4 人）</dd>
          <dt>联系电话</dt><dd>138****6042</dd>
          <dt>所属区域</dt><dd>城西街道 · 第 3 网格</dd>
          <dt>发放方式</dt><dd>现场领用</dd>
          <dt>紧迫等级</dt><dd><span class="tag tag-danger">特急</span></dd>
          <dt>审核员</dt><dd>周慧兰 · 2026-11-01 09:32</dd>
        </dl></div>
      <div class="card"><div class="card-head"><h2>物资明细</h2></div>
        <div class="table-wrap"><table class="table"><tbody>
          <tr><td>一级压榨菜籽油</td><td class="num">3 桶</td><td class="mono small">BAT-260402-11</td></tr>
          <tr><td>东北长粒香米</td><td class="num">1 袋</td><td class="mono small">BAT-260410-06</td></tr>
          <tr><td>加厚羽绒服（L）</td><td class="num">1 件</td><td class="mono small">BAT-261026-11</td></tr>
        </tbody></table></div>
        <div class="rule-note mt12">合计 5 件，出库扣减在同一事务内完成，任一批次可用量不足则整单回滚。</div></div>
    </div>
    <div class="card"><div class="card-head"><h2>关联单据</h2><span class="sub">上下游追溯 · 点击编号打开详情</span></div>
      <div class="table-wrap"><table class="table"><thead><tr>
        <th>类型</th><th>编号</th><th>说明</th><th>状态</th><th>时间</th><th>操作</th></tr></thead>
      <tbody>
        <tr><td>受助申请</td><td class="mono">AID-2026-0418</td><td>王** · 家庭 · 菜籽油/大米/羽绒服</td><td>"""+tag("待拣货")+"""</td><td class="num">2026-11-01 09:12</td><td><span class="link-op">打开</span></td></tr>
        <tr><td>物资批次</td><td class="mono">BAT-260402-11</td><td>一级压榨菜籽油 5L · A-03-01</td><td>"""+tag("正常")+"""</td><td class="num">2026-04-02 10:00</td><td><span class="link-op">打开</span></td></tr>
        <tr><td>物资批次</td><td class="mono">BAT-260410-06</td><td>东北长粒香米 10kg · A-01-02</td><td>"""+tag("正常")+"""</td><td class="num">2026-04-10 14:20</td><td><span class="link-op">打开</span></td></tr>
        <tr><td>捐赠项目</td><td class="mono">PRJ-2026-014</td><td>暖冬计划·御寒物资包</td><td>"""+tag("进行中")+"""</td><td class="num">2026-05-08 09:00</td><td><span class="link-op">打开</span></td></tr>
        <tr><td>分配建议</td><td class="mono">SCR-2026-0418</td><td>规则 v3.2 · 总分 86.4 · 优先分配</td><td>"""+tag("已完成")+"""</td><td class="num">2026-11-01 09:26</td><td><a class="link-op" href="score-detail.html">打开</a></td></tr>
      </tbody></table></div></div>
    <div class="card"><div class="card-head"><h2>分配建议解释（创新模块）</h2><span class="sub">不能只显示分数</span>
        <div class="actions"><button class="btn btn-sm">人工调整</button><button class="btn btn-sm">重新计算</button></div></div>
      <div class="score-head" style="padding-top:0">
        <div class="score-num">86.4<small>/100</small></div>
        <div class="score-lv high">优先分配</div>
        <div class="small muted" style="line-height:1.8">规则版本 <b>v3.2</b>（2026-10-08 生效）<br>
          计算时间 2026-11-01 09:26 · 计算人 系统规则服务</div>
      </div>
      <div class="grid-2">
        <div>
          <div class="small muted" style="margin-bottom:8px">主要影响因素</div>
          <div class="factor"><span class="fn">需求紧迫等级</span><span class="fw">25%</span><span class="ft"><span class="ff" style="width:96%"></span></span><span class="fv">特急</span><span class="fs">24.0</span></div>
          <div class="factor"><span class="fn">库存数量</span><span class="fw">20%</span><span class="ft"><span class="ff" style="width:88%"></span></span><span class="fv">充足</span><span class="fs">17.6</span></div>
          <div class="factor"><span class="fn">区域配送能力</span><span class="fw">15%</span><span class="ft"><span class="ff" style="width:100%"></span></span><span class="fv">高</span><span class="fs">15.0</span></div>
          <div class="factor"><span class="fn">家庭人数</span><span class="fw">15%</span><span class="ft"><span class="ff" style="width:80%"></span></span><span class="fv">4 人</span><span class="fs">12.0</span></div>
          <div class="factor"><span class="fn">保质期</span><span class="fw">10%</span><span class="ft"><span class="ff" style="width:72%"></span></span><span class="fv">14 月</span><span class="fs">7.2</span></div>
          <div class="factor"><span class="fn">历史领取量</span><span class="fw">15%</span><span class="ft"><span class="ff" style="width:47%"></span></span><span class="fv">42kg</span><span class="fs">7.1</span></div>
        </div>
        <div>
          <div class="rule-note" style="margin-bottom:10px"><b>结论说明：</b>该申请紧迫等级为特急，家庭 4 人且含失能老人，库存充足、区域配送能力高，综合评分 86.4，建议优先分配。</div>
          <div class="small muted" style="margin-bottom:6px">未满足条件</div>
          <div class="rule-note" style="border-left-color:#B02A37;margin-bottom:10px">年度累计领取量已接近上限（米面粮油 42/60 kg），大米申请量按上限调整。</div>
          <div class="small muted" style="margin-bottom:6px">可改进项</div>
          <div class="rule-note" style="border-left-color:#A8761C">补充家庭收入流水可提升「需求紧迫等级」判定精度；建议同步登记学龄儿童助学需求。</div>
          <div class="small muted mt16" style="margin-bottom:6px">人工调整记录</div>
          <div class="rule-note">2026-11-01 09:35 周慧兰：将大米数量由 2 袋调整为 1 袋，原因「按年度累计上限调整，保障后续月份可领」。原始计算结果未覆盖。</div>
        </div>
      </div>
    </div>
  </div>
  <div>
    <div class="card"><div class="card-head"><h2>业务时间轴</h2><span class="sub">不可由普通用户修改</span></div>
      <div class="timeline">
        <div class="tl-item done"><div class="tl-t">2026-11-01 09:12　提交受助申请</div>
          <div class="tl-m">提交人 王** · 代办人 柳知远（社区网格员）</div></div>
        <div class="tl-item done"><div class="tl-t">2026-11-01 09:26　生成分配建议</div>
          <div class="tl-m">规则 v3.2 · 总分 86.4 · 优先分配</div>
          <div class="tl-c">输入快照已保存：紧迫等级特急 / 家庭 4 人 / 历史 42kg / 库存 458 桶 / 保质期 14 月 / 配送能力高</div></div>
        <div class="tl-item done"><div class="tl-t">2026-11-01 09:32　资格审核通过</div>
          <div class="tl-m">审核员 周慧兰</div>
          <div class="tl-c">反重校验通过（距上次领取 96 天）；大米数量按年度上限由 2 袋调整为 1 袋。</div></div>
        <div class="tl-item done"><div class="tl-t">2026-11-01 09:40　生成发放追踪单</div>
          <div class="tl-m">系统自动 · 责任人 许文山 · 截止 2026-11-02 18:00</div></div>
        <div class="tl-item cur"><div class="tl-t">2026-11-01 10:26　拣货完成，待复核</div>
          <div class="tl-m">拣货人 许文山 · 3 个批次均复核通过</div>
          <div class="tl-c">FEFO 推荐：BAT-260402-11（2026-12-20 到期，优先出库）</div></div>
        <div class="tl-item"><div class="tl-t">待完成　签收回执</div>
          <div class="tl-m">需上传签字照片或配送凭证</div></div>
        <div class="tl-item"><div class="tl-t">待完成　追踪归档</div>
          <div class="tl-m">受助人提交反馈并审核通过后归档</div></div>
      </div>
    </div>
    <div class="card"><div class="card-head"><h2>操作记录</h2></div>
      <dl class="dl" style="grid-template-columns:76px 1fr">
        <dt>创建人</dt><dd>系统自动（源单 AID-2026-0418）</dd>
        <dt>最近修改</dt><dd>许文山 2026-11-01 10:26</dd>
        <dt>版本号</dt><dd class="num">v7</dd>
        <dt>并发校验</dt><dd>基于版本号，提交时校验</dd>
      </dl>
    </div>
  </div>
</div>""")

# ---------------------------------------------------------------- 12 去向反馈
PAGES["feedback-list.html"] = ("总览", "去向反馈", head(
    "去向反馈", "受助人或项目人员提交收到确认与非敏感反馈，审核后向捐赠人公开展示",
    '<button class="btn">导出</button><button class="btn btn-primary">批量审核通过</button>') + """
<div class="card">
  <div class="rule-note" style="margin-bottom:14px">
    <b>公开脱敏规则：</b>对外展示时隐藏受助人姓名（保留姓氏 + **）、住址（仅到街道）、联系方式与全部证明文件；
    反馈文本经敏感词扫描后才可发布。审核通过的内容同步到「公开报表」与捐赠人门户。
  </div>
  <div class="filter-bar">
    <div class="filter-item"><label>审核状态</label><select class="select"><option>全部状态</option><option>待审核</option><option>已通过</option><option>已驳回</option></select></div>
    <div class="filter-item"><label>反馈类型</label><select class="select"><option>全部类型</option><option>收到确认</option><option>使用反馈</option><option>问题反馈</option></select></div>
    <div class="filter-item"><label>关联项目</label><select class="select"><option>全部项目</option><option>暖冬计划·御寒物资包</option><option>银龄关怀·营养补给</option></select></div>
    <div class="filter-item"><input class="input w-md" placeholder="反馈编号 / 发放单号"></div>
    <button class="btn btn-sub">查询</button><button class="btn">重置</button>
  </div>
  <div class="table-wrap"><table class="table"><thead><tr>
    <th style="width:34px"><input type="checkbox"></th><th>反馈编号</th><th>关联发放单</th><th>提交人（脱敏）</th>
    <th>反馈类型</th><th>反馈摘要</th><th>照片</th><th>提交时间</th><th>状态</th><th>操作</th></tr></thead>
  <tbody>
  <tr><td><input type="checkbox"></td><td class="mono">FB-2026-0306</td><td class="mono">DO-2026-0403</td>
    <td>陈**</td><td>收到确认</td><td class="small">物资已全部收到，油品包装完好，感谢捐赠人。</td>
    <td><div class="flex gap8"><div class="thumb" style="background:linear-gradient(135deg,#356A7A,#19324A)"></div>
      <div class="thumb" style="background:linear-gradient(135deg,#5B6B7A,#33454F)"></div></div></td>
    <td class="num">2026-10-30 19:22</td><td>"""+tag("待审核")+"""</td>
    <td><span class="link-op">审核</span><span class="link-op">预览公开效果</span></td></tr>
  <tr><td><input type="checkbox"></td><td class="mono">FB-2026-0304</td><td class="mono">DO-2026-0409</td>
    <td>赵**</td><td>使用反馈</td><td class="small">羽绒服已穿用，尺码合适，老人说很暖和。</td>
    <td><div class="flex gap8"><div class="thumb" style="background:linear-gradient(135deg,#2C4A63,#19324A)"></div></div></td>
    <td class="num">2026-10-30 08:14</td><td>"""+tag("待审核")+"""</td>
    <td><span class="link-op">审核</span><span class="link-op">预览公开效果</span></td></tr>
  <tr><td><input type="checkbox"></td><td class="mono">FB-2026-0298</td><td class="mono">DO-2026-0391</td>
    <td>东湖街道养老服务中心</td><td>问题反馈</td><td class="small">其中 2 包外包装有轻微破损，内部完好。</td>
    <td><div class="flex gap8"><div class="thumb" style="background:linear-gradient(135deg,#6E7F8C,#4B5F6E)"></div></div></td>
    <td class="num">2026-10-28 15:40</td><td>"""+tag("待审核")+"""</td>
    <td><span class="link-op">审核</span><span class="link-op">转异常处理</span></td></tr>
  <tr><td><input type="checkbox"></td><td class="mono">FB-2026-0292</td><td class="mono">DO-2026-0386</td>
    <td>王**</td><td>收到确认</td><td class="small">已收到大米与食用油，社区志愿者送到家门口。</td>
    <td><div class="flex gap8"><div class="thumb" style="background:linear-gradient(135deg,#356A7A,#2B7955)"></div></div></td>
    <td class="num">2026-10-26 17:05</td><td>"""+tag("已完成")+"""</td>
    <td><span class="link-op">查看</span><span class="link-op">公开页面</span></td></tr>
  <tr><td><input type="checkbox"></td><td class="mono">FB-2026-0286</td><td class="mono">DO-2026-0384</td>
    <td>城西街道××社区</td><td>收到确认</td><td class="small">物资已入库社区爱心角，将按需分发。</td>
    <td><div class="flex gap8"><div class="thumb" style="background:linear-gradient(135deg,#8A6E3C,#5B4520)"></div></div></td>
    <td class="num">2026-10-25 11:18</td><td>"""+tag("已退回")+"""</td>
    <td><span class="link-op">查看理由</span><span class="link-op">通知补正</span></td></tr>
  </tbody></table></div>
  """ + pager(186) + """
</div>
<div class="grid-2 mt16">
  <div class="card"><div class="card-head"><h2>公开效果预览</h2><span class="sub">捐赠人看到的样子</span></div>
    <div class="summary-box">
      <div class="row"><span>受助对象</span><b>陈**（城西街道）</b></div>
      <div class="row"><span>领取物资</span><b>一级压榨菜籽油 5L × 3 桶</b></div>
      <div class="row"><span>发放时间</span><b>2026-10-29 09:30</b></div>
      <div class="row"><span>反馈内容</span><b>物资已全部收到，油品包装完好，感谢捐赠人。</b></div>
    </div>
    <div style="font-size:12px;color:#8A99A6">已隐藏：真实姓名、身份证号、联系电话、家庭住址（仅保留街道）、证明材料文件</div>
  </div>
  <div class="card"><div class="card-head"><h2>审核处理</h2><span class="sub">FB-2026-0306</span></div>
    <div class="form-item"><label>审核结论<em>*</em></label>
      <select class="select" style="width:100%"><option>通过并公开</option><option>通过但不公开</option><option>驳回</option></select></div>
    <div class="form-item mt12"><label>敏感词扫描</label>
      <div class="summary-box" style="margin:0"><div class="row"><span>扫描结果</span><b style="color:#2B7955">未命中敏感词</b></div>
        <div class="row"><span>含个人信息</span><b>否</b></div>
        <div class="row"><span>含他人信息</span><b>否</b></div></div></div>
    <div class="form-item mt12"><label>审核意见（驳回时必填，≥5 字）</label>
      <div class="textarea" style="max-width:100%;color:#8A99A6">如反馈内容涉及受助人隐私或与发放记录不符，请说明具体原因。</div></div>
    <button class="btn btn-primary mt16" style="width:100%;justify-content:center">提交审核</button>
  </div>
</div>""")

# ---------------------------------------------------------------- 13 规则配置（创新点）
PAGES["rule-config.html"] = ("总览", "分配规则配置", head(
    "分配规则配置", "「需求紧迫度与物资分配建议」的权重、阈值与版本管理，权重合计必须等于 100%",
    '<button class="btn">查看历史版本</button><button class="btn btn-primary">保存并发布新版本</button>') + """
<div class="grid-32">
  <div class="card"><div class="card-head"><h2>当前生效规则 v3.2</h2>
      <span class="sub">生效时间 2026-10-08 09:00 · 发布人 陈砚秋</span>
      <div class="actions"><span class="tag tag-plain tag-success">启用中</span></div></div>
    <div class="rule-note" style="margin-bottom:14px">
      规则用于生成受助申请的分配建议，属于「可解释的业务辅助工具」，不替用户做不可逆决定。
      修改权重只影响之后的新计算或主动重新计算的数据，历史结果按原版本保留。
    </div>
    <div class="table-wrap"><table class="table"><thead><tr>
      <th>输入因素</th><th>数据来源</th><th>缺失处理</th><th>权重</th><th>评分规则</th><th>操作</th></tr></thead>
    <tbody>
      <tr><td>需求紧迫等级</td><td>aid_application.urgency_level</td><td>不参与计算并提示补录</td>
        <td><input class="input" style="width:66px;height:27px" value="25"> %</td>
        <td class="small">特急 100 / 紧急 75 / 一般 50 / 低 25</td><td><span class="link-op">调阈值</span></td></tr>
      <tr><td>家庭人数</td><td>aid_application.family_size</td><td>不参与计算并提示补录</td>
        <td><input class="input" style="width:66px;height:27px" value="15"> %</td>
        <td class="small">≥5 人 100 / 4 人 80 / 3 人 65 / ≤2 人 45</td><td><span class="link-op">调阈值</span></td></tr>
      <tr><td>历史领取量</td><td>distribution_order 近 12 月汇总</td><td>按 0 计并提示</td>
        <td><input class="input" style="width:66px;height:27px" value="15"> %</td>
        <td class="small">越接近年度上限得分越低（线性反向）</td><td><span class="link-op">调阈值</span></td></tr>
      <tr><td>库存数量</td><td>inventory_batch 可用量汇总</td><td>不参与计算并提示补录</td>
        <td><input class="input" style="width:66px;height:27px" value="20"> %</td>
        <td class="small">可满足率 ≥100% 得满分，线性递减</td><td><span class="link-op">调阈值</span></td></tr>
      <tr><td>保质期</td><td>inventory_batch.expire_date</td><td>不适用时按中性 60 分</td>
        <td><input class="input" style="width:66px;height:27px" value="10"> %</td>
        <td class="small">剩余 ≤30 天 100（优先出库）/ ≤90 天 80 / 其余 60</td><td><span class="link-op">调阈值</span></td></tr>
      <tr><td>区域配送能力</td><td>sys_org.delivery_capacity</td><td>不参与计算并提示补录</td>
        <td><input class="input" style="width:66px;height:27px" value="15"> %</td>
        <td class="small">高 100 / 中 75 / 低 45</td><td><span class="link-op">调阈值</span></td></tr>
    </tbody></table></div>
    <div class="flex gap12 mt16">
      <div class="summary-box" style="margin:0;flex:1">
        <div class="row"><span>权重合计</span><b style="color:#2B7955;font-size:15px">100%</b></div>
        <div class="row"><span>校验结果</span><b style="color:#2B7955">通过，可发布</b></div>
      </div>
      <div class="summary-box" style="margin:0;flex:1">
        <div class="row"><span>结果等级</span><b>优先分配 ≥80 / 常规 60-79</b></div>
        <div class="row"><span></span><b>暂缓 40-59 / 不推荐 &lt;40</b></div>
      </div>
      <div class="summary-box" style="margin:0;flex:1">
        <div class="row"><span>发布时间</span><b>保存后立即生效</b></div>
        <div class="row"><span>版本号</span><b>自动递增 v3.3</b></div>
      </div>
    </div>
    <div class="card-head mt16" style="margin-bottom:8px"><h2>版本变更说明</h2><span class="sub">发布时必填，≥5 字</span></div>
    <div class="textarea" style="max-width:100%">提高库存数量权重至 20%，降低历史领取量权重至 15%，使库存充足地区的发放更及时。</div>
  </div>
  <div>
    <div class="card"><div class="card-head"><h2>版本历史</h2></div>
      <div class="timeline">
        <div class="tl-item cur"><div class="tl-t">v3.2　2026-10-08 生效</div>
          <div class="tl-m">发布人 陈砚秋 · 使用中</div>
          <div class="tl-c">提高紧迫等级权重至 25%，新增区域配送能力因素。</div></div>
        <div class="tl-item done"><div class="tl-t">v3.1　2026-08-20 生效</div>
          <div class="tl-m">发布人 陈砚秋</div>
          <div class="tl-c">修正保质期评分阈值，临期批次优先出库。</div></div>
        <div class="tl-item done"><div class="tl-t">v3.0　2026-06-12 生效</div>
          <div class="tl-m">发布人 周慧兰</div>
          <div class="tl-c">首次引入六因素加权模型，替代原单一紧迫度排序。</div></div>
      </div>
    </div>
    <div class="card"><div class="card-head"><h2>效果统计</h2><span class="sub">验证创新模块是否有效</span></div>
      <div class="gauge-row"><span class="lb">推荐采纳率</span><span class="track"><span class="fill" style="width:78%;background:#2B7955"></span></span><span class="vl">78.4%</span></div>
      <div class="gauge-row"><span class="lb">人工调整率</span><span class="track"><span class="fill" style="width:13%;background:#A8761C"></span></span><span class="vl">13.2%</span></div>
      <div class="gauge-row"><span class="lb">签收完成率</span><span class="track"><span class="fill" style="width:96%;background:#356A7A"></span></span><span class="vl">96.8%</span></div>
      <div class="gauge-row"><span class="lb">平均处理时长</span><span class="track"><span class="fill" style="width:62%;background:#456C7E"></span></span><span class="vl">21.4h</span></div>
      <div class="rule-note mt12">统计区间 2026-09-01 至 2026-11-01，样本 328 条发放单。人工调整主要集中在历史领取量与家庭人数两项。</div>
    </div>
    <div class="card"><div class="card-head"><h2>最近计算结果</h2></div>
      <div class="table-wrap"><table class="table"><tbody>
        <tr><td class="mono small">SCR-2026-0418</td><td>86.4</td><td><span class="tag tag-success">优先</span></td><td><a class="link-op" href="score-detail.html">查看</a></td></tr>
        <tr><td class="mono small">SCR-2026-0417</td><td>72.1</td><td><span class="tag tag-sub">常规</span></td><td><a class="link-op" href="score-detail.html">查看</a></td></tr>
        <tr><td class="mono small">SCR-2026-0415</td><td>64.8</td><td><span class="tag tag-sub">常规</span></td><td><a class="link-op" href="score-detail.html">查看</a></td></tr>
        <tr><td class="mono small">SCR-2026-0412</td><td>52.3</td><td><span class="tag tag-warn">暂缓</span></td><td><a class="link-op" href="score-detail.html">查看</a></td></tr>
        <tr><td class="mono small">SCR-2026-0409</td><td>38.7</td><td><span class="tag tag-danger">不推荐</span></td><td><a class="link-op" href="score-detail.html">查看</a></td></tr>
      </tbody></table></div>
    </div>
  </div>
</div>""")

# ---------------------------------------------------------------- 14 分配建议解释（创新点）
PAGES["score-detail.html"] = ("总览", "分配建议解释", head(
    "分配建议 · SCR-2026-0418", "展示输入依据、逐项得分、结果等级说明与人工调整记录，原始计算结果不可覆盖",
    '<button class="btn">导出计算报告</button><button class="btn">按新规则重算</button>') + """
<div class="detail-hero">
  <div><div class="code">SCR-2026-0418</div>
    <div class="small muted" style="margin-top:5px">受助申请 AID-2026-0418 · 王** · 城西街道 · 家庭 4 人</div></div>
  <div class="meta">
    <div>规则版本<b>v3.2（2026-10-08 生效）</b></div>
    <div>计算时间<b>2026-11-01 09:26:41</b></div>
    <div>计算耗时<b>38 ms</b></div>
    <div>人工调整<b>有（1 次）</b></div>
  </div>
  <div class="actions"><button class="btn btn-danger">人工调整</button></div>
</div>
<div class="grid-32">
  <div>
    <div class="card"><div class="card-head"><h2>计算结果</h2>
        <div class="actions"><span class="muted small">相同输入 + 相同规则版本 → 相同结果（已通过 30 组用例校验）</span></div></div>
      <div class="score-head">
        <div class="score-num">86.4<small>/100</small></div>
        <div><div class="score-lv high">优先分配</div>
          <div class="small muted mt8">等级阈值：≥80 优先分配 · 60-79 常规分配 · 40-59 暂缓分配 · &lt;40 不推荐</div></div>
        <div style="margin-left:auto;text-align:right">
          <div class="small muted">建议发放数量</div>
          <div style="font-size:16px;font-weight:600;margin-top:4px">菜籽油 3 桶 · 大米 1 袋 · 羽绒服 1 件</div>
          <div class="small muted mt8">基于库存可满足率与限领规则计算</div>
        </div>
      </div>
      <div class="table-wrap"><table class="table"><thead><tr>
        <th>输入因素</th><th>输入值</th><th>数据来源</th><th>归一化得分</th><th>权重</th><th>加权得分</th><th>说明</th></tr></thead>
      <tbody>
        <tr><td>需求紧迫等级</td><td><span class="tag tag-danger">特急</span></td><td class="small">aid_application.urgency_level</td>
          <td class="num">100</td><td class="num">25%</td><td class="num" style="font-weight:600">24.00</td><td class="small">特急映射 100 分</td></tr>
        <tr><td>家庭人数</td><td class="num">4 人</td><td class="small">aid_application.family_size</td>
          <td class="num">80</td><td class="num">15%</td><td class="num" style="font-weight:600">12.00</td><td class="small">4 人区间映射 80 分</td></tr>
        <tr><td>历史领取量</td><td class="num">42 kg</td><td class="small">distribution_order 近 12 月</td>
          <td class="num">47</td><td class="num">15%</td><td class="num" style="font-weight:600">7.05</td><td class="small">42/60 上限，线性反向</td></tr>
        <tr><td>库存数量</td><td class="num">458 桶</td><td class="small">inventory_batch 可用量</td>
          <td class="num">88</td><td class="num">20%</td><td class="num" style="font-weight:600">17.60</td><td class="small">可满足率 100%，扣减降级批次</td></tr>
        <tr><td>保质期</td><td class="num">14 个月</td><td class="small">inventory_batch.expire_date</td>
          <td class="num">72</td><td class="num">10%</td><td class="num" style="font-weight:600">7.20</td><td class="small">推荐批次剩余 72 天加权</td></tr>
        <tr><td>区域配送能力</td><td>高</td><td class="small">sys_org.delivery_capacity</td>
          <td class="num">100</td><td class="num">15%</td><td class="num" style="font-weight:600">15.00</td><td class="small">城西街道配送能力「高」</td></tr>
        <tr style="background:#F7F9FA"><td colspan="4" style="font-weight:600">合计</td><td class="num" style="font-weight:600">100%</td>
          <td class="num" style="font-weight:600;color:#19324A">82.85</td><td class="small">四舍五入 82.9；计入区域系数 1.043 后 86.4</td></tr>
      </tbody></table></div>
      <div class="rule-note mt12">计算链：六项归一化得分 × 权重求和 = 82.85，再乘以区域配送可达系数 1.043（城西街道当日可达率 96%），得到最终分 86.4，落入「优先分配」区间。</div>
    </div>

    <div class="grid-2">
      <div class="card"><div class="card-head"><h2>主要影响因素</h2></div>
        <div class="factor"><span class="fn">需求紧迫等级</span><span class="fw">25%</span><span class="ft"><span class="ff" style="width:96%"></span></span><span class="fv">特急</span><span class="fs">24.0</span></div>
        <div class="factor"><span class="fn">库存数量</span><span class="fw">20%</span><span class="ft"><span class="ff" style="width:88%"></span></span><span class="fv">充足</span><span class="fs">17.6</span></div>
        <div class="factor"><span class="fn">区域配送能力</span><span class="fw">15%</span><span class="ft"><span class="ff" style="width:100%"></span></span><span class="fv">高</span><span class="fs">15.0</span></div>
        <div class="factor"><span class="fn">家庭人数</span><span class="fw">15%</span><span class="ft"><span class="ff" style="width:80%"></span></span><span class="fv">4 人</span><span class="fs">12.0</span></div>
        <div class="factor"><span class="fn">保质期</span><span class="fw">10%</span><span class="ft"><span class="ff" style="width:72%"></span></span><span class="fv">14 月</span><span class="fs">7.2</span></div>
        <div class="factor"><span class="fn">历史领取量</span><span class="fw">15%</span><span class="ft"><span class="ff" style="width:47%"></span></span><span class="fv">42kg</span><span class="fs">7.1</span></div>
      </div>
      <div class="card"><div class="card-head"><h2>结论解释</h2></div>
        <div style="font-size:12px;color:#5B6B7A;line-height:1.9;margin-bottom:12px">
          该申请在六项因素中「需求紧迫等级」与「库存数量」贡献最大（合计 41.6 分，占总分 48%）。
          受助家庭含 1 名失能老人与 1 名学龄儿童，紧迫等级为特急，且城西街道当日配送可达率 96%，
          建议排在待处理队列前列，优先分配。
        </div>
        <div class="small muted" style="margin-bottom:6px">未满足条件</div>
        <div class="rule-note" style="border-left-color:#B02A37;margin-bottom:10px">年度累计领取量已接近上限（米面粮油 42/60 kg），本次大米申请 2 袋超出剩余额度，建议按 1 袋发放。</div>
        <div class="small muted" style="margin-bottom:6px">可改进项</div>
        <div class="rule-note" style="border-left-color:#A8761C">补充家庭收入流水与医疗支出凭证，可提升「需求紧迫等级」判定精度；建议同步登记学龄儿童助学需求，走学习用品专项。</div>
      </div>
    </div>

    <div class="card"><div class="card-head"><h2>人工调整记录</h2><span class="sub">原始计算结果不得覆盖，调整单独留存</span></div>
      <div class="table-wrap"><table class="table"><thead><tr>
        <th>调整时间</th><th>调整人</th><th>调整项</th><th>原值</th><th>新值</th><th>原因</th></tr></thead>
      <tbody>
        <tr><td class="num">2026-11-01 09:35:12</td><td>周慧兰（受助审核员）</td><td>大米发放数量</td>
          <td class="num">2 袋</td><td class="num">1 袋</td>
          <td class="small">按年度累计上限调整，保障后续月份可领</td></tr>
        <tr><td class="num">2026-11-01 09:36:04</td><td>周慧兰（受助审核员）</td><td>结论等级</td>
          <td>优先分配</td><td>优先分配</td>
          <td class="small">维持系统建议，未作调整</td></tr>
      </tbody></table></div>
    </div>
  </div>

  <div>
    <div class="card"><div class="card-head"><h2>输入快照</h2><span class="sub">计算时点数据，不可变</span></div>
      <dl class="dl" style="grid-template-columns:82px 1fr">
        <dt>紧迫等级</dt><dd>特急</dd>
        <dt>家庭人数</dt><dd>4 人</dd>
        <dt>历史领取</dt><dd>42 kg（近 12 月）</dd>
        <dt>申请物资</dt><dd>菜籽油 3 桶 / 大米 2 袋 / 羽绒服 1 件</dd>
        <dt>可用库存</dt><dd>菜籽油 458 桶 / 大米 374 袋 / 羽绒服 3 件</dd>
        <dt>推荐批次</dt><dd>BAT-260402-11（2026-12-20）</dd>
        <dt>区域能力</dt><dd>城西街道 · 高 · 可达率 96%</dd>
        <dt>规则版本</dt><dd>v3.2</dd>
        <dt>数据完整度</dt><dd><span class="tag tag-success">6/6 项齐全</span></dd>
      </dl>
    </div>
    <div class="card"><div class="card-head"><h2>规则依据</h2></div>
      <div class="rule-note" style="margin-bottom:10px">需求紧迫等级权重 25%，特急映射 100 分、紧急 75、一般 50、低 25。数据缺失时不参与计算，并在结果页提示补录。</div>
      <div class="rule-note" style="margin-bottom:10px">历史领取量按近 12 个月发放记录汇总，越接近年度上限得分越低（线性反向），避免同类物资重复发放。</div>
      <div class="rule-note">库存数量按可用量（扣除锁定与不合格）计算可满足率，低于 50% 时该因素得分不超过 40，并在结果页标注「库存不足」。</div>
      <a class="link-op mt12" style="display:block" href="rule-config.html">前往规则配置 →</a>
    </div>
    <div class="card"><div class="card-head"><h2>同批次结果对比</h2><span class="sub">本次计算共 8 条</span></div>
      <div class="table-wrap"><table class="table"><tbody>
        <tr style="background:#F7F9FA"><td class="mono small">SCR-0418</td><td class="num">86.4</td><td><span class="tag tag-success">优先</span></td><td class="small">本单</td></tr>
        <tr><td class="mono small">SCR-0417</td><td class="num">72.1</td><td><span class="tag tag-sub">常规</span></td><td class="small">李** 东湖</td></tr>
        <tr><td class="mono small">SCR-0415</td><td class="num">64.8</td><td><span class="tag tag-sub">常规</span></td><td class="small">南苑中心</td></tr>
        <tr><td class="mono small">SCR-0412</td><td class="num">52.3</td><td><span class="tag tag-warn">暂缓</span></td><td class="small">张** 北岭</td></tr>
        <tr><td class="mono small">SCR-0409</td><td class="num">38.7</td><td><span class="tag tag-danger">不推荐</span></td><td class="small">赵** 城西</td></tr>
      </tbody></table></div>
      <div class="hint-line mt8">SCR-0409 判定不推荐的原因为「同户 30 天内已领取同类物资，间隔期未满」。</div>
    </div>
  </div>
</div>""")
print("part2 ok")
