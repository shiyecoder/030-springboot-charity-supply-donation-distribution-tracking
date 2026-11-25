<template>
  <div>
    <PageHead title="拣货发放" sub="按先到期先出库（FEFO）推荐批次，拣货时条件扣减可用量，杜绝超发">
      <template #actions>
        <button class="btn" @click="$router.push('/batch-list')">批次台账</button>
        <button class="btn btn-primary" @click="$router.push('/distribution-list')">发放单跟踪</button>
      </template>
    </PageHead>

    <div class="card">
      <div class="card-head">
        <h2>待拣货发放单（分配出库阶段）</h2>
        <span class="sub">共 {{ rows.length }} 单待处理</span>
        <div class="actions">
          <button class="btn btn-sm" @click="load">刷新</button>
        </div>
      </div>
      <div class="table-wrap">
        <table class="table tight">
          <thead>
            <tr>
              <th>发放单号</th>
              <th>受助人</th>
              <th>区域</th>
              <th>领取方式</th>
              <th class="num">物资合计</th>
              <th>阶段</th>
              <th>状态</th>
              <th style="width: 110px">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="o in rows" :key="o.id">
              <td class="mono">{{ o.orderNo }}</td>
              <td>{{ o.receiverName }}</td>
              <td>{{ o.region }}</td>
              <td>{{ o.deliverType }}</td>
              <td class="num">{{ fmtNum(o.totalQty) }}</td>
              <td><span class="tag tag-sub">{{ o.stage }}</span></td>
              <td><span class="tag" :class="tagClass(o.status)">{{ o.status }}</span></td>
              <td><span class="link-op" @click="openPick(o)">拣货</span></td>
            </tr>
            <tr v-if="rows.length === 0"><td colspan="8"><div class="empty">当前没有待拣货的发放单</div></td></tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="card">
      <div class="card-head"><h2>拣货作业指引</h2><span class="sub">系统按保质期升序推荐，可手工改选批次</span></div>
      <div class="grid-3">
        <div class="rule-note">
          <b>1. 先到期先出库</b><br />推荐列表按有效期升序排列，锁定与过期批次不参与推荐。
        </div>
        <div class="rule-note">
          <b>2. 条件扣减防超发</b><br />扣减时校验可用量，扣减失败立即回滚并提示剩余数量。
        </div>
        <div class="rule-note">
          <b>3. 批次留痕</b><br />拣货明细记录批次号与拣货时间，签收后进入追踪归档。
        </div>
      </div>
    </div>

    <el-drawer v-model="drawer" title="拣货作业" size="640px">
      <div class="summary-box">
        <div class="row"><span>发放单号</span><b>{{ cur.orderNo }}</b></div>
        <div class="row"><span>受助人</span><b>{{ cur.receiverName }} · {{ cur.region }}</b></div>
        <div class="row"><span>领取方式</span><b>{{ cur.deliverType }}</b></div>
        <div class="row"><span>物资合计</span><b>{{ fmtNum(cur.totalQty) }}</b></div>
      </div>

      <div class="card-head"><h2>拣货明细</h2><span class="sub">默认取推荐批次与计划数量</span></div>
      <div class="table-wrap">
        <table class="table tight">
          <thead>
            <tr>
              <th>物资</th>
              <th>计划数量</th>
              <th>推荐批次</th>
              <th>可用量</th>
              <th>保质期至</th>
              <th>本次拣货</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(p, i) in picks" :key="i">
              <td>{{ p.materialName }}</td>
              <td>{{ p.planQty }}</td>
              <td>
                <select v-model="p.batchId" class="select" style="min-width: 170px">
                  <option v-for="b in p.batches" :key="b.id" :value="b.id">
                    {{ b.batchNo }}（可用 {{ b.availableQty }}）
                  </option>
                </select>
              </td>
              <td>{{ currentBatch(p)?.availableQty ?? '-' }}</td>
              <td>{{ fmtDate(currentBatch(p)?.expireDate) }}</td>
              <td>
                <input v-model.number="p.qty" type="number" class="input" style="width: 76px; height: 26px" />
              </td>
            </tr>
            <tr v-if="picks.length === 0"><td colspan="6"><div class="empty">该发放单没有待拣明细</div></td></tr>
          </tbody>
        </table>
      </div>
      <div class="rule-note mt12">
        拣货提交后发放单进入「签收回执」阶段；若可用量不足，系统会拒绝本次拣货并提示剩余数量。
      </div>
      <template #footer>
        <button class="btn" @click="drawer = false">取消</button>
        <button class="btn btn-primary" :disabled="saving" @click="submit">{{ saving ? '提交中…' : '确认拣货' }}</button>
      </template>
    </el-drawer>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import { getDistribution, pageDistribution, pickDistribution } from '../api'
import { fmtDate, fmtNum, tagClass } from '../utils/dict'

const rows = ref([])
const drawer = ref(false)
const cur = ref({})
const picks = ref([])
const saving = ref(false)

function currentBatch(p) {
  return (p.batches || []).find((b) => b.id === p.batchId)
}

async function load() {
  try {
    const d = await pageDistribution({ page: 1, size: 30, stage: '分配出库' })
    rows.value = d?.list || []
  } catch (e) {
    rows.value = []
  }
}

async function openPick(o) {
  cur.value = o
  picks.value = []
  drawer.value = true
  try {
    const d = await getDistribution(o.id)
    cur.value = d.order || o
    const rec = d.recommend || []
    picks.value = rec.map((r) => ({
      materialName: r.materialName,
      planQty: r.planQty,
      batches: r.batches || [],
      batchId: (r.batches || [])[0]?.id,
      qty: r.planQty
    }))
  } catch (e) {
    /* 已提示 */
  }
}

async function submit() {
  const list = picks.value.filter((p) => p.batchId && Number(p.qty) > 0)
  if (list.length === 0) {
    ElMessage.warning('请至少选择一条拣货明细')
    return
  }
  saving.value = true
  try {
    await pickDistribution(cur.value.id, {
      picks: list.map((p) => ({ batchId: p.batchId, materialName: p.materialName, qty: Number(p.qty) }))
    })
    ElMessage.success('拣货完成，发放单已进入签收回执')
    drawer.value = false
    await load()
  } catch (e) {
    /* 已提示（超发等） */
  } finally {
    saving.value = false
  }
}

load()
</script>
