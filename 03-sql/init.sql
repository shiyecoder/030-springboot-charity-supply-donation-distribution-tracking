-- ============================================================
-- 公益物资捐赠与发放追踪系统 · 数据库初始化脚本
-- 数据库：new_030    字符集：utf8mb4
-- 表数量：26（18 业务 + 8 系统）  测试数据时间跨度：2026-05-01 ~ 2026-11-01
-- 默认管理员：admin / admin123   其余账号密码：123456
-- ============================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS new_030 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE new_030;

DROP TABLE IF EXISTS `donation_project`;
CREATE TABLE `donation_project` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  project_no varchar(50) COMMENT '项目编号',
  title varchar(200) COMMENT '项目主题',
  service_target varchar(50) COMMENT '服务对象',
  category varchar(50) COMMENT '物资类别',
  unit varchar(20) COMMENT '计量单位',
  target_qty int DEFAULT 0 COMMENT '目标数量',
  received_qty int DEFAULT 0 COMMENT '已接收数量',
  distributed_qty int DEFAULT 0 COMMENT '已发放数量',
  warehouse_id bigint COMMENT '承接仓库',
  contact_name varchar(50) COMMENT '联系人',
  contact_phone varchar(20) COMMENT '联系电话',
  deadline date COMMENT '截止日期',
  public_desc text COMMENT '公开说明',
  cover_image varchar(200) COMMENT '项目封面',
  status varchar(20) COMMENT '项目状态',
  publisher_id bigint COMMENT '发布人',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='捐赠项目';

DROP TABLE IF EXISTS `material_demand`;
CREATE TABLE `material_demand` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  demand_no varchar(50) COMMENT '需求编号',
  project_id bigint COMMENT '关联项目',
  material_name varchar(100) COMMENT '物资名称',
  category varchar(50) COMMENT '物资类别',
  spec varchar(100) COMMENT '规格',
  unit varchar(20) COMMENT '单位',
  accept_quality varchar(50) COMMENT '可接收质量',
  shelf_life_req varchar(100) COMMENT '保质期要求',
  demand_qty int DEFAULT 0 COMMENT '需求数量',
  received_qty int DEFAULT 0 COMMENT '已入库数量',
  gap_qty int DEFAULT 0 COMMENT '当前缺口',
  urgency varchar(20) COMMENT '紧迫度',
  status varchar(20) COMMENT '状态',
  remark varchar(500) COMMENT '备注',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物资与需求';

DROP TABLE IF EXISTS `donation_intent`;
CREATE TABLE `donation_intent` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  intent_no varchar(50) COMMENT '意向编号',
  project_id bigint COMMENT '关联项目',
  donor_id bigint COMMENT '捐赠人账号',
  donor_name varchar(100) COMMENT '捐赠人/单位',
  donor_type varchar(20) COMMENT '捐赠人类型',
  material_name varchar(100) COMMENT '物资名称',
  category varchar(50) COMMENT '物资类别',
  spec varchar(100) COMMENT '规格',
  unit varchar(20) COMMENT '单位',
  est_qty int DEFAULT 0 COMMENT '预估数量',
  quality_level varchar(50) COMMENT '新旧程度',
  delivery_type varchar(50) COMMENT '送达方式',
  appoint_time datetime COMMENT '预约送达时间',
  contact_phone varchar(20) COMMENT '联系电话',
  status varchar(20) COMMENT '意向状态',
  precheck_opinion varchar(500) COMMENT '预审意见',
  position varchar(50) COMMENT '预计仓位',
  reject_reason varchar(500) COMMENT '拒收理由',
  auditor_id bigint COMMENT '预审人',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='捐赠意向';

DROP TABLE IF EXISTS `receiving_record`;
CREATE TABLE `receiving_record` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  receive_no varchar(50) COMMENT '收货单号',
  intent_id bigint COMMENT '关联意向',
  warehouse_id bigint COMMENT '收货仓库',
  receive_user_id bigint COMMENT '验收人',
  receive_time datetime COMMENT '验收时间',
  expect_qty int DEFAULT 0 COMMENT '应收数量',
  actual_qty int DEFAULT 0 COMMENT '实收数量',
  qualified_qty int DEFAULT 0 COMMENT '合格数量',
  unqualified_qty int DEFAULT 0 COMMENT '不合格数量',
  unqualified_rate decimal(12,2) COMMENT '不合格率',
  quality_level varchar(50) COMMENT '质量等级',
  expire_date date COMMENT '有效期至',
  photos text COMMENT '现场照片',
  diff_reason varchar(500) COMMENT '差异说明',
  result varchar(20) COMMENT '接收结论',
  status varchar(20) COMMENT '状态',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收货验收';

DROP TABLE IF EXISTS `receiving_item`;
CREATE TABLE `receiving_item` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  receive_id bigint COMMENT '收货单',
  material_name varchar(100) COMMENT '实际品名',
  category varchar(50) COMMENT '物资类别',
  spec varchar(100) COMMENT '规格',
  unit varchar(20) COMMENT '单位',
  expect_qty int DEFAULT 0 COMMENT '应收',
  actual_qty int DEFAULT 0 COMMENT '实收',
  quality_level varchar(50) COMMENT '质量等级',
  expire_date date COMMENT '有效期至',
  unqualified_qty int DEFAULT 0 COMMENT '不合格数',
  diff_qty int DEFAULT 0 COMMENT '差异',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收货明细';

DROP TABLE IF EXISTS `inventory_batch`;
CREATE TABLE `inventory_batch` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  batch_no varchar(50) COMMENT '批次编号',
  material_name varchar(100) COMMENT '物资名称',
  category varchar(50) COMMENT '物资类别',
  spec varchar(100) COMMENT '规格',
  unit varchar(20) COMMENT '单位',
  project_id bigint COMMENT '来源项目',
  intent_id bigint COMMENT '来源意向',
  receive_id bigint COMMENT '来源收货单',
  donor_name varchar(100) COMMENT '捐赠方',
  warehouse_id bigint COMMENT '所在仓库',
  position varchar(50) COMMENT '货位',
  in_qty int DEFAULT 0 COMMENT '入库数量',
  available_qty int DEFAULT 0 COMMENT '可用数量',
  locked_qty int DEFAULT 0 COMMENT '锁定数量',
  quality_level varchar(50) COMMENT '质量等级',
  material_image varchar(200) COMMENT '物资图片',
  produce_date date COMMENT '生产日期',
  expire_date date COMMENT '有效期至',
  in_time datetime COMMENT '入库时间',
  status varchar(20) COMMENT '库存状态',
  issue_status varchar(20) COMMENT '发放状态',
  check_user_id bigint COMMENT '验收人',
  price_ref decimal(12,2) COMMENT '参考单价',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物资入库批次';

DROP TABLE IF EXISTS `aid_beneficiary`;
CREATE TABLE `aid_beneficiary` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  beneficiary_no varchar(50) COMMENT '档案编号',
  name varchar(50) COMMENT '姓名',
  id_card varchar(50) COMMENT '身份证号',
  phone varchar(20) COMMENT '联系电话',
  gender varchar(10) COMMENT '性别',
  birth_year int DEFAULT 0 COMMENT '出生年份',
  family_size int DEFAULT 0 COMMENT '家庭人数',
  address varchar(200) COMMENT '家庭住址',
  region varchar(50) COMMENT '所属区域',
  org_id bigint COMMENT '所属组织',
  family_income decimal(12,2) COMMENT '家庭月收入',
  qualified tinyint DEFAULT 0 COMMENT '是否资格认定',
  qualified_date date COMMENT '认定日期',
  cert_files text COMMENT '证明材料',
  urgent_level varchar(20) COMMENT '紧迫等级',
  status varchar(20) COMMENT '状态',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='受助人档案';

DROP TABLE IF EXISTS `aid_application`;
CREATE TABLE `aid_application` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  apply_no varchar(50) COMMENT '申请编号',
  beneficiary_id bigint COMMENT '受助人',
  apply_type varchar(20) COMMENT '申请类型',
  applicant_name varchar(50) COMMENT '申请人',
  id_card varchar(50) COMMENT '身份证号',
  phone varchar(20) COMMENT '联系电话',
  family_size int DEFAULT 0 COMMENT '家庭人数',
  region varchar(50) COMMENT '所属区域',
  urgency_level varchar(20) COMMENT '紧迫等级',
  purpose varchar(500) COMMENT '用途说明',
  cert_files text COMMENT '证明材料',
  apply_time datetime COMMENT '申请时间',
  status varchar(20) COMMENT '申请状态',
  auditor_id bigint COMMENT '审核员',
  audit_time datetime COMMENT '审核时间',
  audit_opinion varchar(500) COMMENT '审核意见',
  reject_reason varchar(500) COMMENT '退回理由',
  distribute_type varchar(20) COMMENT '发放方式',
  agent_name varchar(50) COMMENT '代办人',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='受助申请';

DROP TABLE IF EXISTS `aid_application_item`;
CREATE TABLE `aid_application_item` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  application_id bigint COMMENT '受助申请',
  material_name varchar(100) COMMENT '物资名称',
  category varchar(50) COMMENT '物资类别',
  spec varchar(100) COMMENT '规格',
  unit varchar(20) COMMENT '单位',
  apply_qty int DEFAULT 0 COMMENT '申请数量',
  approve_qty int DEFAULT 0 COMMENT '批准数量',
  remark varchar(200) COMMENT '说明',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='申请需求明细';

DROP TABLE IF EXISTS `distribution_order`;
CREATE TABLE `distribution_order` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  order_no varchar(50) COMMENT '发放单号',
  application_id bigint COMMENT '受助申请',
  beneficiary_id bigint COMMENT '受助人',
  receiver_name varchar(50) COMMENT '领取人',
  receiver_phone varchar(20) COMMENT '联系电话',
  region varchar(50) COMMENT '所属区域',
  stage varchar(20) COMMENT '当前阶段',
  status varchar(20) COMMENT '单据状态',
  warehouse_id bigint COMMENT '发放仓库',
  owner_id bigint COMMENT '责任人',
  deliver_type varchar(20) COMMENT '发放方式',
  deliver_address varchar(200) COMMENT '配送地址',
  carrier varchar(50) COMMENT '运送人',
  total_qty int DEFAULT 0 COMMENT '合计数量',
  deadline datetime COMMENT '截止时间',
  finish_time datetime COMMENT '完成时间',
  cancel_reason varchar(500) COMMENT '作废/取消原因',
  score_id bigint COMMENT '分配建议',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='发放追踪单';

DROP TABLE IF EXISTS `distribution_item`;
CREATE TABLE `distribution_item` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  order_id bigint COMMENT '发放单',
  batch_id bigint COMMENT '批次',
  material_name varchar(100) COMMENT '物资名称',
  spec varchar(100) COMMENT '规格',
  unit varchar(20) COMMENT '单位',
  plan_qty int DEFAULT 0 COMMENT '计划数量',
  actual_qty int DEFAULT 0 COMMENT '实际数量',
  pick_time datetime COMMENT '拣货时间',
  remark varchar(200) COMMENT '备注',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='发放明细';

DROP TABLE IF EXISTS `beneficiary_feedback`;
CREATE TABLE `beneficiary_feedback` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  feedback_no varchar(50) COMMENT '反馈编号',
  order_id bigint COMMENT '发放单',
  application_id bigint COMMENT '受助申请',
  submitter varchar(50) COMMENT '提交人',
  submitter_type varchar(20) COMMENT '提交人类型',
  feedback_type varchar(20) COMMENT '反馈类型',
  content varchar(500) COMMENT '反馈内容',
  photos text COMMENT '照片',
  public_flag tinyint DEFAULT 0 COMMENT '是否同意公开',
  audit_status varchar(20) COMMENT '审核状态',
  audit_user_id bigint COMMENT '审核人',
  audit_time datetime COMMENT '审核时间',
  audit_opinion varchar(500) COMMENT '审核意见',
  sensitive_hit varchar(200) COMMENT '敏感词命中',
  region varchar(50) COMMENT '所属区域',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='去向反馈';

DROP TABLE IF EXISTS `charity_material_record`;
CREATE TABLE `charity_material_record` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  biz_type varchar(50) COMMENT '业务类型',
  biz_id bigint COMMENT '业务主键',
  biz_no varchar(50) COMMENT '业务编号',
  from_status varchar(50) COMMENT '变更前状态',
  to_status varchar(50) COMMENT '变更后状态',
  action varchar(50) COMMENT '操作动作',
  reason varchar(500) COMMENT '原因',
  operator_id bigint COMMENT '操作人',
  operator_name varchar(50) COMMENT '操作人姓名',
  operate_time datetime COMMENT '操作时间',
  remark varchar(500) COMMENT '备注',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='过程记录与状态流转';

DROP TABLE IF EXISTS `charity_material_attachment`;
CREATE TABLE `charity_material_attachment` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  biz_type varchar(50) COMMENT '业务类型',
  biz_id bigint COMMENT '业务主键',
  file_name varchar(200) COMMENT '原始文件名',
  file_path varchar(200) COMMENT '相对路径',
  file_size bigint COMMENT '文件大小',
  content_type varchar(50) COMMENT '文件类型',
  uploader_id bigint COMMENT '上传人',
  upload_time datetime COMMENT '上传时间',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='附件与图片';

DROP TABLE IF EXISTS `charity_material_rule`;
CREATE TABLE `charity_material_rule` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  rule_no varchar(50) COMMENT '规则编号',
  rule_name varchar(100) COMMENT '规则名称',
  rule_version varchar(20) COMMENT '版本号',
  factor_json text COMMENT '因素与权重',
  weight_total decimal(12,2) COMMENT '权重合计',
  threshold_json text COMMENT '等级阈值',
  status varchar(20) COMMENT '状态',
  effect_time datetime COMMENT '生效时间',
  publisher_id bigint COMMENT '发布人',
  change_note varchar(500) COMMENT '变更说明',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分配规则';

DROP TABLE IF EXISTS `charity_material_score`;
CREATE TABLE `charity_material_score` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  score_no varchar(50) COMMENT '计算编号',
  application_id bigint COMMENT '受助申请',
  order_id bigint COMMENT '发放单',
  rule_id bigint COMMENT '规则',
  rule_version varchar(20) COMMENT '规则版本',
  snapshot_json text COMMENT '输入快照',
  factor_json text COMMENT '逐项得分',
  total_score decimal(12,2) COMMENT '总分',
  result_level varchar(20) COMMENT '结果等级',
  suggestion varchar(500) COMMENT '建议发放',
  unmet varchar(500) COMMENT '未满足条件',
  improve varchar(500) COMMENT '可改进项',
  calc_time datetime COMMENT '计算时间',
  adjust_flag tinyint DEFAULT 0 COMMENT '是否人工调整',
  adjust_reason varchar(500) COMMENT '调整原因',
  adjust_user_id bigint COMMENT '调整人',
  adjust_time datetime COMMENT '调整时间',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分配建议计算';

DROP TABLE IF EXISTS `inventory_check`;
CREATE TABLE `inventory_check` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  check_no varchar(50) COMMENT '盘点单号',
  warehouse_id bigint COMMENT '仓库',
  position varchar(50) COMMENT '货位',
  batch_id bigint COMMENT '批次',
  book_qty int DEFAULT 0 COMMENT '账面数量',
  real_qty int DEFAULT 0 COMMENT '实盘数量',
  diff_qty int DEFAULT 0 COMMENT '差异数量',
  check_user_id bigint COMMENT '盘点人',
  check_time datetime COMMENT '盘点时间',
  status varchar(20) COMMENT '状态',
  remark varchar(200) COMMENT '备注',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存盘点';

DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  username varchar(50) COMMENT '登录账号',
  password varchar(100) COMMENT '密码（BCrypt）',
  real_name varchar(50) COMMENT '姓名',
  avatar varchar(200) COMMENT '头像',
  phone varchar(20) COMMENT '手机号',
  email varchar(100) COMMENT '邮箱',
  org_id bigint COMMENT '所属组织',
  role_id bigint COMMENT '角色',
  role_code varchar(50) COMMENT '角色编码',
  data_scope varchar(20) COMMENT '数据范围',
  status varchar(20) COMMENT '状态',
  login_fail_count int DEFAULT 0 COMMENT '连续失败次数',
  lock_time datetime COMMENT '锁定时间',
  last_login_time datetime COMMENT '最近登录',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户';

DROP TABLE IF EXISTS `sys_org`;
CREATE TABLE `sys_org` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  org_name varchar(100) COMMENT '组织名称',
  org_code varchar(50) COMMENT '组织编码',
  org_type varchar(20) COMMENT '组织类型',
  parent_id bigint COMMENT '上级组织',
  delivery_capacity varchar(20) COMMENT '配送能力',
  address varchar(200) COMMENT '地址',
  leader varchar(50) COMMENT '负责人',
  phone varchar(20) COMMENT '联系电话',
  status varchar(20) COMMENT '状态',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='组织';

DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  role_code varchar(50) COMMENT '角色编码',
  role_name varchar(50) COMMENT '角色名称',
  data_scope varchar(20) COMMENT '数据范围',
  remark varchar(200) COMMENT '说明',
  status varchar(20) COMMENT '状态',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色';

DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  parent_id bigint COMMENT '上级菜单',
  menu_name varchar(50) COMMENT '菜单名称',
  menu_type varchar(20) COMMENT '类型',
  path varchar(100) COMMENT '路由',
  perms varchar(100) COMMENT '权限标识',
  icon varchar(50) COMMENT '图标',
  sort_no int DEFAULT 0 COMMENT '排序',
  visible tinyint DEFAULT 0 COMMENT '是否可见',
  status varchar(20) COMMENT '状态',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单';

DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  role_id bigint COMMENT '角色',
  menu_id bigint COMMENT '菜单',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色菜单';

DROP TABLE IF EXISTS `sys_message`;
CREATE TABLE `sys_message` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  title varchar(100) COMMENT '标题',
  content varchar(500) COMMENT '内容',
  msg_type varchar(20) COMMENT '消息类型',
  biz_type varchar(50) COMMENT '业务类型',
  biz_no varchar(50) COMMENT '业务编号',
  biz_id bigint COMMENT '业务主键',
  biz_url varchar(200) COMMENT '详情跳转',
  receiver_id bigint COMMENT '接收人',
  read_flag tinyint DEFAULT 0 COMMENT '是否已读',
  read_time datetime COMMENT '阅读时间',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='站内消息';

DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  dict_type varchar(50) COMMENT '字典类型',
  dict_code varchar(50) COMMENT '字典编码',
  dict_label varchar(50) COMMENT '字典名称',
  sort_no int DEFAULT 0 COMMENT '排序',
  status varchar(20) COMMENT '状态',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据字典';

