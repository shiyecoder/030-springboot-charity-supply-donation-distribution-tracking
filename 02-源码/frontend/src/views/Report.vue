<template>
  <div>
    <PageHead title="统计报表" sub="物资收支、区域覆盖与发放明细，公开报表已按姓名与手机号脱敏">
      <template #actions>
        <button class="btn" @click="load">刷新</button>
        <button class="btn btn-primary" @click="exportCsv">导出 CSV</button>
      </template>
    </PageHead>

    <div class="chart-grid">
      <div class="chart-box">
        <h3>类别入库结构</h3>
        <div class="hint">累计入库数量（件）</div>
        <div ref="catRef" style="height: 168px"></div>
      </div>
      <div class="chart-box">
        <h3>区域受助覆盖</h3>
        <div class="hint">按受助人数</div>
        <div ref="regionRef" style="height: 168px"></div>
      </div>
      <div class="chart-box">
        <h3>发放单状态</h3>
        <div class="hint">全量发放单</div>
        <div ref="statusRef" style="height: 168px"></div>
      </div>
    </div>

    <div class="grid-2" style="margin-top: 14px">
      <div class="card mb0">
        <div class="card-head"><h2>项目募集进度</h2><span class="sub">公开可见字段</span></div>
        <div class="table-wrap">
          <table class="table tight">
            <thead>
              <tr>
                <th>项目</th>
                <th class="num">目标</th>
                <th class="num">已收</th>
                <th style="width: 130px">进度</th>
                <th>状态</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="p in report.projects || []" :key="p.title">
                <td>{{ p.title }}</td>
                <td class="num">{{ fmtNum(p.target) }}</td>
                <td class="num">{{ fmtNum(p.received) }}</td>
                <td>
                  <div class="progress" style="margin-top: 0">
                    <div class="fill" :style="{ width: pct(p.received, p.target) + '%' }"></div>
                  </div>
                </td>
                <td><span class="tag" :class="tagClass(p.status)">{{ p.status }}</span></td>
              </tr>
              <tr v-if="(report.projects || []).length === 0"><td colspan="5"><div class="empty">暂无项目数据</div></td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card mb0">
        <div class="card-head"><h2>最近发放明细</h2><span class="sub">受助人姓名已脱敏</span></div>
        <div class="table-wrap">
          <table class="table tight">
            <thead>
              <tr>
                <th>发放单号</th>
                <th>区域</th>
                <th>物资</th>
                <th class="num">数量</th>
                <th>受助人</th>
                <th>完成时间</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="r in report.records || []" :key="r.orderNo + r.material">
                <td class="mono">{{ r.orderNo }}</td>
                <td>{{ r.region }}</td>
                <td>{{ r.material }}</td>
                <td class="num">{{ r.qty }}</td>
                <td>{{ r.person }}</td>
                <td>{{ fmtTime(r.finishTime) }}</td>
              </tr>
              <tr v-if="(report.records || []).length === 0"><td colspan="6"><div class="empty">暂无发放明细</div></td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="card" style="margin-top: 14px">
      <div class="card-head"><h2>关键指标</h2><span class="sub">与看板同一口径</span></div>
      <div class="kpi-grid" style="margin-bottom: 0">
        <div class="kpi"><div class="lb">在库总量</div><div class="val">{{ fmtNum(dash.stockTotal) }}</div></div>
        <div class="kpi"><div class="lb">本月入库</div><div class="val">{{ fmtNum(dash.inQty) }}</div></div>
        <div class="kpi"><div class="lb">发放单</div><div class="val">{{ fmtNum(dash.orderTotal) }}</div></div>
        <div class="kpi"><div class="lb">签收率</div><div class="val">{{ fmtNum(dash.signRate) }}<small>%</small></div></div>
        <div class="kpi"><div class="lb">受助人数</div><div class="val">{{ fmtNum(dash.regionPersons) }}</div></div>
        <div class="kpi"><div class="lb">临期批次</div><div class="val">{{ fmtNum(dash.expiringCount) }}</div></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import * as echarts from 'echarts'
import PageHead from '../components/PageHead.vue'
import { getDashboard, getPublicReport } from '../api'
import { fmtNum, fmtTime, tagClass } from '../utils/dict'

const report = ref({})
const dash = ref({})
const catRef = ref(null)
const regionRef = ref(null)
const statusRef = ref(null)
const charts = []

function pct(a, b) {
  const t = Number(b || 0)
  return t ? Math.min(100, Math.round((Number(a || 0) / t) * 100)) : 0
}

const AXIS = {
  axisLine: { lineStyle: { color: '#E3E8ED' } },
  axisLabel: { color: '#8A99A6', fontSize: 10 },
  axisTick: { show: false },
  splitLine: { lineStyle: { color: '#F1F4F6' } }
}

function render() {
  charts.forEach((c) => c.dispose())
  charts.length = 0
  const cat = report.value.categoryIn || []
  if (catRef.value) {
    const c = echarts.init(catRef.value)
    c.setOption({
      grid: { left: 62, right: 34, top: 8, bottom: 6 },
      tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
      xAxis: { type: 'value', ...AXIS },
      yAxis: { type: 'category', data: cat.map((i) => i.name), ...AXIS, splitLine: { show: false } },
      series: [{ type: 'bar', data: cat.map((i) => i.cnt), barWidth: 10, itemStyle: { color: '#356A7A', borderRadius: [0, 3, 3, 0] }, label: { show: true, position: 'right', fontSize: 10, color: '#5B6B7A' } }]
    })
    charts.push(c)
  }
  const region = report.value.regionRank || []
  if (regionRef.value) {
    const c = echarts.init(regionRef.value)
    c.setOption({
      grid: { left: 62, right: 20, top: 8, bottom: 6 },
      tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
      xAxis: { type: 'value', ...AXIS },
      yAxis: { type: 'category', data: region.map((i) => i.name), ...AXIS, splitLine: { show: false } },
      series: [{ type: 'bar', data: region.map((i) => i.cnt), barWidth: 10, itemStyle: { color: '#19324A', borderRadius: [0, 3, 3, 0] }, label: { show: true, position: 'right', fontSize: 10, color: '#5B6B7A' } }]
    })
    charts.push(c)
  }
  const st = dash.value.statusDist || []
  if (statusRef.value) {
    const c = echarts.init(statusRef.value)
    c.setOption({
      tooltip: { trigger: 'item' },
      legend: { orient: 'vertical', right: 0, top: 'center', itemWidth: 8, itemHeight: 8, textStyle: { fontSize: 10, color: '#5B6B7A' } },
      color: ['#2B7955', '#356A7A', '#A8761C', '#B02A37', '#8A99A6'],
      series: [{ type: 'pie', radius: ['50%', '76%'], center: ['34%', '52%'], label: { show: false }, data: st.map((i) => ({ name: i.name, value: i.cnt })) }]
    })
    charts.push(c)
  }
}

async function load() {
  try {
    report.value = (await getPublicReport()) || {}
    dash.value = (await getDashboard()) || {}
  } catch (e) {
    /* 已提示 */
  }
  await nextTick()
  render()
}

function exportCsv() {
  const rows = [['发放单号', '区域', '物资', '数量', '受助人', '完成时间']]
  ;(report.value.records || []).forEach((r) => rows.push([r.orderNo, r.region, r.material, r.qty, r.person, r.finishTime]))
  const csv = rows.map((r) => r.join(',')).join('\n')
  const blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8' })
  const a = document.createElement('a')
  a.href = URL.createObjectURL(blob)
  a.download = '公益物资发放明细.csv'
  a.click()
  URL.revokeObjectURL(a.href)
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
