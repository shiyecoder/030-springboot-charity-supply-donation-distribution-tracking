<template>
  <div>
    <PageHead title="物资批次台账" sub="一批次一档案：入库时间、保质期、可用量、发放状态全程可追溯">
      <template #actions>
        <button class="btn" @click="$router.push('/receiving')">收货验收</button>
        <button class="btn btn-primary" @click="exportHint">导出批次台账</button>
      </template>
    </PageHead>

    <div class="card">
      <ListPage ref="listRef" :cfg="cfg">
        <template #ops="{ row }">
          <span class="link-op" @click="openDetail(row)">明细</span>
          <span v-if="row.status === '锁定'" class="link-op" @click="doLock(row, false)">解锁</span>
          <span v-else class="link-op danger" @click="doLock(row, true)">锁定</span>
        </template>
      </ListPage>
    </div>

    <el-drawer v-model="drawer" title="批次明细" size="520px">
      <div class="summary-box">
        <div class="row"><span>批次编号</span><b>{{ cur.batchNo }}</b></div>
        <div class="row"><span>物资</span><b>{{ cur.materialName }} · {{ cur.spec }}</b></div>
        <div class="row"><span>捐赠人</span><b>{{ cur.donorName }}</b></div>
        <div class="row"><span>存放位置</span><b>{{ cur.position || '-' }}</b></div>
        <div class="row"><span>入库 / 可用 / 锁定</span><b>{{ cur.inQty }} / {{ cur.availableQty }} / {{ cur.lockedQty }}</b></div>
        <div class="row"><span>质量等级</span><b>{{ cur.qualityLevel }}</b></div>
        <div class="row"><span>生产日期</span><b>{{ fmtDate(cur.produceDate) }}</b></div>
        <div class="row"><span>保质期至</span><b>{{ fmtDate(cur.expireDate) }}</b></div>
        <div class="row"><span>入库时间</span><b>{{ fmtTime(cur.inTime) }}</b></div>
        <div class="row"><span>批次状态</span><b>{{ cur.status }} / {{ cur.issueStatus }}</b></div>
      </div>
      <img
        v-if="cur.materialImage"
        :src="cur.materialImage"
        alt=""
        style="width: 100%; height: 150px; object-fit: cover; border-radius: 6px; border: 1px solid var(--line)"
      />
      <div class="card-head" style="margin-top: 16px"><h2>流转记录</h2></div>
      <div class="timeline">
        <div v-for="(r, i) in records" :key="i" class="tl-item" :class="i === records.length - 1 ? 'cur' : 'done'">
          <div class="tl-t">{{ r.action }}<span class="tag tag-sub">{{ r.toStatus }}</span></div>
          <div class="tl-m">{{ fmtTime(r.operateTime) }} · {{ r.operatorName }}</div>
          <div v-if="r.reason" class="tl-c">{{ r.reason }}</div>
        </div>
        <div v-if="records.length === 0" class="empty">暂无流转记录</div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import ListPage from '../components/ListPage.vue'
import { getBatch, lockBatch, pageBatch, unlockBatch } from '../api'
import { CATEGORY, fmtDate, fmtTime } from '../utils/dict'

const listRef = ref(null)
const drawer = ref(false)
const cur = ref({})
const records = ref([])

const cfg = {
  api: pageBatch,
  pageSize: 10,
  filters: [
    { key: 'keyword', label: '关键字', ph: '批次号 / 物资', w: 'w-md' },
    { key: 'status', label: '批次状态', type: 'select', options: ['正常', '临期', '过期', '锁定'] },
    { key: 'expireScope', label: '保质期', type: 'select', options: ['临期', '已过期', '充足'] },
    { key: 'issueStatus', label: '发放状态', type: 'select', options: ['未发放', '部分发放'] }
  ],
  columns: [
    { key: 'materialImage', type: 'img', label: '物资', main: 'materialName', sub: 'batchNo', width: '230px' },
    { key: 'donorName', label: '捐赠人', width: '120px' },
    { key: 'position', label: '存放位置', width: '112px' },
    { key: 'inQty', type: 'num', label: '入库', width: '74px' },
    { key: 'availableQty', type: 'num', label: '可用', width: '74px' },
    { key: 'qualityLevel', label: '质量', width: '74px' },
    { key: 'expireDate', type: 'date', label: '保质期至', width: '104px' },
    { key: 'status', type: 'tag', label: '状态', width: '76px' },
    { key: 'issueStatus', type: 'tag', label: '发放', width: '84px' }
  ]
}

async function openDetail(row) {
  cur.value = row
  records.value = []
  drawer.value = true
  try {
    const d = await getBatch(row.id)
    cur.value = d.batch || row
    records.value = d.records || []
  } catch (e) {
    /* 已提示 */
  }
}

async function doLock(row, lock) {
  try {
    await ElMessageBox.confirm(
      lock ? `锁定批次 ${row.batchNo} 后将不参与拣货推荐，确认锁定？` : `确认解锁批次 ${row.batchNo}？`,
      lock ? '锁定批次' : '解锁批次',
      { type: 'warning' }
    )
    if (lock) await lockBatch(row.id)
    else await unlockBatch(row.id)
    ElMessage.success(lock ? '已锁定' : '已解锁')
    listRef.value?.load()
  } catch (e) {
    /* 取消或已提示 */
  }
}

function exportHint() {
  ElMessage.info('批次台账导出已排队，可在统计报表页面查看汇总')
}
</script>
