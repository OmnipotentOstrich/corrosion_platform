<template>
  <div class="login-container">
    <!-- 背景装饰 -->
    <div class="bg-decoration">
      <div class="bg-circle circle-1"></div>
      <div class="bg-circle circle-2"></div>
      <div class="bg-circle circle-3"></div>
      <div class="bg-wave"></div>
    </div>
    
    <!-- 主要内容 -->
    <div class="login-content">
      <!-- 左侧信息区域 -->
      <div class="login-info">
        <div class="info-content">
          <div class="logo-section">
            <div class="logo-icon">
              <el-icon size="48"><Tools /></el-icon>
            </div>
            <h1>防腐保温智能数字平台</h1>
            <p class="subtitle">Corrosion Protection & Insulation Digital Platform</p>
          </div>
          
                 <div class="features">
                   <div class="feature-item">
                     <el-icon><Lock /></el-icon>
                     <span>安全可靠</span>
                   </div>
            <div class="feature-item">
              <el-icon><TrendCharts /></el-icon>
              <span>智能分析</span>
            </div>
            <div class="feature-item">
              <el-icon><Connection /></el-icon>
              <span>协同管理</span>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 右侧登录区域 -->
      <div class="login-box">
        <div class="login-header">
          <h2>欢迎登录</h2>
          <p>请输入您的账号信息</p>
        </div>
        
        <el-form
          ref="loginFormRef"
          :model="loginForm"
          :rules="loginRules"
          class="login-form"
          @submit.prevent="handleLogin"
        >
          <el-form-item prop="username">
            <el-input
              v-model="loginForm.username"
              placeholder="请输入用户名"
              size="large"
              prefix-icon="User"
            />
          </el-form-item>
          
          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              placeholder="请输入密码"
              size="large"
              prefix-icon="Lock"
              show-password
              @keyup.enter="handleLogin"
            />
          </el-form-item>
          
          <el-form-item>
            <el-button
              type="primary"
              size="large"
              :loading="loading"
              @click="handleLogin"
              class="login-btn"
            >
              登录
            </el-button>
          </el-form-item>
        </el-form>
        
        <!-- 测试用一键登录 -->
        <div class="test-login-section">
          <el-divider>
            <span class="divider-text">测试登录</span>
          </el-divider>
          <div class="test-buttons">
            <el-button
              type="success"
              size="large"
              :loading="adminLoading"
              @click="handleAdminLogin"
              class="test-login-btn"
              plain
            >
              <el-icon><UserFilled /></el-icon>
              系统管理员
            </el-button>
            <el-button
              type="primary"
              size="large"
              :loading="enterpriseLoading"
              @click="handleEnterpriseLogin"
              class="test-login-btn"
              plain
            >
              <el-icon><OfficeBuilding /></el-icon>
              企业用户
            </el-button>
            <el-button
              type="warning"
              size="large"
              :loading="personalLoading"
              @click="handlePersonalLogin"
              class="test-login-btn"
              plain
            >
              <el-icon><User /></el-icon>
              个人用户
            </el-button>
          </div>
          <p class="test-tip">仅用于开发测试，生产环境请移除</p>
          <div class="test-accounts">
            <p class="account-tip">测试账号：</p>
            <p class="account-info">管理员: admin / admin123</p>
            <p class="account-info">企业用户: enterprise / enterprise123</p>
            <p class="account-info">个人用户: user / user123</p>
          </div>
        </div>
        
        <div class="login-footer">
          <el-link type="primary" @click="$router.push('/register')">
            还没有账号？立即注册
          </el-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'
import { UserFilled, OfficeBuilding, User, Tools, Lock, TrendCharts, Connection } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()

// 表单引用
const loginFormRef = ref()

// 加载状态
const loading = ref(false)
const adminLoading = ref(false)
const enterpriseLoading = ref(false)
const personalLoading = ref(false)

// 登录表单数据
const loginForm = reactive({
  username: '',
  password: ''
})

// 表单验证规则
const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
  ]
}

// 处理登录
const handleLogin = async () => {
  if (!loginFormRef.value) return
  
  try {
    const valid = await loginFormRef.value.validate()
    if (!valid) return
    
    loading.value = true
    
    // 调用真实的后端登录API
    const result = await userStore.login({
      username: loginForm.username,
      password: loginForm.password
    })
    
    if (result.success) {
      // 根据用户类型跳转到不同页面
      if (result.user.user_type === 'enterprise') {
        router.push('/dashboard/enterprise')
      } else if (result.user.user_type === 'personal') {
        router.push('/dashboard/personal')
      } else {
        router.push('/dashboard')
      }
    }
  } catch (error) {
    console.error('登录失败:', error)
    // 错误消息已经在userStore中处理了
  } finally {
    loading.value = false
  }
}

// 处理管理员一键登录
const handleAdminLogin = async () => {
  try {
    adminLoading.value = true
    
    // 调用真实的后端登录API
    const result = await userStore.login({
      username: 'admin',
      password: 'admin123'
    })
    
    if (result.success) {
      ElMessage.success('管理员登录成功！')
      // 跳转到系统管理页面
      router.push('/dashboard/system')
    }
  } catch (error) {
    console.error('管理员登录失败:', error)
    ElMessage.error('管理员登录失败，请检查后端服务是否运行')
  } finally {
    adminLoading.value = false
  }
}

