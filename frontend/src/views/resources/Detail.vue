<template>
  <div class="resource-detail">
    <div class="detail-header">
      <div class="breadcrumb">
        <router-link to="/dashboard/resources">资源管理</router-link>
        <span class="separator">></span>
        <span>资源详情</span>
      </div>
      
      <div class="resource-info">
        <div class="resource-icon">
          <i :class="getResourceIcon(resource.type)"></i>
        </div>
        <div class="resource-meta">
          <h1>{{ resource.name }}</h1>
          <p class="description">{{ resource.description }}</p>
          <div class="meta-tags">
            <span class="type">{{ resource.type }}</span>
            <span class="category">{{ resource.category }}</span>
            <span class="size">{{ resource.size }}</span>
          </div>
          <div class="resource-stats">
            <span>上传时间: {{ resource.uploadTime }}</span>
            <span>下载次数: {{ resource.downloads }}</span>
            <span>上传者: {{ resource.uploader }}</span>
          </div>
        </div>
        <div class="actions">
          <button class="btn btn-primary" @click="downloadResource">
            下载资源
          </button>
          <button class="btn btn-outline" @click="shareResource">
            分享
          </button>
        </div>
      </div>
    </div>
    
    <div class="detail-content">
      <div class="content-section">
        <h3>资源信息</h3>
        <div class="info-grid">
          <div class="info-item">
            <label>文件类型</label>
            <span>{{ resource.type }}</span>
          </div>
          <div class="info-item">
            <label>文件大小</label>
            <span>{{ resource.size }}</span>
          </div>
          <div class="info-item">
            <label>资源分类</label>
            <span>{{ resource.category }}</span>
          </div>
          <div class="info-item">
            <label>上传时间</label>
            <span>{{ resource.uploadTime }}</span>
          </div>
          <div class="info-item">
            <label>下载次数</label>
            <span>{{ resource.downloads }}</span>
          </div>
          <div class="info-item">
            <label>上传者</label>
            <span>{{ resource.uploader }}</span>
          </div>
        </div>
        
        <div v-if="resource.tags" class="tags-section">
          <h4>标签</h4>
          <div class="tag-list">
            <span v-for="tag in resource.tags" :key="tag" class="tag">{{ tag }}</span>
          </div>
        </div>
        
        <div v-if="resource.notes" class="notes-section">
          <h4>使用说明</h4>
          <div class="notes-content">{{ resource.notes }}</div>
        </div>
      </div>
      
      <div class="comments-section">
        <h3>评论 ({{ comments.length }})</h3>
        
        <div class="comment-form">
          <textarea 
            v-model="newComment" 
            placeholder="写下您的评论..."
            rows="3"
          ></textarea>
          <button class="btn btn-primary" @click="submitComment">
            发表评论
          </button>
        </div>
        
        <div class="comments-list">
          <div v-for="comment in comments" :key="comment.id" class="comment">
            <div class="comment-header">
              <span class="comment-author">{{ comment.author }}</span>
              <span class="comment-time">{{ comment.time }}</span>
            </div>
            <div class="comment-content">{{ comment.content }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ResourceDetail',
  data() {
    return {
      resource: {
        id: 1,
        name: '防腐保温技术规范',
        description: '最新的防腐保温技术规范和标准，包含详细的施工要求和验收标准',
        type: 'document',
        category: '标准规范',
        size: '2.5MB',
        uploadTime: '2024-10-01',
        downloads: 156,
        uploader: '张工程师',
        tags: ['技术规范', '防腐保温', '标准'],
        notes: '本规范适用于工业设备防腐保温工程的设计、施工和验收。请严格按照规范要求执行，确保工程质量。'
      },
      newComment: '',
      comments: [
        {
          id: 1,
          author: '李工程师',
          time: '2024-10-02 10:30',
          content: '非常实用的技术规范，感谢分享！'
        },
        {
          id: 2,
          author: '王技术员',
          time: '2024-10-03 14:20',
          content: '请问这个规范是否适用于所有类型的防腐工程？'
        }
      ]
    }
  },
  mounted() {
    // 获取资源详情
    this.loadResourceDetail()
  },
  methods: {
    loadResourceDetail() {
      // 根据路由参数获取资源详情
      const resourceId = this.$route.params.id
      console.log('加载资源详情:', resourceId)
    },
    getResourceIcon(type) {
      const icons = {
        document: 'fas fa-file-alt',
        image: 'fas fa-image',
        video: 'fas fa-video',
        software: 'fas fa-download',
        template: 'fas fa-file-code'
      }
      return icons[type] || 'fas fa-file'
    },
    downloadResource() {
      this.$confirm(`确定要下载 ${this.resource.name} 吗？`, '确认下载', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        this.resource.downloads++
        this.$message.success(`开始下载: ${this.resource.name}`)
        // TODO: 调用后端API下载资源
        // window.open(`/api/v1/resources/${this.resource.id}/download/`, '_blank')
      }).catch(() => {
        this.$message.info('已取消下载')
      })
    },
    shareResource() {
      // 复制链接到剪贴板
      const url = window.location.href
      navigator.clipboard.writeText(url).then(() => {
        this.$message.success('链接已复制到剪贴板')
      }).catch(() => {
        this.$message.error('复制失败，请手动复制')
      })
    },
    submitComment() {
      if (!this.newComment.trim()) {
        this.$message.warning('请输入评论内容')
        return
      }
      
      const comment = {
        id: Date.now(),
        author: '当前用户',
        time: new Date().toLocaleString(),
        content: this.newComment
      }
      
      this.comments.push(comment)
      this.newComment = ''
      
      this.$message.success('评论发表成功')
      // TODO: 调用后端API保存评论
      // await api.post('/resources/comments/', { resource: this.resource.id, content: comment.content })
    }
  }
}
</script>

