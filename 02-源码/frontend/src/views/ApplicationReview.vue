<template>
  <div>
    <PageHead title="资格与反重审核" sub="反重校验 4 项 + 六因素紧迫度评分，审核通过后自动生成发放单">
      <template #actions>
        <button class="btn" @click="loadList">刷新待审列表</button>
        <button class="btn btn-primary" @click="$router.push('/rule-config')">规则配置</button>
      </template>
    </PageHead>

    <div class="grid-23">
      <div class="card" style="padding: 14px">
        <div class="card-head" style="margin-bottom: 10px">
          <h2>待审核队列</h2>
          <span class="sub">{{ list.length }} 单</span>
        </div>
        <div
          v-for="a in list"
          :key="a.id"
          class="queue-item"
          :class="{ on: cur.id === a.id }"
          @click="select(a)"
        >
          <div class="q-top">
            <span class="mono">{{ a.applyNo }}</span>
            <span class="tag" :class="tagClass(a.urgencyLevel)">{{ a.urgencyLevel }}</span>
          </div>
          <div class="q-mid">{{ a.applicantName }} · {{ a.region }} · {{ a.familySize }} 人</div>
          <div class="q-bot">{{ a.purpose }}</div>
        </div>
        <div v-if="list.length === 0" class="empty"><b>当前没有待审核申请</b>可切换到其他状态查看</div>
      </div>

      <div>
        <div class="detail-hero" v-if="app.id">
          <div>
            <div class="code">{{ app.applyNo }}</div>
            <div class="meta">
              <div>申请人<b>{{ app.applicantName }}</b></div>
              <div>区域<b>{{ app.region }}</b></div>
              <div>家庭人数<b>{{ app.familySize }} 人</b></div>
              <div>紧迫度<b>{{ app.urgencyLevel }}</b></div>
              <div>领取方式<b>{{ app.distributeType }}</b></div>
            </div>
          </div>
          <div class="actions">
            <span class="tag" :class="tagClass(app.status)">{{ app.status }}</span>
          </div>
        </div>

        <div v-if="!app.id" class="card">
          <div class="empty"><b>请选择左侧待审核申请</b>查看反重校验与评分结果</div>
        </div>

        <template v-else>
          <div class="grid-2">
            <div class="card mb0">
              <div class="card-head"><h2>反重校验</h2><span class="sub">自动计算，不通过需人工判断</span></div>
              <div v-for="c in checks" :key="c.name" class="check-row">
                <span class="tag" :class="c.pass ? 'tag-success' : 'tag-danger'">{{ c.pass ? '通过' : '不通过' }}</span>
                <div>
                  <div class="ck-name">{{ c.name }}</div>
                  <div class="ck-desc">{{ c.rule }}</div>
                  <div class="ck-res">{{ c.result }}</div>
                </div>
              </div>
              <div v-if="checks.length === 0" class="empty">暂无校验结果</div>
            </div>

            <div class="card mb0">
              <div class="card-head">
                <h2>紧迫度评分</h2>
                <div class="actions">
                  <button class="btn btn-sm" :disabled="scoring" @click="doScore">
                    {{ scoring ? '计算中…' : '计算评分' }}
                  </button>
                </div>
              </div>
              <div v-if="score.id">
                <div class="score-head">
                  <div class="score-num">{{ score.totalScore }}<small>分</small></div>
                  <div>
                    <div class="score-lv" :class="scoreClass(score.resultLevel)">{{ score.resultLevel }}</div>
                    <div class="small muted mt8">规则 {{ score.ruleVersion }} · {{ fmtTime(score.calcTime) }}</div>
                  </div>
                </div>
                <div v-for="f in factors" :key="f.name" class="factor">
                  <span class="fn">{{ f.name }}</span>
                  <span class="fw">{{ f.weight }}%</span>
                  <span class="ft"><span class="ff" :style="{ width: Math.min(100, f.rate * 100) + '%' }"></span></span>
                  <span class="fv">{{ f.raw }}</span>
                  <span class="fs">{{ f.score }}</span>
                </div>
                <div class="rule-note mt12">{{ score.suggestion }}</div>
              </div>
              <div v-else class="empty"><b>尚未计算评分</b>点击右上角「计算评分」生成快照</div>
            </div>
          </div>

          <div class="card mt12">
            <div class="card-head">
              <h2>申领物资明细</h2>
              <span class="sub">可调整批准数量，调整需填写原因</span>
            </div>
            <div class="table-wrap">
              <table class="table tight">
                <thead>
                  <tr>
                    <th>物资</th>
                    <th>规格</th>
                    <th class="num">申请数量</th>
                    <th class="num">批准数量</th>
                    <th>备注</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="it in items" :key="it.id">
                    <td>{{ it.materialName }}</td>
                    <td>{{ it.spec }}</td>
                    <td class="num">{{ fmtNum(it.applyQty, it.unit) }}</td>
                    <td class="num">
                      <input v-model.number="it.approveQty" type="number" class="input" style="width: 84px; height: 26px" />
                    </td>
                    <td class="muted small">{{ it.remark || '-' }}</td>
                  </tr>
                  <tr v-if="items.length === 0"><td colspan="5"><div class="empty">该申请没有物资明细</div></td></tr>
                </tbody>
              </table>
            </div>

            <div class="form-grid mt16">
              <div class="form-item full">
                <label>审核意见</label>
                <textarea v-model="opinion" class="textarea" placeholder="填写审核意见；如调整了批准数量或退回，必须不少于 5 个字"></textarea>
              </div>
            </div>

            <div class="flex gap8 mt12" style="justify-content: flex-end">
              <button class="btn" :disabled="saving" @click="submit('approve')">批准并生成发放单</button>
              <button class="btn btn-danger" :disabled="saving" @click="submit('reject')">不符合资格退回</button>
            </div>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import { evaluateScore, getApplication, pageApplication, reviewApplication } from '../api'
