<template>
  <div>
    <PageHead title="公益物资看板" :sub="'统计口径：物资数量按件计，数据截至 ' + today">
      <template #actions>
        <button class="btn" @click="load">刷新数据</button>
        <button class="btn btn-primary" @click="$router.push('/report')">查看公开报表</button>
      </template>
    </PageHead>

    <div class="kpi-grid">
      <div class="kpi">
        <div class="lb">在库物资总量</div>
        <div class="val">{{ fmtNum(d.stockTotal) }}<small>件</small></div>
        <div class="tr">近 3 个月入库 <i>{{ fmtNum(d.inQty) }}</i> 件</div>
      </div>
      <div class="kpi">
        <div class="lb">在运捐赠项目</div>
        <div class="val">{{ fmtNum(d.projectCount) }}<small>个</small></div>
        <div class="tr">意向待预审 <i class="dn">{{ fmtNum(d.intentPending) }}</i> 条</div>
      </div>
      <div class="kpi">
        <div class="lb">发放单总数</div>
        <div class="val">{{ fmtNum(d.orderTotal) }}<small>单</small></div>
        <div class="tr">已完成 <i>{{ fmtNum(d.orderDone) }}</i> 单</div>
      </div>
      <div class="kpi">
        <div class="lb">签收回执率</div>
        <div class="val">{{ fmtNum(d.signRate) }}<small>%</small></div>
        <div class="tr">待反馈 <i class="dn">{{ fmtNum(d.feedbackPending) }}</i> 条</div>
      </div>
      <div class="kpi">
        <div class="lb">受助覆盖人数</div>
        <div class="val">{{ fmtNum(d.regionPersons) }}<small>人</small></div>
        <div class="tr">需求待审核 <i class="dn">{{ fmtNum(d.applicationPending) }}</i> 单</div>
      </div>
      <div class="kpi">
        <div class="lb">近 3 个月出库</div>
        <div class="val">{{ fmtNum(d.outQty) }}<small>件</small></div>
        <div class="tr">临期批次 <i class="dn">{{ fmtNum(d.expiringCount) }}</i> 个 · 待反馈 {{ fmtNum(d.feedbackPending) }} 条</div>
      </div>
    </div>

    <div class="chart-grid">
      <div class="chart-box">
        <h3>入库与出库趋势</h3>
        <div class="hint">近 6 个月，单位：件</div>
        <div ref="trendRef" class="spark" style="height: 132px"></div>
      </div>
      <div class="chart-box">
        <h3>物资类别入库结构</h3>
        <div class="hint">按类别累计入库数量</div>
        <div ref="catRef" class="spark" style="height: 132px"></div>
      </div>
      <div class="chart-box">
        <h3>发放单状态分布</h3>
        <div class="hint">全量发放单流转状态</div>
        <div ref="statusRef" class="spark" style="height: 132px"></div>
      </div>
    </div>

    <div class="grid-32" style="margin-top: 14px">
      <div class="card mb0">
        <div class="card-head">
          <h2>发放单处理进度</h2>
          <span class="sub">按阶段统计，点击可进入跟踪</span>
          <div class="actions">
            <button class="btn btn-sm" @click="$router.push('/distribution-list')">全部发放单</button>
          </div>
        </div>
        <div class="table-wrap">
          <table class="table tight">
            <thead>
              <tr>
                <th>发放单号</th>
                <th>受助人</th>
                <th>所属区域</th>
                <th>阶段</th>
                <th>状态</th>
                <th class="num">物资合计</th>
                <th>申请时间</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="o in orders" :key="o.id">
                <td class="mono">{{ o.orderNo }}</td>
                <td>{{ o.receiverName }}</td>
                <td>{{ o.region }}</td>
                <td><span class="tag tag-sub">{{ o.stage }}</span></td>
                <td><span class="tag" :class="tagClass(o.status)">{{ o.status }}</span></td>
                <td class="num">{{ fmtNum(o.totalQty) }}</td>
                <td>{{ fmtDate(o.createTime) }}</td>
              </tr>
              <tr v-if="orders.length === 0"><td colspan="7"><div class="empty">暂无发放单</div></td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card mb0">
        <div class="card-head">
          <h2>区域受助排行</h2>
          <span class="sub">按受助人数</span>
        </div>
        <div class="hbars">
          <div v-for="r in d.regionRank || []" :key="r.name" class="hbar">
            <span class="nm">{{ r.name }}</span>
            <span class="track"><span class="fill" :style="{ width: barWidth(r.cnt, maxRegion) }"></span></span>
            <span class="vl">{{ r.cnt }}</span>
          </div>
        </div>
        <div class="card-head" style="margin-top: 16px; margin-bottom: 10px">
          <h2 style="font-size: 13px">紧迫度评分等级</h2>
          <span class="sub">优先 / 常规 / 暂缓 / 不推荐</span>
        </div>
        <div class="gauge-row" v-for="l in d.levelDist || []" :key="l.name">
          <span class="lb">{{ l.name }}</span>
          <span class="track"
            ><span
              class="fill"
              :style="{ width: barWidth(l.cnt, maxLevel), background: levelColor(l.name) }"
            ></span
          ></span>
          <span class="vl">{{ l.cnt }}</span>
        </div>
        <div class="rule-note" style="margin-top: 14px">
          评分采纳率 {{ d.adoptRate || 0 }}%，人工调整 {{ d.adjustRate || 0 }}%（调整需填写理由，原评分快照保留）
        </div>
      </div>
    </div>

    <div class="card" style="margin-top: 14px">
      <div class="card-head">
        <h2>仓库作业效能</h2>
        <span class="sub">批次数量 / 不合格件数 / 平均收货时长</span>
      </div>
      <div class="table-wrap">
        <table class="table tight">
          <thead>
            <tr>
              <th>仓库</th>
              <th class="num">在库批次</th>
              <th class="num">不合格件数</th>
              <th class="num">平均收货时长（小时）</th>
              <th>不合格率</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="w in d.warehousePerf || []" :key="w.name">
              <td>{{ w.name }}</td>
              <td class="num">{{ w.batches }}</td>
              <td class="num">{{ w.unqualified }}</td>
              <td class="num">{{ w.hours }}</td>
              <td>
                <div class="progress" style="margin-top: 0; width: 120px">
                  <div class="fill" :style="{ width: Math.min(100, w.unqualified / 4) + '%', background: w.unqualified > 200 ? '#B02A37' : '#356A7A' }"></div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref, nextTick } from 'vue'
