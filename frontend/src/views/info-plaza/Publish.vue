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
          <label for="category">分类 *</label>
          <select id="category" v-model="form.category" required>
            <option value="">请选择分类</option>
            <option value="technology">技术分享</option>
            <option value="news">行业资讯</option>
            <option value="project">项目信息</option>
            <option value="resource">资源共享</option>
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
          <button type="button" class="btn btn-outline" @click="resetForm">
            重置
          </button>
          <button type="submit" class="btn btn-primary" :disabled="!isFormValid">
            发布信息
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'InfoPublish',
  data() {
    return {
      form: {
        title: '',
        category: '',
        summary: '',
        content: '',
        tags: ''
      }
    }
  },
  computed: {
    isFormValid() {
      return this.form.title && this.form.category && this.form.content
    }
  },
  methods: {
    publishInfo() {
      if (!this.isFormValid) {
        this.$message.warning('请填写必填字段')
        return
      }
      
      // 显示确认对话框
      this.$confirm('确定要发布此信息吗？', '确认发布', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        // TODO: 调用后端API发布信息
        // await api.post('/info-plaza/posts/', this.form)
        
        this.$message.success('信息发布成功！')
        
        // 重置表单
        this.resetForm()
        
        // 跳转到信息广场
        this.$router.push('/dashboard/info-plaza')
      }).catch(() => {
        this.$message.info('已取消发布')
      })
    },
    resetForm() {
      this.form = {
        title: '',
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

