<template>
  <div>
    <PageHead title="发放单详情" :sub="'单号 ' + (order.orderNo || '-')">
      <template #actions>
        <button class="btn" @click="$router.push('/distribution-list')">返回列表</button>
        <button class="btn btn-primary" @click="$router.push('/feedback-list')">签收反馈</button>
      </template>
    </PageHead>

    <div class="detail-hero">
      <div>
        <div class="code">{{ order.orderNo }}</div>
        <div class="meta">
          <div>受助人<b>{{ order.receiverName }}</b></div>
          <div>联系电话<b>{{ order.receiverPhone }}</b></div>
          <div>区域<b>{{ order.region }}</b></div>
          <div>领取方式<b>{{ order.deliverType }}</b></div>
          <div>物资合计<b>{{ fmtNum(order.totalQty) }}</b></div>
        </div>
      </div>
      <div class="actions">
        <span class="tag" :class="tagClass(order.status)">{{ order.status }}</span>
      </div>
    </div>

    <div class="card">
      <div class="card-head"><h2>流转进度</h2><span class="sub">{{ order.stage }}</span></div>
      <div class="steps">
        <div v-for="(s, i) in stageSteps" :key="s" class="step" :class="stepCls(i)">
          <i>{{ i + 1 }}</i>
          <span>{{ s }}</span>
        </div>
      </div>
    </div>

    <div class="grid-32" style="margin-top: 14px">
      <div class="card mb0">
        <div class="card-head"><h2>发放明细</h2><span class="sub">批次 — 物资 — 数量</span></div>
        <div class="table-wrap">
          <table class="table tight">
            <thead>
              <tr>
                <th>物资</th>
                <th>规格</th>
                <th class="num">计划数量</th>
                <th class="num">实发数量</th>
                <th>拣货时间</th>
                <th>备注</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="it in items" :key="it.id">
                <td>{{ it.materialName }}</td>
                <td>{{ it.spec }}</td>
                <td class="num">{{ it.planQty }}</td>
                <td class="num">{{ it.actualQty }}</td>
                <td>{{ fmtTime(it.pickTime) }}</td>
                <td class="muted small">{{ it.remark || '-' }}</td>
              </tr>
              <tr v-if="items.length === 0"><td colspan="6"><div class="empty">暂无发放明细</div></td></tr>
            </tbody>
          </table>
        </div>

        <div class="card-head" style="margin-top: 16px"><h2>操作</h2><span class="sub">按当前阶段可用</span></div>
        <div class="flex gap8">
          <button class="btn" :disabled="order.stage !== '签收回执'" @click="doAction('sign')">确认签收</button>
          <button class="btn" :disabled="order.stage !== '追踪归档'" @click="doAction('archive')">追踪归档</button>
          <button class="btn btn-danger" :disabled="order.status === '已完成'" @click="doCancel">作废发放单</button>
        </div>
        <div class="rule-note mt12">
          签收动作要求处于「签收回执」阶段，归档要求处于「追踪归档」阶段；状态越级会被后端拒绝并给出当前阶段提示。
        </div>
      </div>

      <div class="card mb0">
        <div class="card-head"><h2>流转记录</h2><span class="sub">{{ records.length }} 条</span></div>
        <div class="timeline">
          <div v-for="(r, i) in records" :key="i" class="tl-item" :class="i === records.length - 1 ? 'cur' : 'done'">
            <div class="tl-t">
              {{ r.action }}
              <span class="tag tag-sub">{{ r.fromStatus }} → {{ r.toStatus }}</span>
            </div>
            <div class="tl-m">{{ fmtTime(r.operateTime) }} · {{ r.operatorName }}</div>
            <div v-if="r.reason" class="tl-c">{{ r.reason }}</div>
          </div>
          <div v-if="records.length === 0" class="empty">暂无流转记录</div>
        </div>

        <div class="card-head" style="margin-top: 16px"><h2>关联申请</h2></div>
        <div class="dl">
          <dt>申请编号</dt><dd>{{ application.applyNo || '-' }}</dd>
          <dt>申请人</dt><dd>{{ application.applicantName || '-' }}</dd>
          <dt>家庭人数</dt><dd>{{ application.familySize || '-' }}</dd>
          <dt>紧迫度</dt><dd>{{ application.urgencyLevel || '-' }}</dd>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import { getDistribution, transitionDistribution } from '../api'
import { fmtNum, fmtTime, tagClass } from '../utils/dict'

const route = useRoute()
const order = ref({})
const items = ref([])
const records = ref([])
const application = ref({})

const STAGES = ['需求审核', '分配出库', '签收回执', '追踪归档']
const stageSteps = computed(() => STAGES)
const curIndex = computed(() => Math.max(0, STAGES.indexOf(order.value.stage)))
const isDone = computed(() => order.value.status === '已完成')

function stepCls(i) {
  if (isDone.value) return 'done'
  if (i < curIndex.value) return 'done'
  if (i === curIndex.value) return 'cur'
  return ''
}

async function load() {
  const id = route.query.id
  if (!id) return
  try {
    const d = await getDistribution(id)
    order.value = d.order || {}
    items.value = d.items || []
    records.value = d.records || []
    application.value = d.application || {}
  } catch (e) {
    /* 已提示 */
  }
}

async function doAction(action) {
  try {
    await transitionDistribution(order.value.id, { action })
    ElMessage.success(action === 'sign' ? '已签收，进入追踪归档' : '已归档，发放完成')
    await load()
  } catch (e) {
    /* 已提示 */
  }
}

async function doCancel() {
  try {
    const { value } = await ElMessageBox.prompt('请填写作废原因（不少于 5 个字）', '作废发放单', {
      inputPlaceholder: '如：受助人搬迁至其他区域，重新申请',
      inputValidator: (v) => (v && v.trim().length >= 5 ? true : '原因不少于 5 个字')
    })
    await transitionDistribution(order.value.id, { action: 'cancel', reason: value })
    ElMessage.success('已作废')
    await load()
  } catch (e) {
    /* 取消或已提示 */
  }
}

onMounted(load)
</script>
