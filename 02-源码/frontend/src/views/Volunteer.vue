<template>
  <div class="portal">
    <div class="pnav">
      <div class="brand"><div class="mark">仓</div><span>仓储志愿者工作台</span></div>
      <div class="navs">
        <a :class="{ on: tab === 'pending' }" href="javascript:;" @click="tab = 'pending'">今日待办</a>
        <a :class="{ on: tab === 'expire' }" href="javascript:;" @click="tab = 'expire'">临期批次</a>
        <a :class="{ on: tab === 'check' }" href="javascript:;" @click="tab = 'check'">盘点差异</a>
      </div>
      <div class="right">
        <span>{{ user.realName || user.username }}</span>
        <button class="btn btn-sm" @click="$router.push('/dashboard')">管理台</button>
      </div>
    </div>

    <div class="pwrap">
      <div class="phero">
        <div>
          <h2>收货、入库、拣货，一站完成</h2>
          <p>待验收意向与待拣货发放单汇总在此，拣货按先到期先出库推荐批次，扣减失败会明确提示剩余数量。</p>
        </div>
        <div class="stats">
          <div><b>{{ counts.pendingIntent }}</b><span>待验收意向</span></div>
          <div><b>{{ counts.pendingPick }}</b><span>待拣货发放单</span></div>
          <div><b>{{ counts.expiring }}</b><span>临期批次</span></div>
        </div>
      </div>

      <div class="grid-2" style="margin-top: 18px">
        <div class="pcard">
          <div class="card-head">
            <h2>待验收意向</h2>
            <span class="sub">已预审通过，等待送达</span>
            <div class="actions"><button class="btn btn-sm" @click="$router.push('/receiving')">去验收</button></div>
          </div>
          <div class="table-wrap">
            <table class="table tight">
              <thead><tr><th>意向编号</th><th>物资</th><th class="num">数量</th><th>预约时间</th><th>状态</th></tr></thead>
              <tbody>
                <tr v-for="i in intents" :key="i.id">
                  <td class="mono">{{ i.intentNo }}</td>
                  <td>{{ i.materialName }}</td>
                  <td class="num">{{ fmtNum(i.estQty, i.unit) }}</td>
                  <td>{{ fmtTime(i.appointTime) }}</td>
                  <td><span class="tag" :class="tagClass(i.status)">{{ i.status }}</span></td>
                </tr>
                <tr v-if="intents.length === 0"><td colspan="5"><div class="empty">暂无待验收意向</div></td></tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="pcard">
          <div class="card-head">
            <h2>待拣货发放单</h2>
            <span class="sub">按 FEFO 推荐批次</span>
            <div class="actions"><button class="btn btn-sm" @click="$router.push('/distribute')">去拣货</button></div>
          </div>
          <div class="table-wrap">
            <table class="table tight">
              <thead><tr><th>发放单号</th><th>区域</th><th class="num">合计</th><th>领取方式</th><th>阶段</th></tr></thead>
              <tbody>
                <tr v-for="o in orders" :key="o.id">
                  <td class="mono">{{ o.orderNo }}</td>
                  <td>{{ o.region }}</td>
                  <td class="num">{{ o.totalQty }}</td>
                  <td>{{ o.deliverType }}</td>
                  <td><span class="tag tag-sub">{{ o.stage }}</span></td>
                </tr>
                <tr v-if="orders.length === 0"><td colspan="5"><div class="empty">暂无待拣货发放单</div></td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <div class="pcard" style="margin-top: 14px">
        <div class="card-head">
          <h2>{{ tab === 'check' ? '盘点差异明细' : '临期与异常批次' }}</h2>
          <span class="sub">保质期 30 天内或已锁定</span>
          <div class="actions"><button class="btn btn-sm" @click="$router.push('/batch-list')">批次台账</button></div>
        </div>
        <div class="table-wrap">
          <table class="table tight">
            <thead>
              <tr>
                <th>批次号</th>
                <th>物资</th>
                <th>存放位置</th>
                <th class="num">可用量</th>
                <th>保质期至</th>
                <th>状态</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="b in batches" :key="b.id">
                <td class="mono">{{ b.batchNo }}</td>
                <td>{{ b.materialName }}</td>
                <td>{{ b.position }}</td>
                <td class="num">{{ b.availableQty }}</td>
                <td>{{ fmtDate(b.expireDate) }}</td>
                <td><span class="tag" :class="tagClass(b.status)">{{ b.status }}</span></td>
              </tr>
              <tr v-if="batches.length === 0"><td colspan="6"><div class="empty">暂无临期批次</div></td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { pageBatch, pageDistribution, pageIntent } from '../api'
import { userStore } from '../store/user'
import { fmtDate, fmtNum, fmtTime, tagClass } from '../utils/dict'

const user = computed(() => userStore.user || {})
const tab = ref('pending')
const intents = ref([])
const orders = ref([])
const batches = ref([])
const counts = ref({ pendingIntent: 0, pendingPick: 0, expiring: 0 })

onMounted(async () => {
  try {
    const i = await pageIntent({ page: 1, size: 8, status: '待送达' })
    intents.value = i?.list || []
    counts.value.pendingIntent = i?.total || 0

    const o = await pageDistribution({ page: 1, size: 8, stage: '分配出库' })
    orders.value = o?.list || []
    counts.value.pendingPick = o?.total || 0

    const b = await pageBatch({ page: 1, size: 10, expireScope: '临期' })
    batches.value = b?.list || []
    counts.value.expiring = b?.total || 0
  } catch (e) {
    /* 已提示 */
  }
})
</script>