<style scoped>
.resource-detail {
  padding: 20px;
}

.detail-header {
  background: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.breadcrumb {
  margin-bottom: 20px;
  font-size: 14px;
  color: #666;
}

.breadcrumb a {
  color: #007bff;
  text-decoration: none;
}

.breadcrumb a:hover {
  text-decoration: underline;
}

.separator {
  margin: 0 8px;
}

.resource-info {
  display: flex;
  align-items: flex-start;
  gap: 20px;
}

.resource-icon {
  flex-shrink: 0;
}

.resource-icon i {
  font-size: 4em;
  color: #007bff;
}

.resource-meta {
  flex: 1;
}

.resource-meta h1 {
  color: #333;
  margin-bottom: 10px;
}

.description {
  color: #666;
  margin-bottom: 15px;
  line-height: 1.5;
}

.meta-tags {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
  flex-wrap: wrap;
}

.meta-tags span {
  background-color: #e9ecef;
  color: #495057;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.resource-stats {
  display: flex;
  gap: 20px;
  font-size: 14px;
  color: #666;
}

.actions {
  display: flex;
  gap: 10px;
  flex-shrink: 0;
}

.detail-content {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 20px;
}

.content-section {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.content-section h3 {
  color: #333;
  margin-bottom: 20px;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
  margin-bottom: 20px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.info-item label {
  font-weight: 600;
  color: #666;
  font-size: 14px;
}

.info-item span {
  color: #333;
}

.tags-section {
  margin-bottom: 20px;
}

.tags-section h4 {
  color: #333;
  margin-bottom: 10px;
}

.tag-list {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.tag {
  background-color: #e9ecef;
  color: #495057;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.notes-section h4 {
  color: #333;
  margin-bottom: 10px;
}

.notes-content {
  color: #333;
  line-height: 1.6;
  background: #f8f9fa;
  padding: 15px;
  border-radius: 4px;
}

.comments-section {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.comments-section h3 {
  color: #333;
  margin-bottom: 15px;
}

.comment-form {
  margin-bottom: 20px;
}

.comment-form textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  font-family: inherit;
  margin-bottom: 10px;
}

.comment-form textarea:focus {
  outline: none;
  border-color: #007bff;
}

.comments-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.comment {
  padding: 15px;
  background: #f8f9fa;
  border-radius: 6px;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 14px;
}

.comment-author {
  font-weight: 600;
  color: #333;
}

.comment-time {
  color: #666;
}

.comment-content {
  color: #333;
  line-height: 1.5;
}

.btn {
  padding: 8px 16px;
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

.btn-primary:hover {
  background-color: #0056b3;
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

