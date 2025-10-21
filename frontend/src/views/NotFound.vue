<template>
  <div class="not-found">
    <div class="not-found-content">
      <div class="error-code">404</div>
      <div class="error-message">页面不存在</div>
      <div class="error-description">
        抱歉，您访问的页面不存在或已被删除
      </div>
      <div class="error-actions">
        <el-button type="primary" @click="goHome">
          <el-icon><HomeFilled /></el-icon>
          返回首页
        </el-button>
        <el-button @click="goBack">
          <el-icon><ArrowLeft /></el-icon>
          返回上页
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const goHome = () => {
  router.push('/dashboard')
}

const goBack = () => {
  router.go(-1)
}
</script>

<style lang="scss" scoped>
.not-found {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
  
  .not-found-content {
    text-align: center;
    
    .error-code {
      font-size: 120px;
      font-weight: bold;
      color: #409eff;
      line-height: 1;
      margin-bottom: 20px;
    }
    
    .error-message {
      font-size: 32px;
      color: #333;
      margin-bottom: 15px;
    }
    
    .error-description {
      font-size: 16px;
      color: #666;
      margin-bottom: 30px;
    }
    
    .error-actions {
      .el-button {
        margin: 0 10px;
      }
    }
  }
}

@media (max-width: 768px) {
  .not-found {
    .not-found-content {
      .error-code {
        font-size: 80px;
      }
      
      .error-message {
        font-size: 24px;
      }
      
      .error-description {
        font-size: 14px;
      }
    }
  }
}
</style>
