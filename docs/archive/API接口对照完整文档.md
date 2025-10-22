# API接口对照完整文档

## 概述

本文档列出了防腐保温智能数字平台的所有前后端API对照关系，确保前端调用真实的后端API。

## API基础URL

- **开发环境**: `http://localhost:8000/api/v1`
- **前端配置**: `frontend/src/api/index.js`

## 1. 用户认证模块 (`/api/v1/auth/`)

### 1.1 用户认证

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 用户登录 | `frontend/src/stores/user.js:login()` | `/auth/login/` | POST | ✅ 已对接 |
| 用户注册 | `frontend/src/stores/user.js:register()` | `/auth/register/` | POST | ✅ 已对接 |
| 用户登出 | `frontend/src/stores/user.js:logout()` | `/auth/logout/` | POST | ✅ 已对接 |
| Token刷新 | `frontend/src/api/index.js` | `/auth/token/refresh/` | POST | ✅ 已对接 |

### 1.2 用户信息

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 获取当前用户信息 | `frontend/src/stores/user.js:getUserProfile()` | `/auth/profile/` | GET | ✅ 已对接 |
| 更新用户信息 | `frontend/src/stores/user.js:updateProfile()` | `/auth/profile/update/` | PUT | ✅ 已对接 |
| 修改密码 | `frontend/src/stores/user.js:changePassword()` | `/auth/change-password/` | POST | ✅ 已对接 |
| 获取用户菜单 | `frontend/src/stores/user.js:getUserMenus()` | `/auth/user-menus/` | GET | ✅ 已对接 |

### 1.3 用户管理（管理员）

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 用户列表 | `frontend/src/views/system/Users.vue` | `/auth/users/` | GET | ⚠️ 需对接 |
| 创建用户 | `frontend/src/views/system/Users.vue` | `/auth/users/` | POST | ⚠️ 需对接 |
| 用户详情 | `frontend/src/views/system/Users.vue` | `/auth/users/{id}/` | GET | ⚠️ 需对接 |
| 更新用户 | `frontend/src/views/system/Users.vue` | `/auth/users/{id}/` | PUT | ⚠️ 需对接 |
| 删除用户 | `frontend/src/views/system/Users.vue` | `/auth/users/{id}/` | DELETE | ⚠️ 需对接 |

### 1.4 角色权限管理

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 角色列表 | `frontend/src/views/system/Roles.vue` | `/auth/roles/` | GET | ⚠️ 需对接 |
| 创建角色 | `frontend/src/views/system/Roles.vue` | `/auth/roles/` | POST | ⚠️ 需对接 |
| 角色详情 | `frontend/src/views/system/Roles.vue` | `/auth/roles/{id}/` | GET | ⚠️ 需对接 |
| 更新角色 | `frontend/src/views/system/Roles.vue` | `/auth/roles/{id}/` | PUT | ⚠️ 需对接 |
| 删除角色 | `frontend/src/views/system/Roles.vue` | `/auth/roles/{id}/` | DELETE | ⚠️ 需对接 |
| 分配用户角色 | `frontend/src/views/system/Users.vue` | `/auth/assign-role/` | POST | ⚠️ 需对接 |

## 2. 仪表板模块 (`/api/v1/dashboard/`)

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 统计数据 | `frontend/src/views/dashboard/Home.vue` | `/dashboard/statistics/` | GET | ✅ 已对接 |
| 最近活动 | `frontend/src/views/dashboard/Home.vue` | `/dashboard/activities/` | GET | ✅ 已对接 |
| 待办任务 | `frontend/src/views/dashboard/Home.vue` | `/dashboard/tasks/` | GET | ✅ 已对接 |
| 系统通知 | `frontend/src/views/dashboard/Home.vue` | `/dashboard/notifications/` | GET | ✅ 已对接 |

## 3. 企业模块 (`/api/v1/enterprises/`)

### 3.1 企业信息

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 企业列表 | `frontend/src/views/enterprise/index.vue` | `/enterprises/` | GET | ⚠️ 需对接 |
| 创建企业 | N/A | `/enterprises/` | POST | ⚠️ 需对接 |
| 企业详情 | `frontend/src/views/enterprise/index.vue` | `/enterprises/{id}/` | GET | ⚠️ 需对接 |
| 更新企业 | `frontend/src/views/enterprise/index.vue` | `/enterprises/{id}/` | PUT | ⚠️ 需对接 |
| 企业仪表板 | `frontend/src/views/enterprise/index.vue` | `/enterprises/dashboard/` | GET | ⚠️ 需对接 |
| 企业统计 | `frontend/src/views/enterprise/index.vue` | `/enterprises/statistics/` | GET | ⚠️ 需对接 |

