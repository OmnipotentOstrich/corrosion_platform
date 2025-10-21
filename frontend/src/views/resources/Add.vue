<template>
  <div class="resource-add">
    <div class="page-header">
      <h1>添加资源</h1>
      <p>上传新的资源文件到平台</p>
    </div>
    
    <div class="add-form">
      <form @submit.prevent="uploadResource">
        <div class="form-group">
          <label for="name">资源名称 *</label>
          <input 
            type="text" 
            id="name" 
            v-model="form.name" 
            placeholder="请输入资源名称"
            required
          >
        </div>
        
        <div class="form-group">
          <label for="description">资源描述</label>
          <textarea 
            id="description" 
            v-model="form.description" 
            placeholder="请输入资源描述"
            rows="3"
          ></textarea>
        </div>
        
        <div class="form-row">
          <div class="form-group">
            <label for="type">资源类型 *</label>
            <select id="type" v-model="form.type" required>
              <option value="">请选择类型</option>
              <option value="document">文档</option>
              <option value="image">图片</option>
              <option value="video">视频</option>
              <option value="software">软件</option>
              <option value="template">模板</option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="category">资源分类 *</label>
            <select id="category" v-model="form.category" required>
              <option value="">请选择分类</option>
              <option value="technical">技术资料</option>
              <option value="training">培训材料</option>
              <option value="standard">标准规范</option>
              <option value="tool">工具软件</option>
            </select>
          </div>
        </div>
        
        <div class="form-group">
          <label for="file">选择文件 *</label>
          <div class="file-upload">
            <input 
              type="file" 
              id="file" 
              ref="fileInput"
              @change="handleFileSelect"
              required
            >
            <div class="file-info" v-if="selectedFile">
              <span class="file-name">{{ selectedFile.name }}</span>
              <span class="file-size">{{ formatFileSize(selectedFile.size) }}</span>
            </div>
          </div>
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
        
        <div class="form-group">
          <label>
            <input type="checkbox" v-model="form.isPublic">
            公开资源（其他用户可以下载）
          </label>
        </div>
        
        <div class="form-actions">
          <button type="button" class="btn btn-outline" @click="resetForm">
            重置
          </button>
          <button type="submit" class="btn btn-primary" :disabled="!isFormValid || uploading">
            {{ uploading ? '上传中...' : '上传资源' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ResourceAdd',
  data() {
    return {
      form: {
        name: '',
        description: '',
        type: '',
        category: '',
        tags: '',
        isPublic: true
      },
      selectedFile: null,
      uploading: false
    }
  },
  computed: {
    isFormValid() {
      return this.form.name && this.form.type && this.form.category && this.selectedFile
    }
  },
  methods: {
    handleFileSelect(event) {
      const file = event.target.files[0]
      if (file) {
        this.selectedFile = file
        // 如果用户没有输入名称，使用文件名
        if (!this.form.name) {
          this.form.name = file.name.replace(/\.[^/.]+$/, '')
        }
      }
    },
    formatFileSize(bytes) {
      if (bytes === 0) return '0 Bytes'
      const k = 1024
      const sizes = ['Bytes', 'KB', 'MB', 'GB']
      const i = Math.floor(Math.log(bytes) / Math.log(k))
      return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
    },
    async uploadResource() {
      if (!this.isFormValid) {
        this.$message.warning('请填写必填字段并选择文件')
        return
      }
      
      this.uploading = true
      
      try {
        // 模拟文件上传
        this.$message.info('正在上传资源，请稍候...')
        await new Promise(resolve => setTimeout(resolve, 2000))
        
        // TODO: 调用后端API上传资源
        // const formData = new FormData()
        // formData.append('file', this.selectedFile)
        // Object.keys(this.form).forEach(key => {
        //   formData.append(key, this.form[key])
        // })
        // await api.post('/resources/upload/', formData, {
        //   headers: { 'Content-Type': 'multipart/form-data' }
        // })
        
        this.$message.success('资源上传成功！')
        this.resetForm()
        this.$router.push('/dashboard/resources')
        
      } catch (error) {
        console.error('上传失败:', error)
        this.$message.error('上传失败，请重试')
      } finally {
        this.uploading = false
      }
    },
    resetForm() {
      this.form = {
        name: '',
        description: '',
        type: '',
        category: '',
        tags: '',
        isPublic: true
      }
      this.selectedFile = null
      this.$refs.fileInput.value = ''
    }
  }
}
</script>

<style scoped>
.resource-add {
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

.add-form {
  background: white;
  border-radius: 8px;
  padding: 30px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.form-group {
  margin-bottom: 20px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
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
  min-height: 80px;
}

.file-upload {
  border: 2px dashed #ddd;
  border-radius: 4px;
  padding: 20px;
  text-align: center;
  transition: border-color 0.3s;
}

.file-upload:hover {
  border-color: #007bff;
}

.file-upload input[type="file"] {
  margin-bottom: 10px;
}

.file-info {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.file-name {
  font-weight: 600;
  color: #333;
}

.file-size {
  color: #666;
  font-size: 14px;
}

.form-group input[type="checkbox"] {
  width: auto;
  margin-right: 8px;
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

