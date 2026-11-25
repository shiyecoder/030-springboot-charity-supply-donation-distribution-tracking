import http from './request'

// ---------------- 认证 ----------------
export const login = (data) => http.post('/auth/login', data)
export const register = (data) => http.post('/auth/register', data)
export const getMe = () => http.get('/auth/me')
export const getMenus = () => http.get('/auth/menus')
export const logout = () => http.post('/auth/logout')
export const updateProfile = (data) => http.put('/auth/profile', data)
export const updatePassword = (data) => http.put('/auth/password', data)

// ---------------- 看板 ----------------
export const getDashboard = () => http.get('/dashboard')

// ---------------- 捐赠 ----------------
export const pageProject = (p) => http.get('/project/page', { params: p })
export const getProject = (id) => http.get(`/project/${id}`)
export const saveProject = (data) => (data.id ? http.put(`/project/${data.id}`, data) : http.post('/project', data))
export const pageDemand = (p) => http.get('/demand/page', { params: p })
export const pageIntent = (p) => http.get('/intent/page', { params: p })
export const getIntent = (id) => http.get(`/intent/${id}`)
export const createIntent = (data) => http.post('/intent', data)
export const precheckIntent = (id, data) => http.post(`/intent/${id}/precheck`, data || {})

// ---------------- 仓储 ----------------
export const pageReceiving = (p) => http.get('/receiving/page', { params: p })
export const getReceiving = (id) => http.get(`/receiving/${id}`)
export const submitReceiving = (data) => http.post('/receiving/submit', data)
export const pageBatch = (p) => http.get('/batch/page', { params: p })
export const getBatch = (id) => http.get(`/batch/${id}`)
export const lockBatch = (id) => http.post(`/batch/${id}/lock`)
export const unlockBatch = (id) => http.post(`/batch/${id}/unlock`)
export const pageInventoryCheck = (p) => http.get('/inventory-check/page', { params: p })

// ---------------- 受助 ----------------
export const pageBeneficiary = (p) => http.get('/beneficiary/page', { params: p })
export const pageApplication = (p) => http.get('/application/page', { params: p })
export const getApplication = (id) => http.get(`/application/${id}`)
export const reviewApplication = (id, data) => http.post(`/application/${id}/review`, data)
export const pageFeedback = (p) => http.get('/feedback/page', { params: p })
export const auditFeedback = (id, data) => http.post(`/feedback/${id}/audit`, data || {})

// ---------------- 发放 ----------------
export const pageDistribution = (p) => http.get('/distribution/page', { params: p })
export const getDistribution = (id) => http.get(`/distribution/${id}`)
export const recommendBatch = (id) => http.get(`/distribution/${id}/recommend`)
export const pickDistribution = (id, data) => http.post(`/distribution/${id}/pick`, data)
export const transitionDistribution = (id, data) => http.post(`/distribution/${id}/transition`, data)
export const getPublicReport = (p) => http.get('/report/public', { params: p })

// ---------------- 创新：规则与评分 ----------------
export const getCurrentRule = () => http.get('/rule/current')
export const getRuleHistory = () => http.get('/rule/history')
export const saveRule = (data) => http.post('/rule', data)
export const evaluateScore = (data) => http.post('/score/evaluate', data)
export const getScore = (id) => http.get(`/score/${id}`)
export const listScore = (p) => http.get('/score/list', { params: p })
export const adjustScore = (id, data) => http.post(`/score/${id}/adjust`, data)

// ---------------- 系统 ----------------
export const pageUser = (p) => http.get('/system/user/page', { params: p })
export const saveUser = (data) => http.post('/system/user', data)
export const toggleUserStatus = (id, data) => http.post(`/system/user/${id}/status`, data || {})
export const listRole = () => http.get('/system/role/list')
export const listOrg = () => http.get('/system/org/list')
export const getMenuTree = () => http.get('/system/menu/tree')
export const getRoleMenus = (id) => http.get(`/system/role/${id}/menus`)
export const saveRoleMenus = (id, data) => http.post(`/system/role/${id}/menus`, data)
export const pageLog = (p) => http.get('/system/log/page', { params: p })
export const getDict = (p) => http.get('/system/dict', { params: p })
export const pageMessage = (p) => http.get('/message/page', { params: p })
export const readMessage = (id) => http.post(`/message/${id}/read`)
export const readAllMessage = () => http.post('/message/read-all')

// ---------------- 文件 ----------------
export const uploadFile = (formData) =>
  http.post('/file/upload', formData, { headers: { 'Content-Type': 'multipart/form-data' } })
