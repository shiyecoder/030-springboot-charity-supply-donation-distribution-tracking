<template>
  <div>
    <PageHead title="菜单管理" sub="菜单树决定左侧导航结构，权限标识与后端接口校验一一对应">
      <template #actions>
        <button class="btn" @click="load">刷新</button>
        <button class="btn btn-primary" @click="$router.push('/role-list')">角色授权</button>
      </template>
    </PageHead>

    <div class="card">
      <div class="card-head"><h2>菜单树</h2><span class="sub">{{ flat.length }} 个节点（含目录）</span></div>
      <div class="table-wrap">
        <table class="table tight">
          <thead>
            <tr>
              <th style="width: 280px">菜单名称</th>
              <th>类型</th>
              <th>路由路径</th>
              <th>权限标识</th>
              <th>图标</th>
              <th class="num">排序</th>
              <th>可见</th>
              <th>状态</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="n in flat" :key="n.id">
              <td>
                <span :style="{ paddingLeft: n.level * 18 + 'px' }">
                  <span v-if="n.level > 0" class="muted">└ </span>{{ n.name }}
                </span>
              </td>
              <td><span class="tag" :class="n.type === '目录' ? 'tag-info' : 'tag-sub'">{{ n.type }}</span></td>
              <td class="mono">{{ n.path || '—' }}</td>
              <td class="small muted">{{ n.perms || '—' }}</td>
              <td class="small muted">{{ n.icon || '—' }}</td>
              <td class="num">{{ n.sortNo }}</td>
              <td>{{ n.visible ? '是' : '否' }}</td>
              <td><span class="tag" :class="n.status === '启用' ? 'tag-success' : 'tag-gray'">{{ n.status }}</span></td>
            </tr>
            <tr v-if="flat.length === 0"><td colspan="8"><div class="empty">暂无菜单数据</div></td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import PageHead from '../components/PageHead.vue'
import { getMenuTree } from '../api'

const flat = ref([])

function flatten(nodes, level = 0) {
  const out = []
  ;(nodes || []).forEach((n) => {
    out.push({ ...n, level })
    if (n.children) out.push(...flatten(n.children, level + 1))
  })
  return out
}

async function load() {
  try {
    flat.value = flatten((await getMenuTree()) || [])
  } catch (e) {
    flat.value = []
  }
}

onMounted(load)
</script>
