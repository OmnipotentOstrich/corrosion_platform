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
  
  // 如果有token但没有用户信息，先尝试初始化用户信息
  if (userStore.token && !userStore.user) {
    try {
      // 如果是测试token，跳过API调用
      if (userStore.token.startsWith('mock-')) {
        console.log('检测到测试token，跳过用户信息初始化')
      } else {
        await userStore.initUser()
      }
    } catch (error) {
      console.error('初始化用户信息失败:', error)
      // 如果初始化失败，清除无效token
      userStore.logout()
    }
  }
  
  // 如果用户已登录但没有菜单，设置默认菜单
  if (userStore.user && (!userStore.menus || userStore.menus.length === 0)) {
    console.log('路由守卫: 用户已登录但菜单为空，设置默认菜单')
    
    if (userStore.user.is_staff || userStore.user.is_superuser) {
      console.log('路由守卫: 设置管理员菜单')
      userStore.setDefaultAdminMenus()
    } else if (userStore.user.user_type === 'enterprise') {
      console.log('路由守卫: 设置企业用户菜单')
      userStore.setDefaultEnterpriseMenus()
    } else {
      console.log('路由守卫: 设置个人用户菜单')
      userStore.setDefaultPersonalMenus()
    }
  }
  
  // 检查是否需要认证（明确要求认证才检查）
  if (to.meta.requiresAuth === true) {
    // 需要认证的页面，检查是否已登录
    if (!userStore.isAuthenticated) {
      next('/login')
      return
    }
  } else if (to.meta.requiresAuth === false) {
    // 不需要认证的页面（登录、注册页）
    // 如果已登录，访问登录页面时重定向到仪表板
    if (userStore.isAuthenticated) {
      next('/dashboard')
      return
    }
  }
  // requiresAuth 未定义的页面（如根路径），直接放行
  
  next()
})

router.afterEach(() => {
  NProgress.done()
})

export default router
