<template>
  <div>
    <PageHead title="用户管理" sub="机构账号与角色分配，数据范围决定可见业务数据（全部 / 本部门 / 仅本人）">
      <template #actions>
        <button class="btn" @click="$router.push('/role-list')">角色权限</button>
        <button class="btn btn-primary" @click="openCreate">新增用户</button>
      </template>
    </PageHead>

    <div class="card">
      <ListPage ref="listRef" :cfg="cfg">
        <template #ops="{ row }">
          <span class="link-op" @click="openEdit(row)">编辑</span>
          <span v-if="row.status === '启用'" class="link-op danger" @click="toggle(row)">停用</span>
          <span v-else class="link-op" @click="toggle(row)">启用</span>
        </template>
      </ListPage>
    </div>

    <el-dialog v-model="dialog" :title="form.id ? '编辑用户' : '新增用户'" width="620px">
      <div class="form-grid">
        <div class="form-item">
          <label>登录账号<em>*</em></label>
          <input v-model="form.username" class="input" :disabled="!!form.id" placeholder="拼音账号" />
        </div>
        <div class="form-item">
          <label>姓名</label>
          <input v-model="form.realName" class="input" />
        </div>
        <div class="form-item">
          <label>角色</label>
          <select v-model="form.roleCode" class="select" @change="syncRole">
            <option v-for="r in roles" :key="r.roleCode" :value="r.roleCode">{{ r.roleName }}</option>
          </select>
        </div>
        <div class="form-item">
          <label>数据范围</label>
          <select v-model="form.dataScope" class="select">
            <option value="ALL">全部数据</option>
            <option value="DEPT">本部门</option>
            <option value="SELF">仅本人</option>
          </select>
        </div>
        <div class="form-item">
          <label>所属机构</label>
          <select v-model="form.orgId" class="select">
            <option v-for="o in orgs" :key="o.id" :value="o.id">{{ o.orgName }}</option>
          </select>
        </div>
        <div class="form-item">
          <label>手机号</label>
          <input v-model="form.phone" class="input" />
        </div>
        <div class="form-item">
          <label>邮箱</label>
          <input v-model="form.email" class="input" />
        </div>
        <div class="form-item" v-if="!form.id">
          <label>初始密码</label>
          <input v-model="form.password" class="input" placeholder="默认 123456" />
        </div>
      </div>
      <template #footer>
        <button class="btn" @click="dialog = false">取消</button>
        <button class="btn btn-primary" @click="save">保存</button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import ListPage from '../components/ListPage.vue'
import { listOrg, listRole, pageUser, saveUser, toggleUserStatus } from '../api'
import { maskPhone } from '../utils/dict'

const listRef = ref(null)
const dialog = ref(false)
const roles = ref([])
const orgs = ref([])
const form = reactive({})

const cfg = {
  api: pageUser,
  pageSize: 10,
  filters: [
    { key: 'keyword', label: '关键字', ph: '账号 / 姓名', w: 'w-md' },
    { key: 'roleCode', label: '角色', type: 'select', options: () => [] },
    { key: 'status', label: '状态', type: 'select', options: ['启用', '停用'] }
  ],
  columns: [
    { key: 'username', type: 'two', label: '账号', main: 'username', sub: 'realName', width: '160px' },
    { key: 'roleCode', label: '角色', width: '130px', format: (v) => roleName(v) },
    { key: 'dataScope', label: '数据范围', width: '110px', map: { ALL: '全部数据', DEPT: '本部门', SELF: '仅本人' } },
    { key: 'phone', label: '手机号', width: '130px', format: (v) => maskPhone(v) },
    { key: 'email', label: '邮箱', width: '190px' },
    { key: 'status', type: 'tag', label: '状态', width: '84px' },
    { key: 'lastLoginTime', type: 'time', label: '最近登录', width: '140px' }
  ]
}

function roleName(code) {
  const r = roles.value.find((x) => x.roleCode === code)
  return r ? r.roleName : code
}

function syncRole() {
  const r = roles.value.find((x) => x.roleCode === form.roleCode)
  if (r) form.roleId = r.id
}

function openCreate() {
  Object.keys(form).forEach((k) => delete form[k])
  Object.assign(form, { roleCode: 'VOLUNTEER', dataScope: 'SELF', status: '启用' })
  dialog.value = true
}

function openEdit(row) {
  Object.keys(form).forEach((k) => delete form[k])
  Object.assign(form, row)
  dialog.value = true
}

async function save() {
  if (!form.username) {
    ElMessage.warning('请填写登录账号')
    return
  }
  try {
    await saveUser({ ...form })
    ElMessage.success('保存成功')
    dialog.value = false
    listRef.value?.load()
  } catch (e) {
    /* 已提示 */
  }
}

async function toggle(row) {
  try {
    await ElMessageBox.confirm(`确认${row.status === '启用' ? '停用' : '启用'}账号 ${row.username}？`, '状态变更', { type: 'warning' })
    await toggleUserStatus(row.id, { status: row.status === '启用' ? '停用' : '启用' })
    ElMessage.success('已更新')
    listRef.value?.load()
  } catch (e) {
    /* 取消或已提示 */
  }
}

onMounted(async () => {
  try {
    roles.value = (await listRole()) || []
    orgs.value = (await listOrg()) || []
    cfg.filters[1].options = roles.value.map((r) => r.roleCode)
  } catch (e) {
    /* 已提示 */
  }
})
</script>
