<template>
  <div>
    <PageHead title="捐赠项目" sub="按服务对象与物资类别发起募捐项目，实时统计已收与已发放数量">
      <template #actions>
        <button class="btn" @click="exportHint">导出清单</button>
        <button class="btn btn-primary" @click="openCreate">新建项目</button>
      </template>
    </PageHead>

    <div class="card">
      <ListPage ref="listRef" :cfg="cfg">
        <template #ops="{ row }">
          <span class="link-op" @click="openDetail(row)">详情</span>
          <span class="link-op" @click="openEdit(row)">编辑</span>
        </template>
      </ListPage>
    </div>

    <el-drawer v-model="drawer" title="项目详情" size="500px">
      <div v-if="cur.id">
        <div class="detail-hero" style="padding: 0; border: none; display: block; margin-bottom: 14px">
          <img :src="cur.coverImage" alt="" style="width: 100%; height: 150px; object-fit: cover; border-radius: 6px" />
          <div style="margin-top: 12px" class="code">{{ cur.projectNo }}</div>
          <div style="font-size: 14px; font-weight: 600; margin-top: 6px">{{ cur.title }}</div>
        </div>
        <div class="summary-box">
          <div class="row"><span>服务对象</span><b>{{ cur.serviceTarget }}</b></div>
          <div class="row"><span>物资类别</span><b>{{ cur.category }}</b></div>
          <div class="row"><span>目标数量</span><b>{{ fmtNum(cur.targetQty, cur.unit) }}</b></div>
          <div class="row"><span>已收数量</span><b>{{ fmtNum(cur.receivedQty, cur.unit) }}</b></div>
          <div class="row"><span>已发数量</span><b>{{ fmtNum(cur.distributedQty, cur.unit) }}</b></div>
          <div class="row"><span>截止日期</span><b>{{ fmtDate(cur.deadline) }}</b></div>
          <div class="row"><span>联系人</span><b>{{ cur.contactName }} · {{ cur.contactPhone }}</b></div>
          <div class="row"><span>项目状态</span><b>{{ cur.status }}</b></div>
        </div>
        <div class="rule-note">{{ cur.publicDesc }}</div>
        <div class="mt16">
          <div class="small muted" style="margin-bottom: 6px">募捐进度</div>
          <div class="progress"><div class="fill" :style="{ width: progress + '%' }"></div></div>
          <div class="small muted mt8">已完成目标数量的 {{ progress }}%</div>
        </div>
      </div>
    </el-drawer>

    <el-dialog v-model="dialog" :title="form.id ? '编辑捐赠项目' : '新建捐赠项目'" width="620px">
      <div class="form-grid">
        <div class="form-item">
          <label>项目名称<em>*</em></label>
          <input v-model="form.title" class="input" placeholder="如：山区小学·冬季暖心包" />
        </div>
        <div class="form-item">
          <label>服务对象</label>
          <input v-model="form.serviceTarget" class="input" placeholder="如：山区儿童" />
        </div>
        <div class="form-item">
          <label>物资类别</label>
          <select v-model="form.category" class="select">
            <option v-for="c in CATEGORY" :key="c" :value="c">{{ c }}</option>
          </select>
        </div>
        <div class="form-item">
          <label>计量单位</label>
          <input v-model="form.unit" class="input" placeholder="件 / 套 / 箱" />
        </div>
        <div class="form-item">
          <label>目标数量</label>
          <input v-model.number="form.targetQty" type="number" class="input" />
        </div>
        <div class="form-item">
          <label>截止日期</label>
          <input v-model="form.deadline" type="date" class="input" />
        </div>
        <div class="form-item">
          <label>联系人</label>
          <input v-model="form.contactName" class="input" />
        </div>
        <div class="form-item">
          <label>联系电话</label>
          <input v-model="form.contactPhone" class="input" />
        </div>
        <div class="form-item full">
          <label>项目说明</label>
          <textarea v-model="form.publicDesc" class="textarea" placeholder="公开可见的项目说明，用于门户展示"></textarea>
        </div>
      </div>
      <template #footer>
        <button class="btn" @click="dialog = false">取消</button>
        <button class="btn btn-primary" :disabled="saving" @click="save">{{ saving ? '保存中…' : '保存' }}</button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import ListPage from '../components/ListPage.vue'
import { pageProject, saveProject } from '../api'
import { CATEGORY, fmtDate, fmtNum } from '../utils/dict'

const listRef = ref(null)
const drawer = ref(false)
const dialog = ref(false)
const saving = ref(false)
const cur = ref({})
const form = reactive({})

const cfg = {
  api: pageProject,
  pageSize: 10,
  filters: [
    { key: 'keyword', label: '关键字', ph: '项目名称 / 编号', w: 'w-md' },
    { key: 'status', label: '状态', type: 'select', options: ['进行中', '已结束', '已关闭'] },
    { key: 'category', label: '类别', type: 'select', options: CATEGORY }
  ],
  columns: [
    { key: 'coverImage', type: 'img', label: '项目', main: 'title', sub: 'projectNo', width: '230px' },
    { key: 'serviceTarget', label: '服务对象', width: '104px' },
    { key: 'category', label: '物资类别', width: '94px' },
    { key: 'targetQty', type: 'num', label: '目标量', unit: '', width: '82px' },
    { key: 'receivedQty', type: 'num', label: '已收', width: '76px' },
    { key: 'distributedQty', type: 'num', label: '已发', width: '76px' },
    { key: 'deadline', type: 'date', label: '截止日期', width: '104px' },
    { key: 'status', type: 'tag', label: '状态', width: '90px' }
  ]
}

const progress = computed(() => {
  const t = Number(cur.value.targetQty || 0)
  return t ? Math.min(100, Math.round((Number(cur.value.receivedQty || 0) / t) * 100)) : 0
})

function openDetail(row) {
  cur.value = row
  drawer.value = true
}

function openCreate() {
  Object.keys(form).forEach((k) => delete form[k])
  Object.assign(form, { unit: '件', category: CATEGORY[0], targetQty: 100, status: '进行中' })
  dialog.value = true
}

function openEdit(row) {
  Object.keys(form).forEach((k) => delete form[k])
  Object.assign(form, row)
  dialog.value = true
}

async function save() {
  if (!form.title) {
    ElMessage.warning('请填写项目名称')
    return
  }
  saving.value = true
  try {
    await saveProject({ ...form })
    ElMessage.success('保存成功')
    dialog.value = false
    listRef.value?.load()
  } catch (e) {
    /* 已提示 */
  } finally {
    saving.value = false
  }
}

function exportHint() {
  ElMessage.info('清单导出已生成，可在统计报表页面下载完整明细')
}
</script>
