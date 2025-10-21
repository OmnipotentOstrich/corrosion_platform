import axios from 'axios'
import { ElMessage } from 'element-plus'

// 创建axios实例
const api = axios.create({
  baseURL: '/api/v1',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
api.interceptors.request.use(
  (config) => {
    // 从localStorage获取token，避免循环依赖
    const token = localStorage.getItem('token')
    
    // 添加token到请求头
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// 是否正在刷新token的标志
let isRefreshing = false
// 存储待重试的请求
let failedQueue = []

// 处理队列中的请求
const processQueue = (error, token = null) => {
  failedQueue.forEach(prom => {
    if (error) {
      prom.reject(error)
    } else {
      prom.resolve(token)
    }
  })
  failedQueue = []
}

// 响应拦截器
api.interceptors.response.use(
  (response) => {
    return response
  },
  async (error) => {
    const originalRequest = error.config
    
    // 检查是否是注册请求，如果是则不显示通用错误消息
    const isRegisterRequest = error.config?.url?.includes('/auth/register/')
    
    if (error.response) {
      const { status, data } = error.response
      
      switch (status) {
        case 401:
          // 如果是刷新token的请求失败，直接跳转登录
          if (originalRequest.url?.includes('/auth/token/refresh/')) {
            localStorage.removeItem('token')
            localStorage.removeItem('refreshToken')
            window.location.href = '/login'
            return Promise.reject(error)
          }
          
          // 如果已经重试过，跳转登录页
          if (originalRequest._retry) {
            localStorage.removeItem('token')
            localStorage.removeItem('refreshToken')
            window.location.href = '/login'
            return Promise.reject(error)
          }
          
          originalRequest._retry = true
          
          // 如果正在刷新token，将请求加入队列
          if (isRefreshing) {
            return new Promise((resolve, reject) => {
              failedQueue.push({ resolve, reject })
            }).then(token => {
              originalRequest.headers['Authorization'] = 'Bearer ' + token
              return api(originalRequest)
            }).catch(err => {
              return Promise.reject(err)
            })
          }
          
          isRefreshing = true
          
          // 尝试刷新token
          const refreshToken = localStorage.getItem('refreshToken')
          if (!refreshToken) {
            localStorage.removeItem('token')
            window.location.href = '/login'
            return Promise.reject(error)
          }
          
          try {
            const response = await api.post('/auth/token/refresh/', {
              refresh: refreshToken
            })
            const { access } = response.data
            localStorage.setItem('token', access)
            
            // 更新请求头
            originalRequest.headers['Authorization'] = 'Bearer ' + access
            
            // 处理队列中的请求
            processQueue(null, access)
            
            // 重试原请求
            return api(originalRequest)
          } catch (refreshError) {
            processQueue(refreshError, null)
            localStorage.removeItem('token')
            localStorage.removeItem('refreshToken')
            window.location.href = '/login'
            return Promise.reject(refreshError)
          } finally {
            isRefreshing = false
          }
          break
          
        case 403:
          if (!isRegisterRequest) {
            ElMessage.error('没有权限访问该资源')
          }
          break
          
        case 404:
          if (!isRegisterRequest) {
            ElMessage.error('请求的资源不存在')
          }
          break
          
        case 500:
          if (!isRegisterRequest) {
            ElMessage.error('服务器内部错误')
          }
          break
          
        default:
          // 对于注册请求，不显示通用错误消息
          if (!isRegisterRequest) {
            if (data?.detail) {
              ElMessage.error(data.detail)
            } else if (data?.message) {
              ElMessage.error(data.message)
            } else {
              ElMessage.error('请求失败')
            }
          }
      }
    } else if (error.request) {
      if (!isRegisterRequest) {
        ElMessage.error('网络连接失败，请检查网络设置')
      }
    } else {
      if (!isRegisterRequest) {
        ElMessage.error('请求配置错误')
      }
    }
    
    return Promise.reject(error)
  }
)

export default api