<template>
  <div>
    <PageHead title="个人中心" sub="账号信息、头像与密码维护，头像使用上传组件展示态渲染">
      <template #actions>
        <button class="btn" @click="$router.back()">返回</button>
        <button class="btn btn-primary" @click="saveProfile">保存资料</button>
      </template>
    </PageHead>

    <div class="grid-2">
      <div class="card mb0">
        <div class="card-head"><h2>账号信息</h2><span class="sub">{{ user.username }}</span></div>
        <div class="flex gap12" style="margin-bottom: 16px">
          <div class="avatar" style="width: 56px; height: 56px; font-size: 18px">
            <img v-if="form.avatar" :src="form.avatar" alt="" />
            <span v-else>{{ (form.realName || 'U').slice(0, 1) }}</span>
          </div>
          <div>
            <div style="font-size: 15px; font-weight: 600">{{ form.realName }}</div>
            <div class="small muted mt8">{{ roleLabel }}</div>
          </div>
          <div class="spacer"></div>
          <label class="btn btn-sm" style="cursor: pointer">
            更换头像
            <input type="file" accept="image/*" style="display: none" @change="onAvatar" />
          </label>
        </div>
        <div class="form-grid">
          <div class="form-item">
            <label>姓名</label>
            <input v-model="form.realName" class="input" />
          </div>
          <div class="form-item">
            <label>手机号</label>
            <input v-model="form.phone" class="input" />
          </div>
          <div class="form-item">
            <label>邮箱</label>
            <input v-model="form.email" class="input" />
          </div>
          <div class="form-item">
            <label>数据范围</label>
            <input :value="scopeLabel" class="input" disabled />
          </div>
        </div>
      </div>

      <div>
        <div class="card mb0">
          <div class="card-head"><h2>修改密码</h2><span class="sub">修改后需重新登录</span></div>
          <div class="form-grid">
            <div class="form-item full">
              <label>原密码</label>
              <input v-model="pwd.oldPassword" type="password" class="input" />
            </div>
            <div class="form-item full">
              <label>新密码</label>
              <input v-model="pwd.newPassword" type="password" class="input" placeholder="不少于 6 位" />
            </div>
            <div class="form-item full">
              <label>确认新密码</label>
              <input v-model="pwd.confirm" type="password" class="input" />
            </div>
          </div>
          <div class="flex gap8 mt12" style="justify-content: flex-end">
            <button class="btn btn-primary" @click="savePassword">提交修改</button>
          </div>
        </div>

        <div class="card" style="margin-top: 14px">
          <div class="card-head"><h2>角色权限概览</h2></div>
          <div class="dl">
            <dt>角色编码</dt><dd>{{ user.roleCode }}</dd>
            <dt>数据范围</dt><dd>{{ scopeLabel }}</dd>
            <dt>所属机构</dt><dd>{{ orgName }}</dd>
            <dt>最近登录</dt><dd>{{ fmtTime(user.lastLoginTime) }}</dd>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import PageHead from '../components/PageHead.vue'
import { getMe, updatePassword, updateProfile, uploadFile } from '../api'
import { userStore, ROLE_LABEL } from '../store/user'
import { fmtTime } from '../utils/dict'

const router = useRouter()
const user = computed(() => userStore.user || {})
const form = reactive({ realName: '', phone: '', email: '', avatar: '' })
const pwd = reactive({ oldPassword: '', newPassword: '', confirm: '' })
const orgName = ref('-')

const roleLabel = computed(() => ROLE_LABEL[user.value.roleCode] || '系统用户')
const scopeLabel = computed(
  () => ({ ALL: '全部数据', DEPT: '本部门数据', SELF: '仅本人数据' })[user.value.dataScope] || '-'
)

async function load() {
  try {
    const me = await getMe()
    if (me) {
      userStore.setUser(me)
      Object.assign(form, { realName: me.realName, phone: me.phone, email: me.email, avatar: me.avatar })
    }
  } catch (e) {
    Object.assign(form, { realName: user.value.realName, phone: user.value.phone, email: user.value.email, avatar: user.value.avatar })
  }
}

async function onAvatar(e) {
  const file = e.target.files?.[0]
  if (!file) return
  const fd = new FormData()
  fd.append('file', file)
  fd.append('bizType', 'avatar')
  try {
    const r = await uploadFile(fd)
    form.avatar = r?.url || r?.filePath || form.avatar
    ElMessage.success('头像已上传，保存后生效')
  } catch (err) {
    /* 已提示 */
  }
}

async function saveProfile() {
  try {
    await updateProfile({ ...form })
    userStore.setUser({ ...user.value, ...form })
    ElMessage.success('资料已保存')
  } catch (e) {
    /* 已提示 */
  }
}

async function savePassword() {
  if (!pwd.oldPassword || !pwd.newPassword) {
    ElMessage.warning('请填写原密码与新密码')
    return
  }
  if (pwd.newPassword !== pwd.confirm) {
    ElMessage.warning('两次输入的新密码不一致')
    return
  }
  try {
    await updatePassword({ oldPassword: pwd.oldPassword, newPassword: pwd.newPassword })
    ElMessage.success('密码已修改，请重新登录')
    setTimeout(() => {
      userStore.clear()
      router.push('/login')
    }, 800)
  } catch (e) {
    /* 已提示 */
  }
}

onMounted(load)
</script>
