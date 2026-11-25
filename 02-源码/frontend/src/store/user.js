import { reactive } from 'vue'
import { TOKEN_KEY, USER_KEY } from '../api/request'

function readUser() {
  try {
    return JSON.parse(localStorage.getItem(USER_KEY) || 'null')
  } catch (e) {
    return null
  }
}

export const userStore = reactive({
  user: readUser(),
  menus: [],
  notices: 0,
  get token() {
    return localStorage.getItem(TOKEN_KEY) || ''
  },
  get roleCode() {
    return this.user?.roleCode || ''
  },
  setSession(token, user) {
    localStorage.setItem(TOKEN_KEY, token)
    localStorage.setItem(USER_KEY, JSON.stringify(user))
    this.user = user
  },
  setMenus(list) {
    this.menus = list || []
  },
  setUser(user) {
    localStorage.setItem(USER_KEY, JSON.stringify(user))
    this.user = user
  },
  clear() {
    localStorage.removeItem(TOKEN_KEY)
    localStorage.removeItem(USER_KEY)
    this.user = null
    this.menus = []
  }
})

// 角色中文名
export const ROLE_LABEL = {
  ADMIN: '项目管理员',
  VOLUNTEER: '仓储志愿者',
  AUDITOR: '受助审核员',
  DONOR: '捐赠人/单位'
}

// 门户（普通用户端）角色
export const PORTAL_ROLES = ['DONOR', 'AUDITOR']
