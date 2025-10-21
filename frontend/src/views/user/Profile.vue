<template>
  <div class="profile-page">
    <div class="page-container">
      <div class="profile-header">
        <h2>个人资料</h2>
        <p>管理您的个人信息和账户设置</p>
      </div>

      <el-row :gutter="20">
        <!-- 左侧：基本信息 -->
        <el-col :span="8">
          <div class="card">
            <div class="profile-avatar">
              <el-avatar :size="100" :src="userStore.user?.avatar">
                {{ userStore.user?.username?.charAt(0) }}
              </el-avatar>
              <el-button type="primary" size="small" @click="changeAvatar">
                更换头像
              </el-button>
            </div>
            
            <div class="profile-info">
              <h3>{{ userStore.user?.username }}</h3>
              <p class="user-type">{{ getUserTypeText() }}</p>
              <p class="join-date">加入时间：{{ formatDate(userStore.user?.date_joined) }}</p>
            </div>
          </div>
        </el-col>

        <!-- 右侧：详细信息 -->
        <el-col :span="16">
          <el-tabs v-model="activeTab">
            <!-- 基本信息 -->
            <el-tab-pane label="基本信息" name="basic">
              <div class="card">
                <el-form
                  ref="profileFormRef"
                  :model="profileForm"
                  :rules="profileRules"
                  label-width="100px"
                >
                  <el-form-item label="用户名" prop="username">
                    <el-input v-model="profileForm.username" disabled />
                  </el-form-item>
                  
                  <el-form-item label="邮箱" prop="email">
                    <el-input v-model="profileForm.email" />
                  </el-form-item>
                  
                  <el-form-item label="手机号" prop="phone">
                    <el-input v-model="profileForm.phone" />
                  </el-form-item>
                  
                  <el-form-item label="姓名" prop="first_name">
                    <el-input v-model="profileForm.first_name" />
                  </el-form-item>
                  
                  <el-form-item>
                    <el-button type="primary" @click="updateProfile" :loading="loading">
                      保存修改
                    </el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-tab-pane>

            <!-- 修改密码 -->
            <el-tab-pane label="修改密码" name="password">
              <div class="card">
                <el-form
                  ref="passwordFormRef"
                  :model="passwordForm"
                  :rules="passwordRules"
                  label-width="100px"
                >
                  <el-form-item label="原密码" prop="old_password">
                    <el-input
                      v-model="passwordForm.old_password"
                      type="password"
                      show-password
                    />
                  </el-form-item>
                  
                  <el-form-item label="新密码" prop="new_password">
                    <el-input
                      v-model="passwordForm.new_password"
                      type="password"
                      show-password
                    />
                  </el-form-item>
                  
                  <el-form-item label="确认密码" prop="new_password_confirm">
                    <el-input
                      v-model="passwordForm.new_password_confirm"
                      type="password"
                      show-password
                    />
                  </el-form-item>
                  
                  <el-form-item>
                    <el-button type="primary" @click="changePassword" :loading="passwordLoading">
                      修改密码
                    </el-button>
                  </el-form-item>
                </el-form>
              </div>
            </el-tab-pane>

            <!-- 账户安全 -->
            <el-tab-pane label="账户安全" name="security">
              <div class="card">
                <div class="security-item">
                  <div class="security-info">
                    <h4>登录密码</h4>
                    <p>定期更换密码可以提高账户安全性</p>
                  </div>
                  <el-button type="primary" size="small" @click="activeTab = 'password'">
                    修改密码
                  </el-button>
                </div>
                
                <div class="security-item">
                  <div class="security-info">
                    <h4>手机验证</h4>
                    <p>绑定手机号：{{ userStore.user?.phone || '未绑定' }}</p>
                  </div>
                  <el-button type="primary" size="small">
                    {{ userStore.user?.phone ? '更换手机' : '绑定手机' }}
                  </el-button>
                </div>
                
                <div class="security-item">
                  <div class="security-info">
                    <h4>邮箱验证</h4>
                    <p>绑定邮箱：{{ userStore.user?.email || '未绑定' }}</p>
                  </div>
                  <el-button type="primary" size="small">
                    {{ userStore.user?.email ? '更换邮箱' : '绑定邮箱' }}
                  </el-button>
                </div>
              </div>
            </el-tab-pane>
          </el-tabs>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs'

