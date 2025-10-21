# API接口文档

## 概述
本文档列出了防腐保温智能数字平台的所有API接口及其功能。

## 基础配置
- **基础URL**: `/api/v1`
- **认证方式**: JWT Bearer Token
- **内容类型**: `application/json`

## 1. 用户认证模块 (`/api/v1/auth/`)

### 1.1 认证接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| POST | `/auth/login/` | 用户登录 | 公开 |
| POST | `/auth/register/` | 用户注册 | 公开 |
| POST | `/auth/logout/` | 用户登出 | 需认证 |
| POST | `/auth/token/refresh/` | 刷新Token | 需认证 |

### 1.2 用户信息接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/auth/profile/` | 获取当前用户信息 | 需认证 |
| PUT | `/auth/profile/update/` | 更新用户信息 | 需认证 |
| POST | `/auth/change-password/` | 修改密码 | 需认证 |
| GET | `/auth/user-menus/` | 获取用户菜单 | 需认证 |

### 1.3 用户管理接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/auth/users/` | 获取用户列表 | 需认证 |
| POST | `/auth/users/` | 创建用户 | 管理员 |
| GET | `/auth/users/{id}/` | 获取用户详情 | 需认证 |
| PUT | `/auth/users/{id}/` | 更新用户 | 需认证 |
| DELETE | `/auth/users/{id}/` | 删除用户 | 管理员 |

### 1.4 角色管理接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/auth/roles/` | 获取角色列表 | 需认证 |
| POST | `/auth/roles/` | 创建角色 | 管理员 |
| GET | `/auth/roles/{id}/` | 获取角色详情 | 需认证 |
| PUT | `/auth/roles/{id}/` | 更新角色 | 管理员 |
| DELETE | `/auth/roles/{id}/` | 删除角色 | 管理员 |
| POST | `/auth/assign-role/` | 分配用户角色 | 管理员 |
| DELETE | `/auth/remove-role/{user_id}/{role_id}/` | 移除用户角色 | 管理员 |

### 1.5 权限管理接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/auth/permissions/` | 获取权限列表 | 需认证 |
| POST | `/auth/permissions/` | 创建权限 | 管理员 |
| GET | `/auth/permissions/{id}/` | 获取权限详情 | 需认证 |
| PUT | `/auth/permissions/{id}/` | 更新权限 | 管理员 |
| DELETE | `/auth/permissions/{id}/` | 删除权限 | 管理员 |

### 1.6 菜单管理接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/auth/menus/` | 获取菜单列表 | 需认证 |
| POST | `/auth/menus/` | 创建菜单 | 管理员 |
| GET | `/auth/menus/{id}/` | 获取菜单详情 | 需认证 |
| PUT | `/auth/menus/{id}/` | 更新菜单 | 管理员 |
| DELETE | `/auth/menus/{id}/` | 删除菜单 | 管理员 |

### 1.7 登录日志接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/auth/login-logs/` | 获取登录日志列表 | 管理员 |

## 2. 企业管理模块 (`/api/v1/enterprises/`)

### 2.1 企业信息接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/enterprises/` | 获取企业列表 | 需认证 |
| POST | `/enterprises/` | 创建企业 | 需认证 |
| GET | `/enterprises/{id}/` | 获取企业详情 | 需认证 |
| PUT | `/enterprises/{id}/` | 更新企业信息 | 企业用户 |
| DELETE | `/enterprises/{id}/` | 删除企业 | 管理员 |
| GET | `/enterprises/dashboard/` | 企业仪表板数据 | 企业用户 |
| GET | `/enterprises/statistics/` | 企业统计数据 | 企业用户 |

### 2.2 企业资质文件接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/enterprises/documents/` | 获取资质文件列表 | 企业用户 |
| POST | `/enterprises/documents/` | 上传资质文件 | 企业用户 |
| GET | `/enterprises/documents/{id}/` | 获取文件详情 | 企业用户 |
| PUT | `/enterprises/documents/{id}/` | 更新文件信息 | 企业用户 |
| DELETE | `/enterprises/documents/{id}/` | 删除文件 | 企业用户 |
| POST | `/enterprises/documents/{id}/verify/` | 验证资质文件 | 管理员 |

