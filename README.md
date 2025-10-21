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
1. 组织架构模块 - 用户、角色、权限管理
2. 系统配置模块 - 系统参数、日志审计、数据分析
3. 企业用户模块 - 企业信息、员工管理、数据分析
4. 个人用户模块 - 个人信息、项目跟踪、数据统计
5. 信息广场模块 - 信息发布、浏览检索、互动机制
6. 资源管理模块 - 资源分类、信息录入、统计分析