### 3.2 企业项目

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 项目列表 | `frontend/src/views/enterprise/Projects.vue` | `/enterprises/projects/` | GET | ⚠️ 需对接 |
| 创建项目 | `frontend/src/views/enterprise/Projects.vue` | `/enterprises/projects/` | POST | ⚠️ 需对接 |
| 项目详情 | `frontend/src/views/enterprise/Projects.vue` | `/enterprises/projects/{id}/` | GET | ⚠️ 需对接 |
| 更新项目 | `frontend/src/views/enterprise/Projects.vue` | `/enterprises/projects/{id}/` | PUT | ⚠️ 需对接 |
| 删除项目 | `frontend/src/views/enterprise/Projects.vue` | `/enterprises/projects/{id}/` | DELETE | ⚠️ 需对接 |
| 更新项目进度 | `frontend/src/views/enterprise/Projects.vue` | `/enterprises/projects/{id}/progress/` | POST | ⚠️ 需对接 |

### 3.3 企业员工

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 员工列表 | `frontend/src/views/enterprise/Employees.vue` | `/enterprises/employees/` | GET | ⚠️ 需对接 |
| 添加员工 | `frontend/src/views/enterprise/Employees.vue` | `/enterprises/employees/` | POST | ⚠️ 需对接 |
| 员工详情 | `frontend/src/views/enterprise/Employees.vue` | `/enterprises/employees/{id}/` | GET | ⚠️ 需对接 |
| 更新员工 | `frontend/src/views/enterprise/Employees.vue` | `/enterprises/employees/{id}/` | PUT | ⚠️ 需对接 |
| 删除员工 | `frontend/src/views/enterprise/Employees.vue` | `/enterprises/employees/{id}/` | DELETE | ⚠️ 需对接 |

## 4. 个人用户模块 (`/api/v1/persons/`)

### 4.1 个人信息

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 个人信息 | `frontend/src/views/personal/index.vue` | `/persons/` | GET | ⚠️ 需对接 |
| 更新个人信息 | `frontend/src/views/personal/index.vue` | `/persons/{id}/` | PUT | ⚠️ 需对接 |
| 个人仪表板 | `frontend/src/views/personal/index.vue` | `/persons/dashboard/` | GET | ⚠️ 需对接 |
| 个人统计 | `frontend/src/views/personal/index.vue` | `/persons/statistics/` | GET | ⚠️ 需对接 |

### 4.2 个人项目

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 项目列表 | `frontend/src/views/personal/Projects.vue` | `/persons/projects/` | GET | ⚠️ 需对接 |
| 创建项目 | `frontend/src/views/personal/Projects.vue` | `/persons/projects/` | POST | ⚠️ 需对接 |
| 项目详情 | `frontend/src/views/personal/Projects.vue` | `/persons/projects/{id}/` | GET | ⚠️ 需对接 |
| 更新项目 | `frontend/src/views/personal/Projects.vue` | `/persons/projects/{id}/` | PUT | ⚠️ 需对接 |
| 删除项目 | `frontend/src/views/personal/Projects.vue` | `/persons/projects/{id}/` | DELETE | ⚠️ 需对接 |

### 4.3 个人任务

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 任务列表 | `frontend/src/views/personal/Tasks.vue` | `/persons/tasks/` | GET | ⚠️ 需对接 |
| 创建任务 | `frontend/src/views/personal/Tasks.vue` | `/persons/tasks/` | POST | ⚠️ 需对接 |
| 任务详情 | `frontend/src/views/personal/Tasks.vue` | `/persons/tasks/{id}/` | GET | ⚠️ 需对接 |
| 更新任务 | `frontend/src/views/personal/Tasks.vue` | `/persons/tasks/{id}/` | PUT | ⚠️ 需对接 |
| 删除任务 | `frontend/src/views/personal/Tasks.vue` | `/persons/tasks/{id}/` | DELETE | ⚠️ 需对接 |
| 完成任务 | `frontend/src/views/personal/Tasks.vue` | `/persons/tasks/{id}/complete/` | POST | ⚠️ 需对接 |

