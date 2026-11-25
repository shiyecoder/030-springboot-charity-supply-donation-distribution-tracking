import { createRouter, createWebHashHistory } from 'vue-router'
import { userStore } from '../store/user'

const routes = [
  { path: '/login', name: 'login', component: () => import('../views/Login.vue'), meta: { public: true, title: '登录' } },
  { path: '/portal', name: 'portal', component: () => import('../views/Portal.vue'), meta: { title: '捐赠门户' } },
  { path: '/volunteer', name: 'volunteer', component: () => import('../views/Volunteer.vue'), meta: { title: '志愿者工作台' } },
  { path: '/applicant', name: 'applicant', component: () => import('../views/Applicant.vue'), meta: { title: '受助申请' } },
  {
    path: '/',
    component: () => import('../layout/AppLayout.vue'),
    redirect: '/dashboard',
    children: [
      { path: 'dashboard', name: 'dashboard', component: () => import('../views/Dashboard.vue'), meta: { title: '公益物资看板', group: '总览' } },
      { path: 'project-list', name: 'project-list', component: () => import('../views/ProjectList.vue'), meta: { title: '捐赠项目', group: '捐赠管理' } },
      { path: 'demand-list', name: 'demand-list', component: () => import('../views/DemandList.vue'), meta: { title: '物资与需求', group: '捐赠管理' } },
      { path: 'intent-list', name: 'intent-list', component: () => import('../views/IntentList.vue'), meta: { title: '捐赠意向', group: '捐赠管理' } },
      { path: 'receiving', name: 'receiving', component: () => import('../views/Receiving.vue'), meta: { title: '收货验收', group: '仓储管理' } },
      { path: 'batch-list', name: 'batch-list', component: () => import('../views/BatchList.vue'), meta: { title: '物资批次台账', group: '仓储管理' } },
      { path: 'distribute', name: 'distribute', component: () => import('../views/Distribute.vue'), meta: { title: '拣货发放', group: '仓储管理' } },
      { path: 'application-list', name: 'application-list', component: () => import('../views/ApplicationList.vue'), meta: { title: '受助需求池', group: '受助管理' } },
      { path: 'application-review', name: 'application-review', component: () => import('../views/ApplicationReview.vue'), meta: { title: '资格与反重审核', group: '受助管理' } },
      { path: 'distribution-list', name: 'distribution-list', component: () => import('../views/DistributionList.vue'), meta: { title: '发放单跟踪', group: '受助管理' } },
      { path: 'distribution-detail', name: 'distribution-detail', component: () => import('../views/DistributionDetail.vue'), meta: { title: '发放单详情', group: '受助管理', hidden: true } },
      { path: 'feedback-list', name: 'feedback-list', component: () => import('../views/FeedbackList.vue'), meta: { title: '签收与反馈', group: '受助管理' } },
      { path: 'rule-config', name: 'rule-config', component: () => import('../views/RuleConfig.vue'), meta: { title: '紧迫度规则配置', group: '创新点' } },
      { path: 'score-detail', name: 'score-detail', component: () => import('../views/ScoreDetail.vue'), meta: { title: '评分明细与快照', group: '创新点' } },
      { path: 'report', name: 'report', component: () => import('../views/Report.vue'), meta: { title: '统计报表', group: '创新点' } },
      { path: 'user-list', name: 'user-list', component: () => import('../views/UserList.vue'), meta: { title: '用户管理', group: '系统管理' } },
      { path: 'role-list', name: 'role-list', component: () => import('../views/RoleList.vue'), meta: { title: '角色权限', group: '系统管理' } },
      { path: 'menu-list', name: 'menu-list', component: () => import('../views/MenuList.vue'), meta: { title: '菜单管理', group: '系统管理' } },
      { path: 'log-list', name: 'log-list', component: () => import('../views/LogList.vue'), meta: { title: '操作日志', group: '系统管理' } },
      { path: 'message', name: 'message', component: () => import('../views/Message.vue'), meta: { title: '消息通知', group: '系统管理' } },
      { path: 'profile', name: 'profile', component: () => import('../views/Profile.vue'), meta: { title: '个人中心', group: '系统管理', hidden: true } }
    ]
  },
  { path: '/:pathMatch(.*)*', redirect: '/dashboard' }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

router.beforeEach((to) => {
  document.title = (to.meta.title ? to.meta.title + ' · ' : '') + '公益物资捐赠与发放追踪系统'
  if (to.meta.public) return true
  if (!userStore.token) return { path: '/login', query: { redirect: to.fullPath } }
  return true
})

export default router
