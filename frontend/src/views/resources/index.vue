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
    
    <div class="resources-grid">
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
export default {
  name: 'ResourcesManagement',
  data() {
    return {
      searchQuery: '',
      typeFilter: '',
      categoryFilter: '',
      resources: [
        {
          id: 1,
          name: '防腐保温技术规范',
          description: '最新的防腐保温技术规范和标准',
          type: 'document',
          category: '标准规范',
          size: '2.5MB',
          downloads: 156,
          uploadTime: '2024-10-01'
        },
        {
          id: 2,
          name: '防腐材料检测工具',
          description: '用于检测防腐材料性能的专业工具',
          type: 'software',
          category: '工具软件',
          size: '15.2MB',
          downloads: 89,
          uploadTime: '2024-09-28'
        },
        {
          id: 3,
          name: '保温工程培训视频',
          description: '保温工程施工技术培训视频教程',
          type: 'video',
          category: '培训材料',
          size: '125.8MB',
          downloads: 234,
          uploadTime: '2024-09-25'
        },
        {
          id: 4,
          name: '防腐涂料技术资料',
          description: '各种防腐涂料的技术参数和应用指南',
          type: 'document',
          category: '技术资料',
          size: '5.1MB',
          downloads: 78,
          uploadTime: '2024-09-20'
        }
      ]
    }
  },
  computed: {
    filteredResources() {
      return this.resources.filter(resource => {
        const matchesSearch = resource.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                             resource.description.toLowerCase().includes(this.searchQuery.toLowerCase())
        const matchesType = !this.typeFilter || resource.type === this.typeFilter
        const matchesCategory = !this.categoryFilter || resource.category === this.categoryFilter
        return matchesSearch && matchesType && matchesCategory
      })
    }
  },
  methods: {
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
    downloadResource(resource) {
      this.$confirm(`确定要下载 ${resource.name} 吗？`, '确认下载', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        resource.downloads++
        this.$message.success(`开始下载: ${resource.name}`)
        // TODO: 调用后端API下载资源
        // window.open(resource.downloadUrl, '_blank')
      }).catch(() => {
        this.$message.info('已取消下载')
      })
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
</style>

