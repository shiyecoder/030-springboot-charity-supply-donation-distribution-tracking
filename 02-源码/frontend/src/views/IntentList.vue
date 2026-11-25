<template>
  <div>
    <PageHead title="捐赠意向" sub="捐赠人与单位提交的物资意向，需预审通过后才可送达仓库验收">
      <template #actions>
        <button class="btn" @click="$router.push('/demand-list')">查看物资需求</button>
        <button class="btn btn-primary" @click="openCreate">登记捐赠意向</button>
      </template>
    </PageHead>

    <div class="card">
      <ListPage ref="listRef" :cfg="cfg">
        <template #ops="{ row }">
          <span v-if="row.status === '待预审'" class="link-op" @click="openPrecheck(row)">预审</span>
          <span class="link-op" @click="openDetail(row)">详情</span>
        </template>
      </ListPage>
    </div>

    <el-drawer v-model="drawer" title="意向详情" size="480px">
      <div class="summary-box">
        <div class="row"><span>意向编号</span><b>{{ cur.intentNo }}</b></div>
        <div class="row"><span>捐赠人</span><b>{{ cur.donorName }}（{{ cur.donorType }}）</b></div>
        <div class="row"><span>物资</span><b>{{ cur.materialName }} · {{ cur.spec }}</b></div>
        <div class="row"><span>数量</span><b>{{ fmtNum(cur.estQty, cur.unit) }}</b></div>
        <div class="row"><span>质量等级</span><b>{{ cur.qualityLevel }}</b></div>
        <div class="row"><span>交付方式</span><b>{{ cur.deliveryType }}</b></div>
        <div class="row"><span>预约时间</span><b>{{ fmtTime(cur.appointTime) }}</b></div>
        <div class="row"><span>联系电话</span><b>{{ maskPhone(cur.contactPhone) }}</b></div>
        <div class="row"><span>当前状态</span><b>{{ cur.status }}</b></div>
        <div class="row" v-if="cur.position"><span>存放位置</span><b>{{ cur.position }}</b></div>
      </div>
      <div class="card-head"><h2>流转记录</h2><span class="sub">按时间顺序</span></div>
      <div class="timeline">
        <div v-for="(r, i) in records" :key="i" class="tl-item" :class="i === records.length - 1 ? 'cur' : 'done'">
          <div class="tl-t">{{ r.action }}<span class="tag tag-sub">{{ r.toStatus }}</span></div>
          <div class="tl-m">{{ fmtTime(r.operateTime) }} · {{ r.operatorName }}</div>
          <div v-if="r.reason" class="tl-c">{{ r.reason }}</div>
        </div>
        <div v-if="records.length === 0" class="empty">暂无流转记录</div>
      </div>
    </el-drawer>

    <el-dialog v-model="preDialog" title="捐赠意向预审" width="540px">
      <div class="summary-box">
        <div class="row"><span>意向编号</span><b>{{ cur.intentNo }}</b></div>
        <div class="row"><span>物资</span><b>{{ cur.materialName }} · {{ fmtNum(cur.estQty, cur.unit) }}</b></div>
        <div class="row"><span>捐赠人</span><b>{{ cur.donorName }}</b></div>
      </div>
      <div class="form-grid">
        <div class="form-item full">
          <label>预审结论<em>*</em></label>
          <select v-model="pf.result" class="select">
            <option value="接收">接收</option>
            <option value="部分接收">部分接收</option>
            <option value="不接收">不接收</option>
          </select>
        </div>
        <div class="form-item full" v-if="pf.result !== '不接收'">
          <label>建议存放位置</label>
          <input v-model="pf.position" class="input" placeholder="如：A 区 3 号货架" />
        </div>
        <div class="form-item full">
          <label>{{ pf.result === '不接收' ? '拒收理由（不少于 5 字）' : '预审意见' }}</label>
          <textarea v-model="pf.opinion" class="textarea" placeholder="填写预审说明"></textarea>
        </div>
      </div>
      <template #footer>
        <button class="btn" @click="preDialog = false">取消</button>
        <button class="btn btn-primary" :disabled="saving" @click="submitPrecheck">{{ saving ? '提交中…' : '提交预审' }}</button>
      </template>
    </el-dialog>

    <el-dialog v-model="createDialog" title="登记捐赠意向" width="620px">
      <div class="form-grid">
        <div class="form-item">
          <label>物资名称<em>*</em></label>
          <input v-model="form.materialName" class="input" placeholder="如：棉被" />
        </div>
        <div class="form-item">
          <label>物资类别</label>
          <select v-model="form.category" class="select">
            <option v-for="c in CATEGORY" :key="c" :value="c">{{ c }}</option>
          </select>
        </div>
        <div class="form-item">
          <label>规格</label>
          <input v-model="form.spec" class="input" placeholder="如：1.5m×2m" />
        </div>
        <div class="form-item">
          <label>预估数量</label>
          <input v-model.number="form.estQty" type="number" class="input" />
        </div>
        <div class="form-item">
          <label>质量等级</label>
          <select v-model="form.qualityLevel" class="select">
            <option value="全新">全新</option>
            <option value="九成新">九成新</option>
            <option value="八成新">八成新</option>
          </select>
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
        <button class="btn" @click="createDialog = false">取消</button>
        <button class="btn btn-primary" @click="submitCreate">提交意向</button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import ListPage from '../components/ListPage.vue'
