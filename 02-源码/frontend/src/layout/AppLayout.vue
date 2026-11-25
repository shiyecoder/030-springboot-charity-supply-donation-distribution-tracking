<template>
  <div class="app">
    <aside class="sidebar">
      <div class="logo">
        <div class="mark">慈</div>
        <div class="name">公益物资追踪<small>CHARITY MATERIAL</small></div>
      </div>
      <nav class="menu">
        <template v-for="g in groups" :key="g.name">
          <div class="menu-group">{{ g.name }}</div>
          <router-link
            v-for="m in g.items"
            :key="m.path"
            class="menu-item"
            :class="{ active: isActive(m.path) }"
            :to="m.path"
          >
            <span class="ic" v-html="ICON[m.icon] || ICON.dot"></span>
            <span>{{ m.title }}</span>
            <span v-if="m.badge" class="badge">{{ m.badge }}</span>
          </router-link>
        </template>
      </nav>
      <div class="side-foot">
        <span>{{ roleLabel }}</span>
        <span class="ver">v1.0</span>
      </div>
    </aside>

    <div class="main">
      <header class="topbar">
        <div class="crumb">
          <span>{{ currentGroup }}</span><span>/</span><b>{{ currentTitle }}</b>
        </div>
        <div class="topbar-right">
          <div class="icon-btn" title="消息通知" @click="$router.push('/message')">
            <span v-html="ICON.bell"></span>
            <i v-if="notices > 0" class="dot"></i>
          </div>
          <el-dropdown trigger="click" @command="onCommand">
            <div class="user">
              <div class="avatar">
                <img v-if="avatarUrl" :src="avatarUrl" alt="" />
                <span v-else>{{ shortName }}</span>
              </div>
              <div>
                <div class="nm">{{ user.realName || user.username }}</div>
                <div class="rl">{{ roleLabel }}</div>
              </div>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                <el-dropdown-item command="portal">捐赠门户</el-dropdown-item>
                <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>

      <main class="content">
        <router-view v-slot="{ Component }">
          <component :is="Component" />
        </router-view>
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getMe, pageMessage, logout as apiLogout } from '../api'
import { userStore, ROLE_LABEL } from '../store/user'

const route = useRoute()
const router = useRouter()
const notices = ref(0)
const user = computed(() => userStore.user || {})

const ICON = {
  grid: '<svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><rect x="1" y="1" width="6" height="6" rx="1.2"/><rect x="9" y="1" width="6" height="6" rx="1.2"/><rect x="1" y="9" width="6" height="6" rx="1.2"/><rect x="9" y="9" width="6" height="6" rx="1.2"/></svg>',
  heart: '<svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.4"><path d="M8 13.4C4 10.6 1.6 8.4 1.6 5.7 1.6 3.7 3.2 2.2 5.1 2.2c1.1 0 2.1.5 2.9 1.4.8-.9 1.8-1.4 2.9-1.4 1.9 0 3.5 1.5 3.5 3.5 0 2.7-2.4 4.9-6.4 7.7z"/></svg>',
  box: '<svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.4"><path d="M2 5.2 8 2l6 3.2v5.6L8 14l-6-3.2z"/><path d="M2 5.2 8 8.4l6-3.2M8 8.4V14"/></svg>',
  user: '<svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.4"><circle cx="8" cy="5.4" r="2.8"/><path d="M2.6 14c0-2.8 2.4-4.6 5.4-4.6s5.4 1.8 5.4 4.6"/></svg>',
  bulb: '<svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.4"><path d="M8 1.6a4.4 4.4 0 0 0-2.6 8c.4.3.6.7.6 1.2v.6h4v-.6c0-.5.2-.9.6-1.2A4.4 4.4 0 0 0 8 1.6z"/><path d="M6.4 13.4h3.2"/></svg>',
  gear: '<svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.4"><circle cx="8" cy="8" r="2.2"/><path d="M8 1.4v1.8M8 12.8v1.8M1.4 8h1.8M12.8 8h1.8M3.3 3.3l1.3 1.3M11.4 11.4l1.3 1.3M12.7 3.3l-1.3 1.3M4.6 11.4l-1.3 1.3"/></svg>',
  dot: '<svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><circle cx="8" cy="8" r="2.4"/></svg>',
  bell: '<svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.4"><path d="M4 6.6a4 4 0 0 1 8 0c0 3 .8 4 1.2 4.4H2.8C3.2 10.6 4 9.6 4 6.6z"/><path d="M6.4 13a1.7 1.7 0 0 0 3.2 0"/></svg>'
}

// 侧边栏分组：直接由路由表生成，保证每个设计页都有入口
const GROUP_ICON = {
  总览: 'grid',
  捐赠管理: 'heart',
  仓储管理: 'box',
  受助管理: 'user',
  创新点: 'bulb',
  系统管理: 'gear'
}

const groups = computed(() => {
  const layout = router.getRoutes().find((r) => r.path === '/' && r.children)
  const items = []
  if (layout) {
    layout.children.forEach((c) => {
      if (c.meta?.hidden) return
      items.push({ path: '/' + c.path, title: c.meta.title, group: c.meta.group, icon: GROUP_ICON[c.meta.group] })
    })
  }
  // 其他端（门户 / 志愿者 / 受助申请）
  items.push({ path: '/portal', title: '捐赠门户', group: '其他端', icon: 'heart' })
  items.push({ path: '/volunteer', title: '志愿者工作台', group: '其他端', icon: 'box' })
  items.push({ path: '/applicant', title: '受助申请端', group: '其他端', icon: 'user' })

  const order = ['总览', '捐赠管理', '仓储管理', '受助管理', '创新点', '系统管理', '其他端']
  const map = new Map()
  items.forEach((it) => {
    if (!map.has(it.group)) map.set(it.group, [])
    map.get(it.group).push(it)
  })
  return order.filter((g) => map.has(g)).map((g) => ({ name: g, items: map.get(g) }))
})

const isActive = (p) => route.path === p || (p !== '/' && route.path.startsWith(p))
const currentTitle = computed(() => route.meta.title || '')
const currentGroup = computed(() => route.meta.group || '')
const roleLabel = computed(() => ROLE_LABEL[user.value.roleCode] || '系统用户')
const shortName = computed(() => (user.value.realName || 'U').slice(0, 1))
const avatarUrl = computed(() => user.value.avatar || '')

function onCommand(cmd) {
  if (cmd === 'profile') router.push('/profile')
  else if (cmd === 'portal') router.push('/portal')
  else if (cmd === 'logout') doLogout()
}

async function doLogout() {
  try {
    await apiLogout()
  } catch (e) {
    /* 忽略：本地会话仍需清理 */
  }
  userStore.clear()
  router.push('/login')
}

onMounted(async () => {
  try {
    const me = await getMe()
    if (me) userStore.setUser(me)
  } catch (e) {
    /* 拦截器已处理 401 */
  }
  try {
    const m = await pageMessage({ page: 1, size: 1, readFlag: 0 })
    notices.value = m?.total || 0
  } catch (e) {
    notices.value = 0
  }
})
</script>

<style scoped>
.side-foot {
  padding: 12px 18px;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  font-size: 11px;
  color: #69839b;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.side-foot .ver {
  color: #4d6579;
}
.menu-item .ic {
  display: inline-flex;
  align-items: center;
}
</style>
