<template>
  <div>
    <PageHead title="评分明细与快照" sub="六因素加权过程、输入快照与人工调整记录，可追溯到规则版本">
      <template #actions>
        <button class="btn" @click="$router.push('/rule-config')">规则配置</button>
        <button class="btn btn-primary" @click="openEvaluate">计算评分</button>
      </template>
    </PageHead>

    <div class="grid-32">
      <div class="card mb0">
        <div class="card-head">
          <h2>评分记录</h2>
          <span class="sub">共 {{ scores.length }} 条</span>
          <div class="actions">
            <button class="btn btn-sm" @click="load">刷新</button>
          </div>
        </div>
        <div class="table-wrap">
          <table class="table tight">
            <thead>
              <tr>
                <th>评分编号</th>
                <th>申请</th>
                <th class="num">总分</th>
                <th>等级</th>
                <th>规则版本</th>
                <th>计算时间</th>
                <th>人工调整</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="s in scores"
                :key="s.id"
                :class="{ 'row-on': cur.id === s.id }"
                style="cursor: pointer"
                @click="select(s)"
              >
                <td class="mono">{{ s.scoreNo }}</td>
                <td>{{ appNo(s.applicationId) }}</td>
                <td class="num">{{ s.totalScore }}</td>
                <td><span class="score-lv" :class="scoreClass(s.resultLevel)">{{ s.resultLevel }}</span></td>
                <td>{{ s.ruleVersion }}</td>
                <td>{{ fmtTime(s.calcTime) }}</td>
                <td>{{ s.adjustFlag ? '已调整' : '—' }}</td>
              </tr>
              <tr v-if="scores.length === 0"><td colspan="7"><div class="empty">暂无评分记录</div></td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card mb0">
        <div class="card-head"><h2>评分详情</h2><span class="sub">{{ cur.scoreNo || '未选择' }}</span></div>
        <template v-if="cur.id">
          <div class="score-head">
            <div class="score-num">{{ cur.totalScore }}<small>分</small></div>
            <div>
              <div class="score-lv" :class="scoreClass(cur.resultLevel)">{{ cur.resultLevel }}</div>
              <div class="small muted mt8">规则 {{ cur.ruleVersion }} · {{ fmtTime(cur.calcTime) }}</div>
            </div>
          </div>
          <div v-for="f in factors" :key="f.name" class="factor">
            <span class="fn">{{ f.name }}</span>
            <span class="fw">{{ f.weight }}%</span>
            <span class="ft"><span class="ff" :style="{ width: Math.min(100, f.rate * 100) + '%' }"></span></span>
            <span class="fv">{{ f.raw }}</span>
            <span class="fs">{{ f.score }}</span>
          </div>
          <div class="rule-note mt12">{{ cur.suggestion }}</div>

          <div class="card-head" style="margin-top: 16px"><h2>输入快照</h2><span class="sub">评分时的原始数据</span></div>
          <pre class="snap">{{ pretty(cur.snapshotJson) }}</pre>

          <div class="card-head" style="margin-top: 16px"><h2>人工调整</h2></div>
          <div v-if="cur.adjustFlag" class="summary-box">
            <div class="row"><span>调整理由</span><b>{{ cur.adjustReason }}</b></div>
            <div class="row"><span>调整时间</span><b>{{ fmtTime(cur.adjustTime) }}</b></div>
          </div>
          <div class="flex gap8">
            <button class="btn" @click="openAdjust">人工调整等级</button>
          </div>
          <div class="rule-note mt12">
            调整只覆盖建议等级与说明，原评分与快照保留；调整率作为规则优化依据。
          </div>
        </template>
        <div v-else class="empty"><b>请选择左侧评分记录</b>查看六因素计算过程</div>
      </div>
    </div>

    <el-dialog v-model="evalDialog" title="计算紧迫度评分" width="520px">
      <div class="form-grid">
        <div class="form-item full">
          <label>受助申请</label>
          <select v-model="evalForm.applicationId" class="select">
            <option v-for="a in applications" :key="a.id" :value="a.id">{{ a.applyNo }} · {{ a.applicantName }}</option>
          </select>
        </div>
      </div>
      <div class="rule-note mt8">将按当前启用规则计算并保存快照，规则版本随快照一并留痕。</div>
      <template #footer>
        <button class="btn" @click="evalDialog = false">取消</button>
        <button class="btn btn-primary" :disabled="evaluating" @click="doEvaluate">{{ evaluating ? '计算中…' : '开始计算' }}</button>
      </template>
    </el-dialog>

    <el-dialog v-model="adjustDialog" title="人工调整评分等级" width="520px">
      <div class="form-grid">
        <div class="form-item full">
          <label>调整后等级</label>
          <select v-model="adjustForm.level" class="select">
            <option value="优先分配">优先分配</option>
            <option value="常规分配">常规分配</option>
            <option value="暂缓分配">暂缓分配</option>
            <option value="不推荐">不推荐</option>
          </select>
        </div>
        <div class="form-item full">
          <label>调整理由（不少于 5 个字）</label>
          <textarea v-model="adjustForm.reason" class="textarea"></textarea>
        </div>
      </div>
      <template #footer>
        <button class="btn" @click="adjustDialog = false">取消</button>
        <button class="btn btn-primary" @click="doAdjust">提交调整</button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import { adjustScore, evaluateScore, listScore, pageApplication } from '../api'