// 处理企业用户一键登录
const handleEnterpriseLogin = async () => {
  try {
    enterpriseLoading.value = true
    
    // 调用真实的后端登录API
    const result = await userStore.login({
      username: 'enterprise',
      password: 'enterprise123'
    })
    
    if (result.success) {
      ElMessage.success('企业用户登录成功！')
      // 跳转到企业中心
      router.push('/dashboard/enterprise')
    }
  } catch (error) {
    console.error('企业用户登录失败:', error)
    ElMessage.error('企业用户登录失败，请检查后端服务是否运行')
  } finally {
    enterpriseLoading.value = false
  }
}

// 处理个人用户一键登录
const handlePersonalLogin = async () => {
  try {
    personalLoading.value = true
    
    // 调用真实的后端登录API
    const result = await userStore.login({
      username: 'user',
      password: 'user123'
    })
    
    if (result.success) {
      ElMessage.success('个人用户登录成功！')
      // 跳转到个人中心
      router.push('/dashboard/personal')
    }
  } catch (error) {
    console.error('个人用户登录失败:', error)
    ElMessage.error('个人用户登录失败，请检查后端服务是否运行')
  } finally {
    personalLoading.value = false
  }
}
</script>

<style lang="scss" scoped>
.login-container {
  height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  
  // 背景装饰
  .bg-decoration {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    
    .bg-circle {
      position: absolute;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.1);
      animation: float 6s ease-in-out infinite;
      
      &.circle-1 {
        width: 200px;
        height: 200px;
        top: 10%;
        left: 10%;
        animation-delay: 0s;
      }
      
      &.circle-2 {
        width: 150px;
        height: 150px;
        top: 60%;
        right: 15%;
        animation-delay: 2s;
      }
      
      &.circle-3 {
        width: 100px;
        height: 100px;
        bottom: 20%;
        left: 20%;
        animation-delay: 4s;
      }
    }
    
    .bg-wave {
      position: absolute;
      bottom: 0;
      left: 0;
      width: 100%;
      height: 100px;
      background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1200 120'%3E%3Cpath d='M0,0V46.29c47.79,22.2,103.59,32.17,158,28,70.36-5.37,136.33-33.31,206.8-37.5C438.64,32.43,512.34,53.67,583,72.05c69.27,18,138.3,24.88,209.4,13.08,36.15-6,69.85-17.84,104.45-29.34C989.49,25,1113-14.29,1200,52.47V0Z' fill='rgba(255,255,255,0.1)'/%3E%3C/svg%3E") repeat-x;
      animation: wave 8s linear infinite;
    }
  }
  
  // 主要内容区域
  .login-content {
    display: flex;
    width: 100%;
    max-width: 1200px;
    min-height: 600px;
    max-height: 90vh;
    background: rgba(255, 255, 255, 0.95);
    border-radius: 20px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(10px);
    overflow: hidden;
    animation: slideUp 0.8s ease-out;
    
    // 左侧信息区域
    .login-info {
      flex: 1;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      padding: 40px 30px;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      
      &::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Cdefs%3E%3Cpattern id='grain' width='100' height='100' patternUnits='userSpaceOnUse'%3E%3Ccircle cx='50' cy='50' r='1' fill='rgba(255,255,255,0.1)'/%3E%3C/pattern%3E%3C/defs%3E%3Crect width='100' height='100' fill='url(%23grain)'/%3E%3C/svg%3E");
        opacity: 0.3;
      }
      
      .info-content {
        text-align: center;
        color: white;
        z-index: 1;
        position: relative;
        
        .logo-section {
          margin-bottom: 40px;
          
          .logo-icon {
            margin-bottom: 20px;
            animation: pulse 2s ease-in-out infinite;
          }
          
          h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
          }
          
          .subtitle {
            font-size: 16px;
            opacity: 0.9;
            font-weight: 300;
            letter-spacing: 1px;
          }
        }
        
        .features {
          display: flex;
          flex-direction: column;
          gap: 20px;
          
          .feature-item {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 15px 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
            
            &:hover {
              background: rgba(255, 255, 255, 0.2);
              transform: translateY(-2px);
            }
            
            .el-icon {
              font-size: 20px;
            }
            
            span {
              font-size: 16px;
              font-weight: 500;
            }
          }
        }
      }
    }
    
    // 右侧登录区域
    .login-box {
      flex: 1;
      padding: 40px 30px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      overflow-y: auto;
      
      .login-header {
        text-align: center;
        margin-bottom: 30px;
        
        h2 {
          color: #333;
          font-size: 28px;
          font-weight: 700;
          margin-bottom: 8px;
        }
        
        p {
          color: #666;
          font-size: 16px;
          font-weight: 400;
        }
      }
      
             .login-form {
               .el-form-item {
                 margin-bottom: 20px;
          
          :deep(.el-input) {
            .el-input__wrapper {
              border-radius: 12px;
              box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
              border: 2px solid transparent;
              transition: all 0.3s ease;
              
              &:hover {
                border-color: #667eea;
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
              }
              
              &.is-focus {
                border-color: #667eea;
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
              }
            }
            
            .el-input__inner {
              font-size: 16px;
              padding: 12px 16px;
            }
          }
        }
        
        .login-btn {
          width: 100%;
          height: 50px;
          font-size: 18px;
          font-weight: 600;
          border-radius: 12px;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          border: none;
          box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
          transition: all 0.3s ease;
          
          &:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
          }
          
          &:active {
            transform: translateY(0);
          }
        }
      }
      
             .test-login-section {
               margin-top: 20px;
        
        .divider-text {
          color: #999;
          font-size: 14px;
          font-weight: 500;
        }
        
        .test-buttons {
          display: flex;
          flex-direction: column;
          gap: 12px;
          margin-bottom: 15px;
          align-items: stretch;
        }
        
        .test-login-btn {
          width: 100%;
          height: 45px;
          font-size: 15px;
          font-weight: 500;
          border-radius: 10px;
          transition: all 0.3s ease;
          display: flex !important;
          align-items: center !important;
          justify-content: center !important;
          flex-direction: row !important;
          
          :deep(.el-button__content) {
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            width: 100%;
          }
          
          :deep(.el-icon) {
            margin-right: 8px;
            font-size: 16px;
            flex-shrink: 0;
          }
          
          &:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
          }
        }
        
        .test-tip {
          text-align: center;
          color: #999;
          font-size: 12px;
          margin: 0;
          font-style: italic;
          opacity: 0.8;
        }
        
        .test-accounts {
          margin-top: 10px;
          padding: 10px;
          background: rgba(0, 0, 0, 0.05);
          border-radius: 8px;
          text-align: center;
          
          .account-tip {
            font-size: 12px;
            color: #666;
            margin: 0 0 5px 0;
            font-weight: 500;
          }
          
          .account-info {
            font-size: 11px;
            color: #888;
            margin: 2px 0;
            font-family: monospace;
          }
        }
      }
      
             .login-footer {
               text-align: center;
               margin-top: 20px;
        
        .el-link {
          font-size: 15px;
          font-weight: 500;
        }
      }
    }
  }
}

