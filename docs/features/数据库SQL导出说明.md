# 数据库SQL导出说明

## 📁 导出文件

### 1. database_schema_20251022_211347.sql
**类型**: 完整数据库结构（仅表结构，无数据）  
**大小**: 约 50-100 KB  
**内容**: 所有61个表的CREATE TABLE语句  
**用途**: 
- 了解数据库结构
- 在新环境中创建数据库
- 数据库结构文档

### 2. database_schema.sql（旧文件）
**类型**: 旧的数据库结构文件  
**状态**: 可以删除，已被新文件替代

---

## 📊 数据库概况

### 基本信息
- **数据库名称**: corrosion_platform
- **字符集**: utf8mb4
- **存储引擎**: InnoDB
- **总表数**: 61个（57个表 + 4个视图）

### 表分类统计

#### 1. Django系统表（7个）
```
auth_group                  -- 用户组
auth_group_permissions      -- 组权限
auth_permission             -- 权限定义
django_admin_log            -- 管理日志
django_content_type         -- 内容类型
django_migrations           -- 迁移记录
django_session              -- 会话记录
```

#### 2. 用户管理表（14个）⭐ v2.0增强
```
users                       -- 用户基础信息
user_profiles               -- 用户扩展资料 ⭐新增
user_sessions               -- 用户会话管理 ⭐新增
user_activity_logs          -- 用户活动日志 ⭐新增
user_login_logs             -- 登录日志 ⭐增强
roles                       -- 角色定义
permissions                 -- 权限定义
menus                       -- 菜单定义 ⭐增强
user_roles                  -- 用户角色关联
role_permissions            -- 角色权限关联
role_menus                  -- 角色菜单关联 ⭐增强
permission_groups           -- 权限组 ⭐新增
role_permission_audits      -- 权限审计 ⭐新增
user_permission_overrides   -- 权限覆盖 ⭐新增
```

#### 3. 企业管理表（5个）
```
enterprises                 -- 企业信息
employees                   -- 员工信息
enterprise_projects         -- 企业项目
enterprise_documents        -- 企业文档
enterprise_statistics       -- 企业统计
```

#### 4. 个人管理表（5个）
```
persons                     -- 个人信息
person_projects             -- 个人项目
person_tasks                -- 个人任务
person_documents            -- 个人文档
person_statistics           -- 个人统计
```

#### 5. 信息广场表（8个）
```
info_posts                  -- 信息帖子
info_categories             -- 信息分类
info_tags                   -- 信息标签
info_post_images            -- 帖子图片
info_likes                  -- 点赞记录
info_comments               -- 评论记录
info_favorites              -- 收藏记录
info_view_logs              -- 浏览记录
```

#### 6. 资源管理表（7个）
```
resources                   -- 资源信息
resource_types              -- 资源类型
resource_images             -- 资源图片
resource_requests           -- 租赁请求
resource_maintenances       -- 维护记录
resource_usage_logs         -- 使用日志
resource_statistics         -- 资源统计
```

#### 7. 系统配置表（11个）⭐ v2.0增强
```
system_configs              -- 系统配置
system_logs                 -- 系统日志
system_statistics           -- 系统统计
system_notifications        -- 系统通知
system_notifications_target_users -- 通知目标用户
system_backups              -- 系统备份
system_monitors             -- 系统监控 ⭐增强
system_security_logs        -- 安全日志 ⭐新增
system_page_configs         -- 页面配置 ⭐新增
system_analytics            -- 数据分析 ⭐新增
system_maintenance          -- 系统维护 ⭐新增
```

#### 8. 统计视图（4个）
```
v_user_statistics           -- 用户统计视图
v_enterprise_statistics     -- 企业统计视图
v_resource_statistics       -- 资源统计视图
v_info_post_statistics      -- 信息统计视图
```

---

## 🔍 v2.0 新增表详解

### 用户管理新增表（6个）

#### user_profiles
**用途**: 存储用户的详细个人信息  
**字段**: real_name, id_card, gender, birthday, address, company, position, bio, website, social_media, preferences  
**关键特性**: 支持实名认证、个性化设置

#### user_sessions
**用途**: 管理用户登录会话  
**字段**: session_key, ip_address, user_agent, login_time, last_activity, is_active, expire_at  
**关键特性**: 在线用户统计、异常登录检测

#### user_activity_logs
**用途**: 记录用户的所有操作行为  
**字段**: action, description, ip_address, user_agent, request_path, extra_data  
**关键特性**: 用户行为分析、安全审计

#### permission_groups
**用途**: 权限分组管理  
**字段**: name, code, description, module, sort_order, is_active  
**关键特性**: 权限模块化管理

#### role_permission_audits
**用途**: 记录所有角色权限变更  
**字段**: role, permission, user, action, description, ip_address, user_agent  
**关键特性**: 权限变更追踪、安全审计

#### user_permission_overrides
**用途**: 为特定用户设置权限例外  
**字段**: user, permission, is_granted, reason, granted_by, expire_at, is_active  
**关键特性**: 临时权限授予、特殊权限控制

### 系统配置新增表（4个）

#### system_security_logs
**用途**: 记录所有安全相关事件  
**字段**: security_type, user, ip_address, description, risk_level, is_resolved, resolved_by  
**关键特性**: 安全事件监控、风险评估

#### system_page_configs
**用途**: 管理前端页面配置  
**字段**: page_name, page_type, title, description, layout_config, theme_config, custom_css, custom_js  
**关键特性**: 页面个性化定制、SEO优化

#### system_analytics
**用途**: 存储各类分析数据  
**字段**: analytics_type, metric_name, metric_value, dimension_data, time_period, analysis_date  
**关键特性**: 数据分析、趋势预测

#### system_maintenance
**用途**: 管理系统维护计划  
**字段**: maintenance_type, title, description, status, scheduled_start, scheduled_end, actual_start, actual_end  
**关键特性**: 维护计划管理、服务停机通知

---

## 📖 使用说明

### 1. 导入数据库结构

#### 方法一：使用MySQL命令行
```bash
mysql -u root -p corrosion_platform < database_schema_20251022_211347.sql
```

#### 方法二：使用Navicat等工具
1. 打开Navicat
2. 连接到MySQL服务器
3. 新建数据库 `corrosion_platform`
4. 运行SQL文件

#### 方法三：使用Django迁移
```bash
cd backend
python manage.py migrate
```

### 2. 初始化数据

运行测试脚本创建初始数据：
```bash
python test_enhanced_features.py
```

这将创建：
- 25个测试用户
- 14个角色
- 48个权限
- 21个菜单
- 8个系统配置
- 以及其他测试数据

---

## 🔧 数据库维护

### 备份建议
- **频率**: 每天自动备份
- **保留**: 保留最近30天
- **类型**: 完整备份 + 增量备份

### 优化建议
1. 定期执行 `OPTIMIZE TABLE`
2. 分析慢查询日志
3. 监控表大小增长
4. 定期清理过期数据

### 监控指标
- 数据库连接数
- 查询响应时间
- 表大小
- 索引使用率

---

## 📝 注意事项

1. **字符集**: 确保使用utf8mb4字符集
2. **时区**: 数据库时区应与应用一致
3. **权限**: 数据库用户需要完整的DDL和DML权限
4. **备份**: 导入前请备份现有数据
5. **版本**: MySQL版本建议5.7或更高

---

**生成时间**: 2024-10-22  
**数据库版本**: v2.0.0  
**总表数**: 61个（57个表 + 4个视图）





