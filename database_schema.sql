-- =============================================
-- 防腐保温智能数字平台数据库结构
-- 创建时间: 2024年
-- 描述: 完整的数据库表结构和初始数据
-- =============================================

-- 设置字符集和排序规则
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS corrosion_platform 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE corrosion_platform;

-- =============================================
-- 1. 用户相关表
-- =============================================

-- 用户表
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `user_type` varchar(20) NOT NULL DEFAULT 'personal' COMMENT '用户类型: enterprise-企业用户, personal-个人用户',
  `phone` varchar(11) NOT NULL COMMENT '手机号',
  `avatar` varchar(100) DEFAULT NULL COMMENT '头像',
  `is_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否认证',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_user_type` (`user_type`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 角色表
CREATE TABLE `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '角色名称',
  `code` varchar(50) NOT NULL COMMENT '角色代码',
  `description` longtext COMMENT '角色描述',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- 权限表
CREATE TABLE `permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '权限名称',
  `code` varchar(100) NOT NULL COMMENT '权限代码',
  `description` longtext COMMENT '权限描述',
  `module` varchar(50) NOT NULL COMMENT '所属模块',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_module` (`module`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';

-- 菜单表
CREATE TABLE `menus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '菜单名称',
  `code` varchar(50) NOT NULL COMMENT '菜单代码',
  `url` varchar(200) NOT NULL DEFAULT '' COMMENT '菜单URL',
  `icon` varchar(50) NOT NULL DEFAULT '' COMMENT '菜单图标',
  `parent_id` bigint DEFAULT NULL COMMENT '父菜单ID',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单表';

-- 用户角色关联表
CREATE TABLE `user_roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_roles_user_id_role_id` (`user_id`,`role_id`),
  KEY `user_roles_role_id` (`role_id`),
  CONSTRAINT `user_roles_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- 角色权限关联表
CREATE TABLE `role_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_permissions_role_id_permission_id` (`role_id`,`permission_id`),
  KEY `role_permissions_permission_id` (`permission_id`),
  CONSTRAINT `role_permissions_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_permissions_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

-- 角色菜单关联表
CREATE TABLE `role_menus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_menus_role_id_menu_id` (`role_id`,`menu_id`),
  KEY `role_menus_menu_id` (`menu_id`),
  CONSTRAINT `role_menus_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_menus_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色菜单关联表';

-- 用户登录日志表
CREATE TABLE `user_login_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `ip_address` char(39) NOT NULL COMMENT 'IP地址',
  `user_agent` longtext NOT NULL COMMENT '用户代理',
  `login_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '登录时间',
  `is_success` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否成功',
  PRIMARY KEY (`id`),
  KEY `user_login_logs_user_id` (`user_id`),
  KEY `idx_login_time` (`login_time`),
  KEY `idx_ip_address` (`ip_address`),
  CONSTRAINT `user_login_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户登录日志表';

-- =============================================
-- 2. 企业相关表
-- =============================================

-- 企业信息表
CREATE TABLE `enterprises` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '关联用户ID',
  `name` varchar(200) NOT NULL COMMENT '企业名称',
  `short_name` varchar(100) NOT NULL DEFAULT '' COMMENT '企业简称',
  `enterprise_type` varchar(20) NOT NULL COMMENT '企业类型',
  `unified_social_credit_code` varchar(18) NOT NULL COMMENT '统一社会信用代码',
  `legal_representative` varchar(50) NOT NULL COMMENT '法定代表人',
  `registered_capital` decimal(15,2) DEFAULT NULL COMMENT '注册资本',
  `establishment_date` date DEFAULT NULL COMMENT '成立日期',
  `business_scope` longtext COMMENT '经营范围',
  `address` varchar(500) NOT NULL COMMENT '企业地址',
  `contact_person` varchar(50) NOT NULL COMMENT '联系人',
  `contact_phone` varchar(20) NOT NULL COMMENT '联系电话',
  `contact_email` varchar(254) NOT NULL COMMENT '联系邮箱',
  `website` varchar(200) NOT NULL DEFAULT '' COMMENT '企业网站',
  `description` longtext COMMENT '企业简介',
  `status` varchar(20) NOT NULL DEFAULT 'pending' COMMENT '认证状态',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `unified_social_credit_code` (`unified_social_credit_code`),
  KEY `idx_enterprise_type` (`enterprise_type`),
  KEY `idx_status` (`status`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `enterprises_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企业信息表';

-- 企业资质文件表
CREATE TABLE `enterprise_documents` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `document_type` varchar(30) NOT NULL COMMENT '文件类型',
  `title` varchar(200) NOT NULL COMMENT '文件标题',
  `file` varchar(100) NOT NULL COMMENT '文件路径',
  `description` longtext COMMENT '文件描述',
  `is_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已验证',
  `verified_at` datetime(6) DEFAULT NULL COMMENT '验证时间',
  `verified_by_id` bigint DEFAULT NULL COMMENT '验证人ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `enterprise_documents_enterprise_id` (`enterprise_id`),
  KEY `enterprise_documents_verified_by_id` (`verified_by_id`),
  KEY `idx_document_type` (`document_type`),
  KEY `idx_is_verified` (`is_verified`),
  CONSTRAINT `enterprise_documents_enterprise_id` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`) ON DELETE CASCADE,
  CONSTRAINT `enterprise_documents_verified_by_id` FOREIGN KEY (`verified_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企业资质文件表';

-- 企业员工表
CREATE TABLE `employees` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `employee_id` varchar(50) NOT NULL COMMENT '工号',
  `position` varchar(20) NOT NULL COMMENT '职位',
  `department` varchar(100) NOT NULL DEFAULT '' COMMENT '部门',
  `hire_date` date NOT NULL COMMENT '入职日期',
  `salary` decimal(10,2) DEFAULT NULL COMMENT '薪资',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在职',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `employees_enterprise_id_employee_id` (`enterprise_id`,`employee_id`),
  KEY `idx_position` (`position`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `employees_enterprise_id` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`) ON DELETE CASCADE,
  CONSTRAINT `employees_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企业员工表';

-- 企业项目表
CREATE TABLE `enterprise_projects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `name` varchar(200) NOT NULL COMMENT '项目名称',
  `description` longtext NOT NULL COMMENT '项目描述',
  `client` varchar(200) NOT NULL COMMENT '客户',
  `contract_amount` decimal(15,2) DEFAULT NULL COMMENT '合同金额',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date DEFAULT NULL COMMENT '结束日期',
  `status` varchar(20) NOT NULL DEFAULT 'planning' COMMENT '项目状态',
  `progress` int NOT NULL DEFAULT '0' COMMENT '进度百分比',
  `location` varchar(500) NOT NULL DEFAULT '' COMMENT '项目地点',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `enterprise_projects_enterprise_id` (`enterprise_id`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `enterprise_projects_enterprise_id` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企业项目表';

-- 企业统计表
CREATE TABLE `enterprise_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `total_projects` int NOT NULL DEFAULT '0' COMMENT '总项目数',
  `completed_projects` int NOT NULL DEFAULT '0' COMMENT '已完成项目数',
  `total_employees` int NOT NULL DEFAULT '0' COMMENT '总员工数',
  `total_revenue` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '总收入',
  `total_contracts` int NOT NULL DEFAULT '0' COMMENT '总合同数',
  `last_updated` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '最后更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `enterprise_id` (`enterprise_id`),
  CONSTRAINT `enterprise_statistics_enterprise_id` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企业统计表';

-- =============================================
-- 3. 个人用户相关表
-- =============================================

-- 个人用户信息表
CREATE TABLE `persons` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '关联用户ID',
  `real_name` varchar(50) NOT NULL COMMENT '真实姓名',
  `gender` varchar(10) NOT NULL COMMENT '性别',
  `birth_date` date DEFAULT NULL COMMENT '出生日期',
  `id_card` varchar(18) NOT NULL COMMENT '身份证号',
  `education` varchar(20) NOT NULL COMMENT '学历',
  `profession` varchar(100) NOT NULL COMMENT '职业',
  `work_experience` int NOT NULL DEFAULT '0' COMMENT '工作经验(年)',
  `skills` longtext COMMENT '技能专长',
  `address` varchar(500) NOT NULL COMMENT '居住地址',
  `emergency_contact` varchar(50) NOT NULL COMMENT '紧急联系人',
  `emergency_phone` varchar(20) NOT NULL COMMENT '紧急联系电话',
  `bio` longtext COMMENT '个人简介',
  `is_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否认证',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `id_card` (`id_card`),
  KEY `idx_gender` (`gender`),
  KEY `idx_education` (`education`),
  KEY `idx_profession` (`profession`),
  KEY `idx_is_verified` (`is_verified`),
  CONSTRAINT `persons_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人用户信息表';

-- 个人项目记录表
CREATE TABLE `person_projects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `name` varchar(200) NOT NULL COMMENT '项目名称',
  `project_type` varchar(30) NOT NULL COMMENT '项目类型',
  `description` longtext NOT NULL COMMENT '项目描述',
  `client` varchar(200) NOT NULL COMMENT '客户',
  `role` varchar(100) NOT NULL COMMENT '担任角色',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date DEFAULT NULL COMMENT '结束日期',
  `status` varchar(20) NOT NULL DEFAULT 'planning' COMMENT '项目状态',
  `progress` int NOT NULL DEFAULT '0' COMMENT '进度百分比',
  `location` varchar(500) NOT NULL DEFAULT '' COMMENT '项目地点',
  `income` decimal(10,2) DEFAULT NULL COMMENT '项目收入',
  `achievements` longtext COMMENT '项目成果',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `person_projects_person_id` (`person_id`),
  KEY `idx_project_type` (`project_type`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `person_projects_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人项目记录表';

-- 个人任务记录表
CREATE TABLE `person_tasks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `project_id` bigint DEFAULT NULL COMMENT '关联项目ID',
  `title` varchar(200) NOT NULL COMMENT '任务标题',
  `description` longtext NOT NULL COMMENT '任务描述',
  `priority` varchar(10) NOT NULL DEFAULT 'medium' COMMENT '优先级',
  `status` varchar(20) NOT NULL DEFAULT 'pending' COMMENT '任务状态',
  `due_date` datetime(6) DEFAULT NULL COMMENT '截止时间',
  `completed_at` datetime(6) DEFAULT NULL COMMENT '完成时间',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `person_tasks_person_id` (`person_id`),
  KEY `person_tasks_project_id` (`project_id`),
  KEY `idx_priority` (`priority`),
  KEY `idx_status` (`status`),
  KEY `idx_due_date` (`due_date`),
  CONSTRAINT `person_tasks_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `person_tasks_project_id` FOREIGN KEY (`project_id`) REFERENCES `person_projects` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人任务记录表';

-- 个人统计表
CREATE TABLE `person_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `total_projects` int NOT NULL DEFAULT '0' COMMENT '总项目数',
  `completed_projects` int NOT NULL DEFAULT '0' COMMENT '已完成项目数',
  `total_tasks` int NOT NULL DEFAULT '0' COMMENT '总任务数',
  `completed_tasks` int NOT NULL DEFAULT '0' COMMENT '已完成任务数',
  `total_income` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '总收入',
  `work_days` int NOT NULL DEFAULT '0' COMMENT '工作天数',
  `last_updated` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '最后更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `person_id` (`person_id`),
  CONSTRAINT `person_statistics_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人统计表';

-- 个人资质文件表
CREATE TABLE `person_documents` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `document_type` varchar(20) NOT NULL COMMENT '文件类型',
  `title` varchar(200) NOT NULL COMMENT '文件标题',
  `file` varchar(100) NOT NULL COMMENT '文件路径',
  `description` longtext COMMENT '文件描述',
  `is_public` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否公开',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `person_documents_person_id` (`person_id`),
  KEY `idx_document_type` (`document_type`),
  KEY `idx_is_public` (`is_public`),
  CONSTRAINT `person_documents_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人资质文件表';

-- =============================================
-- 4. 信息广场相关表
-- =============================================

-- 信息分类表
CREATE TABLE `info_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `code` varchar(50) NOT NULL COMMENT '分类代码',
  `description` longtext COMMENT '分类描述',
  `icon` varchar(50) NOT NULL DEFAULT '' COMMENT '分类图标',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息分类表';

-- 信息发布表
CREATE TABLE `info_posts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `author_id` bigint NOT NULL COMMENT '发布者ID',
  `category_id` bigint NOT NULL COMMENT '分类ID',
  `post_type` varchar(20) NOT NULL COMMENT '信息类型',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `content` longtext NOT NULL COMMENT '内容',
  `summary` longtext COMMENT '摘要',
  `tags` varchar(500) NOT NULL DEFAULT '' COMMENT '标签',
  `priority` varchar(10) NOT NULL DEFAULT 'normal' COMMENT '优先级',
  `status` varchar(20) NOT NULL DEFAULT 'draft' COMMENT '状态',
  `is_top` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否置顶',
  `is_recommended` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否推荐',
  `view_count` int NOT NULL DEFAULT '0' COMMENT '浏览次数',
  `like_count` int NOT NULL DEFAULT '0' COMMENT '点赞数',
  `comment_count` int NOT NULL DEFAULT '0' COMMENT '评论数',
  `share_count` int NOT NULL DEFAULT '0' COMMENT '分享数',
  `contact_info` longtext COMMENT '联系信息',
  `location` varchar(200) NOT NULL DEFAULT '' COMMENT '地点',
  `price` decimal(10,2) DEFAULT NULL COMMENT '价格',
  `valid_until` datetime(6) DEFAULT NULL COMMENT '有效期至',
  `published_at` datetime(6) DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `info_posts_author_id` (`author_id`),
  KEY `info_posts_category_id` (`category_id`),
  KEY `idx_post_type` (`post_type`),
  KEY `idx_status` (`status`),
  KEY `idx_published_at` (`published_at`),
  KEY `idx_is_top` (`is_top`),
  KEY `idx_is_recommended` (`is_recommended`),
  CONSTRAINT `info_posts_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `info_posts_category_id` FOREIGN KEY (`category_id`) REFERENCES `info_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息发布表';

-- 信息发布图片表
CREATE TABLE `info_post_images` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `image` varchar(100) NOT NULL COMMENT '图片路径',
  `caption` varchar(200) NOT NULL DEFAULT '' COMMENT '图片说明',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `info_post_images_post_id` (`post_id`),
  KEY `idx_sort_order` (`sort_order`),
  CONSTRAINT `info_post_images_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息发布图片表';

-- 信息评论表
CREATE TABLE `info_comments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `author_id` bigint NOT NULL COMMENT '评论者ID',
  `parent_id` bigint DEFAULT NULL COMMENT '父评论ID',
  `content` longtext NOT NULL COMMENT '评论内容',
  `like_count` int NOT NULL DEFAULT '0' COMMENT '点赞数',
  `is_approved` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否审核通过',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `info_comments_post_id` (`post_id`),
  KEY `info_comments_author_id` (`author_id`),
  KEY `info_comments_parent_id` (`parent_id`),
  KEY `idx_is_approved` (`is_approved`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `info_comments_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `info_comments_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `info_comments_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `info_comments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息评论表';

-- 信息点赞表
CREATE TABLE `info_likes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `info_likes_post_id_user_id` (`post_id`,`user_id`),
  KEY `info_likes_user_id` (`user_id`),
  CONSTRAINT `info_likes_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `info_likes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息点赞表';

-- 信息收藏表
CREATE TABLE `info_favorites` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `info_favorites_post_id_user_id` (`post_id`,`user_id`),
  KEY `info_favorites_user_id` (`user_id`),
  CONSTRAINT `info_favorites_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `info_favorites_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息收藏表';

-- 信息浏览日志表
CREATE TABLE `info_view_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `ip_address` char(39) NOT NULL COMMENT 'IP地址',
  `user_agent` longtext NOT NULL COMMENT '用户代理',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `info_view_logs_post_id` (`post_id`),
  KEY `info_view_logs_user_id` (`user_id`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `info_view_logs_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `info_view_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息浏览日志表';

-- 信息标签表
CREATE TABLE `info_tags` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '标签名称',
  `description` longtext COMMENT '标签描述',
  `color` varchar(7) NOT NULL DEFAULT '#1890ff' COMMENT '标签颜色',
  `use_count` int NOT NULL DEFAULT '0' COMMENT '使用次数',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_use_count` (`use_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息标签表';

-- =============================================
-- 5. 资源管理相关表
-- =============================================

-- 资源类型表
CREATE TABLE `resource_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '类型名称',
  `code` varchar(50) NOT NULL COMMENT '类型代码',
  `description` longtext COMMENT '类型描述',
  `icon` varchar(50) NOT NULL DEFAULT '' COMMENT '类型图标',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源类型表';

-- 资源信息表
CREATE TABLE `resources` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL COMMENT '资源名称',
  `resource_type_id` bigint NOT NULL COMMENT '资源类型ID',
  `description` longtext NOT NULL COMMENT '资源描述',
  `specifications` longtext COMMENT '技术规格',
  `manufacturer` varchar(200) NOT NULL DEFAULT '' COMMENT '制造商',
  `model` varchar(100) NOT NULL DEFAULT '' COMMENT '型号',
  `serial_number` varchar(100) NOT NULL DEFAULT '' COMMENT '序列号',
  `purchase_date` date DEFAULT NULL COMMENT '采购日期',
  `warranty_expiry` date DEFAULT NULL COMMENT '保修到期',
  `location` varchar(500) NOT NULL COMMENT '存放位置',
  `status` varchar(20) NOT NULL DEFAULT 'available' COMMENT '状态',
  `quality` varchar(20) NOT NULL DEFAULT 'good' COMMENT '质量等级',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '数量',
  `unit_price` decimal(10,2) DEFAULT NULL COMMENT '单价',
  `total_value` decimal(15,2) DEFAULT NULL COMMENT '总价值',
  `owner_id` bigint NOT NULL COMMENT '所有者ID',
  `contact_person` varchar(50) NOT NULL COMMENT '联系人',
  `contact_phone` varchar(20) NOT NULL COMMENT '联系电话',
  `contact_email` varchar(254) NOT NULL DEFAULT '' COMMENT '联系邮箱',
  `is_public` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否公开',
  `is_available_for_rent` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否可租赁',
  `rental_price` decimal(10,2) DEFAULT NULL COMMENT '租赁价格',
  `rental_unit` varchar(20) NOT NULL DEFAULT '' COMMENT '租赁单位',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `resources_resource_type_id` (`resource_type_id`),
  KEY `resources_owner_id` (`owner_id`),
  KEY `idx_status` (`status`),
  KEY `idx_quality` (`quality`),
  KEY `idx_is_public` (`is_public`),
  KEY `idx_is_available_for_rent` (`is_available_for_rent`),
  CONSTRAINT `resources_resource_type_id` FOREIGN KEY (`resource_type_id`) REFERENCES `resource_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resources_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源信息表';

-- 资源图片表
CREATE TABLE `resource_images` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `image` varchar(100) NOT NULL COMMENT '图片路径',
  `caption` varchar(200) NOT NULL DEFAULT '' COMMENT '图片说明',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `resource_images_resource_id` (`resource_id`),
  KEY `idx_sort_order` (`sort_order`),
  CONSTRAINT `resource_images_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源图片表';

-- 资源使用日志表
CREATE TABLE `resource_usage_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `user_id` bigint NOT NULL COMMENT '使用者ID',
  `usage_type` varchar(20) NOT NULL COMMENT '使用类型',
  `start_date` datetime(6) NOT NULL COMMENT '开始时间',
  `end_date` datetime(6) DEFAULT NULL COMMENT '结束时间',
  `purpose` longtext NOT NULL COMMENT '使用目的',
  `location` varchar(500) NOT NULL DEFAULT '' COMMENT '使用地点',
  `notes` longtext COMMENT '备注',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `resource_usage_logs_resource_id` (`resource_id`),
  KEY `resource_usage_logs_user_id` (`user_id`),
  KEY `idx_usage_type` (`usage_type`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `resource_usage_logs_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resource_usage_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源使用日志表';

-- 资源维护记录表
CREATE TABLE `resource_maintenances` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `maintenance_type` varchar(20) NOT NULL COMMENT '维护类型',
  `title` varchar(200) NOT NULL COMMENT '维护标题',
  `description` longtext NOT NULL COMMENT '维护描述',
  `start_date` datetime(6) NOT NULL COMMENT '开始时间',
  `end_date` datetime(6) DEFAULT NULL COMMENT '结束时间',
  `cost` decimal(10,2) DEFAULT NULL COMMENT '维护费用',
  `technician` varchar(100) NOT NULL DEFAULT '' COMMENT '维护人员',
  `notes` longtext COMMENT '维护备注',
  `created_by_id` bigint NOT NULL COMMENT '创建人ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `resource_maintenances_resource_id` (`resource_id`),
  KEY `resource_maintenances_created_by_id` (`created_by_id`),
  KEY `idx_maintenance_type` (`maintenance_type`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `resource_maintenances_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resource_maintenances_created_by_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源维护记录表';

-- 资源申请表
CREATE TABLE `resource_requests` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `requester_id` bigint NOT NULL COMMENT '申请人ID',
  `request_type` varchar(20) NOT NULL COMMENT '申请类型',
  `title` varchar(200) NOT NULL COMMENT '申请标题',
  `description` longtext NOT NULL COMMENT '申请描述',
  `start_date` datetime(6) NOT NULL COMMENT '开始时间',
  `end_date` datetime(6) NOT NULL COMMENT '结束时间',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '申请数量',
  `purpose` longtext NOT NULL COMMENT '使用目的',
  `status` varchar(20) NOT NULL DEFAULT 'pending' COMMENT '申请状态',
  `approved_by_id` bigint DEFAULT NULL COMMENT '审批人ID',
  `approved_at` datetime(6) DEFAULT NULL COMMENT '审批时间',
  `approval_notes` longtext COMMENT '审批备注',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `resource_requests_resource_id` (`resource_id`),
  KEY `resource_requests_requester_id` (`requester_id`),
  KEY `resource_requests_approved_by_id` (`approved_by_id`),
  KEY `idx_request_type` (`request_type`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `resource_requests_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resource_requests_requester_id` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resource_requests_approved_by_id` FOREIGN KEY (`approved_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源申请表';

-- 资源统计表
CREATE TABLE `resource_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_type_id` bigint NOT NULL COMMENT '资源类型ID',
  `total_count` int NOT NULL DEFAULT '0' COMMENT '总数量',
  `available_count` int NOT NULL DEFAULT '0' COMMENT '可用数量',
  `in_use_count` int NOT NULL DEFAULT '0' COMMENT '使用中数量',
  `maintenance_count` int NOT NULL DEFAULT '0' COMMENT '维护中数量',
  `total_value` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '总价值',
  `utilization_rate` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT '利用率',
  `last_updated` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '最后更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `resource_type_id` (`resource_type_id`),
  CONSTRAINT `resource_statistics_resource_type_id` FOREIGN KEY (`resource_type_id`) REFERENCES `resource_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源统计表';

-- =============================================
-- 6. 系统管理相关表
-- =============================================

-- 系统配置表
CREATE TABLE `system_configs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(100) NOT NULL COMMENT '配置键',
  `value` longtext NOT NULL COMMENT '配置值',
  `config_type` varchar(20) NOT NULL COMMENT '配置类型',
  `description` longtext COMMENT '配置描述',
  `is_encrypted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否加密',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `idx_config_type` (`config_type`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- 系统日志表
CREATE TABLE `system_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `level` varchar(10) NOT NULL COMMENT '日志级别',
  `log_type` varchar(20) NOT NULL COMMENT '日志类型',
  `module` varchar(100) NOT NULL COMMENT '模块',
  `message` longtext NOT NULL COMMENT '日志消息',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `ip_address` char(39) DEFAULT NULL COMMENT 'IP地址',
  `user_agent` longtext COMMENT '用户代理',
  `request_path` varchar(500) NOT NULL DEFAULT '' COMMENT '请求路径',
  `request_method` varchar(10) NOT NULL DEFAULT '' COMMENT '请求方法',
  `response_status` int DEFAULT NULL COMMENT '响应状态',
  `execution_time` double DEFAULT NULL COMMENT '执行时间(秒)',
  `extra_data` json DEFAULT NULL COMMENT '额外数据',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `system_logs_user_id` (`user_id`),
  KEY `idx_level_created_at` (`level`,`created_at`),
  KEY `idx_log_type_created_at` (`log_type`,`created_at`),
  KEY `idx_user_created_at` (`user_id`,`created_at`),
  KEY `idx_module_created_at` (`module`,`created_at`),
  CONSTRAINT `system_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统日志表';

-- 系统统计表
CREATE TABLE `system_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `stat_type` varchar(20) NOT NULL COMMENT '统计类型',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `stat_hour` int DEFAULT NULL COMMENT '统计小时',
  `metric_name` varchar(100) NOT NULL COMMENT '指标名称',
  `metric_value` decimal(15,2) NOT NULL COMMENT '指标值',
  `extra_data` json DEFAULT NULL COMMENT '额外数据',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `system_statistics_stat_type_stat_date_stat_hour_metric_name` (`stat_type`,`stat_date`,`stat_hour`,`metric_name`),
  KEY `idx_stat_type_stat_date` (`stat_type`,`stat_date`),
  KEY `idx_metric_name_stat_date` (`metric_name`,`stat_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统统计表';

-- 系统通知表
CREATE TABLE `system_notifications` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL COMMENT '通知标题',
  `content` longtext NOT NULL COMMENT '通知内容',
  `notification_type` varchar(20) NOT NULL COMMENT '通知类型',
  `priority` varchar(10) NOT NULL DEFAULT 'medium' COMMENT '优先级',
  `is_global` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否全局通知',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已读',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `expire_at` datetime(6) DEFAULT NULL COMMENT '过期时间',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_notification_type` (`notification_type`),
  KEY `idx_priority` (`priority`),
  KEY `idx_is_global` (`is_global`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_expire_at` (`expire_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统通知表';

-- 系统通知用户关联表
CREATE TABLE `system_notifications_target_users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `systemnotification_id` bigint NOT NULL COMMENT '系统通知ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `system_notifications_target_users_systemnotification_id_user_id` (`systemnotification_id`,`user_id`),
  KEY `system_notifications_target_users_user_id` (`user_id`),
  CONSTRAINT `system_notifications_target_users_systemnotification_id` FOREIGN KEY (`systemnotification_id`) REFERENCES `system_notifications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `system_notifications_target_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统通知用户关联表';

-- 系统备份表
CREATE TABLE `system_backups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `backup_type` varchar(20) NOT NULL COMMENT '备份类型',
  `name` varchar(200) NOT NULL COMMENT '备份名称',
  `description` longtext COMMENT '备份描述',
  `file_path` varchar(500) NOT NULL DEFAULT '' COMMENT '文件路径',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小(字节)',
  `status` varchar(20) NOT NULL DEFAULT 'pending' COMMENT '状态',
  `start_time` datetime(6) DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime(6) DEFAULT NULL COMMENT '结束时间',
  `error_message` longtext COMMENT '错误信息',
  `created_by_id` bigint DEFAULT NULL COMMENT '创建人ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `system_backups_created_by_id` (`created_by_id`),
  KEY `idx_backup_type` (`backup_type`),
  KEY `idx_status` (`status`),
  CONSTRAINT `system_backups_created_by_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统备份表';

-- 系统监控表
CREATE TABLE `system_monitors` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `monitor_type` varchar(20) NOT NULL COMMENT '监控类型',
  `metric_name` varchar(100) NOT NULL COMMENT '指标名称',
  `metric_value` double NOT NULL COMMENT '指标值',
  `threshold_warning` double DEFAULT NULL COMMENT '警告阈值',
  `threshold_critical` double DEFAULT NULL COMMENT '严重阈值',
  `status` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '状态',
  `extra_data` json DEFAULT NULL COMMENT '额外数据',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_monitor_type_created_at` (`monitor_type`,`created_at`),
  KEY `idx_status_created_at` (`status`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统监控表';

-- =============================================
-- 7. Django相关表
-- =============================================

-- Django内容类型表
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model` (`app_label`,`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Django会话表
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Django迁移表
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Django管理员日志表
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id` (`content_type_id`),
  KEY `django_admin_log_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE SET NULL,
  CONSTRAINT `django_admin_log_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 8. 添加菜单表的外键约束
-- =============================================

ALTER TABLE `menus` ADD CONSTRAINT `menus_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE;

-- =============================================
-- 9. 创建索引以优化查询性能
-- =============================================

-- 用户表索引
CREATE INDEX `idx_users_email` ON `users` (`email`);
CREATE INDEX `idx_users_date_joined` ON `users` (`date_joined`);

-- 企业表索引
CREATE INDEX `idx_enterprises_name` ON `enterprises` (`name`);
CREATE INDEX `idx_enterprises_contact_email` ON `enterprises` (`contact_email`);

-- 信息发布表索引
CREATE INDEX `idx_info_posts_title` ON `info_posts` (`title`);
CREATE INDEX `idx_info_posts_view_count` ON `info_posts` (`view_count`);
CREATE INDEX `idx_info_posts_like_count` ON `info_posts` (`like_count`);

-- 资源表索引
CREATE INDEX `idx_resources_name` ON `resources` (`name`);
CREATE INDEX `idx_resources_manufacturer` ON `resources` (`manufacturer`);
CREATE INDEX `idx_resources_location` ON `resources` (`location`);

-- 系统日志表索引
CREATE INDEX `idx_system_logs_ip_address` ON `system_logs` (`ip_address`);
CREATE INDEX `idx_system_logs_request_method` ON `system_logs` (`request_method`);

-- =============================================
-- 10. 插入初始数据
-- =============================================

-- 插入基础角色
INSERT INTO `roles` (`name`, `code`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
('系统管理员', 'admin', '系统管理员，拥有所有权限', 1, NOW(), NOW()),
('企业管理员', 'enterprise_admin', '企业管理员，管理企业相关功能', 1, NOW(), NOW()),
('企业员工', 'enterprise_employee', '企业员工，使用企业功能', 1, NOW(), NOW()),
('个人用户', 'personal_user', '个人用户，使用个人功能', 1, NOW(), NOW());

-- 插入基础权限
INSERT INTO `permissions` (`name`, `code`, `description`, `module`, `is_active`, `created_at`) VALUES
-- 用户管理权限
('用户查看', 'user_view', '查看用户信息', 'users', 1, NOW()),
('用户创建', 'user_create', '创建用户', 'users', 1, NOW()),
('用户编辑', 'user_edit', '编辑用户信息', 'users', 1, NOW()),
('用户删除', 'user_delete', '删除用户', 'users', 1, NOW()),

-- 角色管理权限
('角色查看', 'role_view', '查看角色信息', 'users', 1, NOW()),
('角色创建', 'role_create', '创建角色', 'users', 1, NOW()),
('角色编辑', 'role_edit', '编辑角色信息', 'users', 1, NOW()),
('角色删除', 'role_delete', '删除角色', 'users', 1, NOW()),

-- 企业权限
('企业查看', 'enterprise_view', '查看企业信息', 'enterprises', 1, NOW()),
('企业创建', 'enterprise_create', '创建企业', 'enterprises', 1, NOW()),
('企业编辑', 'enterprise_edit', '编辑企业信息', 'enterprises', 1, NOW()),
('企业管理', 'enterprise_manage', '管理企业', 'enterprises', 1, NOW()),

-- 信息广场权限
('信息查看', 'info_view', '查看信息', 'info_plaza', 1, NOW()),
('信息发布', 'info_publish', '发布信息', 'info_plaza', 1, NOW()),
('信息编辑', 'info_edit', '编辑信息', 'info_plaza', 1, NOW()),
('信息删除', 'info_delete', '删除信息', 'info_plaza', 1, NOW()),

-- 资源管理权限
('资源查看', 'resource_view', '查看资源', 'resources', 1, NOW()),
('资源创建', 'resource_create', '创建资源', 'resources', 1, NOW()),
('资源编辑', 'resource_edit', '编辑资源', 'resources', 1, NOW()),
('资源删除', 'resource_delete', '删除资源', 'resources', 1, NOW()),

-- 系统管理权限
('系统配置', 'system_config', '系统配置管理', 'system', 1, NOW()),
('系统日志', 'system_log', '查看系统日志', 'system', 1, NOW()),
('系统统计', 'system_statistics', '查看系统统计', 'system', 1, NOW());

-- 插入基础菜单
INSERT INTO `menus` (`name`, `code`, `url`, `icon`, `parent_id`, `sort_order`, `is_active`, `created_at`) VALUES
-- 一级菜单
('仪表板', 'dashboard', '/dashboard', 'Odometer', NULL, 1, 1, NOW()),
('企业中心', 'enterprise', '/dashboard/enterprise', 'OfficeBuilding', NULL, 2, 1, NOW()),
('个人中心', 'personal', '/dashboard/personal', 'User', NULL, 3, 1, NOW()),
('信息广场', 'info_plaza', '/dashboard/info-plaza', 'ChatDotSquare', NULL, 4, 1, NOW()),
('资源管理', 'resources', '/dashboard/resources', 'Box', NULL, 5, 1, NOW()),
('系统管理', 'system', '/dashboard/system', 'Setting', NULL, 6, 1, NOW());

-- 获取一级菜单ID并插入子菜单
SET @dashboard_id = (SELECT id FROM menus WHERE code = 'dashboard');
SET @enterprise_id = (SELECT id FROM menus WHERE code = 'enterprise');
SET @personal_id = (SELECT id FROM menus WHERE code = 'personal');
SET @info_plaza_id = (SELECT id FROM menus WHERE code = 'info_plaza');
SET @resources_id = (SELECT id FROM menus WHERE code = 'resources');
SET @system_id = (SELECT id FROM menus WHERE code = 'system');

-- 企业中心子菜单
INSERT INTO `menus` (`name`, `code`, `url`, `icon`, `parent_id`, `sort_order`, `is_active`, `created_at`) VALUES
('企业信息', 'enterprise_info', '/dashboard/enterprise', 'OfficeBuilding', @enterprise_id, 1, 1, NOW()),
('项目管理', 'enterprise_projects', '/dashboard/enterprise/projects', 'Folder', @enterprise_id, 2, 1, NOW()),
('员工管理', 'enterprise_employees', '/dashboard/enterprise/employees', 'UserFilled', @enterprise_id, 3, 1, NOW());

-- 个人中心子菜单
INSERT INTO `menus` (`name`, `code`, `url`, `icon`, `parent_id`, `sort_order`, `is_active`, `created_at`) VALUES
('个人信息', 'personal_info', '/dashboard/personal', 'User', @personal_id, 1, 1, NOW()),
('我的项目', 'personal_projects', '/dashboard/personal/projects', 'Folder', @personal_id, 2, 1, NOW()),
('我的任务', 'personal_tasks', '/dashboard/personal/tasks', 'List', @personal_id, 3, 1, NOW());

-- 信息广场子菜单
INSERT INTO `menus` (`name`, `code`, `url`, `icon`, `parent_id`, `sort_order`, `is_active`, `created_at`) VALUES
('信息浏览', 'info_browse', '/dashboard/info-plaza', 'ChatDotSquare', @info_plaza_id, 1, 1, NOW()),
('发布信息', 'info_publish', '/dashboard/info-plaza/publish', 'Edit', @info_plaza_id, 2, 1, NOW());

-- 资源管理子菜单
INSERT INTO `menus` (`name`, `code`, `url`, `icon`, `parent_id`, `sort_order`, `is_active`, `created_at`) VALUES
('资源浏览', 'resource_browse', '/dashboard/resources', 'Box', @resources_id, 1, 1, NOW()),
('添加资源', 'resource_add', '/dashboard/resources/add', 'Plus', @resources_id, 2, 1, NOW());

-- 系统管理子菜单
INSERT INTO `menus` (`name`, `code`, `url`, `icon`, `parent_id`, `sort_order`, `is_active`, `created_at`) VALUES
('用户管理', 'system_users', '/dashboard/system/users', 'User', @system_id, 1, 1, NOW()),
('角色管理', 'system_roles', '/dashboard/system/roles', 'UserFilled', @system_id, 2, 1, NOW()),
('系统日志', 'system_logs', '/dashboard/system/logs', 'Document', @system_id, 3, 1, NOW());

-- 插入信息分类
INSERT INTO `info_categories` (`name`, `code`, `description`, `icon`, `sort_order`, `is_active`, `created_at`) VALUES
('供应信息', 'supply', '产品供应、服务提供等信息', 'ShoppingCart', 1, 1, NOW()),
('需求信息', 'demand', '产品需求、服务需求等信息', 'ShoppingBag', 2, 1, NOW()),
('招聘信息', 'recruitment', '人才招聘、岗位需求等信息', 'User', 3, 1, NOW()),
('招标信息', 'tender', '项目招标、采购招标等信息', 'Document', 4, 1, NOW()),
('技术文章', 'technology', '技术分享、经验交流等文章', 'Reading', 5, 1, NOW()),
('行业资讯', 'news', '行业动态、政策资讯等信息', 'Bell', 6, 1, NOW());

-- 插入资源类型
INSERT INTO `resource_types` (`name`, `code`, `description`, `icon`, `sort_order`, `is_active`, `created_at`) VALUES
('设备', 'equipment', '各种防腐保温设备', 'Tools', 1, 1, NOW()),
('材料', 'material', '防腐保温材料', 'Box', 2, 1, NOW()),
('人才', 'talent', '专业技术人才', 'User', 3, 1, NOW()),
('技术', 'technology', '技术服务和解决方案', 'Setting', 4, 1, NOW());

-- 插入系统配置
INSERT INTO `system_configs` (`key`, `value`, `config_type`, `description`, `is_encrypted`, `is_active`, `created_at`, `updated_at`) VALUES
('site_name', '防腐保温智能数字平台', 'basic', '网站名称', 0, 1, NOW(), NOW()),
('site_description', '专业的防腐保温行业数字化平台', 'basic', '网站描述', 0, 1, NOW(), NOW()),
('site_keywords', '防腐,保温,数字化,平台', 'basic', '网站关键词', 0, 1, NOW(), NOW()),
('contact_email', 'admin@corrosion-platform.com', 'basic', '联系邮箱', 0, 1, NOW(), NOW()),
('contact_phone', '400-123-4567', 'basic', '联系电话', 0, 1, NOW(), NOW()),
('max_file_size', '10485760', 'basic', '最大文件上传大小(字节)', 0, 1, NOW(), NOW()),
('allowed_file_types', 'jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx', 'basic', '允许上传的文件类型', 0, 1, NOW(), NOW());

-- 创建默认管理员用户
INSERT INTO `users` (`password`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`, `user_type`, `phone`, `is_verified`, `created_at`, `updated_at`) VALUES
('pbkdf2_sha256$600000$dummy$dummy', 1, 'admin', '系统', '管理员', 'admin@corrosion-platform.com', 1, 1, NOW(), 'personal', '13800138000', 1, NOW(), NOW());

-- 为管理员分配角色
INSERT INTO `user_roles` (`user_id`, `role_id`, `created_at`) VALUES
(1, 1, NOW());

-- 为系统管理员角色分配所有权限
INSERT INTO `role_permissions` (`role_id`, `permission_id`, `created_at`) 
SELECT 1, id, NOW() FROM permissions;

-- 为系统管理员角色分配所有菜单
INSERT INTO `role_menus` (`role_id`, `menu_id`, `created_at`) 
SELECT 1, id, NOW() FROM menus;

-- =============================================
-- 11. 创建视图
-- =============================================

-- 用户统计视图
CREATE VIEW `v_user_statistics` AS
SELECT 
    u.user_type,
    COUNT(*) as total_users,
    COUNT(CASE WHEN u.is_active = 1 THEN 1 END) as active_users,
    COUNT(CASE WHEN u.is_verified = 1 THEN 1 END) as verified_users,
    COUNT(CASE WHEN u.date_joined >= DATE_SUB(NOW(), INTERVAL 30 DAY) THEN 1 END) as new_users_30d
FROM users u
GROUP BY u.user_type;

-- 企业统计视图
CREATE VIEW `v_enterprise_statistics` AS
SELECT 
    e.enterprise_type,
    COUNT(*) as total_enterprises,
    COUNT(CASE WHEN e.status = 'approved' THEN 1 END) as approved_enterprises,
    COUNT(CASE WHEN e.status = 'pending' THEN 1 END) as pending_enterprises,
    AVG(es.total_projects) as avg_projects_per_enterprise,
    SUM(es.total_revenue) as total_revenue
FROM enterprises e
LEFT JOIN enterprise_statistics es ON e.id = es.enterprise_id
GROUP BY e.enterprise_type;

-- 信息发布统计视图
CREATE VIEW `v_info_post_statistics` AS
SELECT 
    ic.name as category_name,
    ip.post_type,
    COUNT(*) as total_posts,
    COUNT(CASE WHEN ip.status = 'published' THEN 1 END) as published_posts,
    AVG(ip.view_count) as avg_view_count,
    AVG(ip.like_count) as avg_like_count
FROM info_posts ip
JOIN info_categories ic ON ip.category_id = ic.id
GROUP BY ic.name, ip.post_type;

-- 资源统计视图
CREATE VIEW `v_resource_statistics` AS
SELECT 
    rt.name as resource_type_name,
    COUNT(*) as total_resources,
    COUNT(CASE WHEN r.status = 'available' THEN 1 END) as available_resources,
    COUNT(CASE WHEN r.status = 'in_use' THEN 1 END) as in_use_resources,
    SUM(r.total_value) as total_value,
    AVG(r.unit_price) as avg_unit_price
FROM resources r
JOIN resource_types rt ON r.resource_type_id = rt.id
GROUP BY rt.name;

-- =============================================
-- 12. 创建存储过程
-- =============================================

DELIMITER //

-- 更新企业统计数据的存储过程
CREATE PROCEDURE `UpdateEnterpriseStatistics`(IN enterprise_id BIGINT)
BEGIN
    DECLARE total_projects_count INT DEFAULT 0;
    DECLARE completed_projects_count INT DEFAULT 0;
    DECLARE total_employees_count INT DEFAULT 0;
    DECLARE total_revenue_sum DECIMAL(15,2) DEFAULT 0;
    DECLARE total_contracts_count INT DEFAULT 0;
    
    -- 计算项目统计
    SELECT COUNT(*), COUNT(CASE WHEN status = 'completed' THEN 1 END)
    INTO total_projects_count, completed_projects_count
    FROM enterprise_projects 
    WHERE enterprise_id = enterprise_id;
    
    -- 计算员工统计
    SELECT COUNT(*)
    INTO total_employees_count
    FROM employees 
    WHERE enterprise_id = enterprise_id AND is_active = 1;
    
    -- 计算收入统计
    SELECT COALESCE(SUM(contract_amount), 0)
    INTO total_revenue_sum
    FROM enterprise_projects 
    WHERE enterprise_id = enterprise_id AND status = 'completed';
    
    -- 计算合同统计
    SELECT COUNT(*)
    INTO total_contracts_count
    FROM enterprise_projects 
    WHERE enterprise_id = enterprise_id;
    
    -- 更新或插入统计数据
    INSERT INTO enterprise_statistics (
        enterprise_id, total_projects, completed_projects, 
        total_employees, total_revenue, total_contracts, last_updated
    ) VALUES (
        enterprise_id, total_projects_count, completed_projects_count,
        total_employees_count, total_revenue_sum, total_contracts_count, NOW()
    ) ON DUPLICATE KEY UPDATE
        total_projects = total_projects_count,
        completed_projects = completed_projects_count,
        total_employees = total_employees_count,
        total_revenue = total_revenue_sum,
        total_contracts = total_contracts_count,
        last_updated = NOW();
END //

-- 更新个人统计数据的存储过程
CREATE PROCEDURE `UpdatePersonStatistics`(IN person_id BIGINT)
BEGIN
    DECLARE total_projects_count INT DEFAULT 0;
    DECLARE completed_projects_count INT DEFAULT 0;
    DECLARE total_tasks_count INT DEFAULT 0;
    DECLARE completed_tasks_count INT DEFAULT 0;
    DECLARE total_income_sum DECIMAL(12,2) DEFAULT 0;
    DECLARE work_days_count INT DEFAULT 0;
    
    -- 计算项目统计
    SELECT COUNT(*), COUNT(CASE WHEN status = 'completed' THEN 1 END)
    INTO total_projects_count, completed_projects_count
    FROM person_projects 
    WHERE person_id = person_id;
    
    -- 计算任务统计
    SELECT COUNT(*), COUNT(CASE WHEN status = 'completed' THEN 1 END)
    INTO total_tasks_count, completed_tasks_count
    FROM person_tasks 
    WHERE person_id = person_id;
    
    -- 计算收入统计
    SELECT COALESCE(SUM(income), 0)
    INTO total_income_sum
    FROM person_projects 
    WHERE person_id = person_id AND status = 'completed';
    
    -- 计算工作天数
    SELECT COUNT(DISTINCT DATE(created_at))
    INTO work_days_count
    FROM person_tasks 
    WHERE person_id = person_id AND status = 'completed';
    
    -- 更新或插入统计数据
    INSERT INTO person_statistics (
        person_id, total_projects, completed_projects, 
        total_tasks, completed_tasks, total_income, work_days, last_updated
    ) VALUES (
        person_id, total_projects_count, completed_projects_count,
        total_tasks_count, completed_tasks_count, total_income_sum, work_days_count, NOW()
    ) ON DUPLICATE KEY UPDATE
        total_projects = total_projects_count,
        completed_projects = completed_projects_count,
        total_tasks = total_tasks_count,
        completed_tasks = completed_tasks_count,
        total_income = total_income_sum,
        work_days = work_days_count,
        last_updated = NOW();
END //

-- 更新资源统计数据的存储过程
CREATE PROCEDURE `UpdateResourceStatistics`(IN resource_type_id BIGINT)
BEGIN
    DECLARE total_count_val INT DEFAULT 0;
    DECLARE available_count_val INT DEFAULT 0;
    DECLARE in_use_count_val INT DEFAULT 0;
    DECLARE maintenance_count_val INT DEFAULT 0;
    DECLARE total_value_sum DECIMAL(15,2) DEFAULT 0;
    DECLARE utilization_rate_val DECIMAL(5,2) DEFAULT 0;
    
    -- 计算各种状态的资源数量
    SELECT 
        COUNT(*),
        COUNT(CASE WHEN status = 'available' THEN 1 END),
        COUNT(CASE WHEN status = 'in_use' THEN 1 END),
        COUNT(CASE WHEN status = 'maintenance' THEN 1 END),
        COALESCE(SUM(total_value), 0)
    INTO 
        total_count_val, available_count_val, in_use_count_val, 
        maintenance_count_val, total_value_sum
    FROM resources 
    WHERE resource_type_id = resource_type_id;
    
    -- 计算利用率
    IF total_count_val > 0 THEN
        SET utilization_rate_val = (in_use_count_val / total_count_val) * 100;
    END IF;
    
    -- 更新或插入统计数据
    INSERT INTO resource_statistics (
        resource_type_id, total_count, available_count, in_use_count,
        maintenance_count, total_value, utilization_rate, last_updated
    ) VALUES (
        resource_type_id, total_count_val, available_count_val, in_use_count_val,
        maintenance_count_val, total_value_sum, utilization_rate_val, NOW()
    ) ON DUPLICATE KEY UPDATE
        total_count = total_count_val,
        available_count = available_count_val,
        in_use_count = in_use_count_val,
        maintenance_count = maintenance_count_val,
        total_value = total_value_sum,
        utilization_rate = utilization_rate_val,
        last_updated = NOW();
END //

DELIMITER ;

-- =============================================
-- 13. 创建触发器
-- =============================================

-- 企业项目状态更新时自动更新统计
DELIMITER //
CREATE TRIGGER `tr_enterprise_project_update` 
AFTER UPDATE ON `enterprise_projects`
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        CALL UpdateEnterpriseStatistics(NEW.enterprise_id);
    END IF;
END //

-- 企业员工状态更新时自动更新统计
CREATE TRIGGER `tr_employee_update` 
AFTER UPDATE ON `employees`
FOR EACH ROW
BEGIN
    IF OLD.is_active != NEW.is_active THEN
        CALL UpdateEnterpriseStatistics(NEW.enterprise_id);
    END IF;
END //

-- 个人项目状态更新时自动更新统计
CREATE TRIGGER `tr_person_project_update` 
AFTER UPDATE ON `person_projects`
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        CALL UpdatePersonStatistics(NEW.person_id);
    END IF;
END //

-- 个人任务状态更新时自动更新统计
CREATE TRIGGER `tr_person_task_update` 
AFTER UPDATE ON `person_tasks`
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        CALL UpdatePersonStatistics(NEW.person_id);
    END IF;
END //

-- 资源状态更新时自动更新统计
CREATE TRIGGER `tr_resource_update` 
AFTER UPDATE ON `resources`
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status OR OLD.resource_type_id != NEW.resource_type_id THEN
        CALL UpdateResourceStatistics(NEW.resource_type_id);
        IF OLD.resource_type_id != NEW.resource_type_id THEN
            CALL UpdateResourceStatistics(OLD.resource_type_id);
        END IF;
    END IF;
END //

DELIMITER ;

-- =============================================
-- 14. 设置外键检查
-- =============================================

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- 15. 数据库创建完成提示
-- =============================================

SELECT '防腐保温智能数字平台数据库创建完成！' as message;
SELECT '默认管理员账号: admin' as admin_info;
SELECT '默认管理员密码: 请通过Django管理界面重置' as password_info;
SELECT '数据库名称: corrosion_platform' as database_info;