// 动画定义
@keyframes float {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
  }
  50% {
    transform: translateY(-20px) rotate(180deg);
  }
}

@keyframes wave {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-1200px);
  }
}

@keyframes slideUp {
  0% {
    opacity: 0;
    transform: translateY(50px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
}

// 响应式设计
@media (max-width: 768px) {
  .login-container {
    padding: 15px;
    
    .login-content {
      flex-direction: column;
      min-height: auto;
      max-height: none;
      max-width: 400px;
      
      .login-info {
        padding: 30px 20px;
        
        .info-content {
          .logo-section {
            margin-bottom: 30px;
            
            h1 {
              font-size: 24px;
            }
            
            .subtitle {
              font-size: 14px;
            }
          }
          
          .features {
            flex-direction: row;
            flex-wrap: wrap;
            gap: 10px;
            
            .feature-item {
              flex: 1;
              min-width: 120px;
              padding: 10px;
              
              span {
                font-size: 14px;
              }
            }
          }
        }
      }
      
      .login-box {
        padding: 30px 20px;
        
        .login-header {
          margin-bottom: 25px;
          
          h2 {
            font-size: 24px;
          }
        }
        
        .login-form {
          .el-form-item {
            margin-bottom: 18px;
          }
        }
        
        .test-login-section {
          margin-top: 15px;
        }
        
        .login-footer {
          margin-top: 15px;
        }
      }
    }
  }
}

@media (max-width: 480px) {
  .login-container {
    padding: 10px;
    
    .login-content {
      max-width: 350px;
      
      .login-info {
        padding: 25px 15px;
        
        .info-content {
          .logo-section {
            margin-bottom: 25px;
            
            h1 {
              font-size: 20px;
            }
            
            .subtitle {
              font-size: 12px;
            }
          }
          
          .features {
            .feature-item {
              padding: 8px;
              
              span {
                font-size: 12px;
              }
            }
          }
        }
      }
      
      .login-box {
        padding: 25px 15px;
        
        .login-header {
          margin-bottom: 20px;
          
          h2 {
            font-size: 22px;
          }
          
          p {
            font-size: 14px;
          }
        }
        
        .login-form {
          .el-form-item {
            margin-bottom: 15px;
          }
        }
        
        .test-login-section {
          margin-top: 12px;
          
          .test-buttons {
            gap: 10px;
            align-items: stretch;
          }
          
          .test-login-btn {
            height: 40px;
            font-size: 14px;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            flex-direction: row !important;
            
            :deep(.el-button__content) {
              display: flex !important;
              align-items: center !important;
              justify-content: center !important;
              width: 100%;
            }
            
            :deep(.el-icon) {
              margin-right: 6px;
              font-size: 14px;
              flex-shrink: 0;
            }
          }
        }
        
        .login-footer {
          margin-top: 12px;
        }
      }
    }
  }
}
</style>