-- 初始化数据库脚本
-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS corrosion_platform CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE corrosion_platform;

-- 创建基础角色
INSERT IGNORE INTO roles (name, code, description, is_active, created_at, updated_at) VALUES
('系统管理员', 'admin', '系统管理员，拥有所有权限', 1, NOW(), NOW()),
('企业管理员', 'enterprise_admin', '企业管理员，管理企业相关功能', 1, NOW(), NOW()),
('企业员工', 'enterprise_employee', '企业员工，使用企业功能', 1, NOW(), NOW()),
('个人用户', 'personal_user', '个人用户，使用个人功能', 1, NOW(), NOW());

-- 创建基础权限
INSERT IGNORE INTO permissions (name, code, description, module, is_active, created_at) VALUES
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

-- 创建基础菜单
INSERT IGNORE INTO menus (name, code, url, icon, parent_id, sort_order, is_active, created_at) VALUES
-- 一级菜单
('仪表板', 'dashboard', '/dashboard', 'Odometer', NULL, 1, 1, NOW()),
('企业中心', 'enterprise', '/dashboard/enterprise', 'OfficeBuilding', NULL, 2, 1, NOW()),
('个人中心', 'personal', '/dashboard/personal', 'User', NULL, 3, 1, NOW()),
('信息广场', 'info_plaza', '/dashboard/info-plaza', 'ChatDotSquare', NULL, 4, 1, NOW()),
('资源管理', 'resources', '/dashboard/resources', 'Box', NULL, 5, 1, NOW()),
('系统管理', 'system', '/dashboard/system', 'Setting', NULL, 6, 1, NOW()),

-- 企业中心子菜单
('企业信息', 'enterprise_info', '/dashboard/enterprise', 'OfficeBuilding', 2, 1, 1, NOW()),
('项目管理', 'enterprise_projects', '/dashboard/enterprise/projects', 'Folder', 2, 2, 1, NOW()),
('员工管理', 'enterprise_employees', '/dashboard/enterprise/employees', 'UserFilled', 2, 3, 1, NOW()),

-- 个人中心子菜单
('个人信息', 'personal_info', '/dashboard/personal', 'User', 3, 1, 1, NOW()),
('我的项目', 'personal_projects', '/dashboard/personal/projects', 'Folder', 3, 2, 1, NOW()),
('我的任务', 'personal_tasks', '/dashboard/personal/tasks', 'List', 3, 3, 1, NOW()),

-- 信息广场子菜单
('信息浏览', 'info_browse', '/dashboard/info-plaza', 'ChatDotSquare', 4, 1, 1, NOW()),
('发布信息', 'info_publish', '/dashboard/info-plaza/publish', 'Edit', 4, 2, 1, NOW()),

-- 资源管理子菜单
('资源浏览', 'resource_browse', '/dashboard/resources', 'Box', 5, 1, 1, NOW()),
('添加资源', 'resource_add', '/dashboard/resources/add', 'Plus', 5, 2, 1, NOW()),

-- 系统管理子菜单
('用户管理', 'system_users', '/dashboard/system/users', 'User', 6, 1, 1, NOW()),
('角色管理', 'system_roles', '/dashboard/system/roles', 'UserFilled', 6, 2, 1, NOW()),
('系统日志', 'system_logs', '/dashboard/system/logs', 'Document', 6, 3, 1, NOW());

-- 创建信息分类
INSERT IGNORE INTO info_categories (name, code, description, icon, sort_order, is_active, created_at) VALUES
('供应信息', 'supply', '产品供应、服务提供等信息', 'ShoppingCart', 1, 1, NOW()),
('需求信息', 'demand', '产品需求、服务需求等信息', 'ShoppingBag', 2, 1, NOW()),
('招聘信息', 'recruitment', '人才招聘、岗位需求等信息', 'User', 3, 1, NOW()),
('招标信息', 'tender', '项目招标、采购招标等信息', 'Document', 4, 1, NOW()),
('技术文章', 'technology', '技术分享、经验交流等文章', 'Reading', 5, 1, NOW()),
('行业资讯', 'news', '行业动态、政策资讯等信息', 'Bell', 6, 1, NOW());

-- 创建资源类型
INSERT IGNORE INTO resource_types (name, code, description, icon, sort_order, is_active, created_at) VALUES
('设备', 'equipment', '各种防腐保温设备', 'Tools', 1, 1, NOW()),
('材料', 'material', '防腐保温材料', 'Box', 2, 1, NOW()),
('人才', 'talent', '专业技术人才', 'User', 3, 1, NOW()),
('技术', 'technology', '技术服务和解决方案', 'Setting', 4, 1, NOW());

-- 创建系统配置
INSERT IGNORE INTO system_configs (`key`, value, config_type, description, is_encrypted, is_active, created_at, updated_at) VALUES
('site_name', '防腐保温智能数字平台', 'basic', '网站名称', 0, 1, NOW(), NOW()),
('site_description', '专业的防腐保温行业数字化平台', 'basic', '网站描述', 0, 1, NOW(), NOW()),
('site_keywords', '防腐,保温,数字化,平台', 'basic', '网站关键词', 0, 1, NOW(), NOW()),
('contact_email', 'admin@corrosion-platform.com', 'basic', '联系邮箱', 0, 1, NOW(), NOW()),
('contact_phone', '400-123-4567', 'basic', '联系电话', 0, 1, NOW(), NOW()),
('max_file_size', '10485760', 'basic', '最大文件上传大小(字节)', 0, 1, NOW(), NOW()),
('allowed_file_types', 'jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx', 'basic', '允许上传的文件类型', 0, 1, NOW(), NOW());
