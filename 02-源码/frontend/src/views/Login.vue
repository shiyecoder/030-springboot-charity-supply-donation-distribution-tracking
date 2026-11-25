<template>
  <div class="login-page">
    <section class="login-left">
      <div class="brand">
        <div class="mark">慈</div>
        <span>公益物资捐赠与发放追踪系统</span>
      </div>
      <h1>让每一件捐赠物资<br />都看得见去向</h1>
      <p class="sub">
        从捐赠意向预审、质检入库、需求审核，到分配出库、签收回执与追踪归档，
        全流程留痕；物资按先到期先出库发放，受助需求按紧迫度评分排序。
      </p>
      <div class="feats">
        <div><i>1</i><span>捐赠意向预审 + 收货验收质检，不合格率与差异原因全程留痕</span></div>
        <div><i>2</i><span>六因素紧迫度评分，权重与结果快照可追溯，人工调整不覆盖原值</span></div>
        <div><i>3</i><span>先到期先出库 + 条件更新扣减库存，杜绝超发与重复领取</span></div>
      </div>
      <div class="facts">
        <div><b>14</b><span>在运捐赠项目</span></div>
        <div><b>26</b><span>物资需求条目</span></div>
        <div><b>32</b><span>受助发放单</span></div>
      </div>
    </section>

    <section class="login-right">
      <div class="login-form">
        <h2>登录系统</h2>
        <div class="tip">请使用机构分配的账号登录，不同角色进入不同工作台</div>

        <div class="fi">
          <label>账号</label>
          <input v-model="form.username" class="input" placeholder="请输入账号" @keyup.enter="submit" />
        </div>
        <div class="fi">
          <label>密码</label>
          <input v-model="form.password" type="password" class="input" placeholder="请输入密码" @keyup.enter="submit" />
        </div>
        <div class="row">
          <label style="display: flex; align-items: center; gap: 6px">
            <input v-model="remember" type="checkbox" /> 记住账号
          </label>
          <a href="javascript:;" @click="fillDemo">查看演示账号</a>
        </div>
        <button class="btn btn-primary" :disabled="loading" @click="submit">
          {{ loading ? '登录中…' : '登录' }}
        </button>

        <div class="roles">
          <span v-for="r in demos" :key="r.username" @click="useDemo(r)" style="cursor: pointer">
            {{ r.label }}
          </span>
        </div>
        <p class="small muted" style="margin-top: 14px; line-height: 1.8">
          提示：管理员 admin / admin123，其余角色初始密码 123456。
        </p>
      </div>
    </section>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getMenus, login } from '../api'
import { userStore } from '../store/user'

const router = useRouter()
const route = useRoute()
const loading = ref(false)
const remember = ref(true)
const form = reactive({ username: '', password: '' })

const demos = [
  { label: '项目管理员', username: 'admin', password: 'admin123' },
  { label: '仓储志愿者', username: 'xuwsh', password: '123456' },
  { label: '受助审核员', username: 'zhouhl', password: '123456' },
  { label: '捐赠人/单位', username: 'linsx', password: '123456' }
]

function useDemo(d) {
  form.username = d.username
  form.password = d.password
}

function fillDemo() {
  ElMessage.info('管理员 admin/admin123；其余角色（xuwsh、zhouhl、linsx 等）初始密码 123456')
}

async function submit() {
  if (!form.username || !form.password) {
    ElMessage.warning('请输入账号和密码')
    return
  }
  loading.value = true
  try {
    const data = await login({ username: form.username, password: form.password })
    userStore.setSession(data.token, data.user)
    try {
      const menus = await getMenus()
      userStore.setMenus(menus)
    } catch (e) {
      userStore.setMenus([])
    }
    ElMessage.success('欢迎回来，' + (data.user.realName || data.user.username))
    const redirect = route.query.redirect || defaultHome(data.user.roleCode)
    router.replace(redirect)
  } catch (e) {
    /* 错误提示由拦截器统一处理 */
  } finally {
    loading.value = false
  }
}

function defaultHome(role) {
  if (role === 'DONOR') return '/portal'
  if (role === 'VOLUNTEER') return '/volunteer'
  if (role === 'AUDITOR') return '/applicant'
  return '/dashboard'
}

onMounted(() => {
  if (userStore.token) router.replace(defaultHome(userStore.user?.roleCode))
})
</script>