### 2.3 企业员工接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/enterprises/employees/` | 获取员工列表 | 企业用户 |
| POST | `/enterprises/employees/` | 添加员工 | 企业管理员 |
| GET | `/enterprises/employees/{id}/` | 获取员工详情 | 企业用户 |
| PUT | `/enterprises/employees/{id}/` | 更新员工信息 | 企业管理员 |
| DELETE | `/enterprises/employees/{id}/` | 删除员工 | 企业管理员 |

### 2.4 企业项目接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/enterprises/projects/` | 获取项目列表 | 企业用户 |
| POST | `/enterprises/projects/` | 创建项目 | 企业用户 |
| GET | `/enterprises/projects/{id}/` | 获取项目详情 | 企业用户 |
| PUT | `/enterprises/projects/{id}/` | 更新项目信息 | 企业用户 |
| DELETE | `/enterprises/projects/{id}/` | 删除项目 | 企业用户 |
| POST | `/enterprises/projects/{id}/progress/` | 更新项目进度 | 企业用户 |

## 3. 个人用户模块 (`/api/v1/persons/`)

### 3.1 个人信息接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/persons/` | 获取个人用户列表 | 需认证 |
| POST | `/persons/` | 创建个人用户 | 需认证 |
| GET | `/persons/{id}/` | 获取个人用户详情 | 需认证 |
| PUT | `/persons/{id}/` | 更新个人信息 | 个人用户 |
| DELETE | `/persons/{id}/` | 删除个人用户 | 管理员 |
| GET | `/persons/dashboard/` | 个人仪表板数据 | 个人用户 |
| GET | `/persons/statistics/` | 个人统计数据 | 个人用户 |

### 3.2 个人项目接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/persons/projects/` | 获取项目列表 | 个人用户 |
| POST | `/persons/projects/` | 创建项目 | 个人用户 |
| GET | `/persons/projects/{id}/` | 获取项目详情 | 个人用户 |
| PUT | `/persons/projects/{id}/` | 更新项目信息 | 个人用户 |
| DELETE | `/persons/projects/{id}/` | 删除项目 | 个人用户 |
| POST | `/persons/projects/{id}/progress/` | 更新项目进度 | 个人用户 |

### 3.3 个人任务接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/persons/tasks/` | 获取任务列表 | 个人用户 |
| POST | `/persons/tasks/` | 创建任务 | 个人用户 |
| GET | `/persons/tasks/{id}/` | 获取任务详情 | 个人用户 |
| PUT | `/persons/tasks/{id}/` | 更新任务信息 | 个人用户 |
| DELETE | `/persons/tasks/{id}/` | 删除任务 | 个人用户 |
| POST | `/persons/tasks/{id}/complete/` | 完成任务 | 个人用户 |

### 3.4 个人资质文件接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/persons/documents/` | 获取资质文件列表 | 个人用户 |
| POST | `/persons/documents/` | 上传资质文件 | 个人用户 |
| GET | `/persons/documents/{id}/` | 获取文件详情 | 个人用户 |
| PUT | `/persons/documents/{id}/` | 更新文件信息 | 个人用户 |
| DELETE | `/persons/documents/{id}/` | 删除文件 | 个人用户 |

## 4. 信息广场模块 (`/api/v1/info-plaza/`)

### 4.1 信息分类接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/info-plaza/categories/` | 获取分类列表 | 需认证 |
| POST | `/info-plaza/categories/` | 创建分类 | 管理员 |
| GET | `/info-plaza/categories/{id}/` | 获取分类详情 | 需认证 |
| PUT | `/info-plaza/categories/{id}/` | 更新分类 | 管理员 |
| DELETE | `/info-plaza/categories/{id}/` | 删除分类 | 管理员 |

### 4.2 信息标签接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/info-plaza/tags/` | 获取标签列表 | 需认证 |
| POST | `/info-plaza/tags/` | 创建标签 | 需认证 |