import { fmtTime, scoreClass } from '../utils/dict'

const scores = ref([])
const applications = ref([])
const cur = ref({})
const evalDialog = ref(false)
const adjustDialog = ref(false)
const evaluating = ref(false)
const evalForm = reactive({ applicationId: null })
const adjustForm = reactive({ level: '常规分配', reason: '' })

const factors = computed(() => {
  try {
    const fj = typeof cur.value.factorJson === 'string' ? JSON.parse(cur.value.factorJson) : cur.value.factorJson
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

function pretty(t) {
  try {
    return JSON.stringify(typeof t === 'string' ? JSON.parse(t) : t, null, 2)
  } catch (e) {
    return String(t || '-')
  }
}

function appNo(id) {
  const a = applications.value.find((x) => x.id === id)
  return a ? a.applyNo : '#' + id
}

async function load() {
  try {
    const apps = await pageApplication({ page: 1, size: 50 })
    applications.value = apps?.list || []
    scores.value = (await listScore({})) || []
    if (scores.value.length && !cur.value.id) select(scores.value[0])
  } catch (e) {
    scores.value = []
  }
}

function select(s) {
  cur.value = s
}

async function openEvaluate() {
  try {
    const d = await pageApplication({ page: 1, size: 50 })
    applications.value = d?.list || []
    if (!evalForm.applicationId && applications.value.length) evalForm.applicationId = applications.value[0].id
    evalDialog.value = true
  } catch (e) {
    /* 已提示 */
  }
}

async function doEvaluate() {
  if (!evalForm.applicationId) {
    ElMessage.warning('请选择受助申请')
    return
  }
  evaluating.value = true
  try {
    const s = await evaluateScore({ applicationId: evalForm.applicationId })
    ElMessage.success('评分完成：' + s.totalScore + ' 分 / ' + s.resultLevel)
    evalDialog.value = false
    await load()
    cur.value = s
  } catch (e) {
    /* 已提示 */
  } finally {
    evaluating.value = false
  }
}

function openAdjust() {
  adjustForm.level = cur.value.resultLevel || '常规分配'
  adjustForm.reason = ''
  adjustDialog.value = true
}

async function doAdjust() {
  if ((adjustForm.reason || '').trim().length < 5) {
    ElMessage.warning('请填写不少于 5 个字的调整理由')
    return
  }
  try {
    await adjustScore(cur.value.id, {
      level: adjustForm.level,
      suggestion: '人工调整为「' + adjustForm.level + '」',
      reason: adjustForm.reason
    })
    ElMessage.success('已调整，原评分快照保留')
    adjustDialog.value = false
    await load()
  } catch (e) {
    /* 已提示 */
  }
}

onMounted(load)
</script>

<style scoped>
.snap {
  background: #f7f9fa;
  border: 1px solid var(--line);
  border-radius: 5px;
  padding: 10px 12px;
  font-size: 11px;
  line-height: 1.7;
  color: var(--text-2);
  max-height: 190px;
  overflow: auto;
  white-space: pre-wrap;
  word-break: break-all;
}
.row-on {
  background: #eef4f7;
}
</style>
