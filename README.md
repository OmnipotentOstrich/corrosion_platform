# 防腐保温智能数字平台

## 项目简介
防腐保温智能数字平台是一个面向企业与个人从业者的综合性数字化平台，集成组织架构管理、系统配置分析、企业与个人信息管理、资源共享与信息发布等功能。

## 技术栈
- **前端**: Vue3 + Vite + Element Plus + Axios + ECharts
- **后端**: Django + Django REST Framework + JWT
- **数据库**: MySQL
- **部署**: Docker + Nginx

## 项目结构
```
防腐保温智能数字平台/
├── backend/                 # Django后端
│   ├── config/             # 项目配置
│   ├── apps/               # 应用模块
│   │   ├── users/          # 用户管理
│   │   ├── enterprises/    # 企业用户
│   │   ├── persons/        # 个人用户
│   │   ├── info_plaza/     # 信息广场
│   │   ├── resources/      # 资源管理
│   │   └── system/         # 系统配置
│   ├── requirements.txt    # Python依赖
│   └── manage.py
├── frontend/               # Vue3前端
│   ├── src/
│   │   ├── components/     # 组件
│   │   ├── views/          # 页面
│   │   ├── api/            # API接口
│   │   ├── router/         # 路由
│   │   └── store/          # 状态管理
│   ├── package.json
│   └── vite.config.js
└── docker-compose.yml      # Docker部署配置
```

## 快速开始

### 后端启动
```bash
cd backend
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

### 前端启动
```bash
cd frontend
npm install
npm run dev
```

## 功能模块

### 1. 组织架构层（已完善 ✅）
- **用户管理**: 用户资料扩展、会话管理、活动日志
- **角色权限**: 权限组管理、权限审计、用户权限覆盖
- **菜单管理**: 菜单类型、可见性控制、细粒度权限

### 2. 系统配置层（已完善 ✅）
- **系统配置**: 配置分类管理、加密支持
- **安全监控**: 安全事件监控、风险评估、安全审计
- **页面管理**: 页面配置、布局主题、自定义样式
- **数据分析**: 用户行为分析、性能监控、业务分析
- **系统维护**: 维护计划、备份管理、状态跟踪

### 3. 企业用户模块
- 企业信息管理
- 员工管理
- 项目管理
- 数据分析

### 4. 个人用户模块
- 个人信息管理
- 项目跟踪
- 任务管理
- 数据统计

### 5. 信息广场模块
- 信息发布
- 浏览检索
- 互动机制（点赞、评论、收藏）

### 6. 资源管理模块
- 资源分类
- 信息录入
- 统计分析

## 🎯 v2.0 新增功能

### 数据库表（13个新增）
- ✅ `user_profiles` - 用户扩展资料
- ✅ `user_sessions` - 用户会话管理
- ✅ `user_activity_logs` - 用户活动日志
- ✅ `permission_groups` - 权限组管理
- ✅ `role_permission_audits` - 角色权限审计
- ✅ `user_permission_overrides` - 用户权限覆盖
- ✅ `system_security_logs` - 系统安全日志
- ✅ `system_page_configs` - 页面配置管理
- ✅ `system_analytics` - 数据分析记录
- ✅ `system_maintenance` - 系统维护计划

### API接口（50+ 新增）
详见 [组织架构层和系统配置层功能完善-最终报告.md](./组织架构层和系统配置层功能完善-最终报告.md)

## 📚 文档

- [功能完善总结](./组织架构层和系统配置层功能完善总结.md)
- [最终报告](./组织架构层和系统配置层功能完善-最终报告.md)
- [测试脚本](./test_enhanced_features.py)

## 🔧 维护脚本

```bash
# 修复迁移历史
python backend/fix_migrations.py

# 创建缺失的表
python backend/create_missing_tables.py
python backend/create_system_tables.py

# 运行功能测试
python test_enhanced_features.py
```