const userStore = useUserStore()

// 表单引用
const profileFormRef = ref()
const passwordFormRef = ref()

// 加载状态
const loading = ref(false)
const passwordLoading = ref(false)

// 当前标签页
const activeTab = ref('basic')

// 个人信息表单
const profileForm = reactive({
  username: '',
  email: '',
  phone: '',
  first_name: '',
  last_name: ''
})

// 密码修改表单
const passwordForm = reactive({
  old_password: '',
  new_password: '',
  new_password_confirm: ''
})

// 表单验证规则
const profileRules = {
  email: [
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ]
}

const passwordRules = {
  old_password: [
    { required: true, message: '请输入原密码', trigger: 'blur' }
  ],
  new_password: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
  ],
  new_password_confirm: [
    { required: true, message: '请确认新密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== passwordForm.new_password) {
          callback(new Error('两次输入密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

// 获取用户类型文本
const getUserTypeText = () => {
  const types = {
    'enterprise': '企业用户',
    'personal': '个人用户'
  }
  return types[userStore.user?.user_type] || '未知'
}

// 格式化日期
const formatDate = (date) => {
  return date ? dayjs(date).format('YYYY-MM-DD') : ''
}

// 更新个人信息
const updateProfile = async () => {
  if (!profileFormRef.value) return
  
  try {
    const valid = await profileFormRef.value.validate()
    if (!valid) return
    
    loading.value = true
    
    await userStore.updateProfile(profileForm)
  } catch (error) {
    console.error('更新失败:', error)
  } finally {
    loading.value = false
  }
}

// 修改密码
const changePassword = async () => {
  if (!passwordFormRef.value) return
  
  try {
    const valid = await passwordFormRef.value.validate()
    if (!valid) return
    
    passwordLoading.value = true
    
    const result = await userStore.changePassword(passwordForm)
    
    if (result.success) {
      // 清空表单
      passwordForm.old_password = ''
      passwordForm.new_password = ''
      passwordForm.new_password_confirm = ''
      passwordFormRef.value.resetFields()
    }
  } catch (error) {
    console.error('修改密码失败:', error)
  } finally {
    passwordLoading.value = false
  }
}

// 更换头像
const changeAvatar = () => {
  ElMessage.info('头像上传功能开发中...')
}

// 初始化表单数据
const initFormData = () => {
  if (userStore.user) {
    profileForm.username = userStore.user.username || ''
    profileForm.email = userStore.user.email || ''
    profileForm.phone = userStore.user.phone || ''
    profileForm.first_name = userStore.user.first_name || ''
    profileForm.last_name = userStore.user.last_name || ''
  }
}

onMounted(() => {
  initFormData()
})
</script>

<style lang="scss" scoped>
.profile-page {
  .profile-header {
    margin-bottom: 20px;
    
    h2 {
      font-size: 24px;
      color: #333;
      margin-bottom: 5px;
    }
    
    p {
      color: #666;
      font-size: 14px;
    }
  }
  
  .profile-avatar {
    text-align: center;
    padding: 20px;
    
    .el-avatar {
      margin-bottom: 15px;
    }
  }
  
  .profile-info {
    text-align: center;
    padding: 0 20px 20px;
    
    h3 {
      font-size: 18px;
      color: #333;
      margin-bottom: 5px;
    }
    
    .user-type {
      color: #409eff;
      font-size: 14px;
      margin-bottom: 10px;
    }
    
    .join-date {
      color: #666;
      font-size: 12px;
    }
  }
  
  .security-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 0;
    border-bottom: 1px solid #f0f0f0;
    
    &:last-child {
      border-bottom: none;
    }
    
    .security-info {
      h4 {
        font-size: 16px;
        color: #333;
        margin-bottom: 5px;
      }
      
      p {
        color: #666;
        font-size: 14px;
      }
    }
  }
}

@media (max-width: 768px) {
  .profile-page {
    .el-col {
      margin-bottom: 20px;
    }
  }
}
</style>
