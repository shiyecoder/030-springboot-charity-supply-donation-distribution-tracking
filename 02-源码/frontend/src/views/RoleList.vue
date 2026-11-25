<template>
  <div>
    <PageHead title="角色权限" sub="四类角色对应四套菜单权限，数据范围在用户维度进一步收敛">
      <template #actions>
        <button class="btn" @click="$router.push('/user-list')">用户管理</button>
        <button class="btn btn-primary" :disabled="!cur.id || saving" @click="save">{{ saving ? '保存中…' : '保存权限' }}</button>
      </template>
    </PageHead>

    <div class="grid-23">
      <div class="card mb0">
        <div class="card-head"><h2>角色列表</h2><span class="sub">{{ roles.length }} 个</span></div>
        <div
          v-for="r in roles"
          :key="r.id"
          class="role-item"
          :class="{ on: cur.id === r.id }"
          @click="select(r)"
        >
          <div class="r-top">
            <b>{{ r.roleName }}</b>
            <span class="tag" :class="r.status === '启用' ? 'tag-success' : 'tag-gray'">{{ r.status }}</span>
          </div>
          <div class="r-code">{{ r.roleCode }}</div>
          <div class="r-desc">{{ r.remark }}</div>
        </div>
      </div>

      <div class="card mb0">
        <div class="card-head">
          <h2>菜单权限</h2>
          <span class="sub">{{ cur.roleName || '未选择角色' }} · 已选 {{ checked.length }} 项</span>
        </div>
        <div v-if="!cur.id" class="empty"><b>请选择左侧角色</b>查看并调整其菜单权限</div>
        <template v-else>
          <div class="tree">
            <div v-for="n in menus" :key="n.id" class="tree-group">
              <label class="tree-node lv1">
                <input type="checkbox" :checked="isChecked(n.id)" @change="toggleNode(n, $event)" />
                <span>{{ n.name }}</span>
                <span class="tag tag-gray" style="margin-left: 8px">{{ n.type }}</span>
              </label>
              <div v-for="c in n.children || []" :key="c.id" class="tree-node lv2">
                <label>
                  <input type="checkbox" :checked="isChecked(c.id)" @change="toggleNode(c, $event)" />
                  <span>{{ c.name }}</span>
                </label>
                <span class="small muted">{{ c.path || '—' }}</span>
                <span class="mono small" style="margin-left: auto">{{ c.perms }}</span>
              </div>
            </div>
          </div>
          <div class="rule-note mt12">
            目录节点只控制分组显示，页面菜单节点决定可访问页面；权限标识用于接口级校验。
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import { getMenuTree, getRoleMenus, listRole, saveRoleMenus } from '../api'

const roles = ref([])
const menus = ref([])
const checked = ref([])
const cur = ref({})
const saving = ref(false)

function isChecked(id) {
  return checked.value.includes(id)
}

function toggleNode(n, e) {
  const ids = [n.id, ...(n.children || []).map((c) => c.id)]
  if (e.target.checked) {
    ids.forEach((id) => {
      if (!checked.value.includes(id)) checked.value.push(id)
    })
  } else {
    checked.value = checked.value.filter((id) => !ids.includes(id))
  }
}

async function load() {
  try {
    roles.value = (await listRole()) || []
    menus.value = (await getMenuTree()) || []
    if (roles.value.length && !cur.value.id) select(roles.value[0])
  } catch (e) {
    /* 已提示 */
  }
}

async function select(r) {
  cur.value = r
  try {
    const d = await getRoleMenus(r.id)
    checked.value = d.menuIds || []
  } catch (e) {
    checked.value = []
  }
}

async function save() {
  saving.value = true
  try {
    await saveRoleMenus(cur.value.id, { menuIds: checked.value })
    ElMessage.success('权限已保存')
  } catch (e) {
    /* 已提示 */
  } finally {
    saving.value = false
  }
}

onMounted(load)
</script>

<style scoped>
.role-item {
  border: 1px solid var(--line);
  border-radius: 6px;
  padding: 11px 13px;
  margin-bottom: 9px;
  cursor: pointer;
}
.role-item:hover {
  border-color: var(--sub);
}
.role-item.on {
  border-color: var(--sub);
  background: #eef4f7;
  box-shadow: inset 2px 0 0 var(--sub);
}
.r-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 13px;
}
.r-code {
  font-size: 11px;
  color: var(--sub);
  font-family: ui-monospace, Menlo, monospace;
  margin-top: 4px;
}
.r-desc {
  font-size: 11.5px;
  color: var(--text-3);
  margin-top: 5px;
  line-height: 1.6;
}
.tree-group {
  margin-bottom: 10px;
}
.tree-node {
  display: flex;
  align-items: center;
  gap: 7px;
  font-size: 12.5px;
  padding: 5px 0;
  cursor: pointer;
}
.tree-node.lv1 {
  font-weight: 600;
  border-bottom: 1px solid #f2f5f7;
}
.tree-node.lv2 {
  padding-left: 24px;
}
</style>
