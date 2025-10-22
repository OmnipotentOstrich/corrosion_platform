-- ========================================
-- 防腐保温智能数字平台 v2.0 数据库结构
-- 生成时间: 2025-10-22 21:13:47
-- 数据库: corrosion_platform
-- ========================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_unicode_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_users_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for employees
-- ----------------------------
DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `employee_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '工号',
  `position` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '职位',
  `department` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '部门',
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企业员工表';

-- ----------------------------
-- Table structure for enterprise_documents
-- ----------------------------
DROP TABLE IF EXISTS `enterprise_documents`;
CREATE TABLE `enterprise_documents` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `document_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件类型',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件标题',
  `file` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT '文件描述',
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

-- ----------------------------
-- Table structure for enterprise_projects
-- ----------------------------
DROP TABLE IF EXISTS `enterprise_projects`;
CREATE TABLE `enterprise_projects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目名称',
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目描述',
  `client` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户',
  `contract_amount` decimal(15,2) DEFAULT NULL COMMENT '合同金额',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date DEFAULT NULL COMMENT '结束日期',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planning' COMMENT '项目状态',
  `progress` int NOT NULL DEFAULT '0' COMMENT '进度百分比',
  `location` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '项目地点',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `enterprise_projects_enterprise_id` (`enterprise_id`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `enterprise_projects_enterprise_id` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企业项目表';

-- ----------------------------
-- Table structure for enterprise_statistics
-- ----------------------------
DROP TABLE IF EXISTS `enterprise_statistics`;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企业统计表';

-- ----------------------------
-- Table structure for enterprises
-- ----------------------------
DROP TABLE IF EXISTS `enterprises`;
CREATE TABLE `enterprises` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '关联用户ID',
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '企业名称',
  `short_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '企业简称',
  `enterprise_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '企业类型',
  `unified_social_credit_code` varchar(18) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '统一社会信用代码',
  `legal_representative` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '法定代表人',
  `registered_capital` decimal(15,2) DEFAULT NULL COMMENT '注册资本',
  `establishment_date` date DEFAULT NULL COMMENT '成立日期',
  `business_scope` longtext COLLATE utf8mb4_unicode_ci COMMENT '经营范围',
  `address` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '企业地址',
  `contact_person` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人',
  `contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系电话',
  `contact_email` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系邮箱',
  `website` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '企业网站',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT '企业简介',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '认证状态',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `unified_social_credit_code` (`unified_social_credit_code`),
  KEY `idx_enterprise_type` (`enterprise_type`),
  KEY `idx_status` (`status`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_enterprises_name` (`name`),
  KEY `idx_enterprises_contact_email` (`contact_email`),
  CONSTRAINT `enterprises_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='企业信息表';

-- ----------------------------
-- Table structure for info_categories
-- ----------------------------
DROP TABLE IF EXISTS `info_categories`;
CREATE TABLE `info_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类代码',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT '分类描述',
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分类图标',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息分类表';

-- ----------------------------
-- Table structure for info_comments
-- ----------------------------
DROP TABLE IF EXISTS `info_comments`;
CREATE TABLE `info_comments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `author_id` bigint NOT NULL COMMENT '评论者ID',
  `parent_id` bigint DEFAULT NULL COMMENT '父评论ID',
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论内容',
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
  CONSTRAINT `info_comments_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `info_comments_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `info_comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `info_comments_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息评论表';

-- ----------------------------
-- Table structure for info_favorites
-- ----------------------------
DROP TABLE IF EXISTS `info_favorites`;
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

-- ----------------------------
-- Table structure for info_likes
-- ----------------------------
DROP TABLE IF EXISTS `info_likes`;
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息点赞表';

-- ----------------------------
-- Table structure for info_post_images
-- ----------------------------
DROP TABLE IF EXISTS `info_post_images`;
CREATE TABLE `info_post_images` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `image` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片路径',
  `caption` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片说明',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `info_post_images_post_id` (`post_id`),
  KEY `idx_sort_order` (`sort_order`),
  CONSTRAINT `info_post_images_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息发布图片表';

-- ----------------------------
-- Table structure for info_posts
-- ----------------------------
DROP TABLE IF EXISTS `info_posts`;
CREATE TABLE `info_posts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `author_id` bigint NOT NULL COMMENT '发布者ID',
  `category_id` bigint DEFAULT NULL,
  `post_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '信息类型',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容',
  `summary` longtext COLLATE utf8mb4_unicode_ci COMMENT '摘要',
  `tags` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标签',
  `priority` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT '优先级',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft' COMMENT '状态',
  `is_top` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否置顶',
  `is_recommended` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否推荐',
  `view_count` int NOT NULL DEFAULT '0' COMMENT '浏览次数',
  `like_count` int NOT NULL DEFAULT '0' COMMENT '点赞数',
  `comment_count` int NOT NULL DEFAULT '0' COMMENT '评论数',
  `share_count` int NOT NULL DEFAULT '0' COMMENT '分享数',
  `contact_info` longtext COLLATE utf8mb4_unicode_ci COMMENT '联系信息',
  `location` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '地点',
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
  KEY `idx_info_posts_title` (`title`),
  KEY `idx_info_posts_view_count` (`view_count`),
  KEY `idx_info_posts_like_count` (`like_count`),
  CONSTRAINT `info_posts_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `info_posts_category_id` FOREIGN KEY (`category_id`) REFERENCES `info_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息发布表';

-- ----------------------------
-- Table structure for info_tags
-- ----------------------------
DROP TABLE IF EXISTS `info_tags`;
CREATE TABLE `info_tags` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT '标签描述',
  `color` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#1890ff' COMMENT '标签颜色',
  `use_count` int NOT NULL DEFAULT '0' COMMENT '使用次数',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_use_count` (`use_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息标签表';

-- ----------------------------
-- Table structure for info_view_logs
-- ----------------------------
DROP TABLE IF EXISTS `info_view_logs`;
CREATE TABLE `info_view_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `ip_address` char(39) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IP地址',
  `user_agent` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户代理',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `info_view_logs_post_id` (`post_id`),
  KEY `info_view_logs_user_id` (`user_id`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `info_view_logs_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `info_view_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信息浏览日志表';

-- ----------------------------
-- Table structure for menus
-- ----------------------------
DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单代码',
  `url` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '菜单URL',
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '菜单图标',
  `parent_id` bigint DEFAULT NULL COMMENT '父菜单ID',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `menu_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'page',
  `is_visible` tinyint(1) NOT NULL DEFAULT '1',
  `requires_permission` tinyint(1) NOT NULL DEFAULT '1',
  `component_path` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `meta_data` json DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `description` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `menus_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单表';

-- ----------------------------
-- Table structure for permission_groups
-- ----------------------------
DROP TABLE IF EXISTS `permission_groups`;
CREATE TABLE `permission_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `module` varchar(50) NOT NULL,
  `sort_order` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限名称',
  `code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限代码',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT '权限描述',
  `module` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属模块',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_module` (`module`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';

-- ----------------------------
-- Table structure for person_documents
-- ----------------------------
DROP TABLE IF EXISTS `person_documents`;
CREATE TABLE `person_documents` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `document_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件类型',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件标题',
  `file` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT '文件描述',
  `is_public` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否公开',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `person_documents_person_id` (`person_id`),
  KEY `idx_document_type` (`document_type`),
  KEY `idx_is_public` (`is_public`),
  CONSTRAINT `person_documents_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人资质文件表';

-- ----------------------------
-- Table structure for person_projects
-- ----------------------------
DROP TABLE IF EXISTS `person_projects`;
CREATE TABLE `person_projects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目名称',
  `project_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目类型',
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目描述',
  `client` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户',
  `role` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '担任角色',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date DEFAULT NULL COMMENT '结束日期',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planning' COMMENT '项目状态',
  `progress` int NOT NULL DEFAULT '0' COMMENT '进度百分比',
  `location` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '项目地点',
  `income` decimal(10,2) DEFAULT NULL COMMENT '项目收入',
  `achievements` longtext COLLATE utf8mb4_unicode_ci COMMENT '项目成果',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `person_projects_person_id` (`person_id`),
  KEY `idx_project_type` (`project_type`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `person_projects_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人项目记录表';

-- ----------------------------
-- Table structure for person_statistics
-- ----------------------------
DROP TABLE IF EXISTS `person_statistics`;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人统计表';

-- ----------------------------
-- Table structure for person_tasks
-- ----------------------------
DROP TABLE IF EXISTS `person_tasks`;
CREATE TABLE `person_tasks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `project_id` bigint DEFAULT NULL COMMENT '关联项目ID',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务标题',
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务描述',
  `priority` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium' COMMENT '优先级',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '任务状态',
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人任务记录表';

-- ----------------------------
-- Table structure for persons
-- ----------------------------
DROP TABLE IF EXISTS `persons`;
CREATE TABLE `persons` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '关联用户ID',
  `real_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '真实姓名',
  `gender` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '性别',
  `birth_date` date DEFAULT NULL COMMENT '出生日期',
  `id_card` varchar(18) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '身份证号',
  `education` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学历',
  `profession` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '职业',
  `work_experience` int NOT NULL DEFAULT '0' COMMENT '工作经验(年)',
  `skills` longtext COLLATE utf8mb4_unicode_ci COMMENT '技能专长',
  `address` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '居住地址',
  `emergency_contact` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '紧急联系人',
  `emergency_phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '紧急联系电话',
  `bio` longtext COLLATE utf8mb4_unicode_ci COMMENT '个人简介',
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='个人用户信息表';

-- ----------------------------
-- Table structure for resource_images
-- ----------------------------
DROP TABLE IF EXISTS `resource_images`;
CREATE TABLE `resource_images` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `image` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片路径',
  `caption` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片说明',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `resource_images_resource_id` (`resource_id`),
  KEY `idx_sort_order` (`sort_order`),
  CONSTRAINT `resource_images_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源图片表';

-- ----------------------------
-- Table structure for resource_maintenances
-- ----------------------------
DROP TABLE IF EXISTS `resource_maintenances`;
CREATE TABLE `resource_maintenances` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `maintenance_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '维护类型',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '维护标题',
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '维护描述',
  `start_date` datetime(6) NOT NULL COMMENT '开始时间',
  `end_date` datetime(6) DEFAULT NULL COMMENT '结束时间',
  `cost` decimal(10,2) DEFAULT NULL COMMENT '维护费用',
  `technician` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '维护人员',
  `notes` longtext COLLATE utf8mb4_unicode_ci COMMENT '维护备注',
  `created_by_id` bigint NOT NULL COMMENT '创建人ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `resource_maintenances_resource_id` (`resource_id`),
  KEY `resource_maintenances_created_by_id` (`created_by_id`),
  KEY `idx_maintenance_type` (`maintenance_type`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `resource_maintenances_created_by_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resource_maintenances_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源维护记录表';

-- ----------------------------
-- Table structure for resource_requests
-- ----------------------------
DROP TABLE IF EXISTS `resource_requests`;
CREATE TABLE `resource_requests` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `requester_id` bigint NOT NULL COMMENT '申请人ID',
  `request_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申请类型',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申请标题',
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申请描述',
  `start_date` datetime(6) NOT NULL COMMENT '开始时间',
  `end_date` datetime(6) NOT NULL COMMENT '结束时间',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '申请数量',
  `purpose` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用目的',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '申请状态',
  `approved_by_id` bigint DEFAULT NULL COMMENT '审批人ID',
  `approved_at` datetime(6) DEFAULT NULL COMMENT '审批时间',
  `approval_notes` longtext COLLATE utf8mb4_unicode_ci COMMENT '审批备注',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `resource_requests_resource_id` (`resource_id`),
  KEY `resource_requests_requester_id` (`requester_id`),
  KEY `resource_requests_approved_by_id` (`approved_by_id`),
  KEY `idx_request_type` (`request_type`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `resource_requests_approved_by_id` FOREIGN KEY (`approved_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `resource_requests_requester_id` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resource_requests_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源申请表';

-- ----------------------------
-- Table structure for resource_statistics
-- ----------------------------
DROP TABLE IF EXISTS `resource_statistics`;
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

-- ----------------------------
-- Table structure for resource_types
-- ----------------------------
DROP TABLE IF EXISTS `resource_types`;
CREATE TABLE `resource_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型名称',
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型代码',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT '类型描述',
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '类型图标',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源类型表';

-- ----------------------------
-- Table structure for resource_usage_logs
-- ----------------------------
DROP TABLE IF EXISTS `resource_usage_logs`;
CREATE TABLE `resource_usage_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `user_id` bigint NOT NULL COMMENT '使用者ID',
  `usage_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用类型',
  `start_date` datetime(6) NOT NULL COMMENT '开始时间',
  `end_date` datetime(6) DEFAULT NULL COMMENT '结束时间',
  `purpose` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用目的',
  `location` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '使用地点',
  `notes` longtext COLLATE utf8mb4_unicode_ci COMMENT '备注',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `resource_usage_logs_resource_id` (`resource_id`),
  KEY `resource_usage_logs_user_id` (`user_id`),
  KEY `idx_usage_type` (`usage_type`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `resource_usage_logs_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resource_usage_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源使用日志表';

-- ----------------------------
-- Table structure for resources
-- ----------------------------
DROP TABLE IF EXISTS `resources`;
CREATE TABLE `resources` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源名称',
  `resource_type_id` bigint NOT NULL COMMENT '资源类型ID',
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源描述',
  `specifications` longtext COLLATE utf8mb4_unicode_ci COMMENT '技术规格',
  `manufacturer` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '制造商',
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '型号',
  `serial_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '序列号',
  `purchase_date` date DEFAULT NULL COMMENT '采购日期',
  `warranty_expiry` date DEFAULT NULL COMMENT '保修到期',
  `location` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '存放位置',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'available' COMMENT '状态',
  `quality` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'good' COMMENT '质量等级',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '数量',
  `unit_price` decimal(10,2) DEFAULT NULL COMMENT '单价',
  `total_value` decimal(15,2) DEFAULT NULL COMMENT '总价值',
  `owner_id` bigint NOT NULL COMMENT '所有者ID',
  `contact_person` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人',
  `contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系电话',
  `contact_email` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '联系邮箱',
  `is_public` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否公开',
  `is_available_for_rent` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否可租赁',
  `rental_price` decimal(10,2) DEFAULT NULL COMMENT '租赁价格',
  `rental_unit` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '租赁单位',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `resources_resource_type_id` (`resource_type_id`),
  KEY `resources_owner_id` (`owner_id`),
  KEY `idx_status` (`status`),
  KEY `idx_quality` (`quality`),
  KEY `idx_is_public` (`is_public`),
  KEY `idx_is_available_for_rent` (`is_available_for_rent`),
  KEY `idx_resources_name` (`name`),
  KEY `idx_resources_manufacturer` (`manufacturer`),
  KEY `idx_resources_location` (`location`),
  CONSTRAINT `resources_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resources_resource_type_id` FOREIGN KEY (`resource_type_id`) REFERENCES `resource_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源信息表';

-- ----------------------------
-- Table structure for role_menus
-- ----------------------------
DROP TABLE IF EXISTS `role_menus`;
CREATE TABLE `role_menus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `can_view` tinyint(1) NOT NULL DEFAULT '1',
  `can_create` tinyint(1) NOT NULL DEFAULT '0',
  `can_update` tinyint(1) NOT NULL DEFAULT '0',
  `can_delete` tinyint(1) NOT NULL DEFAULT '0',
  `can_export` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_menus_role_id_menu_id` (`role_id`,`menu_id`),
  KEY `role_menus_menu_id` (`menu_id`),
  CONSTRAINT `role_menus_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_menus_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=239 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色菜单关联表';

-- ----------------------------
-- Table structure for role_permission_audits
-- ----------------------------
DROP TABLE IF EXISTS `role_permission_audits`;
CREATE TABLE `role_permission_audits` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `action` varchar(20) NOT NULL,
  `description` longtext NOT NULL,
  `ip_address` char(39) NOT NULL,
  `user_agent` longtext NOT NULL,
  `extra_data` json DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `permission_id` bigint DEFAULT NULL,
  `role_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_permission_audits_role_created_at` (`role_id`,`created_at`),
  KEY `role_permission_audits_user_created_at` (`user_id`,`created_at`),
  KEY `role_permission_audits_action_created_at` (`action`,`created_at`),
  KEY `role_permission_audits_permission_id_fk` (`permission_id`),
  CONSTRAINT `role_permission_audits_permission_id_fk` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `role_permission_audits_role_id_fk` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `role_permission_audits_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for role_permissions
-- ----------------------------
DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE `role_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_permissions_role_id_permission_id` (`role_id`,`permission_id`),
  KEY `role_permissions_permission_id` (`permission_id`),
  CONSTRAINT `role_permissions_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_permissions_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色代码',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT '角色描述',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- ----------------------------
-- Table structure for system_analytics
-- ----------------------------
DROP TABLE IF EXISTS `system_analytics`;
CREATE TABLE `system_analytics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `analytics_type` varchar(20) NOT NULL,
  `metric_name` varchar(100) NOT NULL,
  `metric_value` decimal(15,2) NOT NULL,
  `dimension_data` json DEFAULT NULL,
  `time_period` varchar(20) NOT NULL,
  `analysis_date` date NOT NULL,
  `extra_data` json DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `system_analytics_analytics_type_analysis_date` (`analytics_type`,`analysis_date`),
  KEY `system_analytics_metric_name_analysis_date` (`metric_name`,`analysis_date`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for system_backups
-- ----------------------------
DROP TABLE IF EXISTS `system_backups`;
CREATE TABLE `system_backups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `backup_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '备份类型',
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '备份名称',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT '备份描述',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '文件路径',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小(字节)',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '状态',
  `start_time` datetime(6) DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime(6) DEFAULT NULL COMMENT '结束时间',
  `error_message` longtext COLLATE utf8mb4_unicode_ci COMMENT '错误信息',
  `created_by_id` bigint DEFAULT NULL COMMENT '创建人ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `system_backups_created_by_id` (`created_by_id`),
  KEY `idx_backup_type` (`backup_type`),
  KEY `idx_status` (`status`),
  CONSTRAINT `system_backups_created_by_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统备份表';

-- ----------------------------
-- Table structure for system_configs
-- ----------------------------
DROP TABLE IF EXISTS `system_configs`;
CREATE TABLE `system_configs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `value` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置值',
  `config_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置类型',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT '配置描述',
  `is_encrypted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否加密',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `idx_config_type` (`config_type`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- ----------------------------
-- Table structure for system_logs
-- ----------------------------
DROP TABLE IF EXISTS `system_logs`;
CREATE TABLE `system_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `level` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日志级别',
  `log_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日志类型',
  `module` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模块',
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日志消息',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `ip_address` char(39) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP地址',
  `user_agent` longtext COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `request_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求路径',
  `request_method` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求方法',
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
  KEY `idx_system_logs_ip_address` (`ip_address`),
  KEY `idx_system_logs_request_method` (`request_method`),
  CONSTRAINT `system_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统日志表';

-- ----------------------------
-- Table structure for system_maintenance
-- ----------------------------
DROP TABLE IF EXISTS `system_maintenance`;
CREATE TABLE `system_maintenance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `maintenance_type` varchar(20) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `status` varchar(20) NOT NULL,
  `scheduled_start` datetime(6) NOT NULL,
  `scheduled_end` datetime(6) NOT NULL,
  `actual_start` datetime(6) DEFAULT NULL,
  `actual_end` datetime(6) DEFAULT NULL,
  `affected_services` json DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `system_maintenance_created_by_id_fk` (`created_by_id`),
  CONSTRAINT `system_maintenance_created_by_id_fk` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for system_monitors
-- ----------------------------
DROP TABLE IF EXISTS `system_monitors`;
CREATE TABLE `system_monitors` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `monitor_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '监控类型',
  `metric_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '指标名称',
  `metric_value` double NOT NULL COMMENT '指标值',
  `threshold_warning` double DEFAULT NULL COMMENT '警告阈值',
  `threshold_critical` double DEFAULT NULL COMMENT '严重阈值',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT '状态',
  `extra_data` json DEFAULT NULL COMMENT '额外数据',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_monitor_type_created_at` (`monitor_type`,`created_at`),
  KEY `idx_status_created_at` (`status`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统监控表';

-- ----------------------------
-- Table structure for system_notifications
-- ----------------------------
DROP TABLE IF EXISTS `system_notifications`;
CREATE TABLE `system_notifications` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知标题',
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知内容',
  `notification_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知类型',
  `priority` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium' COMMENT '优先级',
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

-- ----------------------------
-- Table structure for system_notifications_target_users
-- ----------------------------
DROP TABLE IF EXISTS `system_notifications_target_users`;
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

-- ----------------------------
-- Table structure for system_page_configs
-- ----------------------------
DROP TABLE IF EXISTS `system_page_configs`;
CREATE TABLE `system_page_configs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `page_name` varchar(100) NOT NULL,
  `page_type` varchar(20) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `keywords` varchar(500) NOT NULL,
  `layout_config` json DEFAULT NULL,
  `theme_config` json DEFAULT NULL,
  `custom_css` longtext NOT NULL,
  `custom_js` longtext NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `page_name` (`page_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for system_security_logs
-- ----------------------------
DROP TABLE IF EXISTS `system_security_logs`;
CREATE TABLE `system_security_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `security_type` varchar(30) NOT NULL,
  `ip_address` char(39) NOT NULL,
  `user_agent` longtext NOT NULL,
  `description` longtext NOT NULL,
  `risk_level` varchar(10) NOT NULL,
  `is_resolved` tinyint(1) NOT NULL,
  `resolved_at` datetime(6) DEFAULT NULL,
  `extra_data` json DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `resolved_by_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `system_security_logs_security_type_created_at` (`security_type`,`created_at`),
  KEY `system_security_logs_risk_level_created_at` (`risk_level`,`created_at`),
  KEY `system_security_logs_is_resolved_created_at` (`is_resolved`,`created_at`),
  KEY `system_security_logs_resolved_by_id_fk` (`resolved_by_id`),
  KEY `system_security_logs_user_id_fk` (`user_id`),
  CONSTRAINT `system_security_logs_resolved_by_id_fk` FOREIGN KEY (`resolved_by_id`) REFERENCES `users` (`id`),
  CONSTRAINT `system_security_logs_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for system_statistics
-- ----------------------------
DROP TABLE IF EXISTS `system_statistics`;
CREATE TABLE `system_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `stat_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '统计类型',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `stat_hour` int DEFAULT NULL COMMENT '统计小时',
  `metric_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '指标名称',
  `metric_value` decimal(15,2) NOT NULL COMMENT '指标值',
  `extra_data` json DEFAULT NULL COMMENT '额外数据',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `system_statistics_stat_type_stat_date_stat_hour_metric_name` (`stat_type`,`stat_date`,`stat_hour`,`metric_name`),
  KEY `idx_stat_type_stat_date` (`stat_type`,`stat_date`),
  KEY `idx_metric_name_stat_date` (`metric_name`,`stat_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统统计表';

-- ----------------------------
-- Table structure for user_activity_logs
-- ----------------------------
DROP TABLE IF EXISTS `user_activity_logs`;
CREATE TABLE `user_activity_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `action` varchar(50) NOT NULL,
  `description` varchar(200) NOT NULL,
  `ip_address` char(39) NOT NULL,
  `user_agent` longtext NOT NULL,
  `request_path` varchar(500) NOT NULL,
  `extra_data` json DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_activity_logs_user_created_at` (`user_id`,`created_at`),
  KEY `user_activity_logs_action_created_at` (`action`,`created_at`),
  CONSTRAINT `user_activity_logs_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_login_logs
-- ----------------------------
DROP TABLE IF EXISTS `user_login_logs`;
CREATE TABLE `user_login_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `ip_address` char(39) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IP地址',
  `user_agent` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户代理',
  `login_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '登录时间',
  `is_success` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否成功',
  `logout_time` datetime(6) DEFAULT NULL,
  `failure_reason` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `location` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `device_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user_login_logs_user_id` (`user_id`),
  KEY `idx_login_time` (`login_time`),
  KEY `idx_ip_address` (`ip_address`),
  CONSTRAINT `user_login_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户登录日志表';

-- ----------------------------
-- Table structure for user_permission_overrides
-- ----------------------------
DROP TABLE IF EXISTS `user_permission_overrides`;
CREATE TABLE `user_permission_overrides` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_granted` tinyint(1) NOT NULL,
  `reason` longtext NOT NULL,
  `expire_at` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `granted_by_id` bigint DEFAULT NULL,
  `permission_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_permission_unique` (`user_id`,`permission_id`),
  KEY `user_permission_overrides_granted_by_id_fk` (`granted_by_id`),
  KEY `user_permission_overrides_permission_id_fk` (`permission_id`),
  CONSTRAINT `user_permission_overrides_granted_by_id_fk` FOREIGN KEY (`granted_by_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_permission_overrides_permission_id_fk` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `user_permission_overrides_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_profiles
-- ----------------------------
DROP TABLE IF EXISTS `user_profiles`;
CREATE TABLE `user_profiles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `real_name` varchar(50) NOT NULL,
  `id_card` varchar(18) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `birthday` date DEFAULT NULL,
  `address` longtext NOT NULL,
  `company` varchar(200) NOT NULL,
  `position` varchar(100) NOT NULL,
  `bio` longtext NOT NULL,
  `website` varchar(200) NOT NULL,
  `social_media` json DEFAULT NULL,
  `preferences` json DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `user_profiles_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_roles_user_id_role_id` (`user_id`,`role_id`),
  KEY `user_roles_role_id` (`role_id`),
  CONSTRAINT `user_roles_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- ----------------------------
-- Table structure for user_sessions
-- ----------------------------
DROP TABLE IF EXISTS `user_sessions`;
CREATE TABLE `user_sessions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `session_key` varchar(100) NOT NULL,
  `ip_address` char(39) NOT NULL,
  `user_agent` longtext NOT NULL,
  `login_time` datetime(6) NOT NULL,
  `last_activity` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `expire_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_key` (`session_key`),
  KEY `user_sessions_user_id` (`user_id`),
  CONSTRAINT `user_sessions_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `user_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'personal' COMMENT '用户类型: enterprise-企业用户, personal-个人用户',
  `phone` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `avatar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
  `is_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否认证',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_user_type` (`user_type`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_users_email` (`email`),
  KEY `idx_users_date_joined` (`date_joined`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ----------------------------
-- Table structure for v_enterprise_statistics
-- ----------------------------
DROP TABLE IF EXISTS `v_enterprise_statistics`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_enterprise_statistics` AS select `e`.`enterprise_type` AS `enterprise_type`,count(0) AS `total_enterprises`,count((case when (`e`.`status` = 'approved') then 1 end)) AS `approved_enterprises`,count((case when (`e`.`status` = 'pending') then 1 end)) AS `pending_enterprises`,avg(`es`.`total_projects`) AS `avg_projects_per_enterprise`,sum(`es`.`total_revenue`) AS `total_revenue` from (`enterprises` `e` left join `enterprise_statistics` `es` on((`e`.`id` = `es`.`enterprise_id`))) group by `e`.`enterprise_type`;

-- ----------------------------
-- Table structure for v_info_post_statistics
-- ----------------------------
DROP TABLE IF EXISTS `v_info_post_statistics`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_info_post_statistics` AS select `ic`.`name` AS `category_name`,`ip`.`post_type` AS `post_type`,count(0) AS `total_posts`,count((case when (`ip`.`status` = 'published') then 1 end)) AS `published_posts`,avg(`ip`.`view_count`) AS `avg_view_count`,avg(`ip`.`like_count`) AS `avg_like_count` from (`info_posts` `ip` join `info_categories` `ic` on((`ip`.`category_id` = `ic`.`id`))) group by `ic`.`name`,`ip`.`post_type`;

-- ----------------------------
-- Table structure for v_resource_statistics
-- ----------------------------
DROP TABLE IF EXISTS `v_resource_statistics`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_resource_statistics` AS select `rt`.`name` AS `resource_type_name`,count(0) AS `total_resources`,count((case when (`r`.`status` = 'available') then 1 end)) AS `available_resources`,count((case when (`r`.`status` = 'in_use') then 1 end)) AS `in_use_resources`,sum(`r`.`total_value`) AS `total_value`,avg(`r`.`unit_price`) AS `avg_unit_price` from (`resources` `r` join `resource_types` `rt` on((`r`.`resource_type_id` = `rt`.`id`))) group by `rt`.`name`;

-- ----------------------------
-- Table structure for v_user_statistics
-- ----------------------------
DROP TABLE IF EXISTS `v_user_statistics`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user_statistics` AS select `u`.`user_type` AS `user_type`,count(0) AS `total_users`,count((case when (`u`.`is_active` = 1) then 1 end)) AS `active_users`,count((case when (`u`.`is_verified` = 1) then 1 end)) AS `verified_users`,count((case when (`u`.`date_joined` >= (now() - interval 30 day)) then 1 end)) AS `new_users_30d` from `users` `u` group by `u`.`user_type`;


SET FOREIGN_KEY_CHECKS = 1;