import { createIntent, getIntent, pageIntent, precheckIntent } from '../api'
import { CATEGORY, DELIVERY, fmtNum, fmtTime, maskPhone } from '../utils/dict'

const listRef = ref(null)
const drawer = ref(false)
const preDialog = ref(false)
const createDialog = ref(false)
const saving = ref(false)
const cur = ref({})
const records = ref([])
const form = reactive({ category: CATEGORY[0], deliveryType: DELIVERY[0], estQty: 50, qualityLevel: '全新' })
const pf = reactive({ result: '接收', position: '', opinion: '' })

const cfg = {
  api: pageIntent,
  pageSize: 10,
  filters: [
    { key: 'keyword', label: '关键字', ph: '意向编号 / 捐赠人', w: 'w-md' },
    { key: 'status', label: '状态', type: 'select', options: ['待预审', '待送达', '待验收', '已入库', '部分接收', '已拒收'] },
    { key: 'deliveryType', label: '交付方式', type: 'select', options: DELIVERY }
  ],
  columns: [
    { key: 'intentNo', type: 'mono', label: '意向编号', width: '150px' },
    { key: 'donorName', type: 'two', label: '捐赠人', main: 'donorName', sub: 'donorType', width: '150px' },
    { key: 'materialName', type: 'two', label: '物资', main: 'materialName', sub: 'spec', width: '180px' },
    { key: 'estQty', type: 'num', label: '预估数量', width: '90px' },
    { key: 'qualityLevel', label: '质量', width: '80px' },
    { key: 'deliveryType', label: '交付方式', width: '100px' },
    { key: 'appointTime', type: 'time', label: '预约时间', width: '132px' },
    { key: 'status', type: 'tag', label: '状态', width: '90px' }
  ]
}

async function openDetail(row) {
  cur.value = row
  drawer.value = true
  records.value = []
  try {
    const d = await getIntent(row.id)
    cur.value = d.intent || row
    records.value = d.records || []
  } catch (e) {
    /* 已提示 */
  }
}

function openPrecheck(row) {
  cur.value = row
  pf.result = '接收'
  pf.position = ''
  pf.opinion = ''
  preDialog.value = true
}

async function submitPrecheck() {
  if (pf.result === '不接收' && (pf.opinion || '').trim().length < 5) {
    ElMessage.warning('不接收时必须填写不少于 5 个字的理由')
    return
  }
  saving.value = true
  try {
    await precheckIntent(cur.value.id, {
      result: pf.result,
      position: pf.position,
      opinion: pf.opinion,
      rejectReason: pf.result === '不接收' ? pf.opinion : ''
    })
    ElMessage.success('预审完成')
    preDialog.value = false
    listRef.value?.load()
  } catch (e) {
    /* 已提示 */
  } finally {
    saving.value = false
  }
}

function openCreate() {
  createDialog.value = true
}

async function submitCreate() {
  if (!form.materialName) {
    ElMessage.warning('请填写物资名称')
    return
  }
  try {
    await createIntent({ ...form, appointTime: form.appointTime ? form.appointTime.replace('T', ' ') + ':00' : null })
    ElMessage.success('意向已提交，等待预审')
    createDialog.value = false
    listRef.value?.load()
  } catch (e) {
    /* 已提示 */
  }
}
</script>