## 5. 信息广场模块 (`/api/v1/info-plaza/`)

### 5.1 信息发布

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 信息列表 | `frontend/src/views/info-plaza/index.vue` | `/info-plaza/posts/` | GET | ⚠️ 需对接 |
| 发布信息 | `frontend/src/views/info-plaza/Publish.vue` | `/info-plaza/posts/` | POST | ⚠️ 需对接 |
| 信息详情 | `frontend/src/views/info-plaza/Detail.vue` | `/info-plaza/posts/{id}/` | GET | ⚠️ 需对接 |
| 更新信息 | `frontend/src/views/info-plaza/Publish.vue` | `/info-plaza/posts/{id}/` | PUT | ⚠️ 需对接 |
| 删除信息 | `frontend/src/views/info-plaza/index.vue` | `/info-plaza/posts/{id}/` | DELETE | ⚠️ 需对接 |
| 发布信息 | `frontend/src/views/info-plaza/Publish.vue` | `/info-plaza/posts/{id}/publish/` | POST | ⚠️ 需对接 |
| 点赞信息 | `frontend/src/views/info-plaza/Detail.vue` | `/info-plaza/posts/{id}/like/` | POST | ⚠️ 需对接 |
| 收藏信息 | `frontend/src/views/info-plaza/Detail.vue` | `/info-plaza/posts/{id}/favorite/` | POST | ⚠️ 需对接 |

### 5.2 信息分类和标签

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 分类列表 | `frontend/src/views/info-plaza/Publish.vue` | `/info-plaza/categories/` | GET | ⚠️ 需对接 |
| 标签列表 | `frontend/src/views/info-plaza/Publish.vue` | `/info-plaza/tags/` | GET | ⚠️ 需对接 |

### 5.3 信息检索

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 我的发布 | `frontend/src/views/info-plaza/index.vue` | `/info-plaza/my-posts/` | GET | ⚠️ 需对接 |
| 我的收藏 | `frontend/src/views/info-plaza/index.vue` | `/info-plaza/my-favorites/` | GET | ⚠️ 需对接 |
| 热门信息 | `frontend/src/views/info-plaza/index.vue` | `/info-plaza/hot-posts/` | GET | ⚠️ 需对接 |
| 推荐信息 | `frontend/src/views/info-plaza/index.vue` | `/info-plaza/recommended-posts/` | GET | ⚠️ 需对接 |
| 搜索信息 | `frontend/src/views/info-plaza/index.vue` | `/info-plaza/search/` | GET | ⚠️ 需对接 |

### 5.4 评论管理

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 评论列表 | `frontend/src/views/info-plaza/Detail.vue` | `/info-plaza/comments/?post={id}` | GET | ⚠️ 需对接 |
| 发表评论 | `frontend/src/views/info-plaza/Detail.vue` | `/info-plaza/comments/` | POST | ⚠️ 需对接 |
| 删除评论 | `frontend/src/views/info-plaza/Detail.vue` | `/info-plaza/comments/{id}/` | DELETE | ⚠️ 需对接 |

## 6. 资源管理模块 (`/api/v1/resources/`)

### 6.1 资源管理

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 资源列表 | `frontend/src/views/resources/index.vue` | `/resources/` | GET | ⚠️ 需对接 |
| 添加资源 | `frontend/src/views/resources/Add.vue` | `/resources/` | POST | ⚠️ 需对接 |
| 资源详情 | `frontend/src/views/resources/Detail.vue` | `/resources/{id}/` | GET | ⚠️ 需对接 |
| 更新资源 | `frontend/src/views/resources/Add.vue` | `/resources/{id}/` | PUT | ⚠️ 需对接 |
| 删除资源 | `frontend/src/views/resources/index.vue` | `/resources/{id}/` | DELETE | ⚠️ 需对接 |

