<template>
  <div class="register-container">
    <!-- 背景装饰 -->
    <div class="bg-decoration">
      <div class="bg-circle circle-1"></div>
      <div class="bg-circle circle-2"></div>
      <div class="bg-circle circle-3"></div>
      <div class="bg-wave"></div>
    </div>
    
    <!-- 主要内容 -->
    <div class="register-content">
      <!-- 左侧信息区域 -->
      <div class="register-info">
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
      
      <!-- 右侧注册区域 -->
      <div class="register-box">
        <div class="register-header">
          <h2>用户注册</h2>
          <p>请填写您的注册信息</p>
        </div>
        
        <el-form
          ref="registerFormRef"
          :model="registerForm"
          :rules="registerRules"
          class="register-form"
          @submit.prevent="handleRegister"
        >
          <el-form-item prop="user_type">
            <el-radio-group v-model="registerForm.user_type" size="large">
              <el-radio-button label="personal">个人用户</el-radio-button>
              <el-radio-button label="enterprise">企业用户</el-radio-button>
            </el-radio-group>
          </el-form-item>
          
          <el-form-item prop="username">
            <el-input
              v-model="registerForm.username"
              placeholder="请输入用户名"
              size="large"
              prefix-icon="User"
            />
          </el-form-item>
          
          <el-form-item prop="first_name">
            <el-input
              v-model="registerForm.first_name"
              placeholder="请输入姓名"
              size="large"
              prefix-icon="User"
            />
          </el-form-item>
          
          <el-form-item prop="email">
            <el-input
              v-model="registerForm.email"
              placeholder="请输入邮箱"
              size="large"
              prefix-icon="Message"
            />
          </el-form-item>
          
          <el-form-item prop="phone">
            <el-input
              v-model="registerForm.phone"
              placeholder="请输入手机号"
              size="large"
              prefix-icon="Phone"
            />
          </el-form-item>
          
          <el-form-item prop="password">
            <el-input
              v-model="registerForm.password"
              type="password"
              placeholder="请输入密码"
              size="large"
              prefix-icon="Lock"
              show-password
            />
          </el-form-item>
          
          <el-form-item prop="password_confirm">
            <el-input
              v-model="registerForm.password_confirm"
              type="password"
              placeholder="请确认密码"
              size="large"
              prefix-icon="Lock"
              show-password
            />
          </el-form-item>
          
          <el-form-item>
            <el-button
              type="primary"
              size="large"
              :loading="loading"
              @click="handleRegister"
              class="register-btn"
            >
              注册
            </el-button>
          </el-form-item>
        </el-form>
        
        <div class="register-footer">
          <el-link type="primary" @click="$router.push('/login')">
            已有账号？立即登录
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
import { Tools, Lock, TrendCharts, Connection, User, Message, Phone } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()

// 表单引用
const registerFormRef = ref()

// 加载状态
const loading = ref(false)

// 注册表单数据
const registerForm = reactive({
  user_type: 'personal',
  username: '',
  email: '',
  phone: '',
  password: '',
  password_confirm: '',
  first_name: ''
})

// 表单验证规则
const registerRules = {
  user_type: [
    { required: true, message: '请选择用户类型', trigger: 'change' }
  ],
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在3到20个字符', trigger: 'blur' }
  ],
  first_name: [
    { required: true, message: '请输入姓名', trigger: 'blur' },
    { min: 2, max: 10, message: '姓名长度在2到10个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
  ],
  password_confirm: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== registerForm.password) {
          callback(new Error('两次输入密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

// 处理注册
const handleRegister = async () => {
  if (!registerFormRef.value) return
  
  try {
    const valid = await registerFormRef.value.validate()
    if (!valid) return
    
    loading.value = true
    
    // 调用真实的后端注册API
    const result = await userStore.register(registerForm)
    
    if (result.success) {
      // 清空表单
      registerForm.username = ''
      registerForm.first_name = ''
      registerForm.email = ''
      registerForm.phone = ''
      registerForm.password = ''
      registerForm.password_confirm = ''
      
      // 跳转到登录页面
      setTimeout(() => {
        router.push('/login')
      }, 1000)
    }
    
  } catch (error) {
    console.error('注册失败:', error)
    // 不在这里显示错误消息，因为userStore中已经处理了
  } finally {
    loading.value = false
  }
}
</script>

<style lang="scss" scoped>
.register-container {
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
  .register-content {
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
    .register-info {
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
    
    // 右侧注册区域
    .register-box {
      flex: 1;
      padding: 40px 30px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      overflow-y: auto;
      
      .register-header {
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
      
      .register-form {
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
          
          :deep(.el-radio-group) {
            width: 100%;
            
            .el-radio-button {
              flex: 1;
              
              .el-radio-button__inner {
                width: 100%;
                border-radius: 8px;
                border: 2px solid #e4e7ed;
                transition: all 0.3s ease;
                
                &:hover {
                  border-color: #667eea;
                }
              }
              
              &.is-active .el-radio-button__inner {
                background: #667eea;
                border-color: #667eea;
                color: white;
              }
            }
          }
        }
        
        .register-btn {
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
      
      .register-footer {
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
  .register-container {
    padding: 15px;
    
    .register-content {
      flex-direction: column;
      min-height: auto;
      max-height: none;
      max-width: 400px;
      
      .register-info {
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
      
      .register-box {
        padding: 30px 20px;
        
        .register-header {
          margin-bottom: 25px;
          
          h2 {
            font-size: 24px;
          }
        }
        
        .register-form {
          .el-form-item {
            margin-bottom: 18px;
          }
        }
        
        .register-footer {
          margin-top: 15px;
        }
      }
    }
  }
}

@media (max-width: 480px) {
  .register-container {
    padding: 10px;
    
    .register-content {
      max-width: 350px;
      
      .register-info {
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
      
      .register-box {
        padding: 25px 15px;
        
        .register-header {
          margin-bottom: 20px;
          
          h2 {
            font-size: 22px;
          }
          
          p {
            font-size: 14px;
          }
        }
        
        .register-form {
          .el-form-item {
            margin-bottom: 15px;
          }
        }
        
        .register-footer {
          margin-top: 12px;
        }
      }
    }
  }
}
</style>
