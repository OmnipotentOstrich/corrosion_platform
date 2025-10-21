<template>
  <div class="enterprise-projects">
    <div class="page-header">
      <h1>项目管理</h1>
      <div class="header-actions">
        <button class="btn btn-primary" @click="createProject">
          新建项目
        </button>
      </div>
    </div>
    
    <div class="filters">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="搜索项目..."
        class="search-input"
      >
      <select v-model="statusFilter" class="filter-select">
        <option value="">全部状态</option>
        <option value="active">进行中</option>
        <option value="completed">已完成</option>
        <option value="paused">暂停</option>
      </select>
    </div>
    
    <div class="projects-list" v-loading="loading">
      <div v-for="project in filteredProjects" :key="project.id" class="project-card">
        <div class="project-header">
          <h3>{{ project.name }}</h3>
          <span class="status" :class="project.status">{{ project.statusText }}</span>
        </div>
        <p class="project-description">{{ project.description }}</p>
        <div class="project-meta">
          <span>负责人: {{ project.manager }}</span>
          <span>截止日期: {{ project.deadline }}</span>
        </div>
        <div class="project-actions">
          <button class="btn btn-sm btn-outline" @click="viewProject(project)">查看详情</button>
          <button class="btn btn-sm btn-primary" @click="editProject(project)">编辑</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'EnterpriseProjects',
  data() {
    return {
      searchQuery: '',
      statusFilter: '',
      projects: [],
      loading: false
    }
  },
  mounted() {
    this.loadProjects()
  },
  watch: {
    searchQuery() { this.loadProjects() },
    statusFilter() { this.loadProjects() }
  },
  computed: {
    filteredProjects() {
      return this.projects.filter(project => {
        const matchesSearch = project.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                             project.description.toLowerCase().includes(this.searchQuery.toLowerCase())
        const matchesStatus = !this.statusFilter || project.status === this.statusFilter
        return matchesSearch && matchesStatus
      })
    }
  },
  methods: {
    async loadProjects() {
      try {
        this.loading = true
        const params = {}
        if (this.searchQuery) params.search = this.searchQuery
        if (this.statusFilter) params.status = this.statusFilter
        
        const response = await this.$api.get('/enterprises/projects/', { params }).catch(() => ({ data: [] }))
        this.projects = response.data.results || response.data
      } catch (error) {
        console.error('加载项目列表失败:', error)
        this.projects = []
      } finally {
        this.loading = false
      }
    },
    
    async createProject() {
      try {
        const { value } = await this.$prompt('请输入项目名称', '新建项目', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          inputPattern: /.+/,
          inputErrorMessage: '项目名称不能为空'
        })
        
        await this.$api.post('/enterprises/projects/', {
          name: value,
          description: '',
          status: 'active'
        })
        
        this.$message.success(`项目 ${value} 创建成功`)
        this.loadProjects()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('创建项目失败:', error)
          this.$message.error('创建项目失败')
        }
      }
    },
    viewProject(project) {
      this.$alert(`
        <div style="text-align: left;">
          <h3>${project.name}</h3>
          <p><strong>描述：</strong>${project.description}</p>
          <p><strong>负责人：</strong>${project.manager}</p>
          <p><strong>截止日期：</strong>${project.deadline}</p>
          <p><strong>状态：</strong>${project.statusText}</p>
        </div>
      `, '项目详情', {
        dangerouslyUseHTMLString: true,
        confirmButtonText: '关闭'
      })
    },
    async editProject(project) {
      try {
        const { value } = await this.$prompt(`编辑项目 - ${project.name}`, '编辑项目', {
          confirmButtonText: '保存',
          cancelButtonText: '取消',
          inputValue: project.name,
          inputPattern: /.+/,
          inputErrorMessage: '项目名称不能为空'
        })
        
        await this.$api.put(`/enterprises/projects/${project.id}/`, {
          ...project,
          name: value
        })
        
        this.$message.success('项目信息已更新')
        this.loadProjects()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('更新项目失败:', error)
          this.$message.error('更新项目失败')
        }
      }
    }
  },
  
  beforeCreate() {
    this.$api = this.$root.$options.globalProperties.$api || require('@/api').default
  }
}
</script>

<style scoped>
.enterprise-projects {
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

.projects-list {
  display: grid;
  gap: 20px;
}

.project-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.project-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.project-header h3 {
  color: #333;
  margin: 0;
}

.status {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.status.active {
  background-color: #d4edda;
  color: #155724;
}

.status.completed {
  background-color: #cce5ff;
  color: #004085;
}

.status.paused {
  background-color: #fff3cd;
  color: #856404;
}

.project-description {
  color: #666;
  margin-bottom: 15px;
}

.project-meta {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}

.project-actions {
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

