import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'

// 配置NProgress
NProgress.configure({ showSpinner: false })

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { 
      title: '登录',
      requiresAuth: false 
    }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Register.vue'),
    meta: { 
      title: '注册',
      requiresAuth: false 
    }
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('@/layout/index.vue'),
    meta: { 
      title: '仪表板',
      requiresAuth: true 
    },
    children: [
      {
        path: '',
        name: 'DashboardHome',
        component: () => import('@/views/dashboard/Home.vue'),
        meta: { title: '首页' }
      },
      {
        path: 'profile',
        name: 'Profile',
        component: () => import('@/views/user/Profile.vue'),
        meta: { title: '个人资料' }
      },
      {
        path: 'enterprise',
        name: 'Enterprise',
        component: () => import('@/views/enterprise/index.vue'),
        meta: { title: '企业中心' }
      },
      {
        path: 'enterprise/projects',
        name: 'EnterpriseProjects',
        component: () => import('@/views/enterprise/Projects.vue'),
        meta: { title: '项目管理' }
      },
      {
        path: 'enterprise/employees',
        name: 'EnterpriseEmployees',
        component: () => import('@/views/enterprise/Employees.vue'),
        meta: { title: '员工管理' }
      },
      {
        path: 'personal',
        name: 'Personal',
        component: () => import('@/views/personal/index.vue'),
        meta: { title: '个人中心' }
      },
      {
        path: 'personal/projects',
        name: 'PersonalProjects',
        component: () => import('@/views/personal/Projects.vue'),
        meta: { title: '我的项目' }
      },
      {
        path: 'personal/tasks',
        name: 'PersonalTasks',
        component: () => import('@/views/personal/Tasks.vue'),
        meta: { title: '我的任务' }
      },
      {
        path: 'info-plaza',
        name: 'InfoPlaza',
        component: () => import('@/views/info-plaza/index.vue'),
        meta: { title: '信息广场' }
      },
      {
        path: 'info-plaza/publish',
        name: 'InfoPublish',
        component: () => import('@/views/info-plaza/Publish.vue'),
        meta: { title: '发布信息' }
      },
      {
        path: 'info-plaza/detail/:id',
        name: 'InfoDetail',
        component: () => import('@/views/info-plaza/Detail.vue'),
        meta: { title: '信息详情' }
      },
      {
        path: 'resources',
        name: 'Resources',
        component: () => import('@/views/resources/index.vue'),
        meta: { title: '资源管理' }
      },
      {
        path: 'resources/add',
        name: 'ResourceAdd',
        component: () => import('@/views/resources/Add.vue'),
        meta: { title: '添加资源' }
      },
      {
        path: 'resources/detail/:id',
        name: 'ResourceDetail',
        component: () => import('@/views/resources/Detail.vue'),
        meta: { title: '资源详情' }
      },
      {
        path: 'system',
        name: 'System',
        component: () => import('@/views/system/index.vue'),
        meta: { title: '系统管理' }
      },
      {
        path: 'system/users',
        name: 'SystemUsers',
        component: () => import('@/views/system/Users.vue'),
        meta: { title: '用户管理' }
      },
      {
        path: 'system/roles',
        name: 'SystemRoles',
        component: () => import('@/views/system/Roles.vue'),
        meta: { title: '角色管理' }
      },
      {
        path: 'system/logs',
        name: 'SystemLogs',
        component: () => import('@/views/system/Logs.vue'),
        meta: { title: '系统日志' }
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/NotFound.vue'),
    meta: { title: '页面不存在' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach(async (to, from, next) => {
  NProgress.start()
  
  const userStore = useUserStore()
  
  // 设置页面标题
  document.title = to.meta.title ? `${to.meta.title} - 防腐保温智能数字平台` : '防腐保温智能数字平台'
  
  // 如果有token但没有用户信息，先初始化用户信息
  if (userStore.token && !userStore.user) {
    try {
      await userStore.initUser()
    } catch (error) {
      console.error('初始化用户信息失败:', error)
    }
  }
  
  // 检查是否需要认证
  if (to.meta.requiresAuth !== false) {
    if (!userStore.isAuthenticated) {
      next('/login')
      return
    }
  } else {
    // 如果已登录，访问登录页面时重定向到仪表板
    if (userStore.isAuthenticated && (to.name === 'Login' || to.name === 'Register')) {
      next('/dashboard')
      return
    }
  }
  
  next()
})

router.afterEach(() => {
  NProgress.done()
})

export default router