### 4.3 信息发布接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/info-plaza/posts/` | 获取信息列表 | 需认证 |
| POST | `/info-plaza/posts/` | 发布信息 | 需认证 |
| GET | `/info-plaza/posts/{id}/` | 获取信息详情 | 需认证 |
| PUT | `/info-plaza/posts/{id}/` | 更新信息 | 作者 |
| DELETE | `/info-plaza/posts/{id}/` | 删除信息 | 作者/管理员 |
| POST | `/info-plaza/posts/{id}/publish/` | 发布信息 | 作者 |
| POST | `/info-plaza/posts/{id}/like/` | 点赞/取消点赞 | 需认证 |
| POST | `/info-plaza/posts/{id}/favorite/` | 收藏/取消收藏 | 需认证 |

### 4.4 信息评论接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/info-plaza/comments/` | 获取评论列表 | 需认证 |
| POST | `/info-plaza/comments/` | 发表评论 | 需认证 |
| GET | `/info-plaza/comments/{id}/` | 获取评论详情 | 需认证 |
| PUT | `/info-plaza/comments/{id}/` | 更新评论 | 作者 |
| DELETE | `/info-plaza/comments/{id}/` | 删除评论 | 作者/管理员 |

### 4.5 个人相关接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/info-plaza/my-posts/` | 我的发布 | 需认证 |
| GET | `/info-plaza/my-favorites/` | 我的收藏 | 需认证 |

### 4.6 推荐和搜索接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/info-plaza/hot-posts/` | 热门信息 | 需认证 |
| GET | `/info-plaza/recommended-posts/` | 推荐信息 | 需认证 |
| GET | `/info-plaza/search/` | 搜索信息 | 需认证 |

## 5. 资源管理模块 (`/api/v1/resources/`)

### 5.1 资源类型接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/resources/types/` | 获取资源类型列表 | 需认证 |
| POST | `/resources/types/` | 创建资源类型 | 管理员 |
| GET | `/resources/types/{id}/` | 获取类型详情 | 需认证 |
| PUT | `/resources/types/{id}/` | 更新类型 | 管理员 |
| DELETE | `/resources/types/{id}/` | 删除类型 | 管理员 |

### 5.2 资源管理接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/resources/` | 获取资源列表 | 需认证 |
| POST | `/resources/` | 创建资源 | 需认证 |
| GET | `/resources/{id}/` | 获取资源详情 | 需认证 |
| PUT | `/resources/{id}/` | 更新资源信息 | 所有者 |
| DELETE | `/resources/{id}/` | 删除资源 | 所有者/管理员 |
| GET | `/resources/my-resources/` | 我的资源 | 需认证 |
| GET | `/resources/available/` | 可用资源 | 需认证 |
| GET | `/resources/rental/` | 可租赁资源 | 需认证 |
| GET | `/resources/search/` | 搜索资源 | 需认证 |

### 5.3 资源使用日志接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/resources/usage-logs/` | 获取使用日志列表 | 需认证 |
| POST | `/resources/usage-logs/` | 创建使用日志 | 需认证 |

### 5.4 资源维护记录接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/resources/maintenances/` | 获取维护记录列表 | 需认证 |
| POST | `/resources/maintenances/` | 创建维护记录 | 需认证 |

### 5.5 资源申请接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/resources/requests/` | 获取申请列表 | 需认证 |
| POST | `/resources/requests/` | 创建申请 | 需认证 |
| GET | `/resources/requests/{id}/` | 获取申请详情 | 需认证 |
| PUT | `/resources/requests/{id}/` | 更新申请 | 申请人 |
| DELETE | `/resources/requests/{id}/` | 删除申请 | 申请人 |
| POST | `/resources/requests/{id}/approve/` | 审批申请 | 管理员 |
| GET | `/resources/my-requests/` | 我的申请 | 需认证 |

### 5.6 资源统计接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/resources/statistics/` | 资源统计数据 | 需认证 |

## 6. 系统管理模块 (`/api/v1/system/`)

### 6.1 系统配置接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/system/configs/` | 获取配置列表 | 管理员 |
| POST | `/system/configs/` | 创建配置 | 管理员 |
| GET | `/system/configs/{id}/` | 获取配置详情 | 管理员 |
| PUT | `/system/configs/{id}/` | 更新配置 | 管理员 |
| DELETE | `/system/configs/{id}/` | 删除配置 | 管理员 |

