<template>
  <div class="portal">
    <div class="pnav">
      <div class="brand"><div class="mark">助</div><span>受助申请端</span></div>
      <div class="navs">
        <a :class="{ on: tab === 'progress' }" href="javascript:;" @click="tab = 'progress'">申请进度</a>
        <a :class="{ on: tab === 'history' }" href="javascript:;" @click="tab = 'history'">历史领取</a>
      </div>
      <div class="right">
        <span>{{ user.realName || user.username }}</span>
        <button class="btn btn-sm" @click="$router.push('/dashboard')">管理台</button>
      </div>
    </div>

    <div class="pwrap">
      <div class="phead">
        <h1>我的受助申请</h1>
        <p>
          {{ current.receiverName || user.realName }} · {{ current.region || '—' }} ·
          需求审核通过后系统自动生成发放单，拣货完成即可到仓领取或等待配送。
        </p>
      </div>

      <div class="grid-2" style="margin-top: 14px">
        <div class="pcard">
          <div class="card-head">
            <h2>当前申请进度</h2>
            <span class="sub">{{ current.orderNo || '暂无进行中申请' }}</span>
          </div>
          <div class="summary-box" v-if="current.id">
            <div class="row"><span>发放单号</span><b>{{ current.orderNo }}</b></div>
            <div class="row"><span>领取方式</span><b>{{ current.deliverType }}</b></div>
            <div class="row"><span>物资合计</span><b>{{ fmtNum(current.totalQty) }}</b></div>
            <div class="row"><span>要求完成</span><b>{{ fmtTime(current.deadline) }}</b></div>
            <div class="row"><span>当前阶段</span><b>{{ current.stage }} · {{ current.status }}</b></div>
          </div>
          <div class="steps" style="margin-top: 18px">
            <div v-for="(s, i) in stages" :key="s" class="step" :class="stepCls(i)">
              <i>{{ i < curIndex ? '✓' : i + 1 }}</i>
              {{ s }}
            </div>
          </div>
          <div class="rule-note mt16">
            {{ tip }}
          </div>
        </div>

        <div class="pcard">
          <div class="card-head"><h2>历史领取</h2><span class="sub">近 3 次</span></div>
          <div class="timeline">
            <div v-for="(o, i) in history" :key="o.id" class="tl-item done">
              <div class="tl-t">
                {{ fmtDate(o.finishTime || o.createTime) }}　{{ o.deliverType }}
                <span class="tag tag-success">{{ o.status }}</span>
              </div>
              <div class="tl-m">发放单 {{ o.orderNo }} · 物资合计 {{ o.totalQty }} 件 · {{ o.region }}</div>
            </div>
            <div v-if="history.length === 0" class="empty">暂无历史领取记录</div>
          </div>
          <div class="rule-note mt12">
            同一年度领取次数建议不超过 6 次；30 天内重复申请会在审核环节被提示。
          </div>
        </div>
      </div>

      <div class="pcard" style="margin-top: 14px">
        <div class="card-head">
          <h2>我的申请记录</h2>
          <span class="sub">共 {{ list.length }} 条</span>
        </div>
        <div class="table-wrap">
          <table class="table tight">
            <thead>
              <tr>
                <th>发放单号</th>
                <th>区域</th>
                <th>领取方式</th>
                <th class="num">物资合计</th>
                <th>阶段</th>
                <th>状态</th>
                <th>创建时间</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="o in list" :key="o.id">
                <td class="mono">{{ o.orderNo }}</td>
                <td>{{ o.region }}</td>
                <td>{{ o.deliverType }}</td>
                <td class="num">{{ o.totalQty }}</td>
                <td><span class="tag tag-sub">{{ o.stage }}</span></td>
                <td><span class="tag" :class="tagClass(o.status)">{{ o.status }}</span></td>
                <td>{{ fmtTime(o.createTime) }}</td>
              </tr>
              <tr v-if="list.length === 0"><td colspan="7"><div class="empty">暂无申请记录</div></td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { pageDistribution } from '../api'
import { userStore } from '../store/user'
import { fmtDate, fmtNum, fmtTime, tagClass } from '../utils/dict'

const user = computed(() => userStore.user || {})
const tab = ref('progress')
const list = ref([])
const stages = ['提交申请', '资格审核', '拣货出库', '领取签收', '提交反馈']

const current = computed(() => list.value.find((o) => o.status !== '已完成') || list.value[0] || {})
const history = computed(() => list.value.filter((o) => o.status === '已完成').slice(0, 3))

const STAGE_MAP = { 需求审核: 1, 分配出库: 2, 签收回执: 3, 追踪归档: 4 }
const curIndex = computed(() => (current.value.stage ? (STAGE_MAP[current.value.stage] ?? 0) : 0))

const tip = computed(() => {
  const s = current.value
  if (!s.id) return '当前没有进行中的申请。'
  if (s.status === '已完成') return '本次发放已完成，欢迎提交使用反馈帮助捐赠人了解物资去向。'
  if (s.stage === '签收回执') return '物资已拣货完成，请按发放要求到指定仓库领取并签收，如不便前往可联系网格员改为配送。'
  if (s.stage === '追踪归档') return '已签收，等待归档。归档后本次申领结束。'
  if (s.stage === '分配出库') return '仓库正在拣货出库，按先到期先出库原则分配批次。'
  return '申请已进入资格审核，将结合反重校验与紧迫度评分确定分配顺序。'
})

function stepCls(i) {
  if (current.value.status === '已完成') return 'done'
  if (i < curIndex.value) return 'done'
  if (i === curIndex.value) return 'cur'
  return ''
}

onMounted(async () => {
  try {
    const d = await pageDistribution({ page: 1, size: 10 })
    list.value = d?.list || []
  } catch (e) {
    list.value = []
  }
})
</script>
