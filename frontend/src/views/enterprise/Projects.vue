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
      <div v-if="filteredProjects.length === 0" class="empty-state">
        <p>暂无项目数据</p>
      </div>
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

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import api from '@/api'
import dayjs from 'dayjs'

// 响应式数据
const loading = ref(false)
const searchQuery = ref('')
const statusFilter = ref('')
const projects = ref([])

// 状态映射
const statusMap = {
  'active': '进行中',
  'completed': '已完成',
  'paused': '暂停',
  'pending': '待开始'
}

// 格式化日期
const formatDate = (date) => {
  return date ? dayjs(date).format('YYYY-MM-DD') : '-'
}

// 过滤后的项目列表
const filteredProjects = computed(() => {
  return projects.value.filter(project => {
    const matchesSearch = !searchQuery.value || 
      project.name?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      project.description?.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesStatus = !statusFilter.value || project.status === statusFilter.value
    return matchesSearch && matchesStatus
  })
})

// 加载项目列表
const loadProjects = async () => {
  try {
    loading.value = true
    const params = {}
    if (searchQuery.value) params.search = searchQuery.value
    if (statusFilter.value) params.status = statusFilter.value
    
    const response = await api.get('/enterprises/projects/', { params })
    const data = response.data.results || response.data || []
    
    projects.value = data.map(project => ({
      id: project.id,
      name: project.name || project.title || '未命名项目',
      description: project.description || '暂无描述',
      manager: project.manager_name || project.manager || '-',
      deadline: formatDate(project.end_date || project.deadline),
      status: project.status || 'active',
      statusText: statusMap[project.status] || project.status,
      ...project
    }))
  } catch (error) {
    console.error('加载项目列表失败:', error)
    ElMessage.error('加载项目列表失败')
    projects.value = []
  } finally {
    loading.value = false
  }
}

// 创建项目
const createProject = async () => {
  try {
    const { value } = await ElMessageBox.prompt('请输入项目名称', '新建项目', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      inputPattern: /.+/,
      inputErrorMessage: '项目名称不能为空'
    })
    
    await api.post('/enterprises/projects/', {
      name: value,
      description: '',
      status: 'active'
    })
    
    ElMessage.success(`项目 ${value} 创建成功`)
    loadProjects()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('创建项目失败:', error)
      ElMessage.error('创建项目失败')
    }
  }
}

// 查看项目详情
const viewProject = (project) => {
  ElMessageBox.alert(
    `
      <div style="text-align: left;">
        <p><strong>描述：</strong>${project.description}</p>
        <p><strong>负责人：</strong>${project.manager}</p>
        <p><strong>截止日期：</strong>${project.deadline}</p>
        <p><strong>状态：</strong>${project.statusText}</p>
      </div>
    `,
    project.name,
    {
      dangerouslyUseHTMLString: true,
      confirmButtonText: '关闭'
    }
  )
}

// 编辑项目
const editProject = async (project) => {
  try {
    const { value } = await ElMessageBox.prompt(`编辑项目 - ${project.name}`, '编辑项目', {
      confirmButtonText: '保存',
      cancelButtonText: '取消',
      inputValue: project.name,
      inputPattern: /.+/,
      inputErrorMessage: '项目名称不能为空'
    })
    
    await api.put(`/enterprises/projects/${project.id}/`, {
      ...project,
      name: value
    })
    
    ElMessage.success('项目信息已更新')
    loadProjects()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('更新项目失败:', error)
      ElMessage.error('更新项目失败')
    }
  }
}

// 监听搜索和过滤条件变化
watch([searchQuery, statusFilter], () => {
  // 使用computed已经实现了过滤，这里不需要重新加载
})

// 组件挂载时加载数据
onMounted(() => {
  loadProjects()
})
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

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
  font-size: 16px;
}
</style>

