<template>
  <div class="portal">
    <div class="pnav">
      <div class="brand"><div class="mark">慈</div><span>公益物资捐赠与发放追踪系统</span></div>
      <div class="navs">
        <a class="on" href="javascript:;">捐赠项目</a>
        <a href="javascript:;" @click="tab = 'mine'">我的捐赠</a>
        <a href="javascript:;" @click="tab = 'report'">公开报表</a>
      </div>
      <div class="right">
        <span>{{ user.realName || user.username }}</span>
        <button class="btn btn-sm" @click="$router.push('/dashboard')">进入管理台</button>
      </div>
    </div>

    <div class="pwrap">
      <div class="phero">
        <div>
          <h2>让每一件物资都抵达需要它的人</h2>
          <p>登记捐赠意向、跟踪项目募集进度、查看物资发放去向。所有公开数据按姓名与手机号脱敏展示。</p>
        </div>
        <div class="stats">
          <div><b>{{ stats.projectCount }}</b><span>在运项目</span></div>
          <div><b>{{ stats.stockTotal }}</b><span>在库物资</span></div>
          <div><b>{{ stats.regionPersons }}</b><span>受助人数</span></div>
        </div>
      </div>

      <div class="phead" style="margin-top: 24px" v-if="tab === 'projects'">
        <h1>正在募集的捐赠项目</h1>
        <p>按服务对象分类，点击「我要捐赠」登记意向，仓库预审通过后即可送达。</p>
      </div>

      <div class="tile-grid" v-if="tab === 'projects'" style="margin-top: 14px">
        <div v-for="p in projects" :key="p.id" class="tile">
          <div class="cover">
            <img :src="p.coverImage" :alt="p.title" />
            <span class="tag tag-info">{{ p.category }}</span>
          </div>
          <div class="bd">
            <h3>{{ p.title }}</h3>
            <div class="m"><span>{{ p.serviceTarget }}</span><span>截止 {{ fmtDate(p.deadline) }}</span></div>
            <div class="progress"><div class="fill" :style="{ width: pct(p.receivedQty, p.targetQty) + '%' }"></div></div>
            <div class="m" style="margin-top: 6px">
              <span>已收 {{ fmtNum(p.receivedQty) }} / {{ fmtNum(p.targetQty) }} {{ p.unit }}</span>
              <span>{{ pct(p.receivedQty, p.targetQty) }}%</span>
            </div>
            <button class="btn btn-primary mt12" style="width: 100%; justify-content: center" @click="donate(p)">我要捐赠</button>
          </div>
        </div>
        <div v-if="projects.length === 0" class="empty">暂无在运项目</div>
      </div>

      <template v-if="tab === 'mine'">
        <div class="phead" style="margin-top: 8px">
          <h1>我的捐赠意向</h1>
          <p>预审通过后请按预约时间送达仓库，仓库验收合格即生成入库批次。</p>
        </div>
        <div class="pcard" style="margin-top: 14px">
          <div class="table-wrap">
            <table class="table tight">
              <thead>
                <tr>
                  <th>意向编号</th>
                  <th>物资</th>
                  <th class="num">数量</th>
                  <th>交付方式</th>
                  <th>预约时间</th>
                  <th>状态</th>
                  <th>预审意见</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="i in intents" :key="i.id">
                  <td class="mono">{{ i.intentNo }}</td>
                  <td>{{ i.materialName }} · {{ i.spec }}</td>
                  <td class="num">{{ fmtNum(i.estQty, i.unit) }}</td>
                  <td>{{ i.deliveryType }}</td>
                  <td>{{ fmtTime(i.appointTime) }}</td>
                  <td><span class="tag" :class="tagClass(i.status)">{{ i.status }}</span></td>
                  <td class="small muted">{{ i.precheckOpinion || i.rejectReason || '—' }}</td>
                </tr>
                <tr v-if="intents.length === 0"><td colspan="7"><div class="empty">还没有提交过捐赠意向</div></td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </template>

      <template v-if="tab === 'report'">
        <div class="phead" style="margin-top: 8px">
          <h1>公开报表</h1>
          <p>展示物资发放去向与区域覆盖，受助人姓名与手机号均已脱敏。</p>
        </div>
        <div class="grid-2" style="margin-top: 14px">
          <div class="pcard">
            <div class="card-head"><h2>区域受助覆盖</h2></div>
            <div class="hbars">
              <div v-for="r in report.regionRank || []" :key="r.name" class="hbar">
                <span class="nm">{{ r.name }}</span>
                <span class="track"><span class="fill" :style="{ width: Math.min(100, r.cnt * 18) + '%' }"></span></span>
                <span class="vl">{{ r.cnt }}</span>
              </div>
            </div>
          </div>
          <div class="pcard">
            <div class="card-head"><h2>最近发放</h2></div>
            <div class="table-wrap">
              <table class="table tight">
                <thead><tr><th>区域</th><th>物资</th><th class="num">数量</th><th>受助人</th></tr></thead>
                <tbody>
                  <tr v-for="r in (report.records || []).slice(0, 6)" :key="r.orderNo + r.material">
                    <td>{{ r.region }}</td>
                    <td>{{ r.material }}</td>
                    <td class="num">{{ r.qty }}</td>
                    <td>{{ r.person }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </template>
    </div>

    <el-dialog v-model="dialog" title="登记捐赠意向" width="560px">
      <div class="form-grid">
        <div class="form-item">
          <label>物资名称</label>
          <input v-model="form.materialName" class="input" />
        </div>
        <div class="form-item">
          <label>规格</label>
          <input v-model="form.spec" class="input" />
        </div>
        <div class="form-item">
          <label>预估数量</label>
          <input v-model.number="form.estQty" type="number" class="input" />
        </div>
        <div class="form-item">
          <label>交付方式</label>
          <select v-model="form.deliveryType" class="select">
            <option v-for="x in DELIVERY" :key="x" :value="x">{{ x }}</option>
          </select>
        </div>
        <div class="form-item">
          <label>预约送达时间</label>
          <input v-model="form.appointTime" type="datetime-local" class="input" />
        </div>
        <div class="form-item">
          <label>联系电话</label>
          <input v-model="form.contactPhone" class="input" />
        </div>
      </div>
      <template #footer>
        <button class="btn" @click="dialog = false">取消</button>
        <button class="btn btn-primary" @click="submitDonate">提交意向</button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { createIntent, getDashboard, getPublicReport, pageIntent, pageProject } from '../api'
import { userStore } from '../store/user'
import { DELIVERY, fmtDate, fmtNum, fmtTime, tagClass } from '../utils/dict'

const user = computed(() => userStore.user || {})
const tab = ref('projects')
const projects = ref([])
const intents = ref([])
const report = ref({})
const stats = ref({})
const dialog = ref(false)
const form = reactive({ projectId: null, deliveryType: DELIVERY[0], estQty: 50, category: '米面粮油', unit: '件' })

function pct(a, b) {
  const t = Number(b || 0)
  return t ? Math.min(100, Math.round((Number(a || 0) / t) * 100)) : 0
}

function donate(p) {
  form.projectId = p.id
  form.materialName = p.category
  form.spec = ''
  form.category = p.category
  form.unit = p.unit
  dialog.value = true
}

async function submitDonate() {
  if (!form.materialName) {
    ElMessage.warning('请填写物资名称')
    return
  }
  try {
    await createIntent({ ...form, appointTime: form.appointTime ? form.appointTime.replace('T', ' ') + ':00' : null })
    ElMessage.success('意向已提交，等待仓库预审')
    dialog.value = false
    await loadMine()
    tab.value = 'mine'
  } catch (e) {
    /* 已提示 */
  }
}

async function loadMine() {
  try {
    const d = await pageIntent({ page: 1, size: 20 })
    intents.value = d?.list || []
  } catch (e) {
    intents.value = []
  }
}

onMounted(async () => {
  try {
    const p = await pageProject({ page: 1, size: 9, status: '进行中' })
    projects.value = p?.list || []
    stats.value = (await getDashboard()) || {}
    report.value = (await getPublicReport()) || {}
    await loadMine()
  } catch (e) {
    /* 已提示 */
  }
})
</script>
