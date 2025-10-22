<template>
  <div class="personal-projects">
    <div class="page-header">
      <h1>我的项目</h1>
      <div class="header-actions">
        <button class="btn btn-primary" @click="joinProject">
          加入项目
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
      <select v-model="roleFilter" class="filter-select">
        <option value="">全部角色</option>
        <option value="manager">项目经理</option>
        <option value="developer">开发人员</option>
        <option value="designer">设计师</option>
        <option value="tester">测试人员</option>
      </select>
    </div>
    
    <div v-loading="loading" class="projects-list">
      <div v-if="filteredProjects.length === 0" class="empty-state">
        <p>暂无项目数据</p>
      </div>
      <div v-for="project in filteredProjects" :key="project.id" class="project-card">
        <div class="project-header">
          <h3>{{ project.name }}</h3>
          <span class="role">{{ project.role }}</span>
        </div>
        <p class="project-description">{{ project.description }}</p>
        <div class="project-progress">
          <div class="progress-bar">
            <div class="progress-fill" :style="{ width: project.progress + '%' }"></div>
          </div>
          <span class="progress-text">{{ project.progress }}%</span>
        </div>
        <div class="project-meta">
          <span>开始时间: {{ project.startDate }}</span>
          <span>截止时间: {{ project.deadline }}</span>
        </div>
        <div class="project-actions">
          <button class="btn btn-sm btn-outline" @click="viewProject(project)">
            查看详情
          </button>
          <button class="btn btn-sm btn-primary" @click="viewTasks(project)">
            查看任务
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import api from '@/api'
import dayjs from 'dayjs'

const router = useRouter()

// 响应式数据
const loading = ref(false)
const searchQuery = ref('')
const roleFilter = ref('')
const projects = ref([])

// 角色映射
const roleMap = {
  'manager': '项目经理',
  'developer': '开发人员',
  'designer': '设计师',
  'tester': '测试人员',
  'member': '团队成员'
}

// 过滤后的项目列表
const filteredProjects = computed(() => {
  return projects.value.filter(project => {
    const matchesSearch = project.name?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                         project.description?.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesRole = !roleFilter.value || project.role === roleFilter.value
    return matchesSearch && matchesRole
  })
})

// 格式化日期
const formatDate = (date) => {
  return date ? dayjs(date).format('YYYY-MM-DD') : '-'
}

// 获取当前用户信息
const getCurrentUser = async () => {
  try {
    const response = await api.get('/auth/profile/')
    return response.data
  } catch (error) {
    console.error('获取用户信息失败:', error)
    return null
  }
}

// 加载项目列表
const loadProjects = async () => {
  try {
    loading.value = true
    
    // 先检查用户类型
    const user = await getCurrentUser()
    if (user && user.user_type === 'enterprise') {
      // 企业用户显示空列表
      console.log('企业用户访问个人项目页面')
      projects.value = []
      ElMessage.info('企业用户请在左侧菜单选择"企业管理 > 项目管理"')
      loading.value = false
      return
    }
    
    const response = await api.get('/persons/projects/')
    
    // 处理响应数据
    const data = response.data.results || response.data || []
    projects.value = data.map(project => ({
      id: project.id,
      name: project.name || project.title || '未命名项目',
      description: project.description || '暂无描述',
      role: roleMap[project.role] || project.role || '团队成员',
      progress: project.progress || 0,
      startDate: formatDate(project.start_date || project.startDate),
      deadline: formatDate(project.end_date || project.deadline),
      status: project.status || 'in_progress'
    }))
  } catch (error) {
    console.error('加载项目列表失败:', error)
    // 如果是403错误，说明是企业用户或权限不足
    if (error.response?.status === 403) {
      ElMessage.warning('企业用户请在左侧菜单选择"企业管理"模块')
    } else {
      ElMessage.error('加载项目列表失败')
    }
    // 失败时使用空数组
    projects.value = []
  } finally {
    loading.value = false
  }
}

// 加入项目
const joinProject = () => {
  ElMessage.info('加入项目功能开发中')
}

// 查看项目详情
const viewProject = (project) => {
  ElMessageBox.alert(
    `
      <div style="text-align: left;">
        <p><strong>描述：</strong>${project.description}</p>
        <p><strong>角色：</strong>${project.role}</p>
        <p><strong>进度：</strong>${project.progress}%</p>
        <p><strong>开始时间：</strong>${project.startDate}</p>
        <p><strong>截止时间：</strong>${project.deadline}</p>
      </div>
    `,
    project.name,
    {
      dangerouslyUseHTMLString: true,
      confirmButtonText: '关闭'
    }
  )
}

// 查看任务
const viewTasks = (project) => {
  router.push({
    path: '/dashboard/personal/tasks',
    query: { projectId: project.id, projectName: project.name }
  })
}

// 组件挂载时加载数据
onMounted(() => {
  loadProjects()
})
</script>

<style scoped>
.personal-projects {
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

.role {
  background-color: #e9ecef;
  color: #495057;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.project-description {
  color: #666;
  margin-bottom: 15px;
}

.project-progress {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 15px;
}

.progress-bar {
  flex: 1;
  height: 8px;
  background-color: #e9ecef;
  border-radius: 4px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background-color: #007bff;
  transition: width 0.3s ease;
}

.progress-text {
  font-size: 14px;
  color: #666;
  min-width: 40px;
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

