<template>
  <div>
    <PageHead title="收货验收" sub="按意向验收入库：登记实收、不合格数量与保质期，自动生成入库批次">
      <template #actions>
        <button class="btn" @click="$router.push('/intent-list')">意向管理</button>
        <button class="btn btn-primary" @click="$router.push('/batch-list')">批次台账</button>
      </template>
    </PageHead>

    <div class="card">
      <ListPage :cfg="cfg">
        <template #ops="{ row }">
          <span class="link-op" @click="openDetail(row)">验收明细</span>
        </template>
      </ListPage>
    </div>

    <el-drawer v-model="drawer" title="收货验收明细" size="620px">
      <div class="summary-box">
        <div class="row"><span>收货单号</span><b>{{ rec.receiveNo }}</b></div>
        <div class="row"><span>关联意向</span><b>{{ intent.intentNo || '-' }} · {{ intent.donorName || '-' }}</b></div>
        <div class="row"><span>收货时间</span><b>{{ fmtTime(rec.receiveTime) }}</b></div>
        <div class="row"><span>预计 / 实收</span><b>{{ fmtNum(rec.expectQty) }} / {{ fmtNum(rec.actualQty) }}</b></div>
        <div class="row"><span>合格 / 不合格</span><b>{{ fmtNum(rec.qualifiedQty) }} / {{ fmtNum(rec.unqualifiedQty) }}</b></div>
        <div class="row"><span>不合格率</span><b>{{ rec.unqualifiedRate }}%</b></div>
        <div class="row"><span>验收结果</span><b>{{ rec.result }}（{{ rec.status }}）</b></div>
      </div>

      <div class="card-head"><h2>验收明细</h2><span class="sub">合格数量将生成入库批次</span></div>
      <div class="table-wrap">
        <table class="table tight">
          <thead>
            <tr>
              <th>物资</th>
              <th>规格</th>
              <th class="num">预计</th>
              <th class="num">实收</th>
              <th class="num">不合格</th>
              <th>质量</th>
              <th>保质期至</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="it in items" :key="it.id">
              <td>{{ it.materialName }}</td>
              <td>{{ it.spec }}</td>
              <td class="num">{{ it.expectQty }}</td>
              <td class="num">{{ it.actualQty }}</td>
              <td class="num">{{ it.unqualifiedQty }}</td>
              <td>{{ it.qualityLevel }}</td>
              <td>{{ fmtDate(it.expireDate) }}</td>
            </tr>
            <tr v-if="items.length === 0"><td colspan="7"><div class="empty">该单据暂无验收明细</div></td></tr>
          </tbody>
        </table>
      </div>

      <div class="card-head" style="margin-top: 16px"><h2>生成批次</h2><span class="sub">按先到期先出库排序</span></div>
      <div class="hbars">
        <div v-for="b in batches" :key="b.id" class="hbar">
          <span class="nm">{{ b.batchNo }}</span>
          <span class="track"><span class="fill" :style="{ width: Math.min(100, (b.availableQty / Math.max(1, b.inQty)) * 100) + '%' }"></span></span>
          <span class="vl">{{ b.availableQty }}/{{ b.inQty }}</span>
        </div>
        <div v-if="batches.length === 0" class="empty">暂无批次</div>
      </div>

      <template #footer>
        <button class="btn" @click="drawer = false">关闭</button>
        <button class="btn btn-primary" @click="$router.push('/batch-list')">查看批次台账</button>
      </template>
    </el-drawer>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import PageHead from '../components/PageHead.vue'
import ListPage from '../components/ListPage.vue'
import { getReceiving, pageReceiving } from '../api'
import { fmtDate, fmtNum, fmtTime } from '../utils/dict'

const drawer = ref(false)
const rec = ref({})
const items = ref([])
const batches = ref([])
const intent = ref({})

const cfg = {
  api: pageReceiving,
  pageSize: 10,
  filters: [
    { key: 'keyword', label: '收货单号', w: 'w-md' },
    { key: 'status', label: '状态', type: 'select', options: ['已入库', '已拒收'] },
    { key: 'result', label: '验收结果', type: 'select', options: ['接收', '部分接收', '拒收'] }
  ],
  columns: [
    { key: 'receiveNo', type: 'mono', label: '收货单号', width: '160px' },
    { key: 'receiveTime', type: 'time', label: '收货时间', width: '140px' },
    { key: 'expectQty', type: 'num', label: '预计数量', width: '96px' },
    { key: 'actualQty', type: 'num', label: '实收', width: '84px' },
    { key: 'qualifiedQty', type: 'num', label: '合格', width: '84px' },
    { key: 'unqualifiedQty', type: 'num', label: '不合格', width: '90px' },
    { key: 'unqualifiedRate', label: '不合格率', width: '96px', format: (v) => (v ?? 0) + '%' },
    { key: 'result', type: 'tag', label: '验收结果', width: '96px' },
    { key: 'status', type: 'tag', label: '状态', width: '90px' }
  ]
}

async function openDetail(row) {
  drawer.value = true
  rec.value = row
  items.value = []
  batches.value = []
  intent.value = {}
  try {
    const d = await getReceiving(row.id)
    rec.value = d.record || row
    items.value = d.items || []
    batches.value = d.batches || []
    intent.value = d.intent || {}
  } catch (e) {
    /* 已提示 */
  }
}
</script>
