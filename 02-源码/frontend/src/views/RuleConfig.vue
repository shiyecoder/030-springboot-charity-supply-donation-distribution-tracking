<template>
  <div>
    <PageHead title="紧迫度规则配置" sub="六因素加权评分规则：权重合计须为 100%，发布新版本后旧版本保留历史快照">
      <template #actions>
        <button class="btn" @click="$router.push('/score-detail')">查看评分明细</button>
        <button class="btn btn-primary" :disabled="saving" @click="publish">{{ saving ? '发布中…' : '发布新版本' }}</button>
      </template>
    </PageHead>

    <div class="grid-32">
      <div class="card mb0">
        <div class="card-head">
          <h2>当前规则</h2>
          <span class="sub">{{ rule.ruleNo }} · {{ rule.ruleVersion }} · 生效于 {{ fmtTime(rule.effectTime) }}</span>
        </div>
        <div class="score-head">
          <div>
            <div class="small muted">权重合计</div>
            <div class="score-num">{{ total }}<small>%</small></div>
          </div>
          <div>
            <span class="score-lv" :class="Math.abs(total - 100) < 0.01 ? 'high' : 'low'">
              {{ Math.abs(total - 100) < 0.01 ? '校验通过' : '权重合计不等于 100%' }}
            </span>
            <div class="small muted mt8">共 {{ factors.length }} 个因素</div>
          </div>
        </div>

        <div v-for="(f, i) in factors" :key="f.key" class="factor-row">
          <div class="fr-name">
            <b>{{ f.name }}</b>
            <span>{{ f.source }}</span>
          </div>
          <input v-model.number="f.weight" type="range" min="0" max="45" step="1" class="range" />
          <input v-model.number="f.weight" type="number" class="input" style="width: 70px; height: 28px" />
          <span class="small muted">%</span>
        </div>

        <div class="form-grid mt16">
          <div class="form-item full">
            <label>变更说明（不少于 5 个字）<em>*</em></label>
            <textarea v-model="changeNote" class="textarea" placeholder="如：提高紧迫等级权重至 30%，压低库存权重"></textarea>
          </div>
        </div>
        <div class="rule-note mt8">
          发布后将生成新版本规则，历史版本的评分快照不受影响；已生成的评分不会被重算。
        </div>
      </div>

      <div class="card mb0">
        <div class="card-head"><h2>评分等级阈值</h2></div>
        <div class="summary-box" style="margin-bottom: 12px">
          <div class="row"><span>优先分配</span><b>≥ {{ threshold.A || 80 }} 分</b></div>
          <div class="row"><span>常规分配</span><b>≥ {{ threshold.B || 60 }} 分</b></div>
          <div class="row"><span>暂缓分配</span><b>≥ {{ threshold.C || 40 }} 分</b></div>
          <div class="row"><span>不推荐</span><b>&lt; {{ threshold.C || 40 }} 分</b></div>
        </div>
        <div class="card-head" style="margin-top: 8px"><h2>版本历史</h2><span class="sub">{{ history.length }} 个版本</span></div>
        <div class="timeline">
          <div v-for="(h, i) in history" :key="h.id" class="tl-item" :class="i === 0 ? 'cur' : 'done'">
            <div class="tl-t">
              {{ h.ruleVersion }}
              <span class="tag" :class="h.status === '启用' ? 'tag-success' : 'tag-gray'">{{ h.status }}</span>
            </div>
            <div class="tl-m">{{ fmtTime(h.effectTime) }} · 权重合计 {{ h.weightTotal }}%</div>
            <div v-if="h.changeNote" class="tl-c">{{ h.changeNote }}</div>
          </div>
          <div v-if="history.length === 0" class="empty">暂无历史版本</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import { getCurrentRule, getRuleHistory, saveRule } from '../api'
import { fmtTime } from '../utils/dict'

const rule = ref({})
const factors = ref([])
const history = ref([])
const threshold = ref({})
const changeNote = ref('')
const saving = ref(false)

const total = computed(() => factors.value.reduce((s, f) => s + Number(f.weight || 0), 0))

function parse(text, fallback) {
  try {
    return text ? JSON.parse(text) : fallback
  } catch (e) {
    return fallback
  }
}

async function load() {
  try {
    const r = await getCurrentRule()
    rule.value = r || {}
    factors.value = parse(r?.factorJson, [])
    threshold.value = parse(r?.thresholdJson, {})
    history.value = (await getRuleHistory()) || []
  } catch (e) {
    /* 已提示 */
  }
}

async function publish() {
  if (factors.value.length !== 6) {
    ElMessage.warning('必须配置全部 6 个因素')
    return
  }
  if (Math.abs(total.value - 100) > 0.01) {
    ElMessage.warning('权重合计必须等于 100%，当前为 ' + total.value + '%')
    return
  }
  if ((changeNote.value || '').trim().length < 5) {
    ElMessage.warning('请填写不少于 5 个字的变更说明')
    return
  }
  saving.value = true
  try {
    await saveRule({
      factors: factors.value.map((f) => ({ key: f.key, name: f.name, weight: f.weight, source: f.source })),
      changeNote: changeNote.value
    })
    ElMessage.success('新版本已发布')
    changeNote.value = ''
    await load()
  } catch (e) {
    /* 已提示 */
  } finally {
    saving.value = false
  }
}

onMounted(load)
</script>

<style scoped>
.factor-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 9px 0;
  border-bottom: 1px solid #f2f5f7;
}
.factor-row:last-child {
  border-bottom: none;
}
.fr-name {
  width: 190px;
  flex: 0 0 190px;
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.fr-name b {
  font-size: 13px;
  font-weight: 600;
}
.fr-name span {
  font-size: 10.5px;
  color: var(--text-3);
}
.range {
  flex: 1;
  accent-color: #356a7a;
}
</style>
