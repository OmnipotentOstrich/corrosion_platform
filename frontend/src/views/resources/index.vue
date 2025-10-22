<template>
  <div class="resources-management">
    <div class="page-header">
      <h1>资源管理</h1>
      <div class="header-actions">
        <router-link to="/dashboard/resources/add" class="btn btn-primary">
          添加资源
        </router-link>
      </div>
    </div>
    
    <div class="filters">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="搜索资源..."
        class="search-input"
      >
      <select v-model="typeFilter" class="filter-select">
        <option value="">全部类型</option>
        <option value="document">文档</option>
        <option value="image">图片</option>
        <option value="video">视频</option>
        <option value="software">软件</option>
        <option value="template">模板</option>
      </select>
      <select v-model="categoryFilter" class="filter-select">
        <option value="">全部分类</option>
        <option value="technical">技术资料</option>
        <option value="training">培训材料</option>
        <option value="standard">标准规范</option>
        <option value="tool">工具软件</option>
      </select>
    </div>
    
    <div v-loading="loading" class="resources-grid">
      <div v-if="filteredResources.length === 0" class="empty-state">
        <p>暂无资源数据</p>
      </div>
      <div v-for="resource in filteredResources" :key="resource.id" class="resource-card">
        <div class="resource-icon">
          <i :class="getResourceIcon(resource.type)"></i>
        </div>
        <div class="resource-info">
          <h3>{{ resource.name }}</h3>
          <p class="resource-description">{{ resource.description }}</p>
          <div class="resource-meta">
            <span class="type">{{ resource.type }}</span>
            <span class="category">{{ resource.category }}</span>
            <span class="size">{{ resource.size }}</span>
          </div>
          <div class="resource-stats">
            <span>下载: {{ resource.downloads }}</span>
            <span>上传: {{ resource.uploadTime }}</span>
          </div>
        </div>
        <div class="resource-actions">
          <router-link :to="`/dashboard/resources/detail/${resource.id}`" class="btn btn-sm btn-outline">
            查看详情
          </router-link>
          <button class="btn btn-sm btn-primary" @click="downloadResource(resource)">
            下载
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import api from '@/api'
import { ElMessage, ElMessageBox } from 'element-plus'

export default {
  name: 'ResourcesManagement',
  data() {
    return {
      searchQuery: '',
      typeFilter: '',
      categoryFilter: '',
      resources: [],
      loading: false
    }
  },
  mounted() {
    this.loadResources()
  },
  watch: {
    searchQuery() {
      this.loadResources()
    },
    typeFilter() {
      this.loadResources()
    },
    categoryFilter() {
      this.loadResources()
    }
  },
  computed: {
    filteredResources() {
      return this.resources
    }
  },
  methods: {
    // 加载资源列表
    async loadResources() {
      try {
        this.loading = true
        
        // 构建查询参数
        const params = {}
        if (this.searchQuery) {
          params.search = this.searchQuery
        }
        if (this.typeFilter) {
          params.resource_type = this.typeFilter
        }
        if (this.categoryFilter) {
          params.category = this.categoryFilter
        }
        
        const response = await api.get('/resources/', { params })
        const data = response.data.results || response.data || []
        
        // 格式化资源数据
        this.resources = data.map(resource => ({
          id: resource.id,
          name: resource.name || resource.title || '未命名资源',
          description: resource.description || '暂无描述',
          type: resource.resource_type || resource.type || 'document',
          category: this.getCategoryText(resource.category),
          size: this.formatFileSize(resource.file_size || resource.size),
          downloads: resource.download_count || resource.downloads || 0,
          uploadTime: this.formatDate(resource.created_at || resource.upload_time),
          downloadUrl: resource.file || resource.file_url || resource.download_url,
          ...resource
        }))
      } catch (error) {
        console.error('加载资源列表失败:', error)
        ElMessage.error('加载资源列表失败，请稍后重试')
        this.resources = []
      } finally {
        this.loading = false
      }
    },
    
    // 获取分类文本
    getCategoryText(category) {
      const categoryMap = {
        'technical': '技术资料',
        'training': '培训材料',
        'standard': '标准规范',
        'tool': '工具软件'
      }
      return categoryMap[category] || category || '其他'
    },
    
    // 格式化文件大小
    formatFileSize(bytes) {
      if (!bytes) return '未知'
      if (bytes < 1024) return bytes + 'B'
      if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + 'KB'
      if (bytes < 1024 * 1024 * 1024) return (bytes / (1024 * 1024)).toFixed(1) + 'MB'
      return (bytes / (1024 * 1024 * 1024)).toFixed(1) + 'GB'
    },
    
    // 格式化日期
    formatDate(dateString) {
      if (!dateString) return '-'
      const date = new Date(dateString)
      return date.toLocaleDateString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
      })
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
    
    // 下载资源
    async downloadResource(resource) {
      try {
        await ElMessageBox.confirm(`确定要下载 ${resource.name} 吗？`, '确认下载', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'info'
        })
        
        // 如果有下载链接，直接下载
        if (resource.downloadUrl) {
          window.open(resource.downloadUrl, '_blank')
          ElMessage.success(`开始下载: ${resource.name}`)
          
          // 可选：调用API记录下载次数
          try {
            await api.post(`/resources/${resource.id}/download/`)
            // 更新本地下载次数
            resource.downloads++
          } catch (error) {
            console.error('记录下载失败:', error)
          }
        } else {
          ElMessage.warning('该资源暂无下载链接')
        }
      } catch (error) {
        if (error !== 'cancel') {
          console.error('下载资源失败:', error)
          ElMessage.error('下载失败，请稍后重试')
        }
      }
    }
  }
}
</script>

<style scoped>
.resources-management {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.page-header h1 {
  color: #333;
  margin: 0;
}

.filters {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}

.search-input, .filter-select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-input {
  flex: 1;
  max-width: 300px;
}

.resources-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 20px;
}

.resource-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
  display: flex;
  flex-direction: column;
}

.resource-icon {
  text-align: center;
  margin-bottom: 15px;
}

.resource-icon i {
  font-size: 3em;
  color: #007bff;
}

.resource-info {
  flex: 1;
  margin-bottom: 15px;
}

.resource-info h3 {
  color: #333;
  margin-bottom: 10px;
}

.resource-description {
  color: #666;
  margin-bottom: 15px;
  line-height: 1.5;
}

.resource-meta {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
  flex-wrap: wrap;
}

.resource-meta span {
  background-color: #e9ecef;
  color: #495057;
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 12px;
}

.resource-stats {
  display: flex;
  gap: 15px;
  font-size: 14px;
  color: #666;
}

.resource-actions {
  display: flex;
  gap: 10px;
}

.btn {
  padding: 6px 12px;
  border-radius: 4px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s;
  text-decoration: none;
  display: inline-block;
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

.btn-sm {
  padding: 4px 8px;
  font-size: 12px;
}

.empty-state {
  grid-column: 1 / -1;
  text-align: center;
  padding: 60px 20px;
  color: #999;
  font-size: 16px;
}
</style>