### 6.2 系统日志接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/system/logs/` | 获取日志列表 | 管理员 |
| GET | `/system/logs/summary/` | 日志摘要 | 管理员 |

### 6.3 系统统计接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/system/statistics/` | 获取统计列表 | 管理员 |
| GET | `/system/statistics/dashboard/` | 仪表板统计 | 需认证 |
| GET | `/system/statistics/users/` | 用户统计 | 管理员 |
| GET | `/system/statistics/content/` | 内容统计 | 管理员 |

### 6.4 系统通知接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/system/notifications/` | 获取通知列表 | 需认证 |
| POST | `/system/notifications/` | 创建通知 | 管理员 |
| GET | `/system/notifications/{id}/` | 获取通知详情 | 需认证 |
| PUT | `/system/notifications/{id}/` | 更新通知 | 管理员 |
| DELETE | `/system/notifications/{id}/` | 删除通知 | 管理员 |

### 6.5 系统备份接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/system/backups/` | 获取备份列表 | 管理员 |
| POST | `/system/backups/` | 创建备份 | 管理员 |
| GET | `/system/backups/{id}/` | 获取备份详情 | 管理员 |
| PUT | `/system/backups/{id}/` | 更新备份 | 管理员 |
| DELETE | `/system/backups/{id}/` | 删除备份 | 管理员 |
| POST | `/system/backups/create/` | 创建系统备份 | 管理员 |

### 6.6 系统监控接口
| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | `/system/monitors/` | 获取监控列表 | 管理员 |
| GET | `/system/health/` | 系统健康状态 | 管理员 |

## 数据模型说明

### 用户模型 (User)
```json
{
  "id": 1,
  "username": "admin",
  "email": "admin@example.com",
  "first_name": "系统",
  "last_name": "管理员",
  "user_type": "personal",
  "phone": "13800138000",
  "avatar": "/media/avatars/avatar.jpg",
  "is_verified": true,
  "is_active": true,
  "date_joined": "2024-01-01T00:00:00Z",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

### 企业模型 (Enterprise)
```json
{
  "id": 1,
  "name": "示例企业",
  "enterprise_type": "manufacturer",
  "unified_social_credit_code": "123456789012345678",
  "legal_representative": "张三",
  "status": "approved",
  "contact_person": "李四",
  "contact_phone": "13800138001",
  "contact_email": "contact@example.com"
}
```

### 信息发布模型 (InfoPost)
```json
{
  "id": 1,
  "title": "示例信息",
  "content": "信息内容",
  "post_type": "supply",
  "status": "published",
  "view_count": 100,
  "like_count": 10,
  "comment_count": 5,
  "published_at": "2024-01-01T00:00:00Z"
}
```

### 资源模型 (Resource)
```json
{
  "id": 1,
  "name": "示例资源",
  "resource_type": 1,
  "status": "available",
  "quantity": 10,
  "unit_price": 1000.00,
  "is_available_for_rent": true,
  "rental_price": 100.00
}
```

## 查询参数说明

### 分页参数
- `page`: 页码（默认为1）
- `page_size`: 每页数量（默认为10）

### 排序参数
- `ordering`: 排序字段（如 `-created_at` 表示按创建时间倒序）

### 搜索参数
- `search`: 搜索关键词

### 过滤参数
各接口支持的过滤参数请参考具体接口说明。

## 响应格式

### 成功响应
```json
{
  "data": {},
  "message": "操作成功"
}
```

### 错误响应
```json
{
  "error": "错误信息",
  "detail": "详细错误描述"
}
```

### 分页响应
```json
{
  "count": 100,
  "next": "http://api.example.com/api/v1/resource/?page=2",
  "previous": null,
  "results": []
}
```

## 状态码说明

| 状态码 | 说明 |
|--------|------|
| 200 | 请求成功 |
| 201 | 创建成功 |
| 204 | 删除成功 |
| 400 | 请求参数错误 |
| 401 | 未授权，需要登录 |
| 403 | 禁止访问，没有权限 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

## 更新日志

### 2024-10-16
- 完善了所有模块的API接口文档
- 添加了详细的数据模型说明
- 补充了查询参数和响应格式说明