### 6.2 资源检索

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 我的资源 | `frontend/src/views/resources/index.vue` | `/resources/my-resources/` | GET | ⚠️ 需对接 |
| 可用资源 | `frontend/src/views/resources/index.vue` | `/resources/available/` | GET | ⚠️ 需对接 |
| 租赁资源 | `frontend/src/views/resources/index.vue` | `/resources/rental/` | GET | ⚠️ 需对接 |
| 搜索资源 | `frontend/src/views/resources/index.vue` | `/resources/search/` | GET | ⚠️ 需对接 |
| 资源统计 | `frontend/src/views/resources/index.vue` | `/resources/statistics/` | GET | ⚠️ 需对接 |

### 6.3 资源类型

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 资源类型列表 | `frontend/src/views/resources/Add.vue` | `/resources/types/` | GET | ⚠️ 需对接 |

### 6.4 资源申请

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 申请列表 | `frontend/src/views/resources/index.vue` | `/resources/requests/` | GET | ⚠️ 需对接 |
| 创建申请 | `frontend/src/views/resources/Detail.vue` | `/resources/requests/` | POST | ⚠️ 需对接 |
| 我的申请 | `frontend/src/views/resources/index.vue` | `/resources/my-requests/` | GET | ⚠️ 需对接 |
| 审批申请 | `frontend/src/views/resources/index.vue` | `/resources/requests/{id}/approve/` | POST | ⚠️ 需对接 |

## 7. 系统管理模块 (`/api/v1/system/`)

### 7.1 系统配置

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 配置列表 | `frontend/src/views/system/index.vue` | `/system/configs/` | GET | ⚠️ 需对接 |
| 更新配置 | `frontend/src/views/system/index.vue` | `/system/configs/{id}/` | PUT | ⚠️ 需对接 |

### 7.2 系统日志

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 日志列表 | `frontend/src/views/system/Logs.vue` | `/system/logs/` | GET | ⚠️ 需对接 |
| 日志摘要 | `frontend/src/views/system/Logs.vue` | `/system/logs/summary/` | GET | ⚠️ 需对接 |

### 7.3 系统统计

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 仪表板统计 | `frontend/src/views/system/index.vue` | `/system/statistics/dashboard/` | GET | ⚠️ 需对接 |
| 用户统计 | `frontend/src/views/system/Users.vue` | `/system/statistics/users/` | GET | ⚠️ 需对接 |
| 内容统计 | `frontend/src/views/system/index.vue` | `/system/statistics/content/` | GET | ⚠️ 需对接 |

### 7.4 系统监控

| 功能 | 前端路径 | 后端端点 | 方法 | 状态 |
|-----|---------|---------|------|------|
| 系统健康检查 | `frontend/src/views/system/index.vue` | `/system/health/` | GET | ⚠️ 需对接 |

## 8. 状态说明

- ✅ **已对接**: 前端已调用真实API
- ⚠️ **需对接**: 前端使用模拟数据或尚未实现
- ❌ **未实现**: 后端API尚未实现

## 9. 修复计划

### 优先级1（高）- 核心功能

1. 企业模块数据展示
   - 企业仪表板统计数据
   - 企业项目列表
   - 企业员工列表

2. 个人模块数据展示
   - 个人统计数据
   - 个人项目列表
   - 个人任务列表

3. 信息广场数据展示
   - 信息列表加载
   - 信息详情展示
   - 点赞和收藏功能

### 优先级2（中）- 管理功能

4. 系统管理数据展示
   - 系统统计数据
   - 用户管理列表
   - 角色管理列表
   - 系统日志列表

5. 资源管理数据展示
   - 资源列表加载
   - 资源详情展示
   - 资源申请功能

### 优先级3（低）- 次要功能

6. 高级功能
   - 数据图表
   - 实时通知
   - 高级搜索

## 10. 注意事项

1. **认证要求**: 除了登录、注册接口外，所有API都需要在请求头中携带JWT token
2. **错误处理**: 统一在 `frontend/src/api/index.js` 中处理
3. **数据格式**: 统一使用JSON格式
4. **分页**: 列表接口支持分页，参数为 `page` 和 `page_size`
5. **过滤**: 列表接口支持过滤，使用查询参数
6. **排序**: 列表接口支持排序，参数为 `ordering`

## 11. 下一步行动

1. 按优先级修复前端页面的API调用
2. 为每个需要对接的页面创建对应的API调用函数
3. 移除所有硬编码的模拟数据
4. 测试所有API调用是否正常工作
5. 处理边界情况和错误情况

---

**更新日期**: 2024-10-21
**维护者**: 开发团队