import * as echarts from 'echarts'
import PageHead from '../components/PageHead.vue'
import { getDashboard, pageDistribution } from '../api'
import { fmtDate, fmtNum, tagClass } from '../utils/dict'

const d = ref({})
const orders = ref([])
const trendRef = ref(null)
const catRef = ref(null)
const statusRef = ref(null)
const charts = []
const today = new Date().toISOString().slice(0, 10)

const maxRegion = computed(() => Math.max(1, ...(d.value.regionRank || []).map((r) => r.cnt)))
const maxLevel = computed(() => Math.max(1, ...(d.value.levelDist || []).map((r) => r.cnt)))

function barWidth(v, max) {
  return Math.max(6, Math.round((Number(v) / max) * 100)) + '%'
}

function levelColor(name) {
  if (name.includes('优先')) return '#2B7955'
  if (name.includes('暂缓')) return '#A8761C'
  if (name.includes('不推荐')) return '#B02A37'
  return '#356A7A'
}

const AXIS = {
  axisLine: { lineStyle: { color: '#E3E8ED' } },
  axisLabel: { color: '#8A99A6', fontSize: 10 },
  axisTick: { show: false },
  splitLine: { lineStyle: { color: '#F1F4F6' } }
}

function renderCharts() {
  charts.forEach((c) => c.dispose())
  charts.length = 0
  const trend = d.value.trend || []
  if (trendRef.value) {
    const c = echarts.init(trendRef.value)
    c.setOption({
      grid: { left: 34, right: 8, top: 18, bottom: 22 },
      tooltip: { trigger: 'axis' },
      legend: { right: 0, top: 0, itemWidth: 10, itemHeight: 6, textStyle: { fontSize: 10, color: '#5B6B7A' } },
      xAxis: { type: 'category', data: trend.map((t) => t.ym), ...AXIS, splitLine: { show: false } },
      yAxis: { type: 'value', ...AXIS },
      series: [
        { name: '入库', type: 'bar', data: trend.map((t) => t.inQty), barWidth: 12, itemStyle: { color: '#19324A', borderRadius: [2, 2, 0, 0] } },
        { name: '出库', type: 'bar', data: trend.map((t) => t.outQty || 0), barWidth: 12, itemStyle: { color: '#5E93A6', borderRadius: [2, 2, 0, 0] } }
      ]
    })
    charts.push(c)
  }
  const cat = d.value.categoryIn || []
  if (catRef.value) {
    const c = echarts.init(catRef.value)
    c.setOption({
      grid: { left: 64, right: 30, top: 10, bottom: 8 },
      tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
      xAxis: { type: 'value', ...AXIS },
      yAxis: { type: 'category', data: cat.map((i) => i.name), ...AXIS, splitLine: { show: false } },
      series: [{ type: 'bar', data: cat.map((i) => i.cnt), barWidth: 9, itemStyle: { color: '#356A7A', borderRadius: [0, 3, 3, 0] }, label: { show: true, position: 'right', fontSize: 10, color: '#5B6B7A' } }]
    })
    charts.push(c)
  }
  const st = d.value.statusDist || []
  if (statusRef.value) {
    const c = echarts.init(statusRef.value)
    c.setOption({
      tooltip: { trigger: 'item' },
      legend: { orient: 'vertical', right: 0, top: 'center', itemWidth: 8, itemHeight: 8, textStyle: { fontSize: 10, color: '#5B6B7A' } },
      color: ['#2B7955', '#356A7A', '#A8761C', '#B02A37', '#8A99A6'],
      series: [
        {
          type: 'pie',
          radius: ['52%', '78%'],
          center: ['36%', '52%'],
          avoidLabelOverlap: true,
          label: { show: false },
          data: st.map((i) => ({ name: i.name, value: i.cnt }))
        }
      ]
    })
    charts.push(c)
  }
}

async function load() {
  try {
    d.value = (await getDashboard()) || {}
    const p = await pageDistribution({ page: 1, size: 6 })
    orders.value = p?.list || []
  } catch (e) {
    /* 拦截器已提示 */
  }
  await nextTick()
  renderCharts()
}

function onResize() {
  charts.forEach((c) => c.resize())
}

onMounted(() => {
  load()
  window.addEventListener('resize', onResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', onResize)
  charts.forEach((c) => c.dispose())
})
</script>
