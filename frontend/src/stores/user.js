import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'
import api from '@/api'

export const useUserStore = defineStore('user', () => {
  const user = ref(null)
  const token = ref(localStorage.getItem('token') || '')
  const refreshToken = ref(localStorage.getItem('refreshToken') || '')
  const permissions = ref([])
  const menus = ref([])

  // 计算属性
  const isAuthenticated = computed(() => {
    // 如果有测试token，认为已认证
    if (token.value && token.value.startsWith('mock-')) {
      return true
    }
    // 否则需要同时有token和user
    return !!token.value && !!user.value
  })
  const isEnterprise = computed(() => user.value?.user_type === 'enterprise')
  const isPersonal = computed(() => user.value?.user_type === 'personal')
  const isAdmin = computed(() => user.value?.is_staff)

  // 初始化用户信息
  const initUser = async () => {
    if (token.value) {
      try {
        // 检查是否是测试token
        if (token.value.startsWith('mock-')) {
          console.log('使用测试模式，跳过API调用')
          return
        }
        
        // 获取用户信息
        await getUserProfile()
        
        // 尝试获取用户菜单
        try {
          await getUserMenus()
        } catch (error) {
          console.log('获取用户菜单失败，将使用默认菜单')
        }
        
        // 【重要】始终根据用户类型强制设置正确的菜单
        if (user.value) {
          console.log(`页面初始化，用户类型: ${user.value.user_type}，强制设置对应菜单`)
          if (user.value.is_staff || user.value.is_superuser) {
            console.log('→ 设置管理员菜单')
            setDefaultAdminMenus()
          } else if (user.value.user_type === 'enterprise') {
            console.log('→ 设置企业用户菜单')
            setDefaultEnterpriseMenus()
          } else {
            console.log('→ 设置个人用户菜单')
            setDefaultPersonalMenus()
          }
        }
      } catch (error) {
        console.error('初始化用户信息失败:', error)
        // 如果是测试环境，不清除token
        if (!token.value.startsWith('mock-')) {
          logout()
        }
      }
    }
  }

  // 登录
  const login = async (credentials) => {
    try {
      const response = await api.post('/auth/login/', credentials)
      const { access, refresh, user: userData } = response.data
      
      token.value = access
      refreshToken.value = refresh
      user.value = userData
      
      // 保存到本地存储
      localStorage.setItem('token', access)
      localStorage.setItem('refreshToken', refresh)
      
      // 尝试获取用户菜单（但不依赖它）
      try {
        await getUserMenus()
      } catch (error) {
        console.log('获取用户菜单失败，将使用默认菜单')
      }
      
      // 【重要】始终根据用户类型强制设置正确的菜单，确保菜单显示正确
      console.log(`登录成功，用户类型: ${userData.user_type}，强制设置对应菜单`)
      if (userData.is_staff || userData.is_superuser) {
        console.log('→ 设置管理员菜单')
        setDefaultAdminMenus()
      } else if (userData.user_type === 'enterprise') {
        console.log('→ 设置企业用户菜单')
        setDefaultEnterpriseMenus()
      } else {
        console.log('→ 设置个人用户菜单')
        setDefaultPersonalMenus()
      }
      
      ElMessage.success('登录成功')
      return { success: true, user: userData }
    } catch (error) {
      // 处理验证错误
      if (error.response?.data) {
        const errorData = error.response.data
        
        // 如果有字段级别的错误
        if (typeof errorData === 'object' && !errorData.detail && !errorData.message) {
          const errors = []
          for (const [field, messages] of Object.entries(errorData)) {
            if (Array.isArray(messages)) {
              errors.push(...messages)
            } else {
              errors.push(messages)
            }
          }
          const message = errors.join('; ')
          ElMessage.error(message || '登录失败，请检查输入')
          return { success: false, error: message }
        }
        
        // 如果有通用错误消息
        const message = errorData.detail || errorData.message || '登录失败'
        ElMessage.error(message)
        return { success: false, error: message }
      }
      
      ElMessage.error('登录失败，请稍后重试')
      return { success: false, error: '登录失败' }
    }
  }

  // 注册
  const register = async (userData) => {
    try {
      const response = await api.post('/auth/register/', userData)
      ElMessage.success('注册成功，请登录')
      return { success: true, data: response.data }
    } catch (error) {
      // 处理验证错误
      if (error.response?.data) {
        const errorData = error.response.data
        
        // 如果有字段级别的错误
        if (typeof errorData === 'object' && !errorData.detail && !errorData.message) {
          const errors = []
          for (const [field, messages] of Object.entries(errorData)) {
            if (Array.isArray(messages)) {
              errors.push(...messages)
            } else {
              errors.push(messages)
            }
          }
          const message = errors.join('; ')
          ElMessage.error(message || '注册失败，请检查输入')
          return { success: false, error: message }
        }
        
        // 如果有通用错误消息
        const message = errorData.detail || errorData.message || '注册失败'
        ElMessage.error(message)
        return { success: false, error: message }
      }
      
      ElMessage.error('注册失败，请稍后重试')
      return { success: false, error: '注册失败' }
    }
  }

  // 登出
  const logout = async () => {
    try {
      if (refreshToken.value) {
        await api.post('/auth/logout/', { refresh: refreshToken.value })
      }
    } catch (error) {
      console.error('登出请求失败:', error)
    } finally {
      // 清除本地数据
      token.value = ''
      refreshToken.value = ''
      user.value = null
      permissions.value = []
      menus.value = []
      
      localStorage.removeItem('token')
      localStorage.removeItem('refreshToken')
      
      ElMessage.success('已退出登录')
    }
  }

  // 获取用户信息
  const getUserProfile = async () => {
    try {
      const response = await api.get('/auth/profile/')
      user.value = response.data
      return response.data
    } catch (error) {
      console.error('获取用户信息失败:', error)
      throw error
    }
  }

  // 更新用户信息
  const updateProfile = async (data) => {
    try {
      const response = await api.put('/auth/profile/update/', data)
      user.value = response.data
      ElMessage.success('更新成功')
      return response.data
    } catch (error) {
      const message = error.response?.data?.detail || '更新失败'
      ElMessage.error(message)
      throw error
    }
  }

  // 修改密码
  const changePassword = async (data) => {
    try {
      await api.post('/auth/change-password/', data)
      ElMessage.success('密码修改成功')
      return { success: true }
    } catch (error) {
      const message = error.response?.data?.detail || '密码修改失败'
      ElMessage.error(message)
      return { success: false, error: message }
    }
  }

  // 获取用户菜单
  const getUserMenus = async () => {
    try {
      const response = await api.get('/auth/user-menus/')
      menus.value = response.data
      return response.data
    } catch (error) {
      console.error('获取用户菜单失败:', error)
      // API调用失败时，根据用户类型设置默认菜单
      if (user.value) {
        if (user.value.is_staff || user.value.is_superuser) {
          console.log('设置管理员默认菜单')
          setDefaultAdminMenus()
        } else if (user.value.user_type === 'enterprise') {
          console.log('设置企业用户默认菜单')
          setDefaultEnterpriseMenus()
        } else {
          console.log('设置个人用户默认菜单')
          setDefaultPersonalMenus()
        }
      }
      return []
    }
  }

  // 获取可选择的角色列表
  const getAvailableRoles = async (userType = 'personal') => {
    try {
      const response = await api.get('/auth/available-roles/', {
        params: { user_type: userType }
      })
      return response.data
    } catch (error) {
      console.error('获取角色列表失败:', error)
      return []
    }
  }

  // 刷新token
  const refreshAccessToken = async () => {
    try {
      const response = await api.post('/auth/token/refresh/', {
        refresh: refreshToken.value
      })
      const { access } = response.data
      token.value = access
      localStorage.setItem('token', access)
      return access
    } catch (error) {
      console.error('刷新token失败:', error)
      logout()
      throw error
    }
  }

  // 检查权限
  const hasPermission = (permission) => {
    if (isAdmin.value) return true
    return permissions.value.includes(permission)
  }

  // 检查菜单权限
  const hasMenu = (menuCode) => {
    if (isAdmin.value) return true
    return menus.value.some(menu => menu.code === menuCode)
  }

  // 设置用户信息（用于测试）
  const setUser = (userData) => {
    user.value = userData
    // 根据用户类型设置默认菜单
    if (userData.role === 'super_admin' || userData.user_type === 'admin' || userData.is_superuser) {
      setDefaultAdminMenus()
    } else if (userData.user_type === 'enterprise') {
      setDefaultEnterpriseMenus()
    } else {
      setDefaultPersonalMenus()
    }
  }

  // 设置token（用于测试）
  const setToken = (tokenValue) => {
    token.value = tokenValue
    localStorage.setItem('token', tokenValue)
  }

  // 设置默认管理员菜单
  const setDefaultAdminMenus = () => {
    menus.value = [
      {
        id: 1,
        name: '仪表板',
        code: 'dashboard',
        url: '/dashboard',
        icon: 'House',
        children: []
      },
      {
        id: 2,
        name: '企业中心',
        code: 'enterprise',
        url: '/dashboard/enterprise',
        icon: 'OfficeBuilding',
        children: [
          {
            id: 21,
            name: '项目管理',
            code: 'enterprise-projects',
            url: '/dashboard/enterprise/projects',
            icon: 'FolderOpened'
          },
          {
            id: 22,
            name: '员工管理',
            code: 'enterprise-employees',
            url: '/dashboard/enterprise/employees',
            icon: 'User'
          }
        ]
      },
      {
        id: 3,
        name: '个人中心',
        code: 'personal',
        url: '/dashboard/personal',
        icon: 'UserFilled',
        children: [
          {
            id: 31,
            name: '我的项目',
            code: 'personal-projects',
            url: '/dashboard/personal/projects',
            icon: 'FolderOpened'
          },
          {
            id: 32,
            name: '我的任务',
            code: 'personal-tasks',
            url: '/dashboard/personal/tasks',
            icon: 'List'
          }
        ]
      },
      {
        id: 4,
        name: '信息广场',
        code: 'info-plaza',
        url: '/dashboard/info-plaza',
        icon: 'Message',
        children: [
          {
            id: 41,
            name: '发布信息',
            code: 'info-publish',
            url: '/dashboard/info-plaza/publish',
            icon: 'Edit'
          }
        ]
      },
      {
        id: 5,
        name: '资源管理',
        code: 'resources',
        url: '/dashboard/resources',
        icon: 'Folder',
        children: [
          {
            id: 51,
            name: '添加资源',
            code: 'resource-add',
            url: '/dashboard/resources/add',
            icon: 'Plus'
          }
        ]
      },
      {
        id: 6,
        name: '系统管理',
        code: 'system',
        url: '/dashboard/system',
        icon: 'Setting',
        children: [
          {
            id: 61,
            name: '用户管理',
            code: 'system-users',
            url: '/dashboard/system/users',
            icon: 'User'
          },
          {
            id: 62,
            name: '角色管理',
            code: 'system-roles',
            url: '/dashboard/system/roles',
            icon: 'UserFilled'
          },
          {
            id: 63,
            name: '系统日志',
            code: 'system-logs',
            url: '/dashboard/system/logs',
            icon: 'Document'
          }
        ]
      }
    ]
  }

  // 设置默认企业用户菜单
  const setDefaultEnterpriseMenus = () => {
    menus.value = [
      {
        id: 1,
        name: '仪表板',
        code: 'dashboard',
        url: '/dashboard',
        icon: 'House',
        children: []
      },
      {
        id: 2,
        name: '企业管理',  // 修改为"企业管理"
        code: 'enterprise',
        url: '/dashboard/enterprise',
        icon: 'OfficeBuilding',
        children: [
          {
            id: 21,
            name: '企业信息',  // 添加企业信息子菜单
            code: 'enterprise-info',
            url: '/dashboard/enterprise',
            icon: 'OfficeBuilding'
          },
          {
            id: 22,
            name: '项目管理',
            code: 'enterprise-projects',
            url: '/dashboard/enterprise/projects',
            icon: 'FolderOpened'
          },
          {
            id: 23,
            name: '员工管理',
            code: 'enterprise-employees',
            url: '/dashboard/enterprise/employees',
            icon: 'User'
          }
        ]
      },
      {
        id: 3,
        name: '信息广场',
        code: 'info-plaza',
        url: '/dashboard/info-plaza',
        icon: 'Message',
        children: [
          {
            id: 31,
            name: '发布信息',
            code: 'info-publish',
            url: '/dashboard/info-plaza/publish',
            icon: 'Edit'
          }
        ]
      },
      {
        id: 4,
        name: '资源管理',
        code: 'resources',
        url: '/dashboard/resources',
        icon: 'Folder',
        children: [
          {
            id: 41,
            name: '添加资源',
            code: 'resource-add',
            url: '/dashboard/resources/add',
            icon: 'Plus'
          }
        ]
      }
    ]
  }

  // 设置默认个人用户菜单
  const setDefaultPersonalMenus = () => {
    menus.value = [
      {
        id: 1,
        name: '仪表板',
        code: 'dashboard',
        url: '/dashboard',
        icon: 'House',
        children: []
      },
      {
        id: 2,
        name: '个人中心',
        code: 'personal',
        url: '/dashboard/personal',
        icon: 'UserFilled',
        children: [
          {
            id: 21,
            name: '我的项目',
            code: 'personal-projects',
            url: '/dashboard/personal/projects',
            icon: 'FolderOpened'
          },
          {
            id: 22,
            name: '我的任务',
            code: 'personal-tasks',
            url: '/dashboard/personal/tasks',
            icon: 'List'
          }
        ]
      },
      {
        id: 3,
        name: '信息广场',
        code: 'info-plaza',
        url: '/dashboard/info-plaza',
        icon: 'Message',
        children: []
      },
      {
        id: 4,
        name: '资源管理',
        code: 'resources',
        url: '/dashboard/resources',
        icon: 'Folder',
        children: []
      }
    ]
  }

  return {
    // 状态
    user,
    token,
    refreshToken,
    permissions,
    menus,
    
    // 计算属性
    isAuthenticated,
    isEnterprise,
    isPersonal,
    isAdmin,
    
    // 方法
    initUser,
    login,
    register,
    logout,
    getUserProfile,
    updateProfile,
    changePassword,
    getUserMenus,
    getAvailableRoles,
    refreshAccessToken,
    hasPermission,
    hasMenu,
    setUser,
    setToken,
    setDefaultAdminMenus,
    setDefaultEnterpriseMenus,
    setDefaultPersonalMenus
  }
})
