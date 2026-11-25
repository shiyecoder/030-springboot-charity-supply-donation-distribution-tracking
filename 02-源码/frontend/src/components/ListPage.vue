<template>
  <div>
    <div class="filter-bar">
      <div v-for="f in cfg.filters || []" :key="f.key" class="filter-item">
        <label>{{ f.label }}</label>
        <select v-if="f.type === 'select'" v-model="query[f.key]" class="select" @change="search">
          <option value="">全部</option>
          <option v-for="o in optionsOf(f)" :key="o.value ?? o" :value="o.value ?? o">{{ o.label ?? o }}</option>
        </select>
        <input
          v-else
          v-model="query[f.key]"
          class="input"
          :class="f.w || 'w-sm'"
          :placeholder="f.ph || '请输入'"
          @keyup.enter="search"
        />
      </div>
      <button class="btn btn-primary" @click="search">查询</button>
      <button class="btn" @click="reset">重置</button>
      <div class="spacer"></div>
      <span class="small muted">共 {{ total }} 条</span>
    </div>

    <div class="table-wrap">
      <table class="table">
        <thead>
          <tr>
            <th v-for="c in cfg.columns" :key="c.key" :style="c.width ? { width: c.width } : null">{{ c.label }}</th>
            <th v-if="$slots.ops" style="width: 132px">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="row in rows" :key="row.id">
            <td v-for="c in cfg.columns" :key="c.key" :class="c.type === 'num' ? 'num' : ''">
              <span v-if="!c.type || c.type === 'text'">{{ display(row, c) }}</span>
              <span v-else-if="c.type === 'mono'" class="mono">{{ row[c.key] }}</span>
              <span v-else-if="c.type === 'num'">{{ fmtNum(row[c.key], c.unit) }}</span>
              <span v-else-if="c.type === 'tag'" class="tag" :class="tagClass(row[c.key])">{{ row[c.key] || '-' }}</span>
              <span v-else-if="c.type === 'date'">{{ fmtDate(row[c.key]) }}</span>
              <span v-else-if="c.type === 'time'">{{ fmtTime(row[c.key]) }}</span>
              <div v-else-if="c.type === 'img'" class="cell-main">
                <img class="thumb" :src="row[c.key]" :alt="row[c.main] || ''" />
                <div class="two-line">
                  <b>{{ row[c.main] }}</b>
                  <span>{{ row[c.sub] }}</span>
                </div>
              </div>
              <div v-else-if="c.type === 'two'" class="two-line">
                <b>{{ row[c.main] }}</b>
                <span>{{ row[c.sub] }}</span>
              </div>
              <div v-else-if="c.type === 'progress'" style="min-width: 96px">
                <div class="progress" style="margin-top: 0">
                  <div class="fill" :style="{ width: pct(row, c) + '%' }"></div>
                </div>
                <div class="small muted" style="margin-top: 3px">{{ pct(row, c) }}%</div>
              </div>
              <span v-else>{{ row[c.key] }}</span>
            </td>
            <td v-if="$slots.ops">
              <slot name="ops" :row="row" />
            </td>
          </tr>
          <tr v-if="!loading && rows.length === 0">
            <td :colspan="cfg.columns.length + 1">
              <div class="empty"><b>暂无数据</b>调整筛选条件后重新查询</div>
            </td>
          </tr>
          <tr v-if="loading">
            <td :colspan="cfg.columns.length + 1">
              <div class="empty">数据加载中…</div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="pager">
      <span class="total">
        <button class="pg" :disabled="page <= 1" @click="go(page - 1)">上一页</button>
        <button
          v-for="p in pages"
          :key="p"
          class="pg"
          :class="{ on: p === page }"
          @click="go(p)"
        >
          {{ p }}
        </button>
        <button class="pg" :disabled="page >= pageCount" @click="go(page + 1)">下一页</button>
      </span>
      <span class="muted">共 {{ total }} 条 / {{ pageCount }} 页</span>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { fmtDate, fmtNum, fmtTime, tagClass } from '../utils/dict'

const props = defineProps({
  cfg: { type: Object, required: true }
})
const emit = defineEmits(['loaded'])

const rows = ref([])
const total = ref(0)
const page = ref(1)
const size = ref(props.cfg.pageSize || 10)
const loading = ref(false)
const query = reactive({})

const pageCount = computed(() => Math.max(1, Math.ceil(total.value / size.value)))
const pages = computed(() => {
  const arr = []
  const start = Math.max(1, page.value - 2)
  const end = Math.min(pageCount.value, start + 4)
  for (let i = start; i <= end; i++) arr.push(i)
  return arr
})

function optionsOf(f) {
  return f.options || []
}

function display(row, c) {
  const v = row[c.key]
  if (c.format) return c.format(v, row)
  if (c.map) return c.map[v] ?? v ?? '-'
  return v === null || v === undefined || v === '' ? '-' : v
}

function pct(row, c) {
  const v = Number(row[c.key] || 0)
  const max = Number(row[c.max] || c.maxValue || 100)
  if (!max) return 0
  return Math.min(100, Math.round((v / max) * 100))
}

async function load() {
  loading.value = true
  try {
    const params = { page: page.value, size: size.value }
    Object.keys(query).forEach((k) => {
      if (query[k] !== '' && query[k] !== null && query[k] !== undefined) params[k] = query[k]
    })
    const data = await props.cfg.api(params)
    rows.value = data?.list || []
    total.value = data?.total || 0
    emit('loaded', rows.value)
  } catch (e) {
    rows.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

function search() {
  page.value = 1
  load()
}

function go(p) {
  if (p < 1 || p > pageCount.value) return
  page.value = p
  load()
}

function reset() {
  Object.keys(query).forEach((k) => (query[k] = ''))
  search()
}

watch(
  () => props.cfg,
  () => {
    page.value = 1
    load()
  }
)

onMounted(load)

defineExpose({ load, search, rows, total })
</script>
