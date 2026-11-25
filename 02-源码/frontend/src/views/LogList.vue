<template>
  <div>
    <PageHead title="操作日志" sub="关键业务动作全量留痕：模块、动作、状态迁移、操作人与结果">
      <template #actions>
        <button class="btn" @click="load">刷新</button>
      </template>
    </PageHead>

    <div class="card">
      <div class="filter-bar">
        <div class="filter-item">
          <label>关键字</label>
          <input v-model="q.keyword" class="input w-md" placeholder="业务单号 / 操作人" @keyup.enter="search" />
        </div>
        <div class="filter-item">
          <label>模块</label>
          <select v-model="q.module" class="select" @change="search">
            <option value="">全部</option>
            <option v-for="m in modules" :key="m" :value="m">{{ m }}</option>
          </select>
        </div>
        <button class="btn btn-primary" @click="search">查询</button>
        <button class="btn" @click="reset">重置</button>
        <div class="spacer"></div>
        <span class="small muted">共 {{ total }} 条</span>
      </div>

      <div class="table-wrap">
        <table class="table tight">
          <thead>
            <tr>
              <th>时间</th>
              <th>操作人</th>
              <th>角色</th>
              <th>模块</th>
              <th>动作</th>
              <th>业务单号</th>
              <th>状态迁移</th>
              <th>IP</th>
              <th>结果</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="l in rows" :key="l.id">
              <td>{{ fmtTime(l.operateTime) }}</td>
              <td>{{ l.userName }}</td>
              <td class="small muted">{{ l.roleCode }}</td>
              <td>{{ l.module }}</td>
              <td>{{ l.action }}</td>
              <td class="mono">{{ l.bizNo || '—' }}</td>
              <td class="small">
                <span v-if="l.fromStatus">{{ l.fromStatus }} → {{ l.toStatus }}</span>
                <span v-else class="muted">—</span>
              </td>
              <td class="small muted">{{ l.ip }}</td>
              <td><span class="tag" :class="tagClass(l.result)">{{ l.result }}</span></td>
            </tr>
            <tr v-if="rows.length === 0"><td colspan="9"><div class="empty">暂无日志</div></td></tr>
          </tbody>
        </table>
      </div>

      <div class="pager">
        <button class="pg" :disabled="page <= 1" @click="go(page - 1)">上一页</button>
        <span class="pg on">{{ page }}</span>
        <button class="pg" :disabled="page >= pageCount" @click="go(page + 1)">下一页</button>
        <span class="muted">共 {{ total }} 条 / {{ pageCount }} 页</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import PageHead from '../components/PageHead.vue'
import { pageLog } from '../api'
import { fmtTime, tagClass } from '../utils/dict'

const rows = ref([])
const total = ref(0)
const page = ref(1)
const size = 15
const q = reactive({ keyword: '', module: '' })
const modules = ['捐赠意向', '收货验收', '物资批次', '受助申请', '发放单', '反馈', '规则', '系统']

const pageCount = computed(() => Math.max(1, Math.ceil(total.value / size)))

async function load() {
  try {
    const d = await pageLog({ page: page.value, size, ...q })
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

function reset() {
  q.keyword = ''
  q.module = ''
  search()
}

function go(p) {
  if (p < 1 || p > pageCount.value) return
  page.value = p
  load()
}

onMounted(load)
</script>
