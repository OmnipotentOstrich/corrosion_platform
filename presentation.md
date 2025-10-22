---
marp: true
theme: default
paginate: true
header: '防腐保温智能数字平台'
footer: '© 2025'
---

<!-- _class: lead -->

# 防腐保温智能数字平台

## 面向企业与个人的综合性数字化平台

---

## 📋 项目简介

防腐保温智能数字平台是一个**综合性数字化解决方案**，旨在为企业与个人从业者提供：

- 🏢 **组织架构管理** - 完善的用户、角色、权限体系
- ⚙️ **系统配置分析** - 智能化配置与安全监控
- 👥 **信息管理** - 企业与个人信息一体化管理
- 📢 **资源共享** - 信息发布与资源管理平台
- 📊 **数据分析** - 全方位的业务数据统计与分析

---

## 🛠️ 技术栈

### 前端技术
- **Vue 3** - 渐进式JavaScript框架
- **Vite** - 新一代前端构建工具
- **Element Plus** - Vue 3组件库
- **ECharts** - 数据可视化图表库

### 后端技术
- **Django** - Python Web框架
- **Django REST Framework** - RESTful API框架
- **JWT** - 身份认证方案

### 基础设施
- **MySQL** - 关系型数据库
- **Docker + Nginx** - 容器化部署方案

---

## 🏗️ 项目架构

```
防腐保温智能数字平台/
├── backend/                  # Django后端
│   ├── apps/
│   │   ├── users/           # 用户管理
│   │   ├── enterprises/     # 企业用户
│   │   ├── persons/         # 个人用户
│   │   ├── info_plaza/      # 信息广场
│   │   ├── resources/       # 资源管理
│   │   └── system/          # 系统配置
│   └── config/              # 项目配置
│
├── frontend/                 # Vue3前端
│   └── src/
│       ├── components/       # 组件
│       ├── views/           # 页面
│       ├── api/             # API接口
│       └── router/          # 路由
│
└── docker-compose.yml        # Docker部署
```

---

## 🎯 核心功能模块（1/3）

### 1. 组织架构层 ✅
- **用户管理**
  - 用户资料扩展
  - 会话管理
  - 活动日志追踪
  
- **角色权限**
  - 权限组管理
  - 权限审计
  - 用户权限覆盖

- **菜单管理**
  - 菜单类型配置
  - 可见性控制
  - 细粒度权限

---

## 🎯 核心功能模块（2/3）

### 2. 系统配置层 ✅
- **系统配置** - 分类管理、加密支持
- **安全监控** - 安全事件监控、风险评估、安全审计
- **页面管理** - 页面配置、布局主题、自定义样式
- **数据分析** - 用户行为分析、性能监控、业务分析
- **系统维护** - 维护计划、备份管理、状态跟踪

### 3. 企业用户模块
- 企业信息管理
- 员工管理
- 项目管理
- 数据分析

---

## 🎯 核心功能模块（3/3）

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

---

## 🚀 v2.0 版本升级

### 新增数据库表（13个）
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

### 新增API接口
**50+ RESTful API 接口**，覆盖所有核心功能模块

---

## 💻 快速开始

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

### Docker 部署
```bash
docker-compose up -d
```

---

## 🔧 维护工具

### 数据库维护脚本
```bash
# 修复迁移历史
python backend/fix_migrations.py

# 创建缺失的表
python backend/create_missing_tables.py
python backend/create_system_tables.py

# 运行功能测试
python test_enhanced_features.py
```

---

## 📊 平台优势

### 🎨 现代化界面
- 基于 Element Plus 的美观UI
- 响应式设计，适配多终端

### 🔒 安全可靠
- JWT 身份认证
- 权限细粒度控制
- 安全审计日志

### 📈 数据驱动
- ECharts 可视化
- 实时数据分析
- 性能监控

### 🚀 高性能
- Vite 极速构建
- Docker 容器化部署
- Nginx 高性能代理

---

## 🔮 未来展望

### 短期规划
- 🔄 完善企业用户模块
- 🔄 优化个人用户模块
- 🔄 增强信息广场交互功能

### 长期规划
- 📱 移动端应用开发
- 🤖 AI 智能推荐系统
- 🌐 多语言国际化支持
- 📊 高级数据分析与报表

---

<!-- _class: lead -->

## 感谢观看！

### 防腐保温智能数字平台

**联系我们**
GitHub: [项目地址]
Email: [联系邮箱]

---

