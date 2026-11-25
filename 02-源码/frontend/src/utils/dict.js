// 通用格式化与状态映射（状态值全部来自需求文档的状态机，不做臆造）

export function fmtDate(v) {
  if (!v) return '-'
  return String(v).slice(0, 10)
}

export function fmtTime(v) {
  if (!v) return '-'
  return String(v).replace('T', ' ').slice(0, 16)
}

export function fmtNum(v, unit) {
  if (v === null || v === undefined || v === '') return '-'
  const n = Number(v)
  const s = Number.isInteger(n) ? n.toLocaleString('zh-CN') : n.toFixed(1)
  return unit ? s + ' ' + unit : s
}

export function maskPhone(p) {
  if (!p) return '-'
  const s = String(p)
  if (s.length < 7) return s
  return s.slice(0, 3) + '****' + s.slice(-4)
}

export function maskName(n) {
  if (!n) return '-'
  const s = String(n)
  return s.slice(0, 1) + '**'
}

// 状态 → 标签样式
const DANGER = ['已拒收', '驳回', '异常', '停用', '不通过', '已退回', '已取消', '不合格', '过期', '失败', '冻结', '已拒绝']
const SUCCESS = ['已完成', '已入库', '启用', '通过', '正常', '已签收', '已归档', '已发放', '合格', '已读']
const WARN = ['待预审', '待送达', '待验收', '待审核', '待拣货', '待领用', '待配送', '待反馈', '待处理', '部分接收', '锁定', '待分配', '待确认', '处理中']
const SUB = ['进行中', '已分配', '已发布', '已审核', '已批准', '优先分配', '常规分配']

export function tagClass(v) {
  const s = String(v || '')
  if (DANGER.some((k) => s.includes(k))) return 'tag-danger'
  if (SUCCESS.some((k) => s.includes(k))) return 'tag-success'
  if (WARN.some((k) => s.includes(k))) return 'tag-warn'
  if (SUB.some((k) => s.includes(k))) return 'tag-sub'
  return 'tag-info'
}

export function scoreClass(level) {
  if (!level) return 'low'
  if (level.includes('优先')) return 'high'
  if (level.includes('暂缓') || level.includes('常规')) return 'mid'
  return 'low'
}

// 主流程阶段（发放单）
export const ORDER_STAGES = ['待审核', '待拣货', '待领用', '待反馈', '已完成']

export const URGENCY = ['特急', '紧急', '一般']
export const CATEGORY = ['米面粮油', '御寒衣物', '学习用品', '日用清洁', '医疗护理']
export const DELIVERY = ['到仓捐赠', '上门取件', '快递寄送']
export const REGION = ['城西街道', '南苑街道', '北岭街道', '开发区', '东湖街道', '青山镇']

export function money(v) {
  if (v === null || v === undefined || v === '') return '-'
  return '¥' + Number(v).toLocaleString('zh-CN')
}