import { fmtNum, fmtTime, scoreClass, tagClass } from '../utils/dict'

const route = useRoute()
const list = ref([])
const app = ref({})
const items = ref([])
const checks = ref([])
const score = ref({})
const opinion = ref('')
const saving = ref(false)
const scoring = ref(false)
const cur = ref({})

const factors = computed(() => {
  try {
    const fj = typeof score.value.factorJson === 'string' ? JSON.parse(score.value.factorJson) : score.value.factorJson
    if (!fj) return []
    return Object.keys(fj).map((k) => {
      const o = fj[k]
      return {
        name: o.name || k,
        weight: o.weight ?? 0,
        raw: o.raw ?? o.value ?? '-',
        score: o.score ?? o.point ?? '-',
        rate: o.rate ?? (typeof o.ratio === 'number' ? o.ratio : (o.score || 0) / 100)
      }
    })
  } catch (e) {
    return []
  }
})

async function loadList() {
  try {
    const d = await pageApplication({ page: 1, size: 20, status: '待审核' })
    list.value = d?.list || []
    const qid = route.query.id ? Number(route.query.id) : null
    if (qid) {
      const hit = list.value.find((x) => x.id === qid)
      if (hit) return select(hit)
    }
    if (list.value.length) select(list.value[0])
  } catch (e) {
    /* 已提示 */
  }
}

async function select(row) {
  cur.value = row
  opinion.value = ''
  score.value = {}
  try {
    const d = await getApplication(row.id)
    app.value = d.application || {}
    items.value = (d.items || []).map((i) => ({ ...i, approveQty: i.approveQty ?? i.applyQty }))
    checks.value = d.checks || []
  } catch (e) {
    /* 已提示 */
  }
}

async function doScore() {
  scoring.value = true
  try {
    const s = await evaluateScore({ applicationId: app.value.id })
    score.value = s || {}
    ElMessage.success('评分完成：' + (s.totalScore ?? '') + ' 分 / ' + (s.resultLevel || ''))
  } catch (e) {
    /* 已提示 */
  } finally {
    scoring.value = false
  }
}

async function submit(kind) {
  if (kind === 'reject' && (opinion.value || '').trim().length < 5) {
    ElMessage.warning('退回必须填写不少于 5 个字的原因')
    return
  }
  saving.value = true
  try {
    const body = {
      result: kind === 'reject' ? '不符合资格' : '批准',
      items: items.value.map((i) => ({ materialName: i.materialName, approveQty: Number(i.approveQty || 0) })),
      opinion: opinion.value,
      reason: opinion.value
    }
    const r = await reviewApplication(app.value.id, body)
    ElMessage.success(kind === 'reject' ? '已退回' : '已批准，发放单号：' + (r?.orderNo || '已生成'))
    app.value = {}
    items.value = []
    checks.value = []
    score.value = {}
    await loadList()
  } catch (e) {
    /* 已提示 */
  } finally {
    saving.value = false
  }
}

onMounted(loadList)
</script>

<style scoped>
.queue-item {
  border: 1px solid var(--line);
  border-radius: 6px;
  padding: 10px 12px;
  cursor: pointer;
  margin-bottom: 8px;
}
.queue-item:hover {
  border-color: var(--sub);
  background: #fafbfc;
}
.queue-item.on {
  border-color: var(--sub);
  background: #eef4f7;
  box-shadow: inset 2px 0 0 var(--sub);
}
.q-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.q-mid {
  font-size: 12.5px;
  margin-top: 6px;
}
.q-bot {
  font-size: 11.5px;
  color: var(--text-3);
  margin-top: 4px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.check-row {
  display: flex;
  gap: 10px;
  padding: 9px 0;
  border-bottom: 1px solid #f2f5f7;
}
.check-row:last-child {
  border-bottom: none;
}
.ck-name {
  font-size: 12.5px;
  font-weight: 600;
}
.ck-desc {
  font-size: 11px;
  color: var(--text-3);
  margin-top: 2px;
}
.ck-res {
  font-size: 11.5px;
  color: var(--text-2);
  margin-top: 3px;
}
</style>