DROP TABLE IF EXISTS `sys_file`;
CREATE TABLE `sys_file` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  file_name varchar(200) COMMENT '原始文件名',
  file_path varchar(200) COMMENT '相对路径',
  file_size bigint COMMENT '文件大小',
  content_type varchar(50) COMMENT '文件类型',
  biz_type varchar(50) COMMENT '业务类型',
  uploader_id bigint COMMENT '上传人',
  upload_time datetime COMMENT '上传时间',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文件';

DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log` (
  id bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  user_id bigint COMMENT '操作人',
  user_name varchar(50) COMMENT '操作人姓名',
  role_code varchar(50) COMMENT '角色',
  module varchar(50) COMMENT '模块',
  action varchar(50) COMMENT '操作',
  biz_no varchar(50) COMMENT '业务编号',
  from_status varchar(50) COMMENT '原状态',
  to_status varchar(50) COMMENT '新状态',
  ip varchar(50) COMMENT 'IP',
  result varchar(50) COMMENT '结果',
  operate_time datetime COMMENT '操作时间',
  create_time datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  deleted tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  version int NOT NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志';

-- sys_org: 6 行
INSERT INTO `sys_org` (`id`,`org_name`,`org_code`,`org_type`,`parent_id`,`delivery_capacity`,`address`,`leader`,`phone`,`status`,`create_time`) VALUES (1,'总会秘书处','ORG-001','总会',0,'高','杭州市拱墅区公益路 18 号','陈砚秋','0571-88010001','启用','2026-05-12 16:51:18');
INSERT INTO `sys_org` (`id`,`org_name`,`org_code`,`org_type`,`parent_id`,`delivery_capacity`,`address`,`leader`,`phone`,`status`,`create_time`) VALUES (2,'城西公益仓','ORG-002','仓库',1,'高','杭州市西湖区文一西路 826 号','周慧兰','0571-88010002','启用','2026-05-13 17:01:39');
INSERT INTO `sys_org` (`id`,`org_name`,`org_code`,`org_type`,`parent_id`,`delivery_capacity`,`address`,`leader`,`phone`,`status`,`create_time`) VALUES (3,'东湖公益仓','ORG-003','仓库',1,'中','杭州市临平区东湖街道兴国路 66 号','周慧兰','0571-88010003','启用','2026-05-14 18:52:13');
INSERT INTO `sys_org` (`id`,`org_name`,`org_code`,`org_type`,`parent_id`,`delivery_capacity`,`address`,`leader`,`phone`,`status`,`create_time`) VALUES (4,'南苑公益仓','ORG-004','仓库',1,'中','杭州市上城区南苑街道秋涛路 128 号','许文山','0571-88010004','启用','2026-05-15 12:03:25');
INSERT INTO `sys_org` (`id`,`org_name`,`org_code`,`org_type`,`parent_id`,`delivery_capacity`,`address`,`leader`,`phone`,`status`,`create_time`) VALUES (5,'北岭服务站','ORG-005','服务站',1,'低','杭州市拱墅区北岭街道石桥路 32 号','柳知远','0571-88010005','启用','2026-05-16 14:41:08');
INSERT INTO `sys_org` (`id`,`org_name`,`org_code`,`org_type`,`parent_id`,`delivery_capacity`,`address`,`leader`,`phone`,`status`,`create_time`) VALUES (6,'开发区驿站','ORG-006','服务站',1,'低','杭州市钱塘区下沙街道学源街 8 号','王凤娟','0571-88010006','启用','2026-05-17 09:29:00');
-- sys_role: 4 行
INSERT INTO `sys_role` (`id`,`role_code`,`role_name`,`data_scope`,`remark`,`status`,`create_time`) VALUES (1,'ADMIN','项目管理员','ALL','发布需求、管理项目与仓库、审批与公开报表','启用','2026-05-13 16:59:15');
INSERT INTO `sys_role` (`id`,`role_code`,`role_name`,`data_scope`,`remark`,`status`,`create_time`) VALUES (2,'VOLUNTEER','仓储志愿者','SELF','收货验收、分批入库、拣货盘点','启用','2026-05-13 08:04:10');
INSERT INTO `sys_role` (`id`,`role_code`,`role_name`,`data_scope`,`remark`,`status`,`create_time`) VALUES (3,'AUDITOR','受助审核员','DEPT','资格与反重审核、批准数量','启用','2026-05-13 17:33:58');
INSERT INTO `sys_role` (`id`,`role_code`,`role_name`,`data_scope`,`remark`,`status`,`create_time`) VALUES (4,'DONOR','捐赠人/单位','SELF','查看需求、提交捐赠意向、查看去向反馈','启用','2026-05-13 14:53:41');
-- sys_user: 12 行
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (1,'admin','admin123','陈砚秋','/uploads/seed/avatar/02.jpg','13800130021','chenyq@charity.org.cn',1,1,'ADMIN','ALL','启用',0,'2026-05-03 16:56:04','2026-05-07 14:01:15');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (2,'chenyq2','123456','陈立群','/uploads/seed/avatar/03.jpg','13800130022','chenlq@charity.org.cn',1,1,'ADMIN','ALL','启用',0,'2026-05-03 14:36:06','2026-05-08 18:17:40');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (3,'zhouhl','123456','周慧兰','/uploads/seed/avatar/04.jpg','13900134417','zhouhl@charity.org.cn',2,3,'AUDITOR','DEPT','启用',0,'2026-05-01 17:31:59','2026-05-09 12:08:53');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (4,'qianxy','123456','钱雪莹','/uploads/seed/avatar/05.jpg','13900134418','qianxy@charity.org.cn',3,3,'AUDITOR','DEPT','启用',0,'2026-05-03 12:16:32','2026-05-10 09:08:15');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (5,'xuwsh','123456','许文山','/uploads/seed/avatar/06.jpg','13700138823','xuwsh@charity.org.cn',2,2,'VOLUNTEER','SELF','启用',0,'2026-05-03 09:49:01','2026-05-11 14:58:47');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (6,'liuzy','123456','柳知远','/uploads/seed/avatar/01.jpg','13600131109','liuzy@charity.org.cn',5,2,'VOLUNTEER','SELF','启用',0,'2026-05-03 10:33:41','2026-05-12 10:30:41');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (7,'wangfj','123456','王凤娟','/uploads/seed/avatar/02.jpg','13300137781','wangfj@charity.org.cn',4,2,'VOLUNTEER','SELF','启用',0,'2026-05-03 16:28:55','2026-05-13 18:21:33');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (8,'guomz','123456','郭明泽','/uploads/seed/avatar/03.jpg','13500136602','guomz@qinghe.com',1,4,'DONOR','SELF','启用',0,'2026-05-03 09:01:59','2026-05-14 18:06:30');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (9,'linsx','123456','林素心','/uploads/seed/avatar/04.jpg','18800133345','linsx@163.com',1,4,'DONOR','SELF','启用',0,'2026-05-04 12:59:30','2026-05-15 12:37:16');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (10,'zhaoyq','123456','赵雨琪','/uploads/seed/avatar/05.jpg','18800133346','zhaoyq@163.com',1,4,'DONOR','SELF','启用',0,'2026-05-02 18:11:52','2026-05-16 10:32:18');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (11,'sunq','123456','孙启明','/uploads/seed/avatar/06.jpg','18800133347','sunqm@163.com',1,4,'DONOR','SELF','启用',0,'2026-05-04 18:14:59','2026-05-17 11:30:23');
INSERT INTO `sys_user` (`id`,`username`,`password`,`real_name`,`avatar`,`phone`,`email`,`org_id`,`role_id`,`role_code`,`data_scope`,`status`,`login_fail_count`,`last_login_time`,`create_time`) VALUES (12,'hejy','123456','何佳颖','/uploads/seed/avatar/01.jpg','18800133348','hejy@163.com',1,4,'DONOR','SELF','启用',0,'2026-05-04 19:52:39','2026-05-18 12:32:24');
-- sys_menu: 28 行
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (1,0,'公益物资看板','菜单','/dashboard','dashboard:view','grid',1,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (2,0,'捐赠管理','目录','donation','','heart',2,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (3,2,'捐赠项目','菜单','/project-list','project:list','',1,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (4,2,'物资与需求','菜单','/demand-list','demand:list','',2,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (5,2,'捐赠意向','菜单','/intent-list','intent:list','',3,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (6,0,'仓储管理','目录','warehouse','','box',3,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (7,6,'收货验收','菜单','/receiving','receiving:list','',1,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (8,6,'物资批次台账','菜单','/batch-list','batch:list','',2,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (9,6,'拣货发放','菜单','/distribute','distribute:list','',3,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (10,0,'受助管理','目录','aid','','user',4,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (11,10,'受助需求池','菜单','/application-list','application:list','',1,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (12,10,'资格与反重审核','菜单','/application-review','application:review','',2,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (13,10,'发放追踪单','菜单','/distribution-list','distribution:list','',3,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (14,10,'去向反馈','菜单','/feedback-list','feedback:list','',4,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (15,0,'创新模块','目录','innovation','','chart',5,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (16,15,'分配规则配置','菜单','/rule-config','rule:config','',1,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (17,15,'分配建议解释','菜单','/score-detail','score:detail','',2,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (18,0,'公开与报表','目录','report','','chart',6,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (19,18,'公开报表','菜单','/report','report:view','',1,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (20,0,'系统管理','目录','system','','gear',9,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (21,20,'用户管理','菜单','/user-list','user:list','',1,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (22,20,'角色管理','菜单','/role-list','role:list','',2,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (23,20,'菜单管理','菜单','/menu-list','menu:list','',3,0,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (24,20,'操作日志','菜单','/log-list','log:list','',4,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (25,0,'消息中心','菜单','/message','message:list','bell',7,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (26,0,'个人中心','菜单','/profile','profile:view','user',8,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (27,6,'库存盘点','菜单','/inventory-check','check:list','',4,1,'启用');
INSERT INTO `sys_menu` (`id`,`parent_id`,`menu_name`,`menu_type`,`path`,`perms`,`icon`,`sort_no`,`visible`,`status`) VALUES (28,10,'受助人档案','菜单','/beneficiary-list','beneficiary:list','',5,1,'启用');
-- sys_role_menu: 59 行
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (1,1,1);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (2,1,2);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (3,1,3);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (4,1,4);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (5,1,5);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (6,1,6);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (7,1,7);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (8,1,8);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (9,1,9);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (10,1,10);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (11,1,11);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (12,1,12);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (13,1,13);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (14,1,14);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (15,1,15);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (16,1,16);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (17,1,17);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (18,1,18);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (19,1,19);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (20,1,20);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (21,1,21);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (22,1,22);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (23,1,23);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (24,1,24);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (25,1,25);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (26,1,26);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (27,1,27);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (28,1,28);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (29,2,1);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (30,2,6);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (31,2,7);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (32,2,8);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (33,2,9);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (34,2,25);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (35,2,26);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (36,2,27);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (37,3,1);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (38,3,10);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (39,3,11);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (40,3,12);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (41,3,13);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (42,3,14);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (43,3,15);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (44,3,16);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (45,3,17);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (46,3,18);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (47,3,19);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (48,3,25);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (49,3,26);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (50,3,28);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (51,4,1);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (52,4,2);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (53,4,3);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (54,4,4);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (55,4,5);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (56,4,18);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (57,4,19);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (58,4,25);
INSERT INTO `sys_role_menu` (`id`,`role_id`,`menu_id`) VALUES (59,4,26);
-- sys_dict: 37 行
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (1,'material_category','C01','米面粮油',1,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (2,'material_category','C02','御寒衣物',2,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (3,'material_category','C03','学习用品',3,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (4,'material_category','C04','日用清洁',4,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (5,'material_category','C05','医疗护理',5,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (6,'material_category','C06','其他',6,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (11,'intent_status','S01','待预审',1,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (12,'intent_status','S02','待送达',2,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (13,'intent_status','S03','待验收',3,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (14,'intent_status','S04','已入库',4,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (15,'intent_status','S05','部分接收',5,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (16,'intent_status','S06','已拒收',6,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (17,'apply_status','A01','待审核',1,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (18,'apply_status','A02','待拣货',2,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (19,'apply_status','A03','待领用',3,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (20,'apply_status','A04','待配送',4,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (21,'apply_status','A05','待反馈',5,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (22,'apply_status','A06','已完成',6,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (23,'apply_status','A07','已退回',7,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (24,'apply_status','A08','已取消',8,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (25,'batch_status','B01','正常',1,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (26,'batch_status','B02','临期',2,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (27,'batch_status','B03','过期',3,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (28,'batch_status','B04','锁定',4,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (29,'urgency_level','U01','特急',1,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (30,'urgency_level','U02','紧急',2,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (31,'urgency_level','U03','一般',3,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (32,'quality_level','Q01','A 级',1,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (33,'quality_level','Q02','B 级',2,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (34,'quality_level','Q03','C 级',3,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (35,'deliver_type','D01','现场领用',1,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (36,'deliver_type','D02','配送上门',2,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (40,'region','R01','城西街道',1,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (41,'region','R02','东湖街道',2,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (42,'region','R03','南苑街道',3,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (43,'region','R04','北岭街道',4,'启用');
INSERT INTO `sys_dict` (`id`,`dict_type`,`dict_code`,`dict_label`,`sort_no`,`status`) VALUES (44,'region','R05','开发区',5,'启用');
-- donation_project: 14 行
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-001','春苗阅读·图书角','留守儿童','学习用品','册',600,604,604,3,'陈砚秋','0571-88010001','2026-09-22','本项目面向留守儿童，募集学习用品类物资，由东湖公益仓承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/01.jpg','已归档',1,'2026-05-03 18:40:58','2026-05-07 14:19:51');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-002','清凉一夏·防暑物资','户外劳动者','日用清洁','件',900,906,906,3,'周慧兰','0571-88010002','2026-09-21','本项目面向户外劳动者，募集日用清洁类物资，由东湖公益仓承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/02.jpg','已归档',1,'2026-05-11 18:53:44','2026-05-15 15:23:19');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-003','银龄关怀·营养补给','独居老人','米面粮油','件',900,612,486,5,'许文山','0571-88010003','2026-12-01','本项目面向独居老人，募集米面粮油类物资，由北岭服务站承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/03.jpg','进行中',1,'2026-05-19 16:08:46','2026-05-23 10:18:33');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-004','无障碍生活·辅具支持','残障人士','医疗护理','件',320,148,96,5,'陈砚秋','0571-88010004','2026-12-06','本项目面向残障人士，募集医疗护理类物资，由北岭服务站承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/04.jpg','进行中',1,'2026-05-27 13:01:44','2026-05-31 11:07:49');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-005','开学第一课·学习用品','留守儿童','学习用品','件',1500,1502,1386,3,'周慧兰','0571-88010005','2026-12-11','本项目面向留守儿童，募集学习用品类物资，由东湖公益仓承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/01.jpg','进行中',1,'2026-06-04 13:35:02','2026-06-08 17:35:58');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-006','暖冬计划·御寒物资包','低保家庭','御寒衣物','件',2000,1486,1032,2,'许文山','0571-88010006','2026-12-16','本项目面向低保家庭，募集御寒衣物类物资，由城西公益仓承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/02.jpg','进行中',1,'2026-06-12 12:54:25','2026-06-16 19:50:52');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-007','社区爱心角·日常补给','社区居民','日用清洁','件',1200,842,690,4,'陈砚秋','0571-88010007','2026-12-21','本项目面向社区居民，募集日用清洁类物资，由南苑公益仓承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/03.jpg','进行中',1,'2026-06-20 18:34:02','2026-06-24 19:28:42');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-008','困境儿童·营养早餐','困境儿童','米面粮油','件',800,486,372,4,'周慧兰','0571-88010008','2026-12-26','本项目面向困境儿童，募集米面粮油类物资，由南苑公益仓承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/04.jpg','进行中',1,'2026-06-28 08:09:52','2026-07-02 17:31:39');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-009','失能老人·护理支持','失能老人','医疗护理','件',600,214,128,2,'许文山','0571-88010009','2026-12-31','本项目面向失能老人，募集医疗护理类物资，由城西公益仓承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/01.jpg','进行中',1,'2026-07-06 13:16:28','2026-07-10 16:08:08');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-010','新市民·安家物资','新市民家庭','米面粮油','件',500,268,180,5,'陈砚秋','0571-88010010','2027-01-05','本项目面向新市民家庭，募集米面粮油类物资，由北岭服务站承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/02.jpg','进行中',1,'2026-07-14 14:33:04','2026-07-18 19:58:21');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-011','暖冬计划·儿童棉衣','困境儿童','御寒衣物','件',700,312,204,2,'周慧兰','0571-88010011','2027-01-10','本项目面向困境儿童，募集御寒衣物类物资，由城西公益仓承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/03.jpg','进行中',1,'2026-07-22 08:12:26','2026-07-26 17:30:00');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-012','书香社区·共享阅读','社区居民','学习用品','册',400,402,402,3,'许文山','0571-88010012','2026-09-11','本项目面向社区居民，募集学习用品类物资，由东湖公益仓承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/04.jpg','已归档',1,'2026-07-30 10:27:04','2026-08-03 14:15:48');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-013','环卫工人·冬日关怀','户外劳动者','御寒衣物','件',300,128,62,5,'陈砚秋','0571-88010013','2027-01-20','本项目面向户外劳动者，募集御寒衣物类物资，由北岭服务站承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/01.jpg','进行中',1,'2026-08-07 12:48:19','2026-08-11 17:00:57');
INSERT INTO `donation_project` (`project_no`,`title`,`service_target`,`category`,`unit`,`target_qty`,`received_qty`,`distributed_qty`,`warehouse_id`,`contact_name`,`contact_phone`,`deadline`,`public_desc`,`cover_image`,`status`,`publisher_id`,`create_time`,`update_time`) VALUES ('PRJ-2026-014','应急储备·家庭物资包','应急家庭','米面粮油','件',1000,615,420,4,'周慧兰','0571-88010014','2027-01-25','本项目面向应急家庭，募集米面粮油类物资，由南苑公益仓承接，物资按先到期先出库原则发放，发放去向在公开报表中脱敏展示。','/uploads/seed/project/02.jpg','进行中',1,'2026-08-15 13:21:00','2026-08-19 15:48:28');
-- material_demand: 26 行
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0301',1,'一级压榨菜籽油','米面粮油','5L / 桶','桶','全新','≥ 12 个月',406,189,217,'特急','缺口','2026-05-01 15:36:46');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0302',2,'东北长粒香米','米面粮油','10kg / 袋','袋','全新','≥ 10 个月',563,162,401,'紧急','缺口','2026-05-07 13:30:24');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0303',3,'加厚羽绒服（成人）','御寒衣物','M/L/XL','件','九成新以上','不适用',416,143,273,'一般','缺口','2026-05-13 15:47:06');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0304',4,'儿童棉衣','御寒衣物','110-150','件','九成新以上','不适用',418,207,211,'特急','缺口','2026-05-19 10:10:44');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0305',5,'学生护眼台灯','学习用品','USB 供电','台','全新','不适用',1260,576,684,'紧急','缺口','2026-05-25 18:43:36');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0306',6,'课外读物','学习用品','适龄读物','册','八成新以上','不适用',539,414,125,'一般','缺口','2026-05-31 19:23:33');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0307',7,'洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶','全新','≥ 24 个月',1289,551,738,'特急','缺口','2026-06-06 17:22:09');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0308',8,'成人纸尿裤','医疗护理','L 码 20 片','包','全新','≥ 18 个月',1381,512,869,'紧急','缺口','2026-06-12 19:39:38');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0309',9,'轮椅','医疗护理','折叠式','台','八成新以上','不适用',481,147,334,'一般','缺口','2026-06-18 09:38:59');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0310',10,'棉被','御寒衣物','200×230','床','九成新以上','不适用',655,288,367,'特急','缺口','2026-06-24 16:09:12');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0311',11,'一级压榨菜籽油','米面粮油','5L / 桶','桶','全新','≥ 12 个月',537,228,309,'紧急','缺口','2026-06-30 11:18:01');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0312',12,'东北长粒香米','米面粮油','10kg / 袋','袋','全新','≥ 10 个月',1048,790,258,'一般','缺口','2026-07-06 08:52:25');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0313',13,'加厚羽绒服（成人）','御寒衣物','M/L/XL','件','九成新以上','不适用',763,594,169,'特急','缺口','2026-07-12 09:30:17');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0314',14,'儿童棉衣','御寒衣物','110-150','件','九成新以上','不适用',400,205,195,'紧急','缺口','2026-07-18 15:35:05');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0315',1,'学生护眼台灯','学习用品','USB 供电','台','全新','不适用',1160,1046,114,'一般','缺口','2026-07-24 09:15:02');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0316',2,'课外读物','学习用品','适龄读物','册','八成新以上','不适用',1348,1179,169,'特急','缺口','2026-07-30 15:39:54');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0317',3,'洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶','全新','≥ 24 个月',625,400,225,'紧急','缺口','2026-08-05 10:07:30');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0318',4,'成人纸尿裤','医疗护理','L 码 20 片','包','全新','≥ 18 个月',1476,1138,338,'一般','缺口','2026-08-11 08:35:49');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0319',5,'轮椅','医疗护理','折叠式','台','八成新以上','不适用',350,162,188,'特急','缺口','2026-08-17 16:28:20');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0320',6,'棉被','御寒衣物','200×230','床','九成新以上','不适用',1190,798,392,'紧急','缺口','2026-08-23 14:04:12');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0321',7,'一级压榨菜籽油','米面粮油','5L / 桶','桶','全新','≥ 12 个月',336,110,226,'一般','缺口','2026-08-29 17:39:00');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0322',8,'东北长粒香米','米面粮油','10kg / 袋','袋','全新','≥ 10 个月',348,97,251,'特急','缺口','2026-09-04 18:11:18');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0323',9,'加厚羽绒服（成人）','御寒衣物','M/L/XL','件','九成新以上','不适用',259,167,92,'紧急','缺口','2026-09-10 19:22:44');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0324',10,'儿童棉衣','御寒衣物','110-150','件','九成新以上','不适用',1292,1170,122,'一般','缺口','2026-09-16 11:02:34');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0325',11,'学生护眼台灯','学习用品','USB 供电','台','全新','不适用',1286,267,1019,'特急','缺口','2026-09-22 18:56:40');
INSERT INTO `material_demand` (`demand_no`,`project_id`,`material_name`,`category`,`spec`,`unit`,`accept_quality`,`shelf_life_req`,`demand_qty`,`received_qty`,`gap_qty`,`urgency`,`status`,`create_time`) VALUES ('DMD-0326',12,'课外读物','学习用品','适龄读物','册','八成新以上','不适用',427,384,43,'紧急','缺口','2026-09-28 14:18:17');
-- donation_intent: 46 行
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0862',1,1,'杭州市临平区青禾商贸','企业','一级压榨菜籽油','米面粮油','5L / 桶','桶',87,'全新','自送到仓','2026-10-18 09:00:52','138****1000','待送达','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-10-13 10:33:02');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0861',2,2,'周慧兰（个人）','个人','东北长粒香米','米面粮油','10kg / 袋','袋',97,'全新','志愿者上门取件','2026-10-15 10:00:39','138****1001','已入库','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-10-10 09:30:10');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0860',3,3,'浙江明远律师事务所','企业','加厚羽绒服（成人）','御寒衣物','M/L/XL','件',97,'九成新以上','物流到付','2026-10-12 11:00:14','138****1002','待预审',NULL,'C 区 01 货位',NULL,NULL,'2026-10-07 15:06:01');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0859',4,4,'城西社区爱心志愿队','社会组织','儿童棉衣','御寒衣物','110-150','件',56,'九成新以上','自送到仓','2026-10-09 12:00:40','138****1003','已入库','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-10-04 17:20:39');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0858',5,5,'李泽川（个人）','个人','学生护眼台灯','学习用品','USB 供电','台',77,'全新','志愿者上门取件','2026-10-06 13:00:20','138****1004','待验收','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-10-01 12:23:10');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0857',6,6,'匿名爱心人士','个人','课外读物','学习用品','适龄读物','册',292,'八成新以上','物流到付','2026-10-03 14:00:02','138****1005','待预审',NULL,'C 区 01 货位',NULL,NULL,'2026-09-28 19:27:59');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0856',7,7,'杭州云栖科技有限公司','企业','洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',134,'全新','自送到仓','2026-09-30 15:00:03','138****1006','已入库','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-09-25 09:10:27');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0855',8,8,'孙启明（个人）','个人','成人纸尿裤','医疗护理','L 码 20 片','包',289,'全新','志愿者上门取件','2026-09-27 16:00:02','138****1007','待送达','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-09-22 12:24:19');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0854',9,9,'何佳颖（个人）','个人','轮椅','医疗护理','折叠式','台',188,'八成新以上','物流到付','2026-09-24 09:00:33','138****1008','已入库','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-09-19 12:28:21');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0853',10,10,'赵雨琪（个人）','个人','棉被','御寒衣物','200×230','床',234,'九成新以上','自送到仓','2026-09-21 10:00:06','138****1009','待送达','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-09-16 13:08:42');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0852',11,11,'杭州市临平区青禾商贸','企业','一级压榨菜籽油','米面粮油','5L / 桶','桶',279,'全新','志愿者上门取件','2026-09-18 11:00:14','138****1010','已拒收',NULL,'B 区 02 货位','物资为六成新棉被，超出可接收质量等级（需九成新以上）',1,'2026-09-13 09:19:50');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0851',12,12,'周慧兰（个人）','个人','东北长粒香米','米面粮油','10kg / 袋','袋',150,'全新','物流到付','2026-09-15 12:00:10','138****1011','待送达','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-09-10 14:15:08');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0850',13,1,'浙江明远律师事务所','企业','加厚羽绒服（成人）','御寒衣物','M/L/XL','件',163,'九成新以上','自送到仓','2026-09-12 13:00:51','138****1012','待验收','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-09-07 18:03:53');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0849',14,2,'城西社区爱心志愿队','社会组织','儿童棉衣','御寒衣物','110-150','件',75,'九成新以上','志愿者上门取件','2026-09-09 14:00:56','138****1013','已入库','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-09-04 18:07:27');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0848',1,3,'李泽川（个人）','个人','学生护眼台灯','学习用品','USB 供电','台',189,'全新','物流到付','2026-09-06 15:00:11','138****1014','已入库','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-09-01 13:41:55');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0847',2,4,'匿名爱心人士','个人','课外读物','学习用品','适龄读物','册',28,'八成新以上','自送到仓','2026-09-03 16:00:13','138****1015','待验收','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-08-29 14:58:21');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0846',3,5,'杭州云栖科技有限公司','企业','洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',197,'全新','志愿者上门取件','2026-08-31 09:00:31','138****1016','已入库','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-08-26 10:28:43');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0845',4,6,'孙启明（个人）','个人','成人纸尿裤','医疗护理','L 码 20 片','包',114,'全新','物流到付','2026-08-28 10:00:50','138****1017','已入库','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-08-23 14:52:35');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0844',5,7,'何佳颖（个人）','个人','轮椅','医疗护理','折叠式','台',45,'八成新以上','自送到仓','2026-08-25 11:00:14','138****1018','待送达','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-08-20 18:41:06');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0843',6,8,'赵雨琪（个人）','个人','棉被','御寒衣物','200×230','床',135,'九成新以上','志愿者上门取件','2026-08-22 12:00:58','138****1019','已入库','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-08-17 14:27:52');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0842',7,9,'杭州市临平区青禾商贸','企业','一级压榨菜籽油','米面粮油','5L / 桶','桶',96,'全新','物流到付','2026-08-19 13:00:44','138****1020','已入库','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-08-14 15:04:25');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0841',8,10,'周慧兰（个人）','个人','东北长粒香米','米面粮油','10kg / 袋','袋',128,'全新','自送到仓','2026-08-16 14:00:23','138****1021','已入库','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-08-11 14:49:44');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0840',9,11,'浙江明远律师事务所','企业','加厚羽绒服（成人）','御寒衣物','M/L/XL','件',121,'九成新以上','志愿者上门取件','2026-08-13 15:00:42','138****1022','已入库','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-08-08 15:17:26');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0839',10,12,'城西社区爱心志愿队','社会组织','儿童棉衣','御寒衣物','110-150','件',190,'九成新以上','物流到付','2026-08-10 16:00:45','138****1023','待送达','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-08-05 13:55:47');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0838',11,1,'李泽川（个人）','个人','学生护眼台灯','学习用品','USB 供电','台',280,'全新','自送到仓','2026-08-07 09:00:36','138****1024','待验收','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-08-02 14:14:50');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0837',12,2,'匿名爱心人士','个人','课外读物','学习用品','适龄读物','册',56,'八成新以上','志愿者上门取件','2026-08-04 10:00:15','138****1025','已入库','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-07-30 12:20:07');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0836',13,3,'杭州云栖科技有限公司','企业','洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',264,'全新','物流到付','2026-08-01 11:00:13','138****1026','已入库','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-07-27 09:33:24');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0835',14,4,'孙启明（个人）','个人','成人纸尿裤','医疗护理','L 码 20 片','包',170,'全新','自送到仓','2026-07-29 12:00:25','138****1027','已入库','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-07-24 18:27:54');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0834',1,5,'何佳颖（个人）','个人','轮椅','医疗护理','折叠式','台',275,'八成新以上','志愿者上门取件','2026-07-26 13:00:56','138****1028','待预审',NULL,'B 区 02 货位',NULL,NULL,'2026-07-21 19:00:54');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0833',2,6,'赵雨琪（个人）','个人','棉被','御寒衣物','200×230','床',185,'九成新以上','物流到付','2026-07-23 14:00:41','138****1029','待送达','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-07-18 08:35:31');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0832',3,7,'杭州市临平区青禾商贸','企业','一级压榨菜籽油','米面粮油','5L / 桶','桶',33,'全新','自送到仓','2026-07-20 15:00:07','138****1030','已入库','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-07-15 09:32:27');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0831',4,8,'周慧兰（个人）','个人','东北长粒香米','米面粮油','10kg / 袋','袋',256,'全新','志愿者上门取件','2026-07-17 16:00:02','138****1031','已入库','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-07-12 10:02:47');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0830',5,9,'浙江明远律师事务所','企业','加厚羽绒服（成人）','御寒衣物','M/L/XL','件',147,'九成新以上','物流到付','2026-07-14 09:00:45','138****1032','待验收','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-07-09 14:13:07');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0829',6,10,'城西社区爱心志愿队','社会组织','儿童棉衣','御寒衣物','110-150','件',270,'九成新以上','自送到仓','2026-07-11 10:00:30','138****1033','待预审',NULL,'A 区 03 货位',NULL,NULL,'2026-07-06 08:51:22');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0828',7,11,'李泽川（个人）','个人','学生护眼台灯','学习用品','USB 供电','台',269,'全新','志愿者上门取件','2026-07-08 11:00:39','138****1034','部分接收','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-07-03 19:10:58');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0827',8,12,'匿名爱心人士','个人','课外读物','学习用品','适龄读物','册',102,'八成新以上','物流到付','2026-07-05 12:00:36','138****1035','部分接收','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-06-30 15:21:33');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0826',9,1,'杭州云栖科技有限公司','企业','洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',177,'全新','自送到仓','2026-07-02 13:00:06','138****1036','待送达','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-06-27 17:42:21');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0825',10,2,'孙启明（个人）','个人','成人纸尿裤','医疗护理','L 码 20 片','包',265,'全新','志愿者上门取件','2026-06-29 14:00:40','138****1037','已入库','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-06-24 14:01:24');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0824',11,3,'何佳颖（个人）','个人','轮椅','医疗护理','折叠式','台',234,'八成新以上','物流到付','2026-06-26 15:00:11','138****1038','待预审',NULL,'C 区 01 货位',NULL,NULL,'2026-06-21 13:30:44');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0823',12,4,'赵雨琪（个人）','个人','棉被','御寒衣物','200×230','床',90,'九成新以上','自送到仓','2026-06-23 16:00:59','138****1039','部分接收','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-06-18 15:27:05');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0822',13,5,'杭州市临平区青禾商贸','企业','一级压榨菜籽油','米面粮油','5L / 桶','桶',108,'全新','志愿者上门取件','2026-05-03 09:00:05','138****1040','已拒收',NULL,'B 区 02 货位','物资为六成新棉被，超出可接收质量等级（需九成新以上）',1,'2026-06-15 10:09:39');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0821',14,6,'周慧兰（个人）','个人','东北长粒香米','米面粮油','10kg / 袋','袋',21,'全新','物流到付','2026-05-03 10:00:43','138****1041','已入库','物资符合需求，仓位已预留','C 区 01 货位',NULL,1,'2026-06-12 09:41:47');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0820',1,7,'浙江明远律师事务所','企业','加厚羽绒服（成人）','御寒衣物','M/L/XL','件',171,'九成新以上','自送到仓','2026-05-03 11:00:27','138****1042','已入库','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-06-09 08:46:40');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0819',2,8,'城西社区爱心志愿队','社会组织','儿童棉衣','御寒衣物','110-150','件',220,'九成新以上','志愿者上门取件','2026-05-03 12:00:15','138****1043','已入库','物资符合需求，仓位已预留','B 区 02 货位',NULL,1,'2026-06-06 09:14:13');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0818',3,9,'李泽川（个人）','个人','学生护眼台灯','学习用品','USB 供电','台',292,'全新','物流到付','2026-05-03 13:00:43','138****1044','待预审',NULL,'C 区 01 货位',NULL,NULL,'2026-06-03 17:46:06');
INSERT INTO `donation_intent` (`intent_no`,`project_id`,`donor_id`,`donor_name`,`donor_type`,`material_name`,`category`,`spec`,`unit`,`est_qty`,`quality_level`,`delivery_type`,`appoint_time`,`contact_phone`,`status`,`precheck_opinion`,`position`,`reject_reason`,`auditor_id`,`create_time`) VALUES ('INT-0817',4,10,'匿名爱心人士','个人','课外读物','学习用品','适龄读物','册',131,'八成新以上','自送到仓','2026-05-03 14:00:03','138****1045','已入库','物资符合需求，仓位已预留','A 区 03 货位',NULL,1,'2026-05-31 08:52:27');
-- receiving_record: 30 行
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2605-01',1,2,5,'2026-10-16 09:00:46',295,295,295,0,0.0,'A 级','2027-05-20','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-10-16 09:00:46');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2605-02',2,3,6,'2026-10-11 10:01:35',208,208,208,0,0.0,'A 级','2027-05-30','/uploads/seed/scene/04.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-10-11 10:01:35');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2605-03',3,4,7,'2026-10-06 11:02:56',152,152,152,0,0.0,'A 级',NULL,'/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-10-06 11:02:56');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2606-04',4,5,5,'2026-10-01 12:03:21',82,82,82,0,0.0,'A 级',NULL,'/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-10-01 12:03:21');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2606-05',5,6,6,'2026-09-26 13:04:41',298,298,298,0,0.0,'A 级',NULL,'/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-09-26 13:04:41');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2606-06',6,2,7,'2026-09-21 14:05:49',91,91,91,0,0.0,'A 级',NULL,'/uploads/seed/scene/04.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-09-21 14:05:49');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2606-07',7,3,5,'2026-09-16 15:06:50',228,228,228,0,0.0,'A 级','2027-07-19','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-09-16 15:06:50');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2606-08',8,4,6,'2026-09-11 16:07:14',235,235,235,0,0.0,'A 级','2027-07-29','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-09-11 16:07:14');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2606-09',9,5,7,'2026-09-06 17:08:12',267,267,267,0,0.0,'A 级','2027-08-08','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-09-06 17:08:12');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2607-10',10,6,5,'2026-09-01 09:09:14',155,155,155,0,0.0,'A 级',NULL,'/uploads/seed/scene/04.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-09-01 09:09:14');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2607-11',11,2,6,'2026-08-27 10:10:22',235,235,235,0,0.0,'A 级','2027-08-28','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-08-27 10:10:22');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2607-12',12,3,7,'2026-08-22 11:11:50',221,221,221,0,0.0,'A 级','2027-09-07','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-08-22 11:11:50');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2607-13',13,4,5,'2026-08-17 12:12:06',175,175,175,0,0.0,'A 级',NULL,'/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-08-17 12:12:06');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2607-14',14,5,6,'2026-08-12 13:13:03',99,99,99,0,0.0,'A 级',NULL,'/uploads/seed/scene/04.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-08-12 13:13:03');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2607-15',15,6,7,'2026-08-07 14:14:06',243,243,243,0,0.0,'A 级',NULL,'/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-08-07 14:14:06');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2607-16',16,2,5,'2026-08-02 15:15:44',91,91,91,0,0.0,'A 级',NULL,'/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-08-02 15:15:44');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2608-17',17,3,6,'2026-07-28 16:16:49',181,181,181,0,0.0,'A 级','2027-10-27','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-07-28 16:16:49');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2608-18',18,4,7,'2026-07-23 17:17:03',249,249,249,0,0.0,'A 级','2027-11-06','/uploads/seed/scene/04.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-07-23 17:17:03');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2608-19',19,5,5,'2026-07-18 09:18:57',253,253,253,0,0.0,'A 级','2027-11-16','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-07-18 09:18:57');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2608-20',20,6,6,'2026-07-13 10:19:52',72,72,72,0,0.0,'A 级',NULL,'/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','实收与应收差异 0 件，无差异','接收','已入库','2026-07-13 10:19:52');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2608-21',21,2,7,'2026-07-08 11:20:04',198,198,190,8,4.04,'C 级','2027-12-06','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','实收与应收差异 0 件，外包装破损已退回','部分接收','已入库','2026-07-08 11:20:04');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2608-22',22,3,5,'2026-07-03 12:21:54',265,262,256,6,2.29,'A 级','2027-12-16','/uploads/seed/scene/04.jpg','实收与应收差异 3 件，外包装破损已退回','部分接收','已入库','2026-07-03 12:21:54');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2609-23',23,4,6,'2026-06-28 13:22:05',184,181,179,2,1.1,'B 级',NULL,'/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','实收与应收差异 3 件，外包装破损已退回','部分接收','已入库','2026-06-28 13:22:05');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2609-24',24,5,7,'2026-06-23 14:23:00',104,100,96,4,4.0,'C 级',NULL,'/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','实收与应收差异 4 件，外包装破损已退回','部分接收','已入库','2026-06-23 14:23:00');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2609-25',25,6,5,'2026-06-18 15:24:28',54,52,45,7,13.46,'A 级',NULL,'/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','实收与应收差异 2 件，外包装破损已退回','部分接收','已入库','2026-06-18 15:24:28');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2609-26',26,2,6,'2026-06-13 16:25:13',78,78,71,7,8.97,'B 级',NULL,'/uploads/seed/scene/04.jpg','实收与应收差异 0 件，外包装破损已退回','部分接收','已入库','2026-06-13 16:25:13');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2609-27',27,3,7,'2026-06-08 17:26:37',115,111,109,2,1.8,'C 级','2028-02-04','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','实收与应收差异 4 件，外包装破损已退回','部分接收','已入库','2026-06-08 17:26:37');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2609-28',28,4,5,'2026-06-03 09:27:23',293,291,0,293,100.69,'A 级','2028-02-14','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','实收与应收差异 2 件，外包装破损已退回','拒收','已拒收','2026-06-03 09:27:23');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2610-29',29,5,6,'2026-05-29 10:28:27',168,164,0,168,102.44,'B 级','2028-02-24','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','实收与应收差异 4 件，外包装破损已退回','拒收','已拒收','2026-05-29 10:28:27');
INSERT INTO `receiving_record` (`receive_no`,`intent_id`,`warehouse_id`,`receive_user_id`,`receive_time`,`expect_qty`,`actual_qty`,`qualified_qty`,`unqualified_qty`,`unqualified_rate`,`quality_level`,`expire_date`,`photos`,`diff_reason`,`result`,`status`,`create_time`) VALUES ('RCV-2610-30',30,6,7,'2026-05-24 11:29:36',98,95,0,98,103.16,'C 级',NULL,'/uploads/seed/scene/04.jpg','实收与应收差异 3 件，外包装破损已退回','拒收','已拒收','2026-05-24 11:29:36');
-- receiving_item: 30 行
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (1,'一级压榨菜籽油','米面粮油','5L / 桶','桶',295,295,'B 级','2027-05-20',0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (2,'东北长粒香米','米面粮油','10kg / 袋','袋',208,208,'A 级','2027-05-30',0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (3,'加厚羽绒服（成人）','御寒衣物','M/L/XL','件',152,152,'A 级',NULL,0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (4,'儿童棉衣','御寒衣物','110-150','件',82,82,'A 级',NULL,0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (5,'学生护眼台灯','学习用品','USB 供电','台',298,298,'A 级',NULL,0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (6,'课外读物','学习用品','适龄读物','册',91,91,'B 级',NULL,0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (7,'洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',228,228,'A 级','2027-07-19',0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (8,'成人纸尿裤','医疗护理','L 码 20 片','包',235,235,'A 级','2027-07-29',0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (9,'轮椅','医疗护理','折叠式','台',267,267,'A 级','2027-08-08',0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (10,'棉被','御寒衣物','200×230','床',155,155,'A 级',NULL,0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (11,'一级压榨菜籽油','米面粮油','5L / 桶','桶',235,235,'B 级','2027-08-28',0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (12,'东北长粒香米','米面粮油','10kg / 袋','袋',221,221,'A 级','2027-09-07',0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (13,'加厚羽绒服（成人）','御寒衣物','M/L/XL','件',175,175,'A 级',NULL,0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (14,'儿童棉衣','御寒衣物','110-150','件',99,99,'A 级',NULL,0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (15,'学生护眼台灯','学习用品','USB 供电','台',243,243,'A 级',NULL,0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (16,'课外读物','学习用品','适龄读物','册',91,91,'B 级',NULL,0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (17,'洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',181,181,'A 级','2027-10-27',0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (18,'成人纸尿裤','医疗护理','L 码 20 片','包',249,249,'A 级','2027-11-06',0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (19,'轮椅','医疗护理','折叠式','台',253,253,'A 级','2027-11-16',0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (20,'棉被','御寒衣物','200×230','床',72,72,'A 级',NULL,0,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (21,'一级压榨菜籽油','米面粮油','5L / 桶','桶',198,198,'B 级','2027-12-06',8,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (22,'东北长粒香米','米面粮油','10kg / 袋','袋',265,262,'A 级','2027-12-16',6,-3);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (23,'加厚羽绒服（成人）','御寒衣物','M/L/XL','件',184,181,'A 级',NULL,2,-3);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (24,'儿童棉衣','御寒衣物','110-150','件',104,100,'A 级',NULL,4,-4);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (25,'学生护眼台灯','学习用品','USB 供电','台',54,52,'A 级',NULL,7,-2);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (26,'课外读物','学习用品','适龄读物','册',78,78,'B 级',NULL,7,0);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (27,'洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',115,111,'A 级','2028-02-04',2,-4);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (28,'成人纸尿裤','医疗护理','L 码 20 片','包',293,291,'A 级','2028-02-14',293,-2);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (29,'轮椅','医疗护理','折叠式','台',168,164,'A 级','2028-02-24',168,-4);
INSERT INTO `receiving_item` (`receive_id`,`material_name`,`category`,`spec`,`unit`,`expect_qty`,`actual_qty`,`quality_level`,`expire_date`,`unqualified_qty`,`diff_qty`) VALUES (30,'棉被','御寒衣物','200×230','床',98,95,'A 级',NULL,98,-3);
-- inventory_batch: 24 行
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260520-01','一级压榨菜籽油','米面粮油','5L / 桶','桶',1,1,1,'杭州市临平区青禾商贸',2,'A-01-01',200,102,0,'A 级','/uploads/seed/material/01.jpg','2026-04-20','2026-12-31','2026-10-13 10:00:29','正常','未发放',5,234.38,'2026-10-13 10:00:29');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260526-02','东北长粒香米','米面粮油','10kg / 袋','袋',2,2,2,'周慧兰（个人）',3,'B-02-02',150,88,0,'A 级','/uploads/seed/material/02.jpg','2026-04-26','2027-01-20','2026-10-07 11:01:08','正常','未发放',6,114.52,'2026-10-07 11:01:08');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260601-03','加厚羽绒服（成人）','御寒衣物','M/L/XL','件',3,3,3,'浙江明远律师事务所',4,'C-03-03',36,27,0,'B 级','/uploads/seed/material/03.jpg','2026-05-02',NULL,'2026-10-01 12:02:05','正常','未发放',7,244.94,'2026-10-01 12:02:05');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260607-04','儿童棉衣','御寒衣物','110-150','件',4,4,4,'城西社区爱心志愿队',5,'D-04-04',120,85,0,'九成新','/uploads/seed/material/04.jpg','2026-05-08',NULL,'2026-09-25 13:03:31','正常','未发放',5,74.08,'2026-09-25 13:03:31');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260613-05','学生护眼台灯','学习用品','USB 供电','台',5,5,5,'李泽川（个人）',6,'E-05-01',118,98,0,'A 级','/uploads/seed/material/05.jpg','2026-05-14',NULL,'2026-09-19 14:04:24','正常','未发放',6,69.55,'2026-09-19 14:04:24');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260619-06','课外读物','学习用品','适龄读物','册',6,6,6,'匿名爱心人士',2,'A-06-02',90,52,0,'A 级','/uploads/seed/material/06.jpg','2026-05-20',NULL,'2026-09-13 15:05:21','正常','未发放',7,12.51,'2026-09-13 15:05:21');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260625-07','洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',7,7,7,'杭州市临平区青禾商贸',3,'B-01-03',152,126,0,'B 级','/uploads/seed/material/01.jpg','2026-05-26','2027-04-30','2026-09-07 16:06:45','正常','未发放',5,80.14,'2026-09-07 16:06:45');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260701-08','成人纸尿裤','医疗护理','L 码 20 片','包',8,8,8,'周慧兰（个人）',4,'C-02-04',60,34,0,'九成新','/uploads/seed/material/02.jpg','2026-06-01','2027-05-20','2026-09-01 17:07:53','正常','未发放',6,160.27,'2026-09-01 17:07:53');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260707-09','轮椅','医疗护理','折叠式','台',9,9,9,'浙江明远律师事务所',5,'D-03-01',8,8,0,'A 级','/uploads/seed/material/03.jpg','2026-06-07','2027-06-09','2026-08-26 10:08:00','正常','未发放',7,110.88,'2026-08-26 10:08:00');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260713-10','棉被','御寒衣物','200×230','床',10,10,10,'城西社区爱心志愿队',6,'E-04-02',48,44,0,'A 级','/uploads/seed/material/04.jpg','2026-06-13',NULL,'2026-08-20 11:09:20','正常','未发放',5,124.48,'2026-08-20 11:09:20');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260719-11','一级压榨菜籽油','米面粮油','5L / 桶','桶',11,11,11,'李泽川（个人）',2,'A-05-03',200,111,0,'B 级','/uploads/seed/material/05.jpg','2026-06-19','2027-07-19','2026-08-14 12:10:42','正常','未发放',6,72.12,'2026-08-14 12:10:42');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260725-12','东北长粒香米','米面粮油','10kg / 袋','袋',12,12,12,'匿名爱心人士',3,'B-06-04',150,116,0,'九成新','/uploads/seed/material/06.jpg','2026-06-25','2027-08-08','2026-08-08 13:11:59','正常','未发放',7,230.02,'2026-08-08 13:11:59');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260731-13','加厚羽绒服（成人）','御寒衣物','M/L/XL','件',13,13,13,'杭州市临平区青禾商贸',4,'C-01-01',36,20,0,'A 级','/uploads/seed/material/01.jpg','2026-07-01',NULL,'2026-08-02 14:12:42','正常','未发放',5,225.13,'2026-08-02 14:12:42');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260806-14','儿童棉衣','御寒衣物','110-150','件',14,14,14,'周慧兰（个人）',5,'D-02-02',120,97,0,'A 级','/uploads/seed/material/02.jpg','2026-07-07',NULL,'2026-07-27 15:13:51','正常','未发放',6,27.44,'2026-07-27 15:13:51');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260812-15','学生护眼台灯','学习用品','USB 供电','台',1,15,15,'浙江明远律师事务所',6,'E-03-03',118,73,0,'B 级','/uploads/seed/material/03.jpg','2026-07-13',NULL,'2026-07-21 16:14:11','正常','未发放',7,54.77,'2026-07-21 16:14:11');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260818-16','课外读物','学习用品','适龄读物','册',2,16,16,'城西社区爱心志愿队',2,'A-04-04',90,45,0,'九成新','/uploads/seed/material/04.jpg','2026-07-19',NULL,'2026-07-15 17:15:42','正常','未发放',5,104.2,'2026-07-15 17:15:42');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260824-17','洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',3,17,17,'李泽川（个人）',3,'B-05-01',152,111,0,'A 级','/uploads/seed/material/05.jpg','2026-07-25','2026-12-25','2026-07-09 10:16:39','临期','未发放',6,169.4,'2026-07-09 10:16:39');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260830-18','成人纸尿裤','医疗护理','L 码 20 片','包',4,18,18,'匿名爱心人士',4,'C-06-02',60,51,0,'A 级','/uploads/seed/material/06.jpg','2026-07-31','2026-12-28','2026-07-03 11:17:22','临期','未发放',7,223.18,'2026-07-03 11:17:22');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260905-19','轮椅','医疗护理','折叠式','台',5,19,19,'杭州市临平区青禾商贸',5,'D-01-03',8,6,0,'B 级','/uploads/seed/material/01.jpg','2026-08-06','2026-12-31','2026-06-27 12:18:05','临期','未发放',5,161.02,'2026-06-27 12:18:05');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260911-20','棉被','御寒衣物','200×230','床',6,20,20,'周慧兰（个人）',6,'E-02-04',48,42,0,'九成新','/uploads/seed/material/02.jpg','2026-08-12','2027-01-03','2026-06-21 13:19:28','临期','未发放',6,172.74,'2026-06-21 13:19:28');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260917-21','一级压榨菜籽油','米面粮油','5L / 桶','桶',7,21,21,'浙江明远律师事务所',2,'A-03-01',200,119,0,'A 级','/uploads/seed/material/03.jpg','2026-08-18','2027-01-06','2026-06-15 14:20:14','临期','未发放',7,223.25,'2026-06-15 14:20:14');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260923-22','东北长粒香米','米面粮油','10kg / 袋','袋',8,22,22,'城西社区爱心志愿队',3,'B-04-02',150,0,0,'A 级','/uploads/seed/material/04.jpg','2026-08-24','2026-10-08','2026-06-09 15:21:16','过期','部分发放',5,13.11,'2026-06-09 15:21:16');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-260929-23','加厚羽绒服（成人）','御寒衣物','M/L/XL','件',9,23,23,'李泽川（个人）',4,'C-05-03',36,0,0,'B 级','/uploads/seed/material/05.jpg','2026-08-30','2026-10-07','2026-06-03 16:22:21','过期','部分发放',6,165.71,'2026-06-03 16:22:21');
INSERT INTO `inventory_batch` (`batch_no`,`material_name`,`category`,`spec`,`unit`,`project_id`,`intent_id`,`receive_id`,`donor_name`,`warehouse_id`,`position`,`in_qty`,`available_qty`,`locked_qty`,`quality_level`,`material_image`,`produce_date`,`expire_date`,`in_time`,`status`,`issue_status`,`check_user_id`,`price_ref`,`create_time`) VALUES ('BAT-261005-24','儿童棉衣','御寒衣物','110-150','件',10,24,24,'匿名爱心人士',5,'D-06-04',120,0,120,'九成新','/uploads/seed/material/06.jpg','2026-09-05',NULL,'2026-05-28 17:23:30','锁定','部分发放',7,71.01,'2026-05-28 17:23:30');
-- aid_beneficiary: 30 行
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0001','王秀兰','330102****1800','138****6000','女',1940,6,'城西街道××社区××路 8 号','城西街道',2,876.92,1,'2026-04-15','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','特急','停用','2026-06-25 19:16:28');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0002','李志强','330103****1837','138****6011','男',1942,1,'东湖街道××社区××路 9 号','东湖街道',3,2486.66,1,'2026-04-20','/uploads/seed/scene/04.jpg','紧急','正常','2026-06-25 09:53:12');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0003','张素芬','330105****1874','138****6022','女',1944,5,'南苑街道××社区××路 10 号','南苑街道',4,3604.3,1,'2026-04-25','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','一般','正常','2026-06-25 12:12:06');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0004','赵国庆','330106****1911','138****6033','男',1946,5,'北岭街道××社区××路 11 号','北岭街道',5,1339.65,1,'2026-04-30','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','特急','正常','2026-06-25 09:48:43');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0005','陈桂英','330102****1948','138****6044','女',1948,5,'开发区××社区××路 12 号','开发区',6,2812.99,1,'2026-05-05','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','紧急','正常','2026-06-25 10:12:32');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0006','刘德明','330103****1985','138****6055','男',1950,1,'城西街道××社区××路 13 号','城西街道',2,1722.29,1,'2026-05-10','/uploads/seed/scene/04.jpg','一般','正常','2026-06-25 17:44:30');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0007','杨玉梅','330105****2022','138****6066','女',1952,4,'东湖街道××社区××路 14 号','东湖街道',3,2443.56,1,'2026-05-15','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','特急','正常','2026-06-25 10:15:55');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0008','黄建国','330106****2059','138****6077','男',1954,3,'南苑街道××社区××路 15 号','南苑街道',4,956.18,1,'2026-05-20','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','紧急','正常','2026-06-25 14:49:24');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0009','周美华','330102****2096','138****6088','女',1956,1,'北岭街道××社区××路 16 号','北岭街道',5,1755.89,1,'2026-05-25','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','一般','停用','2026-06-25 14:34:01');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0010','吴海涛','330103****2133','138****6099','男',1958,2,'开发区××社区××路 17 号','开发区',6,3342.81,1,'2026-05-30','/uploads/seed/scene/04.jpg','特急','正常','2026-06-25 17:33:29');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0011','王秀兰','330105****2170','138****6110','女',1960,1,'城西街道××社区××路 18 号','城西街道',2,2363.82,1,'2026-06-04','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','紧急','正常','2026-06-25 18:11:26');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0012','李志强','330106****2207','138****6121','男',1962,5,'东湖街道××社区××路 19 号','东湖街道',3,3353.01,1,'2026-06-09','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','一般','正常','2026-06-25 08:49:21');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0013','张素芬','330102****2244','138****6132','女',1964,4,'南苑街道××社区××路 20 号','南苑街道',4,2299.06,1,'2026-06-14','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','特急','正常','2026-06-25 19:36:05');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0014','赵国庆','330103****2281','138****6143','男',1966,1,'北岭街道××社区××路 21 号','北岭街道',5,3873.33,1,'2026-06-19','/uploads/seed/scene/04.jpg','紧急','正常','2026-06-25 14:43:08');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0015','陈桂英','330105****2318','138****6154','女',1968,6,'开发区××社区××路 22 号','开发区',6,2287.8,1,'2026-06-24','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','一般','正常','2026-06-25 08:19:52');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0016','刘德明','330106****2355','138****6165','男',1970,3,'城西街道××社区××路 23 号','城西街道',2,2731.03,1,'2026-06-29','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','特急','正常','2026-06-25 18:29:40');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0017','杨玉梅','330102****2392','138****6176','女',1972,2,'东湖街道××社区××路 24 号','东湖街道',3,3763.75,1,'2026-07-04','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','紧急','停用','2026-06-25 19:58:54');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0018','黄建国','330103****2429','138****6187','男',1974,1,'南苑街道××社区××路 25 号','南苑街道',4,1143.49,1,'2026-07-09','/uploads/seed/scene/04.jpg','一般','正常','2026-06-25 09:49:37');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0019','周美华','330105****2466','138****6198','女',1976,1,'北岭街道××社区××路 26 号','北岭街道',5,3735.28,1,'2026-07-14','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','特急','正常','2026-06-25 19:25:02');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0020','吴海涛','330106****2503','138****6209','男',1978,2,'开发区××社区××路 27 号','开发区',6,2896.05,1,'2026-07-19','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','紧急','正常','2026-06-25 08:32:35');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0021','王秀兰','330102****2540','138****6220','女',1980,3,'城西街道××社区××路 28 号','城西街道',2,896.31,1,'2026-07-24','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','一般','正常','2026-06-25 10:37:40');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0022','李志强','330103****2577','138****6231','男',1982,5,'东湖街道××社区××路 29 号','东湖街道',3,3046.26,1,'2026-07-29','/uploads/seed/scene/04.jpg','特急','正常','2026-06-25 10:39:10');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0023','张素芬','330105****2614','138****6242','女',1984,1,'南苑街道××社区××路 30 号','南苑街道',4,1116.05,1,'2026-08-03','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','紧急','正常','2026-06-25 12:46:43');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0024','赵国庆','330106****2651','138****6253','男',1986,6,'北岭街道××社区××路 31 号','北岭街道',5,1585.72,1,'2026-08-08','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','一般','正常','2026-06-25 12:09:00');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0025','陈桂英','330102****2688','138****6264','女',1988,1,'开发区××社区××路 32 号','开发区',6,2119.74,1,'2026-08-13','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','特急','停用','2026-06-25 13:56:41');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0026','刘德明','330103****2725','138****6275','男',1990,4,'城西街道××社区××路 33 号','城西街道',2,2935.87,1,'2026-08-18','/uploads/seed/scene/04.jpg','紧急','正常','2026-06-25 08:45:35');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0027','杨玉梅','330105****2762','138****6286','女',1992,4,'东湖街道××社区××路 34 号','东湖街道',3,2003.1,1,'2026-08-23','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','一般','正常','2026-06-25 10:21:12');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0028','黄建国','330106****2799','138****6297','男',1994,5,'南苑街道××社区××路 35 号','南苑街道',4,3401.52,1,'2026-08-28','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','特急','正常','2026-06-25 09:37:23');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0029','周美华','330102****2836','138****6308','女',1996,4,'北岭街道××社区××路 36 号','北岭街道',5,923.65,1,'2026-09-02','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','紧急','正常','2026-06-25 19:14:28');
INSERT INTO `aid_beneficiary` (`beneficiary_no`,`name`,`id_card`,`phone`,`gender`,`birth_year`,`family_size`,`address`,`region`,`org_id`,`family_income`,`qualified`,`qualified_date`,`cert_files`,`urgent_level`,`status`,`create_time`) VALUES ('BEN-2026-0030','吴海涛','330103****2873','138****6319','男',1998,2,'开发区××社区××路 37 号','开发区',6,4017.62,1,'2026-09-07','/uploads/seed/scene/04.jpg','一般','正常','2026-06-25 18:34:37');
-- aid_application: 32 行
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0418',1,'个人','王秀兰','330102****1800','138****6000',6,'城西街道','特急','机构统一分发至服务对象','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','2026-10-08 09:00:56','已完成',3,'2026-10-07 10:00:53','资格符合，按限领规则批准',NULL,'现场领用','社区网格员 柳知远','2026-10-08 09:00:56');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0417',2,'家庭','李志强','330103****1837','138****6011',6,'东湖街道','紧急','家庭日常食用与保暖需求','/uploads/seed/scene/04.jpg','2026-10-04 10:01:56','待反馈',3,'2026-10-03 11:01:36','资格符合，按限领规则批准',NULL,'配送上门',NULL,'2026-10-04 10:01:56');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0416',3,'机构','张素芬','330105****1874','138****6022',3,'南苑街道','一般','机构统一分发至服务对象','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','2026-09-30 11:02:18','待拣货',3,'2026-09-29 12:02:43','资格符合，按限领规则批准',NULL,'现场领用',NULL,'2026-09-30 11:02:18');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0415',4,'个人','赵国庆','330106****1911','138****6033',4,'北岭街道','特急','家庭日常食用与保暖需求','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','2026-09-26 12:03:06','待审核',NULL,NULL,NULL,NULL,'配送上门','社区网格员 柳知远','2026-09-26 12:03:06');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0414',5,'家庭','陈桂英','330102****1948','138****6044',5,'开发区','紧急','机构统一分发至服务对象','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','2026-09-22 13:04:53','已退回',3,'2026-09-21 14:04:42',NULL,'同户 30 天内已领取同类物资，间隔期未满','现场领用',NULL,'2026-09-22 13:04:53');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0413',6,'机构','刘德明','330103****1985','138****6055',5,'城西街道','一般','家庭日常食用与保暖需求','/uploads/seed/scene/04.jpg','2026-09-18 14:05:08','待审核',NULL,NULL,NULL,NULL,'配送上门',NULL,'2026-09-18 14:05:08');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0412',7,'个人','杨玉梅','330105****2022','138****6066',1,'东湖街道','特急','机构统一分发至服务对象','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','2026-09-14 15:06:05','待拣货',3,'2026-09-13 10:06:41','资格符合，按限领规则批准',NULL,'现场领用','社区网格员 柳知远','2026-09-14 15:06:05');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0411',8,'家庭','黄建国','330106****2059','138****6077',3,'南苑街道','紧急','家庭日常食用与保暖需求','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','2026-09-10 16:07:11','已完成',3,'2026-09-09 11:07:12','资格符合，按限领规则批准',NULL,'配送上门',NULL,'2026-09-10 16:07:11');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0410',9,'机构','周美华','330102****2096','138****6088',1,'北岭街道','一般','机构统一分发至服务对象','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','2026-09-06 09:08:33','已完成',3,'2026-09-05 12:08:31','资格符合，按限领规则批准',NULL,'现场领用',NULL,'2026-09-06 09:08:33');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0409',10,'个人','吴海涛','330103****2133','138****6099',4,'开发区','特急','家庭日常食用与保暖需求','/uploads/seed/scene/04.jpg','2026-09-02 10:09:07','待领用',3,'2026-09-01 13:09:58','资格符合，按限领规则批准',NULL,'配送上门','社区网格员 柳知远','2026-09-02 10:09:07');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0408',11,'家庭','王秀兰','330105****2170','138****6110',3,'城西街道','紧急','机构统一分发至服务对象','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','2026-08-29 11:10:38','待拣货',3,'2026-08-28 14:10:31','资格符合，按限领规则批准',NULL,'现场领用',NULL,'2026-08-29 11:10:38');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0407',12,'机构','李志强','330106****2207','138****6121',1,'东湖街道','一般','家庭日常食用与保暖需求','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','2026-08-25 12:11:27','待配送',3,'2026-08-24 15:11:01','资格符合，按限领规则批准',NULL,'配送上门',NULL,'2026-08-25 12:11:27');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0406',13,'个人','张素芬','330102****2244','138****6132',3,'南苑街道','特急','机构统一分发至服务对象','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','2026-08-21 13:12:14','已取消',3,'2026-08-20 10:12:52','资格符合，按限领规则批准',NULL,'现场领用','社区网格员 柳知远','2026-08-21 13:12:14');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0405',14,'家庭','赵国庆','330103****2281','138****6143',5,'北岭街道','紧急','家庭日常食用与保暖需求','/uploads/seed/scene/04.jpg','2026-08-17 14:13:21','已完成',3,'2026-08-16 11:13:33','资格符合，按限领规则批准',NULL,'配送上门',NULL,'2026-08-17 14:13:21');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0404',15,'机构','陈桂英','330105****2318','138****6154',6,'开发区','一般','机构统一分发至服务对象','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','2026-08-13 15:14:56','待审核',NULL,NULL,NULL,NULL,'现场领用',NULL,'2026-08-13 15:14:56');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0403',16,'个人','刘德明','330106****2355','138****6165',4,'城西街道','特急','家庭日常食用与保暖需求','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','2026-08-09 16:15:37','已完成',3,'2026-08-08 13:15:32','资格符合，按限领规则批准',NULL,'配送上门','社区网格员 柳知远','2026-08-09 16:15:37');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0402',17,'家庭','杨玉梅','330102****2392','138****6176',2,'东湖街道','紧急','机构统一分发至服务对象','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','2026-08-05 09:16:35','待反馈',3,'2026-08-04 14:16:43','资格符合，按限领规则批准',NULL,'现场领用',NULL,'2026-08-05 09:16:35');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0401',18,'机构','黄建国','330103****2429','138****6187',4,'南苑街道','一般','家庭日常食用与保暖需求','/uploads/seed/scene/04.jpg','2026-08-01 10:17:41','待审核',NULL,NULL,NULL,NULL,'配送上门',NULL,'2026-08-01 10:17:41');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0400',19,'个人','周美华','330105****2466','138****6198',3,'北岭街道','特急','机构统一分发至服务对象','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','2026-07-28 11:18:17','已完成',3,'2026-07-27 10:18:10','资格符合，按限领规则批准',NULL,'现场领用','社区网格员 柳知远','2026-07-28 11:18:17');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0399',20,'家庭','吴海涛','330106****2503','138****6209',1,'开发区','紧急','家庭日常食用与保暖需求','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','2026-07-24 12:19:31','待拣货',3,'2026-07-23 11:19:50','资格符合，按限领规则批准',NULL,'配送上门',NULL,'2026-07-24 12:19:31');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0398',21,'机构','王秀兰','330102****2540','138****6220',4,'城西街道','一般','机构统一分发至服务对象','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','2026-07-20 13:20:36','待反馈',3,'2026-07-19 12:20:31','资格符合，按限领规则批准',NULL,'现场领用',NULL,'2026-07-20 13:20:36');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0397',22,'个人','李志强','330103****2577','138****6231',3,'东湖街道','特急','家庭日常食用与保暖需求','/uploads/seed/scene/04.jpg','2026-07-16 14:21:42','待审核',NULL,NULL,NULL,NULL,'配送上门','社区网格员 柳知远','2026-07-16 14:21:42');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0396',23,'家庭','张素芬','330105****2614','138****6242',5,'南苑街道','紧急','机构统一分发至服务对象','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','2026-07-12 15:22:26','已完成',3,'2026-07-11 14:22:14','资格符合，按限领规则批准',NULL,'现场领用',NULL,'2026-07-12 15:22:26');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0395',24,'机构','赵国庆','330106****2651','138****6253',3,'北岭街道','一般','家庭日常食用与保暖需求','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','2026-07-08 16:23:19','待配送',3,'2026-07-07 15:23:06','资格符合，按限领规则批准',NULL,'配送上门',NULL,'2026-07-08 16:23:19');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0394',25,'个人','陈桂英','330102****2688','138****6264',1,'开发区','特急','机构统一分发至服务对象','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','2026-07-04 09:24:31','待拣货',3,'2026-07-03 10:24:07','资格符合，按限领规则批准',NULL,'现场领用','社区网格员 柳知远','2026-07-04 09:24:31');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0393',26,'家庭','刘德明','330103****2725','138****6275',1,'城西街道','紧急','家庭日常食用与保暖需求','/uploads/seed/scene/04.jpg','2026-06-30 10:25:36','待反馈',3,'2026-06-29 11:25:19','资格符合，按限领规则批准',NULL,'配送上门',NULL,'2026-06-30 10:25:36');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0392',27,'机构','杨玉梅','330105****2762','138****6286',5,'东湖街道','一般','机构统一分发至服务对象','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','2026-06-26 11:26:23','待领用',3,'2026-06-25 12:26:16','资格符合，按限领规则批准',NULL,'现场领用',NULL,'2026-06-26 11:26:23');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0391',28,'个人','黄建国','330106****2799','138****6297',6,'南苑街道','特急','家庭日常食用与保暖需求','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','2026-06-22 12:27:42','待配送',3,'2026-06-21 13:27:26','资格符合，按限领规则批准',NULL,'配送上门','社区网格员 柳知远','2026-06-22 12:27:42');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0390',29,'家庭','周美华','330102****2836','138****6308',1,'北岭街道','紧急','机构统一分发至服务对象','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg','2026-06-18 13:28:49','待审核',NULL,NULL,NULL,NULL,'现场领用',NULL,'2026-06-18 13:28:49');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0389',30,'机构','吴海涛','330103****2873','138****6319',3,'开发区','一般','家庭日常食用与保暖需求','/uploads/seed/scene/04.jpg','2026-06-14 14:29:45','已完成',3,'2026-06-13 15:29:41','资格符合，按限领规则批准',NULL,'配送上门',NULL,'2026-06-14 14:29:45');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0388',31,'个人','王秀兰','330102****1800','138****6000',5,'城西街道','特急','机构统一分发至服务对象','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg','2026-06-10 15:30:55','待领用',3,'2026-06-09 10:30:11','资格符合，按限领规则批准',NULL,'现场领用','社区网格员 柳知远','2026-06-10 15:30:55');
INSERT INTO `aid_application` (`apply_no`,`beneficiary_id`,`apply_type`,`applicant_name`,`id_card`,`phone`,`family_size`,`region`,`urgency_level`,`purpose`,`cert_files`,`apply_time`,`status`,`auditor_id`,`audit_time`,`audit_opinion`,`reject_reason`,`distribute_type`,`agent_name`,`create_time`) VALUES ('AID-2026-0387',32,'家庭','李志强','330103****1837','138****6011',3,'东湖街道','紧急','家庭日常食用与保暖需求','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg','2026-06-06 16:31:01','待领用',3,'2026-06-05 11:31:45','资格符合，按限领规则批准',NULL,'配送上门',NULL,'2026-06-06 16:31:01');
-- aid_application_item: 32 行
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (1,'一级压榨菜籽油','米面粮油','5L / 桶','桶',2,2,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (2,'东北长粒香米','米面粮油','10kg / 袋','袋',1,1,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (3,'加厚羽绒服（成人）','御寒衣物','M/L/XL','件',3,3,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (4,'儿童棉衣','御寒衣物','110-150','件',2,2,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (5,'学生护眼台灯','学习用品','USB 供电','台',5,0,'按年度上限调整');
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (6,'课外读物','学习用品','适龄读物','册',2,2,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (7,'洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',1,1,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (8,'成人纸尿裤','医疗护理','L 码 20 片','包',4,4,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (9,'轮椅','医疗护理','折叠式','台',2,2,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (10,'棉被','御寒衣物','200×230','床',5,5,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (11,'一级压榨菜籽油','米面粮油','5L / 桶','桶',5,5,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (12,'东北长粒香米','米面粮油','10kg / 袋','袋',3,3,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (13,'加厚羽绒服（成人）','御寒衣物','M/L/XL','件',3,3,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (14,'儿童棉衣','御寒衣物','110-150','件',1,1,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (15,'学生护眼台灯','学习用品','USB 供电','台',1,1,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (16,'课外读物','学习用品','适龄读物','册',1,1,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (17,'洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',4,4,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (18,'成人纸尿裤','医疗护理','L 码 20 片','包',4,4,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (19,'轮椅','医疗护理','折叠式','台',3,3,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (20,'棉被','御寒衣物','200×230','床',5,5,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (21,'一级压榨菜籽油','米面粮油','5L / 桶','桶',1,1,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (22,'东北长粒香米','米面粮油','10kg / 袋','袋',3,3,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (23,'加厚羽绒服（成人）','御寒衣物','M/L/XL','件',2,2,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (24,'儿童棉衣','御寒衣物','110-150','件',2,2,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (25,'学生护眼台灯','学习用品','USB 供电','台',2,2,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (26,'课外读物','学习用品','适龄读物','册',1,1,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (27,'洗衣液（家庭装）','日用清洁','3kg / 瓶','瓶',3,3,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (28,'成人纸尿裤','医疗护理','L 码 20 片','包',3,3,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (29,'轮椅','医疗护理','折叠式','台',5,5,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (30,'棉被','御寒衣物','200×230','床',3,3,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (31,'一级压榨菜籽油','米面粮油','5L / 桶','桶',2,2,NULL);
INSERT INTO `aid_application_item` (`application_id`,`material_name`,`category`,`spec`,`unit`,`apply_qty`,`approve_qty`,`remark`) VALUES (32,'东北长粒香米','米面粮油','10kg / 袋','袋',3,3,NULL);
-- distribution_order: 32 行
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0418',1,1,'王秀兰','138****6000','城西街道','追踪归档','已完成',2,5,'现场领用',NULL,NULL,8,'2026-09-26 18:00:02','2026-09-25 15:20:38',NULL,1,'2026-09-26 09:00:13');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0417',2,2,'李志强','138****6011','东湖街道','追踪归档','处理中',3,6,'配送上门','东湖街道××社区××路 9 号','运送人 何志远',3,'2026-09-22 18:00:01',NULL,NULL,2,'2026-09-22 10:01:48');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0416',3,3,'张素芬','138****6022','南苑街道','分配出库','处理中',4,7,'现场领用',NULL,NULL,6,'2026-09-18 18:00:53',NULL,NULL,3,'2026-09-18 11:02:28');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0415',4,4,'赵国庆','138****6033','北岭街道','需求审核','待处理',5,3,'配送上门','北岭街道××社区××路 11 号','运送人 何志远',6,'2026-09-14 18:00:31',NULL,NULL,4,'2026-09-14 12:03:51');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0414',5,5,'陈桂英','138****6044','开发区','需求审核','已退回',6,5,'现场领用',NULL,NULL,5,'2026-09-10 18:00:12',NULL,NULL,5,'2026-09-10 13:04:03');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0413',6,6,'刘德明','138****6055','城西街道','需求审核','待处理',2,6,'配送上门','城西街道××社区××路 13 号','运送人 何志远',3,'2026-09-06 18:00:00',NULL,NULL,6,'2026-09-06 14:05:37');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0412',7,7,'杨玉梅','138****6066','东湖街道','分配出库','处理中',3,7,'现场领用',NULL,NULL,5,'2026-09-02 18:00:13',NULL,NULL,7,'2026-09-02 15:06:44');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0411',8,8,'黄建国','138****6077','南苑街道','追踪归档','已完成',4,3,'配送上门','南苑街道××社区××路 15 号','运送人 何志远',1,'2026-08-29 18:00:37','2026-08-28 15:20:38',NULL,8,'2026-08-29 16:07:50');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0410',9,9,'周美华','138****6088','北岭街道','追踪归档','已完成',5,5,'现场领用',NULL,NULL,3,'2026-08-25 18:00:36','2026-08-24 15:20:59',NULL,9,'2026-08-25 09:08:32');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0409',10,10,'吴海涛','138****6099','开发区','签收回执','处理中',6,6,'配送上门','开发区××社区××路 17 号','运送人 何志远',2,'2026-08-21 18:00:33',NULL,NULL,10,'2026-08-21 10:09:05');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0408',11,11,'王秀兰','138****6110','城西街道','分配出库','处理中',2,7,'现场领用',NULL,NULL,3,'2026-08-17 18:00:10',NULL,NULL,11,'2026-08-17 11:10:09');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0407',12,12,'李志强','138****6121','东湖街道','签收回执','处理中',3,3,'配送上门','东湖街道××社区××路 19 号','运送人 何志远',4,'2026-08-13 18:00:18',NULL,NULL,12,'2026-08-13 12:11:15');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0406',13,13,'张素芬','138****6132','南苑街道','分配出库','已取消',4,5,'现场领用',NULL,NULL,8,'2026-08-09 18:00:16',NULL,'受助人已由社区统一安置，无需发放',13,'2026-08-09 13:12:00');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0405',14,14,'赵国庆','138****6143','北岭街道','追踪归档','已完成',5,6,'配送上门','北岭街道××社区××路 21 号','运送人 何志远',4,'2026-08-05 18:00:48','2026-08-04 15:20:18',NULL,14,'2026-08-05 14:13:10');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0404',15,15,'陈桂英','138****6154','开发区','需求审核','待处理',6,7,'现场领用',NULL,NULL,5,'2026-08-01 18:00:16',NULL,NULL,15,'2026-08-01 15:14:25');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0403',16,16,'刘德明','138****6165','城西街道','追踪归档','已完成',2,3,'配送上门','城西街道××社区××路 23 号','运送人 何志远',2,'2026-07-28 18:00:59','2026-07-27 15:20:28',NULL,16,'2026-07-28 16:15:02');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0402',17,17,'杨玉梅','138****6176','东湖街道','追踪归档','处理中',3,5,'现场领用',NULL,NULL,7,'2026-07-24 18:00:32',NULL,NULL,17,'2026-07-24 09:16:23');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0401',18,18,'黄建国','138****6187','南苑街道','需求审核','待处理',4,6,'配送上门','南苑街道××社区××路 25 号','运送人 何志远',8,'2026-07-20 18:00:28',NULL,NULL,18,'2026-07-20 10:17:47');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0400',19,19,'周美华','138****6198','北岭街道','追踪归档','已完成',5,7,'现场领用',NULL,NULL,2,'2026-07-16 18:00:26','2026-07-15 15:20:06',NULL,19,'2026-07-16 11:18:26');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0399',20,20,'吴海涛','138****6209','开发区','分配出库','处理中',6,3,'配送上门','开发区××社区××路 27 号','运送人 何志远',3,'2026-07-12 18:00:45',NULL,NULL,20,'2026-07-12 12:19:58');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0398',21,21,'王秀兰','138****6220','城西街道','追踪归档','处理中',2,5,'现场领用',NULL,NULL,8,'2026-07-08 18:00:08',NULL,NULL,21,'2026-07-08 13:20:47');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0397',22,22,'李志强','138****6231','东湖街道','需求审核','待处理',3,6,'配送上门','东湖街道××社区××路 29 号','运送人 何志远',7,'2026-07-04 18:00:37',NULL,NULL,22,'2026-07-04 14:21:57');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0396',23,23,'张素芬','138****6242','南苑街道','追踪归档','已完成',4,7,'现场领用',NULL,NULL,3,'2026-06-30 18:00:44','2026-06-29 15:20:45',NULL,23,'2026-06-30 15:22:15');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0395',24,24,'赵国庆','138****6253','北岭街道','签收回执','处理中',5,3,'配送上门','北岭街道××社区××路 31 号','运送人 何志远',2,'2026-06-26 18:00:05',NULL,NULL,24,'2026-06-26 16:23:39');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0394',25,25,'陈桂英','138****6264','开发区','分配出库','处理中',6,5,'现场领用',NULL,NULL,6,'2026-06-22 18:00:51',NULL,NULL,25,'2026-06-22 09:24:26');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0393',26,26,'刘德明','138****6275','城西街道','追踪归档','处理中',2,6,'配送上门','城西街道××社区××路 33 号','运送人 何志远',6,'2026-06-18 18:00:10',NULL,NULL,26,'2026-06-18 10:25:02');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0392',27,27,'杨玉梅','138****6286','东湖街道','签收回执','处理中',3,7,'现场领用',NULL,NULL,8,'2026-06-14 18:00:14',NULL,NULL,27,'2026-06-14 11:26:56');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0391',28,28,'黄建国','138****6297','南苑街道','签收回执','处理中',4,3,'配送上门','南苑街道××社区××路 35 号','运送人 何志远',8,'2026-06-10 18:00:46',NULL,NULL,28,'2026-06-10 12:27:15');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0390',29,29,'周美华','138****6308','北岭街道','需求审核','待处理',5,5,'现场领用',NULL,NULL,6,'2026-06-06 18:00:30',NULL,NULL,29,'2026-06-06 13:28:31');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0389',30,30,'吴海涛','138****6319','开发区','追踪归档','已完成',6,6,'配送上门','开发区××社区××路 37 号','运送人 何志远',3,'2026-06-02 18:00:09','2026-06-01 15:20:28',NULL,30,'2026-06-02 14:29:21');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0388',31,31,'王秀兰','138****6000','城西街道','签收回执','处理中',2,7,'现场领用',NULL,NULL,7,'2026-05-29 18:00:34',NULL,NULL,NULL,'2026-05-29 15:30:32');
INSERT INTO `distribution_order` (`order_no`,`application_id`,`beneficiary_id`,`receiver_name`,`receiver_phone`,`region`,`stage`,`status`,`warehouse_id`,`owner_id`,`deliver_type`,`deliver_address`,`carrier`,`total_qty`,`deadline`,`finish_time`,`cancel_reason`,`score_id`,`create_time`) VALUES ('DO-2026-0387',32,32,'李志强','138****6011','东湖街道','签收回执','处理中',3,3,'配送上门','东湖街道××社区××路 39 号','运送人 何志远',8,'2026-05-25 18:00:09',NULL,NULL,NULL,'2026-05-25 16:31:51');
-- distribution_item: 32 行
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (1,1,'一级压榨菜籽油','5L / 桶','桶',2,2,'2026-09-26 10:00:23','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (2,2,'东北长粒香米','10kg / 袋','袋',3,2,'2026-09-22 11:01:53',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (3,3,'加厚羽绒服（成人）','M/L/XL','件',4,2,'2026-09-18 12:02:47',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (4,4,'儿童棉衣','110-150','件',3,4,'2026-09-14 13:03:18','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (5,5,'学生护眼台灯','USB 供电','台',2,2,'2026-09-10 14:04:23',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (6,6,'课外读物','适龄读物','册',1,3,'2026-09-06 15:05:24',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (7,7,'洗衣液（家庭装）','3kg / 瓶','瓶',4,2,'2026-09-02 10:06:47','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (8,8,'成人纸尿裤','L 码 20 片','包',4,4,'2026-08-29 11:07:29',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (9,9,'轮椅','折叠式','台',3,1,'2026-08-25 12:08:33',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (10,10,'棉被','200×230','床',2,3,'2026-08-21 13:09:30','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (11,11,'一级压榨菜籽油','5L / 桶','桶',3,2,'2026-08-17 14:10:11',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (12,12,'东北长粒香米','10kg / 袋','袋',1,3,'2026-08-13 15:11:56',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (13,13,'加厚羽绒服（成人）','M/L/XL','件',4,4,'2026-08-09 10:12:18','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (14,14,'儿童棉衣','110-150','件',2,1,'2026-08-05 11:13:26',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (15,15,'学生护眼台灯','USB 供电','台',3,1,'2026-08-01 12:14:45',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (16,16,'课外读物','适龄读物','册',1,2,'2026-07-28 13:15:56','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (17,17,'洗衣液（家庭装）','3kg / 瓶','瓶',1,3,'2026-07-24 14:16:58',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (18,18,'成人纸尿裤','L 码 20 片','包',3,4,'2026-07-20 15:17:33',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (19,19,'轮椅','折叠式','台',4,1,'2026-07-16 10:18:56','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (20,20,'棉被','200×230','床',1,3,'2026-07-12 11:19:13',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (21,21,'一级压榨菜籽油','5L / 桶','桶',1,2,'2026-07-08 12:20:55',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (22,22,'东北长粒香米','10kg / 袋','袋',4,2,'2026-07-04 13:21:25','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (23,23,'加厚羽绒服（成人）','M/L/XL','件',2,1,'2026-06-30 14:22:10',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (24,24,'儿童棉衣','110-150','件',1,2,'2026-06-26 15:23:22',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (25,1,'学生护眼台灯','USB 供电','台',4,1,'2026-06-22 10:24:49','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (26,2,'课外读物','适龄读物','册',2,1,'2026-06-18 11:25:49',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (27,3,'洗衣液（家庭装）','3kg / 瓶','瓶',1,1,'2026-06-14 12:26:38',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (28,4,'成人纸尿裤','L 码 20 片','包',2,4,'2026-06-10 13:27:54','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (29,5,'轮椅','折叠式','台',2,2,'2026-06-06 14:28:06',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (30,6,'棉被','200×230','床',4,1,'2026-06-02 15:29:20',NULL);
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (31,7,'一级压榨菜籽油','5L / 桶','桶',3,4,'2026-05-29 10:30:37','FEFO 推荐批次');
INSERT INTO `distribution_item` (`order_id`,`batch_id`,`material_name`,`spec`,`unit`,`plan_qty`,`actual_qty`,`pick_time`,`remark`) VALUES (32,8,'东北长粒香米','10kg / 袋','袋',4,4,'2026-05-25 11:31:11',NULL);
-- beneficiary_feedback: 24 行
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0306',1,1,'王秀兰','受助人','收到确认','物资已全部收到，包装完好，感谢捐赠人的关心。','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg',1,'待审核',NULL,NULL,NULL,NULL,'城西街道','2026-09-18 08:00:18');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0305',2,2,'李志强','项目人员','使用反馈','羽绒服已穿用，尺码合适，老人说很暖和。','/uploads/seed/scene/04.jpg',1,'待审核',NULL,NULL,NULL,NULL,'东湖街道','2026-09-13 09:01:56');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0304',3,3,'张素芬','受助人','问题反馈','其中 2 包外包装有轻微破损，内部完好。','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg',1,'待审核',NULL,NULL,NULL,NULL,'南苑街道','2026-09-08 10:02:41');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0303',4,4,'赵国庆','项目人员','收到确认','大米与食用油已收到，社区志愿者送到家门口。','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg',1,'待审核',NULL,NULL,NULL,NULL,'北岭街道','2026-09-03 11:03:26');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0302',5,5,'陈桂英','受助人','使用反馈','物资已全部收到，包装完好，感谢捐赠人的关心。','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg',1,'待审核',NULL,NULL,NULL,NULL,'开发区','2026-08-29 12:04:07');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0301',6,6,'刘德明','项目人员','问题反馈','羽绒服已穿用，尺码合适，老人说很暖和。','/uploads/seed/scene/04.jpg',1,'待审核',NULL,NULL,NULL,NULL,'城西街道','2026-08-24 13:05:37');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0300',7,7,'杨玉梅','受助人','收到确认','其中 2 包外包装有轻微破损，内部完好。','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg',1,'已通过',5,'2026-08-18 17:06:44','内容属实，脱敏后公开',NULL,'东湖街道','2026-08-19 14:06:22');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0299',8,8,'黄建国','项目人员','使用反馈','大米与食用油已收到，社区志愿者送到家门口。','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg',1,'已通过',5,'2026-08-13 18:07:57','内容属实，脱敏后公开',NULL,'南苑街道','2026-08-14 15:07:36');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0298',9,9,'周美华','受助人','问题反馈','物资已全部收到，包装完好，感谢捐赠人的关心。','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg',1,'已通过',5,'2026-08-08 15:08:52','内容属实，脱敏后公开',NULL,'北岭街道','2026-08-09 16:08:16');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0297',10,10,'吴海涛','项目人员','收到确认','羽绒服已穿用，尺码合适，老人说很暖和。','/uploads/seed/scene/04.jpg',1,'已通过',5,'2026-08-03 16:09:46','内容属实，脱敏后公开',NULL,'开发区','2026-08-04 17:09:12');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0296',11,11,'王秀兰','受助人','使用反馈','其中 2 包外包装有轻微破损，内部完好。','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg',1,'已通过',5,'2026-07-29 17:10:05','内容属实，脱敏后公开',NULL,'城西街道','2026-07-30 08:10:13');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0295',12,12,'李志强','项目人员','问题反馈','大米与食用油已收到，社区志愿者送到家门口。','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg',1,'已通过',5,'2026-07-24 18:11:13','内容属实，脱敏后公开',NULL,'东湖街道','2026-07-25 09:11:06');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0294',13,13,'张素芬','受助人','收到确认','物资已全部收到，包装完好，感谢捐赠人的关心。','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg',1,'已通过',5,'2026-07-19 15:12:02','内容属实，脱敏后公开',NULL,'南苑街道','2026-07-20 10:12:52');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0293',14,14,'赵国庆','项目人员','使用反馈','羽绒服已穿用，尺码合适，老人说很暖和。','/uploads/seed/scene/04.jpg',1,'已通过',5,'2026-07-14 16:13:24','内容属实，脱敏后公开',NULL,'北岭街道','2026-07-15 11:13:14');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0292',15,15,'陈桂英','受助人','问题反馈','其中 2 包外包装有轻微破损，内部完好。','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg',1,'已通过',5,'2026-07-09 17:14:21','内容属实，脱敏后公开',NULL,'开发区','2026-07-10 12:14:18');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0291',16,16,'刘德明','项目人员','收到确认','大米与食用油已收到，社区志愿者送到家门口。','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg',1,'已通过',5,'2026-07-04 18:15:42','内容属实，脱敏后公开',NULL,'城西街道','2026-07-05 13:15:01');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0290',17,17,'杨玉梅','受助人','使用反馈','物资已全部收到，包装完好，感谢捐赠人的关心。','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg',1,'已通过',5,'2026-06-29 15:16:02','内容属实，脱敏后公开',NULL,'东湖街道','2026-06-30 14:16:08');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0289',18,18,'黄建国','项目人员','问题反馈','羽绒服已穿用，尺码合适，老人说很暖和。','/uploads/seed/scene/04.jpg',1,'已通过',5,'2026-06-24 16:17:36','内容属实，脱敏后公开',NULL,'南苑街道','2026-06-25 15:17:12');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0288',19,19,'周美华','受助人','收到确认','其中 2 包外包装有轻微破损，内部完好。','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg',1,'已通过',5,'2026-06-19 17:18:25','内容属实，脱敏后公开',NULL,'北岭街道','2026-06-20 16:18:13');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0287',20,20,'吴海涛','项目人员','使用反馈','大米与食用油已收到，社区志愿者送到家门口。','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg',1,'已通过',5,'2026-06-14 18:19:23','内容属实，脱敏后公开',NULL,'开发区','2026-06-15 17:19:34');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0286',21,21,'王秀兰','受助人','问题反馈','物资已全部收到，包装完好，感谢捐赠人的关心。','/uploads/seed/scene/01.jpg,/uploads/seed/scene/02.jpg',1,'已驳回',5,'2026-06-09 15:20:27','含他人信息，驳回修改','手机号','城西街道','2026-06-10 08:20:16');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0285',22,22,'李志强','项目人员','收到确认','羽绒服已穿用，尺码合适，老人说很暖和。','/uploads/seed/scene/04.jpg',1,'已驳回',5,'2026-06-04 16:21:15','含他人信息，驳回修改','手机号','东湖街道','2026-06-05 09:21:07');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0284',23,23,'张素芬','受助人','使用反馈','其中 2 包外包装有轻微破损，内部完好。','/uploads/seed/scene/03.jpg,/uploads/seed/scene/04.jpg',1,'已驳回',5,'2026-05-30 17:22:45','含他人信息，驳回修改','手机号','南苑街道','2026-05-31 10:22:30');
INSERT INTO `beneficiary_feedback` (`feedback_no`,`order_id`,`application_id`,`submitter`,`submitter_type`,`feedback_type`,`content`,`photos`,`public_flag`,`audit_status`,`audit_user_id`,`audit_time`,`audit_opinion`,`sensitive_hit`,`region`,`create_time`) VALUES ('FB-2026-0283',24,24,'赵国庆','项目人员','问题反馈','大米与食用油已收到，社区志愿者送到家门口。','/uploads/seed/scene/02.jpg,/uploads/seed/scene/03.jpg',1,'已驳回',5,'2026-05-25 18:23:48','含他人信息，驳回修改','手机号','北岭街道','2026-05-26 11:23:27');
-- charity_material_record: 60 行
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',1,'INT-0862','—','待预审','提交意向','物资符合需求，仓位已预留',2,'许文山','2026-10-08 09:00:53',NULL,'2026-10-08 09:00:53');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',2,'RCV-0861','待预审','待送达','预审通过','实收与应收差异 2 件，已现场拍照',3,'柳知远','2026-10-06 10:01:23',NULL,'2026-10-06 10:01:23');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('收货验收',3,'AID-0860','待验收','已入库','提交验收','资格符合，按限领规则批准',4,'王凤娟','2026-10-04 11:02:32',NULL,'2026-10-04 11:02:32');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',4,'DO-0859','待审核','待拣货','资格审核','FEFO 推荐批次可用量充足',5,'周慧兰','2026-10-02 12:03:01',NULL,'2026-10-02 12:03:01');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',5,'INT-0858','待拣货','待领用','拣货完成','受助人本人到场领取',6,'陈砚秋','2026-09-30 13:04:19',NULL,'2026-09-30 13:04:19');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',6,'RCV-0857','待领用','待反馈','签收回执','反馈审核通过并公开',2,'许文山','2026-09-28 14:05:37',NULL,'2026-09-28 14:05:37');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',7,'AID-0856','待反馈','已完成','追踪归档','物资符合需求，仓位已预留',3,'柳知远','2026-09-26 15:06:52',NULL,'2026-09-26 15:06:52');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',8,'DO-0855','待审核','已退回','退回申请','实收与应收差异 2 件，已现场拍照',4,'王凤娟','2026-09-24 16:07:28',NULL,'2026-09-24 16:07:28');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',9,'INT-0854','—','待预审','提交意向','资格符合，按限领规则批准',5,'周慧兰','2026-09-22 17:08:53',NULL,'2026-09-22 17:08:53');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',10,'RCV-0853','待预审','待送达','预审通过','FEFO 推荐批次可用量充足',6,'陈砚秋','2026-09-20 09:09:10',NULL,'2026-09-20 09:09:10');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('收货验收',11,'AID-0852','待验收','已入库','提交验收','受助人本人到场领取',2,'许文山','2026-09-18 10:10:49',NULL,'2026-09-18 10:10:49');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',12,'DO-0851','待审核','待拣货','资格审核','反馈审核通过并公开',3,'柳知远','2026-09-16 11:11:52',NULL,'2026-09-16 11:11:52');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',13,'INT-0850','待拣货','待领用','拣货完成','物资符合需求，仓位已预留',4,'王凤娟','2026-09-14 12:12:55',NULL,'2026-09-14 12:12:55');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',14,'RCV-0849','待领用','待反馈','签收回执','实收与应收差异 2 件，已现场拍照',5,'周慧兰','2026-09-12 13:13:44',NULL,'2026-09-12 13:13:44');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',15,'AID-0848','待反馈','已完成','追踪归档','资格符合，按限领规则批准',6,'陈砚秋','2026-09-10 14:14:15',NULL,'2026-09-10 14:14:15');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',16,'DO-0847','待审核','已退回','退回申请','FEFO 推荐批次可用量充足',2,'许文山','2026-09-08 15:15:00',NULL,'2026-09-08 15:15:00');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',17,'INT-0846','—','待预审','提交意向','受助人本人到场领取',3,'柳知远','2026-09-06 16:16:13',NULL,'2026-09-06 16:16:13');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',18,'RCV-0845','待预审','待送达','预审通过','反馈审核通过并公开',4,'王凤娟','2026-09-04 17:17:43',NULL,'2026-09-04 17:17:43');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('收货验收',19,'AID-0844','待验收','已入库','提交验收','物资符合需求，仓位已预留',5,'周慧兰','2026-09-02 09:18:48',NULL,'2026-09-02 09:18:48');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',20,'DO-0843','待审核','待拣货','资格审核','实收与应收差异 2 件，已现场拍照',6,'陈砚秋','2026-08-31 10:19:10',NULL,'2026-08-31 10:19:10');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',21,'INT-0842','待拣货','待领用','拣货完成','资格符合，按限领规则批准',2,'许文山','2026-08-29 11:20:40',NULL,'2026-08-29 11:20:40');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',22,'RCV-0841','待领用','待反馈','签收回执','FEFO 推荐批次可用量充足',3,'柳知远','2026-08-27 12:21:56',NULL,'2026-08-27 12:21:56');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',23,'AID-0840','待反馈','已完成','追踪归档','受助人本人到场领取',4,'王凤娟','2026-08-25 13:22:56',NULL,'2026-08-25 13:22:56');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',24,'DO-0839','待审核','已退回','退回申请','反馈审核通过并公开',5,'周慧兰','2026-08-23 14:23:00',NULL,'2026-08-23 14:23:00');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',25,'INT-0838','—','待预审','提交意向','物资符合需求，仓位已预留',6,'陈砚秋','2026-08-21 15:24:18',NULL,'2026-08-21 15:24:18');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',26,'RCV-0837','待预审','待送达','预审通过','实收与应收差异 2 件，已现场拍照',2,'许文山','2026-08-19 16:25:51',NULL,'2026-08-19 16:25:51');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('收货验收',27,'AID-0836','待验收','已入库','提交验收','资格符合，按限领规则批准',3,'柳知远','2026-08-17 17:26:59',NULL,'2026-08-17 17:26:59');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',28,'DO-0835','待审核','待拣货','资格审核','FEFO 推荐批次可用量充足',4,'王凤娟','2026-08-15 09:27:57',NULL,'2026-08-15 09:27:57');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',29,'INT-0834','待拣货','待领用','拣货完成','受助人本人到场领取',5,'周慧兰','2026-08-13 10:28:24',NULL,'2026-08-13 10:28:24');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',30,'RCV-0833','待领用','待反馈','签收回执','反馈审核通过并公开',6,'陈砚秋','2026-08-11 11:29:53',NULL,'2026-08-11 11:29:53');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',31,'AID-0832','待反馈','已完成','追踪归档','物资符合需求，仓位已预留',2,'许文山','2026-08-09 12:30:47',NULL,'2026-08-09 12:30:47');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',32,'DO-0831','待审核','已退回','退回申请','实收与应收差异 2 件，已现场拍照',3,'柳知远','2026-08-07 13:31:30',NULL,'2026-08-07 13:31:30');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',1,'INT-0830','—','待预审','提交意向','资格符合，按限领规则批准',4,'王凤娟','2026-08-05 14:32:38',NULL,'2026-08-05 14:32:38');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',2,'RCV-0829','待预审','待送达','预审通过','FEFO 推荐批次可用量充足',5,'周慧兰','2026-08-03 15:33:05',NULL,'2026-08-03 15:33:05');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('收货验收',3,'AID-0828','待验收','已入库','提交验收','受助人本人到场领取',6,'陈砚秋','2026-08-01 16:34:53',NULL,'2026-08-01 16:34:53');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',4,'DO-0827','待审核','待拣货','资格审核','反馈审核通过并公开',2,'许文山','2026-07-30 17:35:34',NULL,'2026-07-30 17:35:34');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',5,'INT-0826','待拣货','待领用','拣货完成','物资符合需求，仓位已预留',3,'柳知远','2026-07-28 09:36:10',NULL,'2026-07-28 09:36:10');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',6,'RCV-0825','待领用','待反馈','签收回执','实收与应收差异 2 件，已现场拍照',4,'王凤娟','2026-07-26 10:37:22',NULL,'2026-07-26 10:37:22');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',7,'AID-0824','待反馈','已完成','追踪归档','资格符合，按限领规则批准',5,'周慧兰','2026-07-24 11:38:19',NULL,'2026-07-24 11:38:19');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',8,'DO-0823','待审核','已退回','退回申请','FEFO 推荐批次可用量充足',6,'陈砚秋','2026-07-22 12:39:58',NULL,'2026-07-22 12:39:58');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',9,'INT-0822','—','待预审','提交意向','受助人本人到场领取',2,'许文山','2026-07-20 13:40:21',NULL,'2026-07-20 13:40:21');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',10,'RCV-0821','待预审','待送达','预审通过','反馈审核通过并公开',3,'柳知远','2026-07-18 14:41:51',NULL,'2026-07-18 14:41:51');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('收货验收',11,'AID-0820','待验收','已入库','提交验收','物资符合需求，仓位已预留',4,'王凤娟','2026-07-16 15:42:29',NULL,'2026-07-16 15:42:29');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',12,'DO-0819','待审核','待拣货','资格审核','实收与应收差异 2 件，已现场拍照',5,'周慧兰','2026-07-14 16:43:51',NULL,'2026-07-14 16:43:51');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',13,'INT-0818','待拣货','待领用','拣货完成','资格符合，按限领规则批准',6,'陈砚秋','2026-07-12 17:44:47',NULL,'2026-07-12 17:44:47');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',14,'RCV-0817','待领用','待反馈','签收回执','FEFO 推荐批次可用量充足',2,'许文山','2026-07-10 09:45:49',NULL,'2026-07-10 09:45:49');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',15,'AID-0816','待反馈','已完成','追踪归档','受助人本人到场领取',3,'柳知远','2026-07-08 10:46:02',NULL,'2026-07-08 10:46:02');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',16,'DO-0815','待审核','已退回','退回申请','反馈审核通过并公开',4,'王凤娟','2026-07-06 11:47:54',NULL,'2026-07-06 11:47:54');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',17,'INT-0814','—','待预审','提交意向','物资符合需求，仓位已预留',5,'周慧兰','2026-07-04 12:48:10',NULL,'2026-07-04 12:48:10');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',18,'RCV-0813','待预审','待送达','预审通过','实收与应收差异 2 件，已现场拍照',6,'陈砚秋','2026-07-02 13:49:31',NULL,'2026-07-02 13:49:31');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('收货验收',19,'AID-0812','待验收','已入库','提交验收','资格符合，按限领规则批准',2,'许文山','2026-06-30 14:50:56',NULL,'2026-06-30 14:50:56');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',20,'DO-0811','待审核','待拣货','资格审核','FEFO 推荐批次可用量充足',3,'柳知远','2026-06-28 15:51:13',NULL,'2026-06-28 15:51:13');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',21,'INT-0810','待拣货','待领用','拣货完成','受助人本人到场领取',4,'王凤娟','2026-06-26 16:52:09',NULL,'2026-06-26 16:52:09');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',22,'RCV-0809','待领用','待反馈','签收回执','反馈审核通过并公开',5,'周慧兰','2026-06-24 17:53:51',NULL,'2026-06-24 17:53:51');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('发放追踪单',23,'AID-0808','待反馈','已完成','追踪归档','物资符合需求，仓位已预留',6,'陈砚秋','2026-06-22 09:54:32',NULL,'2026-06-22 09:54:32');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',24,'DO-0807','待审核','已退回','退回申请','实收与应收差异 2 件，已现场拍照',2,'许文山','2026-06-20 10:55:34',NULL,'2026-06-20 10:55:34');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',25,'INT-0806','—','待预审','提交意向','资格符合，按限领规则批准',3,'柳知远','2026-06-18 11:56:36',NULL,'2026-06-18 11:56:36');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('捐赠意向',26,'RCV-0805','待预审','待送达','预审通过','FEFO 推荐批次可用量充足',4,'王凤娟','2026-06-16 12:57:50',NULL,'2026-06-16 12:57:50');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('收货验收',27,'AID-0804','待验收','已入库','提交验收','受助人本人到场领取',5,'周慧兰','2026-06-14 13:58:47',NULL,'2026-06-14 13:58:47');
INSERT INTO `charity_material_record` (`biz_type`,`biz_id`,`biz_no`,`from_status`,`to_status`,`action`,`reason`,`operator_id`,`operator_name`,`operate_time`,`remark`,`create_time`) VALUES ('受助申请',28,'DO-0803','待审核','待拣货','资格审核','反馈审核通过并公开',6,'陈砚秋','2026-06-12 14:59:54',NULL,'2026-06-12 14:59:54');
-- charity_material_rule: 3 行
INSERT INTO `charity_material_rule` (`id`,`rule_no`,`rule_name`,`rule_version`,`factor_json`,`weight_total`,`threshold_json`,`status`,`effect_time`,`publisher_id`,`change_note`,`create_time`) VALUES (1,'RULE-001','需求紧迫度与物资分配建议','v3.0','[{"key":"urgency","name":"需求紧迫等级","weight":35,"source":"aid_application.urgency_level"},{"key":"family","name":"家庭人数","weight":15,"source":"aid_application.family_size"},{"key":"history","name":"历史领取量","weight":15,"source":"distribution_order 近12月"},{"key":"stock","name":"库存数量","weight":20,"source":"inventory_batch 可用量"},{"key":"expire","name":"保质期","weight":10,"source":"inventory_batch.expire_date"},{"key":"delivery","name":"区域配送能力","weight":15,"source":"sys_org.delivery_capacity"}]',100,'{"A":80,"B":60,"C":40}','停用','2026-08-29 09:00:28',1,'首次引入六因素加权模型，替代原单一紧迫度排序','2026-08-29 12:01:39');
INSERT INTO `charity_material_rule` (`id`,`rule_no`,`rule_name`,`rule_version`,`factor_json`,`weight_total`,`threshold_json`,`status`,`effect_time`,`publisher_id`,`change_note`,`create_time`) VALUES (2,'RULE-002','需求紧迫度与物资分配建议','v3.1','[{"key":"urgency","name":"需求紧迫等级","weight":25,"source":"aid_application.urgency_level"},{"key":"family","name":"家庭人数","weight":15,"source":"aid_application.family_size"},{"key":"history","name":"历史领取量","weight":20,"source":"distribution_order 近12月"},{"key":"stock","name":"库存数量","weight":15,"source":"inventory_batch 可用量"},{"key":"expire","name":"保质期","weight":10,"source":"inventory_batch.expire_date"},{"key":"delivery","name":"区域配送能力","weight":15,"source":"sys_org.delivery_capacity"}]',100,'{"A":80,"B":60,"C":40}','停用','2026-07-10 09:00:43',1,'修正保质期评分阈值，临期批次优先出库','2026-07-10 15:05:14');
INSERT INTO `charity_material_rule` (`id`,`rule_no`,`rule_name`,`rule_version`,`factor_json`,`weight_total`,`threshold_json`,`status`,`effect_time`,`publisher_id`,`change_note`,`create_time`) VALUES (3,'RULE-003','需求紧迫度与物资分配建议','v3.2','[{"key":"urgency","name":"需求紧迫等级","weight":25,"source":"aid_application.urgency_level"},{"key":"family","name":"家庭人数","weight":15,"source":"aid_application.family_size"},{"key":"history","name":"历史领取量","weight":15,"source":"distribution_order 近12月"},{"key":"stock","name":"库存数量","weight":20,"source":"inventory_batch 可用量"},{"key":"expire","name":"保质期","weight":10,"source":"inventory_batch.expire_date"},{"key":"delivery","name":"区域配送能力","weight":15,"source":"sys_org.delivery_capacity"}]',100,'{"A":80,"B":60,"C":40}','启用','2026-05-25 09:00:09',1,'提高紧迫等级权重至 25%，新增区域配送能力因素','2026-05-25 09:14:11');
-- charity_material_score: 30 行
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0418',1,1,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',73.0,'常规分配','按申请数量 80% 发放','年度累计领取量已接近上限（米面粮油 42/60 kg）','补充家庭收入流水可提升紧迫等级判定精度','2026-09-28 09:00:02',1,'按年度累计上限调整，保障后续月份可领',3,'2026-09-28 10:05:26');
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0417',2,2,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',66.8,'常规分配','按申请数量 80% 发放',NULL,NULL,'2026-09-24 10:01:40',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0416',3,3,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',47.3,'暂缓分配','按申请数量 80% 发放',NULL,'补充家庭收入流水可提升紧迫等级判定精度','2026-09-20 11:02:06',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0415',4,4,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',30.3,'不推荐','按申请数量 80% 发放','年度累计领取量已接近上限（米面粮油 42/60 kg）',NULL,'2026-09-16 12:03:49',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0414',5,5,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',92.3,'优先分配','菜籽油 3 桶 · 大米 1 袋 · 羽绒服 1 件',NULL,'补充家庭收入流水可提升紧迫等级判定精度','2026-09-12 13:04:28',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0413',6,6,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',72.2,'常规分配','按申请数量 80% 发放',NULL,NULL,'2026-09-08 14:05:49',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0412',7,7,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',48.0,'暂缓分配','按申请数量 80% 发放','年度累计领取量已接近上限（米面粮油 42/60 kg）','补充家庭收入流水可提升紧迫等级判定精度','2026-09-04 15:06:49',1,'按年度累计上限调整，保障后续月份可领',3,'2026-09-04 10:05:14');
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0411',8,8,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',84.1,'优先分配','菜籽油 3 桶 · 大米 1 袋 · 羽绒服 1 件',NULL,NULL,'2026-08-31 16:07:09',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0410',9,9,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',92.3,'优先分配','菜籽油 3 桶 · 大米 1 袋 · 羽绒服 1 件',NULL,'补充家庭收入流水可提升紧迫等级判定精度','2026-08-27 09:08:38',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0409',10,10,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',66.4,'常规分配','按申请数量 80% 发放','年度累计领取量已接近上限（米面粮油 42/60 kg）',NULL,'2026-08-23 10:09:36',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0408',11,11,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',46.9,'暂缓分配','按申请数量 80% 发放',NULL,'补充家庭收入流水可提升紧迫等级判定精度','2026-08-19 11:10:38',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0407',12,12,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',38.8,'不推荐','按申请数量 80% 发放',NULL,NULL,'2026-08-15 12:11:25',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0406',13,13,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',90.7,'优先分配','菜籽油 3 桶 · 大米 1 袋 · 羽绒服 1 件','年度累计领取量已接近上限（米面粮油 42/60 kg）','补充家庭收入流水可提升紧迫等级判定精度','2026-08-11 13:12:19',1,'按年度累计上限调整，保障后续月份可领',3,'2026-08-11 10:05:02');
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0405',14,14,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',64.3,'常规分配','按申请数量 80% 发放',NULL,NULL,'2026-08-07 14:13:21',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0404',15,15,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',36.2,'不推荐','按申请数量 80% 发放',NULL,'补充家庭收入流水可提升紧迫等级判定精度','2026-08-03 15:14:48',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0403',16,16,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',33.2,'不推荐','按申请数量 80% 发放','年度累计领取量已接近上限（米面粮油 42/60 kg）',NULL,'2026-07-30 16:15:00',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0402',17,17,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',95.7,'优先分配','菜籽油 3 桶 · 大米 1 袋 · 羽绒服 1 件',NULL,'补充家庭收入流水可提升紧迫等级判定精度','2026-07-26 09:16:33',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0401',18,18,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',78.3,'常规分配','按申请数量 80% 发放',NULL,NULL,'2026-07-22 10:17:08',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0400',19,19,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',46.8,'暂缓分配','按申请数量 80% 发放','年度累计领取量已接近上限（米面粮油 42/60 kg）','补充家庭收入流水可提升紧迫等级判定精度','2026-07-18 11:18:46',1,'按年度累计上限调整，保障后续月份可领',3,'2026-07-18 10:05:02');
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0399',20,20,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',36.7,'不推荐','按申请数量 80% 发放',NULL,NULL,'2026-07-14 12:19:17',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0398',21,21,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',82.1,'优先分配','菜籽油 3 桶 · 大米 1 袋 · 羽绒服 1 件',NULL,'补充家庭收入流水可提升紧迫等级判定精度','2026-07-10 13:20:43',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0397',22,22,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',42.9,'暂缓分配','按申请数量 80% 发放','年度累计领取量已接近上限（米面粮油 42/60 kg）',NULL,'2026-07-06 14:21:36',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0396',23,23,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',44.1,'暂缓分配','按申请数量 80% 发放',NULL,'补充家庭收入流水可提升紧迫等级判定精度','2026-07-02 15:22:52',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0395',24,24,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',37.9,'不推荐','按申请数量 80% 发放',NULL,NULL,'2026-06-28 16:23:14',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0394',25,25,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',83.8,'优先分配','菜籽油 3 桶 · 大米 1 袋 · 羽绒服 1 件','年度累计领取量已接近上限（米面粮油 42/60 kg）','补充家庭收入流水可提升紧迫等级判定精度','2026-06-24 09:24:35',1,'按年度累计上限调整，保障后续月份可领',3,'2026-06-24 10:05:06');
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0393',26,26,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',65.1,'常规分配','按申请数量 80% 发放',NULL,NULL,'2026-06-20 10:25:03',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0392',27,27,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',51.5,'暂缓分配','按申请数量 80% 发放',NULL,'补充家庭收入流水可提升紧迫等级判定精度','2026-06-16 11:26:56',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0391',28,28,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',39.0,'不推荐','按申请数量 80% 发放','年度累计领取量已接近上限（米面粮油 42/60 kg）',NULL,'2026-06-12 12:27:02',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0390',29,29,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',66.4,'常规分配','按申请数量 80% 发放',NULL,'补充家庭收入流水可提升紧迫等级判定精度','2026-06-08 13:28:47',0,NULL,NULL,NULL);
INSERT INTO `charity_material_score` (`score_no`,`application_id`,`order_id`,`rule_id`,`rule_version`,`snapshot_json`,`factor_json`,`total_score`,`result_level`,`suggestion`,`unmet`,`improve`,`calc_time`,`adjust_flag`,`adjust_reason`,`adjust_user_id`,`adjust_time`) VALUES ('SCR-2026-0389',30,30,3,'v3.2','{"urgency":"特急","familySize":4,"history12m":"42kg","stockRate":"100%","expireDays":72,"delivery":"高"}','[{"key":"urgency","score":100,"weight":25,"got":24.0},{"key":"family","score":80,"weight":15,"got":12.0},{"key":"history","score":47,"weight":15,"got":7.05},{"key":"stock","score":88,"weight":20,"got":17.6},{"key":"expire","score":72,"weight":10,"got":7.2},{"key":"delivery","score":100,"weight":15,"got":15.0}]',68.4,'常规分配','按申请数量 80% 发放',NULL,NULL,'2026-06-04 14:29:19',0,NULL,NULL,NULL);
-- inventory_check: 20 行
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0120',2,'A-01-01',1,170,170,0,5,'2026-08-29 14:00:37','正常',NULL,'2026-08-29 14:00:37');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0119',3,'B-02-02',2,28,28,0,6,'2026-08-24 15:01:03','正常',NULL,'2026-08-24 15:01:03');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0118',4,'C-03-03',3,217,217,0,7,'2026-08-19 16:02:35','正常',NULL,'2026-08-19 16:02:35');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0117',5,'D-04-04',4,106,106,0,5,'2026-08-14 17:03:19','正常',NULL,'2026-08-14 17:03:19');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0116',6,'E-05-01',5,207,207,0,6,'2026-08-09 14:04:33','正常',NULL,'2026-08-09 14:04:33');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0115',2,'A-06-02',6,105,105,0,7,'2026-08-04 15:05:52','正常',NULL,'2026-08-04 15:05:52');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0114',3,'B-01-03',7,135,135,0,5,'2026-07-30 16:06:53','正常',NULL,'2026-07-30 16:06:53');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0113',4,'C-02-04',8,163,163,0,6,'2026-07-25 17:07:20','正常',NULL,'2026-07-25 17:07:20');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0112',5,'D-03-01',9,49,49,0,7,'2026-07-20 14:08:05','正常',NULL,'2026-07-20 14:08:05');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0111',6,'E-04-02',10,191,191,0,5,'2026-07-15 15:09:11','正常',NULL,'2026-07-15 15:09:11');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0110',2,'A-05-03',11,86,86,0,6,'2026-07-10 16:10:02','正常',NULL,'2026-07-10 16:10:02');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0109',3,'B-06-04',12,100,100,0,7,'2026-07-05 17:11:19','正常',NULL,'2026-07-05 17:11:19');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0108',4,'C-01-01',13,163,163,0,5,'2026-06-30 14:12:58','正常',NULL,'2026-06-30 14:12:58');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0107',5,'D-02-02',14,109,109,0,6,'2026-06-25 15:13:08','正常',NULL,'2026-06-25 15:13:08');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0106',6,'E-03-03',15,101,99,-2,7,'2026-06-20 16:14:54','差异待复核','账面与实盘不符，待复核','2026-06-20 16:14:54');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0105',2,'A-04-04',16,191,188,-3,5,'2026-06-15 17:15:28','差异待复核','账面与实盘不符，待复核','2026-06-15 17:15:28');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0104',3,'B-05-01',17,218,219,1,6,'2026-06-10 14:16:40','差异待复核','账面与实盘不符，待复核','2026-06-10 14:16:40');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0103',4,'C-06-02',18,217,214,-3,7,'2026-06-05 15:17:40','差异待复核','账面与实盘不符，待复核','2026-06-05 15:17:40');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0102',5,'D-01-03',19,39,36,-3,5,'2026-05-31 16:18:22','已调整','账面与实盘不符，待复核','2026-05-31 16:18:22');
INSERT INTO `inventory_check` (`check_no`,`warehouse_id`,`position`,`batch_id`,`book_qty`,`real_qty`,`diff_qty`,`check_user_id`,`check_time`,`status`,`remark`,`create_time`) VALUES ('CHK-2026-0101',6,'E-02-04',20,81,79,-2,6,'2026-05-26 17:19:24','已调整','账面与实盘不符，待复核','2026-05-26 17:19:24');
-- sys_message: 20 行
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('待审批提醒','捐赠意向 INT-0862（青禾商贸，菜籽油 200 桶）待您预审，预约送达时间 2026-11-03 09:00。','待审批','INT','INT-0862',1,'intent',1,0,'2026-08-29 09:00:04');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('即将超时提醒','发放追踪单 DO-2026-0418 距截止时间不足 32 小时，当前阶段「分配出库」。','即将超时','DO','DO-2026-0418',2,'distribution',1,0,'2026-08-24 10:01:36');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('待验收提醒','收货任务 RCV-2026-1031-018（城西社区爱心志愿队，洗衣液 150 瓶）已到仓，请验收。','待验收','RCV','RCV-2026-1031-018',3,'receiving',1,0,'2026-08-19 11:02:35');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('已退回提醒','受助申请 AID-2026-0398 被退回：年度累计领取量已超上限，请补充材料后重新提交。','已退回','AID','AID-2026-0398',4,'application',1,0,'2026-08-14 12:03:49');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('已完成提醒','发放追踪单 DO-2026-0403 已完成归档，受助人反馈已审核通过并公开。','已完成','DO','DO-2026-0403',5,'distribution',1,0,'2026-08-09 13:04:32');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('待审批提醒','去向反馈 FB-2026-0306 待审核，提交人 陈**，含 2 张照片。','待审批','FB','FB-2026-0306',6,'intent',1,0,'2026-08-04 14:05:48');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('异常提醒','批次 BAT-260802-03（东北长粒香米）已过期，系统已自动锁定，请登记处置方式。','异常','BAT','BAT-260802-03',7,'batch',1,1,'2026-07-30 15:06:03');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('待审批提醒','捐赠意向 INT-0862（青禾商贸，菜籽油 200 桶）待您预审，预约送达时间 2026-11-03 09:00。','待审批','INT','INT-0862',8,'intent',2,1,'2026-07-25 16:07:49');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('即将超时提醒','发放追踪单 DO-2026-0418 距截止时间不足 32 小时，当前阶段「分配出库」。','即将超时','DO','DO-2026-0418',9,'distribution',2,1,'2026-07-20 17:08:01');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('待验收提醒','收货任务 RCV-2026-1031-018（城西社区爱心志愿队，洗衣液 150 瓶）已到仓，请验收。','待验收','RCV','RCV-2026-1031-018',10,'receiving',1,1,'2026-07-15 09:09:32');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('已退回提醒','受助申请 AID-2026-0398 被退回：年度累计领取量已超上限，请补充材料后重新提交。','已退回','AID','AID-2026-0398',11,'application',2,1,'2026-07-10 10:10:22');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('已完成提醒','发放追踪单 DO-2026-0403 已完成归档，受助人反馈已审核通过并公开。','已完成','DO','DO-2026-0403',12,'distribution',2,1,'2026-07-05 11:11:56');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('待审批提醒','去向反馈 FB-2026-0306 待审核，提交人 陈**，含 2 张照片。','待审批','FB','FB-2026-0306',13,'intent',1,1,'2026-06-30 12:12:11');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('异常提醒','批次 BAT-260802-03（东北长粒香米）已过期，系统已自动锁定，请登记处置方式。','异常','BAT','BAT-260802-03',14,'batch',2,1,'2026-06-25 13:13:50');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('待审批提醒','捐赠意向 INT-0862（青禾商贸，菜籽油 200 桶）待您预审，预约送达时间 2026-11-03 09:00。','待审批','INT','INT-0862',15,'intent',2,1,'2026-06-20 14:14:26');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('即将超时提醒','发放追踪单 DO-2026-0418 距截止时间不足 32 小时，当前阶段「分配出库」。','即将超时','DO','DO-2026-0418',16,'distribution',1,1,'2026-06-15 15:15:36');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('待验收提醒','收货任务 RCV-2026-1031-018（城西社区爱心志愿队，洗衣液 150 瓶）已到仓，请验收。','待验收','RCV','RCV-2026-1031-018',17,'receiving',2,1,'2026-06-10 16:16:12');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('已退回提醒','受助申请 AID-2026-0398 被退回：年度累计领取量已超上限，请补充材料后重新提交。','已退回','AID','AID-2026-0398',18,'application',2,1,'2026-06-05 17:17:27');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('已完成提醒','发放追踪单 DO-2026-0403 已完成归档，受助人反馈已审核通过并公开。','已完成','DO','DO-2026-0403',19,'distribution',1,1,'2026-05-31 09:18:26');
INSERT INTO `sys_message` (`title`,`content`,`msg_type`,`biz_type`,`biz_no`,`biz_id`,`biz_url`,`receiver_id`,`read_flag`,`create_time`) VALUES ('待审批提醒','去向反馈 FB-2026-0306 待审核，提交人 陈**，含 2 张照片。','待审批','FB','FB-2026-0306',20,'intent',2,1,'2026-05-26 10:19:41');
-- sys_oper_log: 30 行
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (1,'许文山','项目管理员','捐赠意向','预审','INT-0862','待预审','待送达','192.168.1.12','正常','2026-09-28 09:00:10');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (2,'柳知远','仓储志愿者','收货验收','提交验收','RCV-0861','待验收','已入库','192.168.1.13','正常','2026-09-24 10:01:29');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (3,'王凤娟','受助审核员','受助申请','资格审核','AID-0860','待审核','待拣货','192.168.1.14','正常','2026-09-20 11:02:26');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (4,'周慧兰','项目管理员','受助申请','人工调整','DO-0859','—','—','192.168.1.15','正常','2026-09-16 12:03:10');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (5,'陈砚秋','仓储志愿者','发放追踪单','拣货完成','INT-0858','待拣货','待领用','192.168.1.16','正常','2026-09-12 13:04:18');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (6,'许文山','受助审核员','规则配置','发布规则','RCV-0857','v3.1','v3.2','192.168.1.17','正常','2026-09-08 14:05:43');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (7,'柳知远','项目管理员','系统登录','登录','AID-0856','—','—','192.168.1.18','正常','2026-09-04 15:06:55');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (8,'王凤娟','仓储志愿者','系统登录','登录','DO-0855','—','—','192.168.1.19','密码错误，已锁定','2026-08-31 16:07:40');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (9,'周慧兰','受助审核员','捐赠意向','预审','INT-0854','待预审','待送达','192.168.1.20','正常','2026-08-27 17:08:41');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (10,'陈砚秋','项目管理员','收货验收','提交验收','RCV-0853','待验收','已入库','192.168.1.21','正常','2026-08-23 09:09:52');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (11,'许文山','仓储志愿者','受助申请','资格审核','AID-0852','待审核','待拣货','192.168.1.22','正常','2026-08-19 10:10:46');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (12,'柳知远','受助审核员','受助申请','人工调整','DO-0851','—','—','192.168.1.23','正常','2026-08-15 11:11:06');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (1,'王凤娟','项目管理员','发放追踪单','拣货完成','INT-0850','待拣货','待领用','192.168.1.24','正常','2026-08-11 12:12:41');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (2,'周慧兰','仓储志愿者','规则配置','发布规则','RCV-0849','v3.1','v3.2','192.168.1.25','正常','2026-08-07 13:13:50');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (3,'陈砚秋','受助审核员','系统登录','登录','AID-0848','—','—','192.168.1.26','正常','2026-08-03 14:14:51');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (4,'许文山','项目管理员','系统登录','登录','DO-0847','—','—','192.168.1.27','密码错误，已锁定','2026-07-30 15:15:19');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (5,'柳知远','仓储志愿者','捐赠意向','预审','INT-0846','待预审','待送达','192.168.1.28','正常','2026-07-26 16:16:42');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (6,'王凤娟','受助审核员','收货验收','提交验收','RCV-0845','待验收','已入库','192.168.1.29','正常','2026-07-22 17:17:34');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (7,'周慧兰','项目管理员','受助申请','资格审核','AID-0844','待审核','待拣货','192.168.1.30','正常','2026-07-18 09:18:57');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (8,'陈砚秋','仓储志愿者','受助申请','人工调整','DO-0843','—','—','192.168.1.31','正常','2026-07-14 10:19:45');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (9,'许文山','受助审核员','发放追踪单','拣货完成','INT-0842','待拣货','待领用','192.168.1.32','正常','2026-07-10 11:20:44');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (10,'柳知远','项目管理员','规则配置','发布规则','RCV-0841','v3.1','v3.2','192.168.1.33','正常','2026-07-06 12:21:34');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (11,'王凤娟','仓储志愿者','系统登录','登录','AID-0840','—','—','192.168.1.34','正常','2026-07-02 13:22:20');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (12,'周慧兰','受助审核员','系统登录','登录','DO-0839','—','—','192.168.1.35','密码错误，已锁定','2026-06-28 14:23:27');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (1,'陈砚秋','项目管理员','捐赠意向','预审','INT-0838','待预审','待送达','192.168.1.36','正常','2026-06-24 15:24:42');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (2,'许文山','仓储志愿者','收货验收','提交验收','RCV-0837','待验收','已入库','192.168.1.37','正常','2026-06-20 16:25:35');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (3,'柳知远','受助审核员','受助申请','资格审核','AID-0836','待审核','待拣货','192.168.1.38','正常','2026-06-16 17:26:34');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (4,'王凤娟','项目管理员','受助申请','人工调整','DO-0835','—','—','192.168.1.39','正常','2026-06-12 09:27:00');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (5,'周慧兰','仓储志愿者','发放追踪单','拣货完成','INT-0834','待拣货','待领用','192.168.1.40','正常','2026-06-08 10:28:03');
INSERT INTO `sys_oper_log` (`user_id`,`user_name`,`role_code`,`module`,`action`,`biz_no`,`from_status`,`to_status`,`ip`,`result`,`operate_time`) VALUES (6,'陈砚秋','受助审核员','规则配置','发布规则','RCV-0833','v3.1','v3.2','192.168.1.41','正常','2026-06-04 11:29:33');
-- sys_file: 12 行
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('低保证明.pdf','/uploads/seed/scene/01.jpg',2297868,'application/pdf','application',1,'2026-09-28 10:00:42');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('户口本首页.jpg','/uploads/seed/scene/02.jpg',466933,'image/jpeg','receiving',2,'2026-09-22 11:01:32');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('诊断证明.pdf','/uploads/seed/scene/03.jpg',1309366,'application/pdf','feedback',3,'2026-09-16 12:02:17');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('手写申请.jpg','/uploads/seed/scene/04.jpg',1808514,'image/jpeg','material',4,'2026-09-10 13:03:38');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('验收现场-1.jpg','/uploads/seed/scene/01.jpg',884208,'image/jpeg','application',5,'2026-09-04 14:04:03');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('验收现场-2.jpg','/uploads/seed/scene/02.jpg',1117976,'image/jpeg','receiving',6,'2026-08-29 15:05:02');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('签字照片.jpg','/uploads/seed/scene/03.jpg',625668,'image/jpeg','feedback',7,'2026-08-23 16:06:14');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('配送凭证.jpg','/uploads/seed/scene/04.jpg',1464831,'image/jpeg','material',8,'2026-08-17 17:07:57');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('物资图片-1.jpg','/uploads/seed/material/01.jpg',1439830,'image/jpeg','application',9,'2026-08-11 10:08:02');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('物资图片-2.jpg','/uploads/seed/material/02.jpg',2217986,'image/jpeg','receiving',10,'2026-08-05 11:09:32');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('项目封面.jpg','/uploads/seed/project/01.jpg',1308333,'image/jpeg','feedback',11,'2026-07-30 12:10:05');
INSERT INTO `sys_file` (`file_name`,`file_path`,`file_size`,`content_type`,`biz_type`,`uploader_id`,`upload_time`) VALUES ('反馈照片.jpg','/uploads/seed/scene/01.jpg',1598050,'image/jpeg','material',12,'2026-07-24 13:11:41');
-- ---------------- 索引 ----------------
CREATE INDEX idx_intent_status ON donation_intent (status);
CREATE INDEX idx_intent_donor ON donation_intent (donor_id);
CREATE INDEX idx_batch_status ON inventory_batch (status, expire_date);
CREATE INDEX idx_batch_material ON inventory_batch (material_name, warehouse_id);
CREATE INDEX idx_apply_status ON aid_application (status, apply_time);
CREATE INDEX idx_order_stage ON distribution_order (stage, status);
CREATE INDEX idx_order_beneficiary ON distribution_order (beneficiary_id);
CREATE INDEX idx_feedback_audit ON beneficiary_feedback (audit_status);
CREATE INDEX idx_record_biz ON charity_material_record (biz_type, biz_id);
CREATE INDEX idx_score_app ON charity_material_score (application_id);
CREATE INDEX idx_msg_receiver ON sys_message (receiver_id, read_flag);
CREATE INDEX idx_log_user ON sys_oper_log (user_id, operate_time);

SET FOREIGN_KEY_CHECKS = 1;
