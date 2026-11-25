import axios from 'axios'
import { ElMessage } from 'element-plus'

// localStorage 统一前缀 cm_（避免和其他项目串数据）
export const TOKEN_KEY = 'cm_token'
export const USER_KEY = 'cm_user'

const http = axios.create({
  baseURL: '/api',
  timeout: 20000
})

http.interceptors.request.use((cfg) => {
  const token = localStorage.getItem(TOKEN_KEY)
  if (token) cfg.headers.Authorization = 'Bearer ' + token
  return cfg
})

// 后端统一响应结构 { code, msg, data, requestId }
// 未登录/登录过期时 HTTP 状态仍是 200，业务码为 401，这里统一按业务码判断
http.interceptors.response.use(
  (res) => {
    const body = res.data
    if (body && typeof body === 'object' && 'code' in body) {
      if (body.code === 0) return body.data
      if (body.code === 401) {
        localStorage.removeItem(TOKEN_KEY)
        localStorage.removeItem(USER_KEY)
        if (!location.hash.includes('/login')) {
          ElMessage.warning('登录已过期，请重新登录')
          location.hash = '#/login'
        }
        return Promise.reject(new Error(body.msg || '未登录'))
      }
      ElMessage.error(body.msg || '操作失败')
      return Promise.reject(new Error(body.msg || '操作失败'))
    }
    return body
  },
  (err) => {
    ElMessage.error(err.message || '网络异常，请稍后重试')
    return Promise.reject(err)
  }
)

export default http
