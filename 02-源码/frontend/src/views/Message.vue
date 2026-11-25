<template>
  <div>
    <PageHead title="消息通知" sub="业务流转自动推送：预审结果、验收完成、审核结论、发放提醒">
      <template #actions>
        <button class="btn" @click="readAll">全部标为已读</button>
        <button class="btn btn-primary" @click="load">刷新</button>
      </template>
    </PageHead>

    <div class="card">
      <div class="filter-bar">
        <div class="filter-item">
          <label>类型</label>
          <select v-model="q.msgType" class="select" @change="search">
            <option value="">全部</option>
            <option v-for="t in types" :key="t" :value="t">{{ t }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>阅读状态</label>
          <select v-model="q.readFlag" class="select" @change="search">
            <option value="">全部</option>
            <option :value="0">未读</option>
            <option :value="1">已读</option>
          </select>
        </div>
        <div class="spacer"></div>
        <span class="small muted">共 {{ total }} 条</span>
      </div>

      <div class="msg-list">
        <div v-for="m in rows" :key="m.id" class="msg-item" :class="{ unread: !m.readFlag }" @click="open(m)">
          <div class="m-dot"></div>
          <div class="m-body">
            <div class="m-top">
              <b>{{ m.title }}</b>
              <span class="tag tag-sub">{{ m.msgType }}</span>
              <span class="m-time">{{ fmtTime(m.createTime) }}</span>
            </div>
            <div class="m-content">{{ m.content }}</div>
            <div class="m-biz" v-if="m.bizNo">
              关联单据：<span class="mono">{{ m.bizNo }}</span>
              <span v-if="m.bizUrl" class="link-op" style="margin-left: 10px" @click.stop="goBiz(m)">查看</span>
            </div>
          </div>
        </div>
        <div v-if="rows.length === 0" class="empty"><b>暂无消息</b>业务流转后会自动推送</div>
      </div>

      <div class="pager">
        <button class="pg" :disabled="page <= 1" @click="go(page - 1)">上一页</button>
        <span class="pg on">{{ page }}</span>
        <button class="pg" :disabled="page >= pageCount" @click="go(page + 1)">下一页</button>
        <span class="muted">共 {{ total }} 条</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import { pageMessage, readAllMessage, readMessage } from '../api'
import { fmtTime } from '../utils/dict'

const router = useRouter()
const rows = ref([])
const total = ref(0)
const page = ref(1)
const size = 10
const q = reactive({ msgType: '', readFlag: '' })
const types = ['预审通过', '已退回', '验收完成', '发放提醒', '审核结果', '系统']

const pageCount = computed(() => Math.max(1, Math.ceil(total.value / size)))

async function load() {
  try {
    const params = { page: page.value, size }
    if (q.msgType) params.msgType = q.msgType
    if (q.readFlag !== '') params.readFlag = q.readFlag
    const d = await pageMessage(params)
    rows.value = d?.list || []
    total.value = d?.total || 0
  } catch (e) {
    rows.value = []
    total.value = 0
  }
}

function search() {
  page.value = 1
  load()
}

async function open(m) {
  if (!m.readFlag) {
    try {
      await readMessage(m.id)
      m.readFlag = 1
    } catch (e) {
      /* 已提示 */
    }
  }
  if (m.bizUrl) goBiz(m)
}

function goBiz(m) {
  const url = m.bizUrl.startsWith('/') ? m.bizUrl : '/' + m.bizUrl
  router.push(url)
}

async function readAll() {
  try {
    await readAllMessage()
    ElMessage.success('已全部标为已读')
    await load()
  } catch (e) {
    /* 已提示 */
  }
}

function go(p) {
  if (p < 1 || p > pageCount.value) return
  page.value = p
  load()
}

onMounted(load)
</script>

<style scoped>
.msg-list {
  border-top: 1px solid var(--line);
}
.msg-item {
  display: flex;
  gap: 10px;
  padding: 13px 4px;
  border-bottom: 1px solid #eef2f5;
  cursor: pointer;
}
.msg-item:hover {
  background: #fafbfc;
}
.m-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  margin-top: 7px;
  background: transparent;
  flex: 0 0 6px;
}
.msg-item.unread .m-dot {
  background: var(--danger);
}
.m-body {
  flex: 1;
}
.m-top {
  display: flex;
  align-items: center;
  gap: 9px;
}
.m-top b {
  font-size: 13px;
  font-weight: 600;
}
.m-time {
  margin-left: auto;
  font-size: 11px;
  color: var(--text-3);
}
.m-content {
  font-size: 12.5px;
  color: var(--text-2);
  margin-top: 5px;
  line-height: 1.7;
}
.m-biz {
  font-size: 11.5px;
  color: var(--text-3);
  margin-top: 6px;
}
.msg-item.unread .m-top b {
  color: var(--primary);
}
</style>
