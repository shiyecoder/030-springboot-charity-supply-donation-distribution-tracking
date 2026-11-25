<template>
  <div>
    <PageHead title="签收与反馈" sub="受助人签收确认与使用反馈，含敏感信息命中标记与公开可见控制">
      <template #actions>
        <button class="btn" @click="$router.push('/distribution-list')">发放单跟踪</button>
        <button class="btn btn-primary" @click="$router.push('/report')">公开报表</button>
      </template>
    </PageHead>

    <div class="card">
      <ListPage ref="listRef" :cfg="cfg">
        <template #ops="{ row }">
          <span class="link-op" @click="openDetail(row)">详情</span>
          <span v-if="row.auditStatus === '待审核'" class="link-op" @click="openAudit(row)">审核</span>
        </template>
      </ListPage>
    </div>

    <el-drawer v-model="drawer" title="反馈详情" size="520px">
      <div class="summary-box">
        <div class="row"><span>反馈编号</span><b>{{ cur.feedbackNo }}</b></div>
        <div class="row"><span>提交人</span><b>{{ cur.submitter }}（{{ cur.submitterType }}）</b></div>
        <div class="row"><span>反馈类型</span><b>{{ cur.feedbackType }}</b></div>
        <div class="row"><span>所属区域</span><b>{{ cur.region }}</b></div>
        <div class="row"><span>公开可见</span><b>{{ cur.publicFlag ? '是' : '否' }}</b></div>
        <div class="row"><span>敏感命中</span><b>{{ cur.sensitiveHit || '无' }}</b></div>
        <div class="row"><span>审核状态</span><b>{{ cur.auditStatus }}</b></div>
        <div class="row" v-if="cur.auditOpinion"><span>审核意见</span><b>{{ cur.auditOpinion }}</b></div>
      </div>
      <div class="card-head"><h2>反馈内容</h2></div>
      <div class="rule-note">{{ cur.content }}</div>
      <div class="card-head" style="margin-top: 16px"><h2>现场照片</h2></div>
      <div class="upload-boxes">
        <div v-for="(p, i) in photos" :key="i" class="upload-box filled">
          <img :src="p" alt="" />
        </div>
        <div v-if="photos.length === 0" class="small muted">暂无照片</div>
      </div>
    </el-drawer>

    <el-dialog v-model="auditDialog" title="反馈审核" width="520px">
      <div class="form-grid">
        <div class="form-item full">
          <label>审核结论</label>
          <select v-model="af.result" class="select">
            <option value="已通过">通过（可公开）</option>
            <option value="已驳回">驳回</option>
          </select>
        </div>
        <div class="form-item full">
          <label>审核意见</label>
          <textarea v-model="af.opinion" class="textarea" placeholder="填写审核意见"></textarea>
        </div>
      </div>
      <template #footer>
        <button class="btn" @click="auditDialog = false">取消</button>
        <button class="btn btn-primary" @click="submitAudit">提交</button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import ListPage from '../components/ListPage.vue'
import { auditFeedback, pageFeedback } from '../api'
import { REGION } from '../utils/dict'

const listRef = ref(null)
const drawer = ref(false)
const auditDialog = ref(false)
const cur = ref({})
const af = reactive({ result: '已通过', opinion: '' })

const photos = computed(() => {
  const p = cur.value.photos
  if (!p) return []
  return String(p)
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean)
})

const cfg = {
  api: pageFeedback,
  pageSize: 10,
  filters: [
    { key: 'keyword', label: '关键字', ph: '反馈编号 / 提交人', w: 'w-md' },
    { key: 'feedbackType', label: '类型', type: 'select', options: ['收到确认', '使用反馈', '问题反馈'] },
    { key: 'auditStatus', label: '审核状态', type: 'select', options: ['待审核', '已通过', '已驳回'] },
    { key: 'region', label: '区域', type: 'select', options: REGION }
  ],
  columns: [
    { key: 'feedbackNo', type: 'mono', label: '反馈编号', width: '150px' },
    { key: 'submitter', type: 'two', label: '提交人', main: 'submitter', sub: 'submitterType', width: '140px' },
    { key: 'feedbackType', type: 'tag', label: '类型', width: '96px' },
    { key: 'content', label: '反馈内容', width: '260px' },
    { key: 'publicFlag', label: '公开', width: '70px', format: (v) => (v ? '是' : '否') },
    { key: 'auditStatus', type: 'tag', label: '审核', width: '88px' },
    { key: 'region', label: '区域', width: '100px' },
    { key: 'createTime', type: 'time', label: '提交时间', width: '140px' }
  ]
}

function openDetail(row) {
  cur.value = row
  drawer.value = true
}

function openAudit(row) {
  cur.value = row
  af.result = '已通过'
  af.opinion = ''
  auditDialog.value = true
}

async function submitAudit() {
  try {
    await auditFeedback(cur.value.id, { result: af.result, opinion: af.opinion })
    ElMessage.success('审核完成')
    auditDialog.value = false
    listRef.value?.load()
  } catch (e) {
    /* 已提示 */
  }
}
</script>
