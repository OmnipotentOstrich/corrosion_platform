<template>
  <div class="info-publish">
    <div class="page-header">
      <h1>发布信息</h1>
      <p>分享您的技术经验、行业资讯或项目信息</p>
    </div>
    
    <div class="publish-form">
      <form @submit.prevent="publishInfo">
        <div class="form-group">
          <label for="title">标题 *</label>
          <input 
            type="text" 
            id="title" 
            v-model="form.title" 
            placeholder="请输入信息标题"
            required
          >
        </div>
        
        <div class="form-group">
          <label for="post_type">信息类型 *</label>
          <select id="post_type" v-model="form.post_type" required>
            <option value="">请选择信息类型</option>
            <option value="supply">供应信息</option>
            <option value="demand">需求信息</option>
            <option value="recruitment">招聘信息</option>
            <option value="tender">招标信息</option>
            <option value="technology">技术文章</option>
            <option value="news">行业资讯</option>
            <option value="other">其他</option>
          </select>
        </div>
        
        <div class="form-group">
          <label for="category">分类</label>
          <select id="category" v-model="form.category">
            <option value="">请选择分类（可选）</option>
            <option v-for="cat in categories" :key="cat.id" :value="cat.id">
              {{ cat.name }}
            </option>
          </select>
        </div>
        
        <div class="form-group">
          <label for="summary">摘要</label>
          <textarea 
            id="summary" 
            v-model="form.summary" 
            placeholder="请输入信息摘要"
            rows="3"
          ></textarea>
        </div>
        
        <div class="form-group">
          <label for="content">内容 *</label>
          <textarea 
            id="content" 
            v-model="form.content" 
            placeholder="请输入详细信息内容"
            rows="10"
            required
          ></textarea>
        </div>
        
        <div class="form-group">
          <label for="tags">标签</label>
          <input 
            type="text" 
            id="tags" 
            v-model="form.tags" 
            placeholder="请输入标签，用逗号分隔"
          >
        </div>
        
        <div class="form-actions">
          <button type="button" class="btn btn-outline" @click="resetForm" :disabled="publishing">
            重置
          </button>
          <button type="submit" class="btn btn-primary" :disabled="!isFormValid || publishing">
            {{ publishing ? '发布中...' : '发布信息' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import api from '@/api'
import { ElMessage, ElMessageBox } from 'element-plus'

export default {
  name: 'InfoPublish',
  data() {
    return {
      form: {
        title: '',
        post_type: '',
        category: '',
        summary: '',
        content: '',
        tags: ''
      },
      categories: [],
      tags: [],
      loading: false,
      publishing: false
    }
  },
  mounted() {
    this.loadCategories()
    this.loadTags()
  },
  computed: {
    isFormValid() {
      return this.form.title && this.form.post_type && this.form.content
    }
  },
  methods: {
    // 加载分类列表
    async loadCategories() {
      try {
        const response = await api.get('/info-plaza/categories/')
        this.categories = response.data.results || response.data || []
      } catch (error) {
        console.error('加载分类失败:', error)
      }
    },
    
    // 加载标签列表
    async loadTags() {
      try {
        const response = await api.get('/info-plaza/tags/')
        this.tags = response.data.results || response.data || []
      } catch (error) {
        console.error('加载标签失败:', error)
      }
    },
    
    // 发布信息
    async publishInfo() {
      if (!this.isFormValid) {
        ElMessage.warning('请填写必填字段')
        return
      }
      
      try {
        // 显示确认对话框
        await ElMessageBox.confirm('确定要发布此信息吗？', '确认发布', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'info'
        })
        
        this.publishing = true
        
        // 准备提交数据
        const postData = {
          title: this.form.title,
          post_type: this.form.post_type,
          content: this.form.content,
          summary: this.form.summary || '',
        }
        
        // 如果选择了分类，添加分类ID
        if (this.form.category) {
          postData.category = this.form.category
        }
        
        // 处理标签 - 保持为逗号分隔的字符串格式
        if (this.form.tags) {
          postData.tags = this.form.tags.trim()
        }
        
        // 调用后端API发布信息
        const response = await api.post('/info-plaza/posts/', postData)
        
        ElMessage.success('信息发布成功！')
        
        // 重置表单
        this.resetForm()
        
        // 延迟跳转到信息广场，让用户看到成功提示
        setTimeout(() => {
          this.$router.push('/dashboard/info-plaza')
        }, 1000)
        
      } catch (error) {
        if (error !== 'cancel') {
          console.error('发布信息失败:', error)
          
          // 处理错误消息
          let errorMsg = '发布失败，请稍后重试'
          if (error.response?.data) {
            const errorData = error.response.data
            if (typeof errorData === 'object') {
              // 提取第一个错误消息
              const firstError = Object.values(errorData)[0]
              if (Array.isArray(firstError)) {
                errorMsg = firstError[0]
              } else if (typeof firstError === 'string') {
                errorMsg = firstError
              }
            } else if (typeof errorData === 'string') {
              errorMsg = errorData
            }
          }
          
          ElMessage.error(errorMsg)
        }
      } finally {
        this.publishing = false
      }
    },
    
    // 重置表单
    resetForm() {
      this.form = {
        title: '',
        post_type: '',
        category: '',
        summary: '',
        content: '',
        tags: ''
      }
    }
  }
}
</script>

<style scoped>
.info-publish {
  padding: 20px;
}

.page-header {
  margin-bottom: 30px;
}

.page-header h1 {
  color: #333;
  margin-bottom: 10px;
}

.page-header p {
  color: #666;
  font-size: 16px;
}

.publish-form {
  background: white;
  border-radius: 8px;
  padding: 30px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 600;
  color: #333;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  font-family: inherit;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
}

.form-group textarea {
  resize: vertical;
  min-height: 100px;
}

.form-actions {
  display: flex;
  gap: 15px;
  justify-content: flex-end;
  margin-top: 30px;
}

.btn {
  padding: 10px 20px;
  border-radius: 4px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s;
}

.btn-primary {
  background-color: #007bff;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background-color: #0056b3;
}

.btn-primary:disabled {
  background-color: #6c757d;
  cursor: not-allowed;
}

.btn-outline {
  background-color: transparent;
  color: #007bff;
  border: 1px solid #007bff;
}

.btn-outline:hover {
  background-color: #007bff;
  color: white;
}
</style>

