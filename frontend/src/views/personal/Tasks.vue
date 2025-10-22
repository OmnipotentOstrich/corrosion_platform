<template>
  <div class="personal-tasks">
    <div class="page-header">
      <h1>我的任务</h1>
      <div class="header-actions">
        <el-button type="primary" @click="createTask">
          创建任务
        </el-button>
      </div>
    </div>
    
    <div class="filters">
      <el-input 
        v-model="searchQuery" 
        placeholder="搜索任务..."
        clearable
        style="max-width: 300px"
      />
      <el-select v-model="statusFilter" placeholder="全部状态" clearable style="width: 150px">
        <el-option label="待处理" value="pending" />
        <el-option label="进行中" value="in_progress" />
        <el-option label="已完成" value="completed" />
        <el-option label="已取消" value="cancelled" />
      </el-select>
      <el-select v-model="priorityFilter" placeholder="全部优先级" clearable style="width: 150px">
        <el-option label="高" value="high" />
        <el-option label="中" value="medium" />
        <el-option label="低" value="low" />
      </el-select>
    </div>
    
    <div v-loading="loading" class="tasks-list">
      <div v-if="filteredTasks.length === 0" class="empty-state">
        <p>暂无任务数据</p>
      </div>
      <div v-for="task in filteredTasks" :key="task.id" class="task-card">
        <div class="task-header">
          <h3>{{ task.title }}</h3>
          <div class="task-badges">
            <el-tag :type="getPriorityType(task.priority)" size="small">
              {{ getPriorityText(task.priority) }}
            </el-tag>
            <el-tag :type="getStatusType(task.status)" size="small">
              {{ getStatusText(task.status) }}
            </el-tag>
          </div>
        </div>
        <p class="task-description">{{ task.description || '暂无描述' }}</p>
        <div class="task-meta">
          <span v-if="task.project">项目: {{ task.project }}</span>
          <span>截止时间: {{ task.deadline }}</span>
          <span>创建时间: {{ task.createdAt }}</span>
        </div>
        <div class="task-actions">
          <el-button 
            v-if="task.status !== 'completed'" 
            type="success" 
            size="small"
            @click="completeTask(task)"
          >
            完成
          </el-button>
          <el-button size="small" @click="editTask(task)">
            编辑
          </el-button>
          <el-button type="danger" size="small" @click="deleteTask(task)">
            删除
          </el-button>
        </div>
      </div>
    </div>
    
    <!-- 编辑任务对话框 -->
    <el-dialog
      v-model="editDialogVisible"
      title="编辑任务"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form :model="editForm" label-width="100px">
        <el-form-item label="任务标题">
          <el-input v-model="editForm.title" placeholder="请输入任务标题" />
        </el-form-item>
        <el-form-item label="任务描述">
          <el-input 
            v-model="editForm.description" 
            type="textarea" 
            :rows="3"
            placeholder="请输入任务描述" 
          />
        </el-form-item>
        <el-form-item label="优先级">
          <el-select v-model="editForm.priority" placeholder="请选择优先级">
            <el-option label="高" value="high" />
            <el-option label="中" value="medium" />
            <el-option label="低" value="low" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="editForm.status" placeholder="请选择状态">
            <el-option label="待处理" value="pending" />
            <el-option label="进行中" value="in_progress" />
            <el-option label="已完成" value="completed" />
            <el-option label="已取消" value="cancelled" />
          </el-select>
        </el-form-item>
        <el-form-item label="截止时间">
          <el-date-picker
            v-model="editForm.due_date"
            type="date"
            placeholder="选择日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="cancelEdit">取消</el-button>
          <el-button type="primary" :loading="saving" @click="saveEdit">保存</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import api from '@/api'
import dayjs from 'dayjs'

const route = useRoute()

// 响应式数据
const loading = ref(false)
const saving = ref(false)
const searchQuery = ref('')
const statusFilter = ref('')
const priorityFilter = ref('')
const tasks = ref([])
const editDialogVisible = ref(false)
const editingTask = ref(null)
const editForm = ref({
  title: '',
  description: '',
  priority: 'medium',
  status: 'pending',
  due_date: ''
})

// 优先级映射
const getPriorityText = (priority) => {
  const map = { high: '高', medium: '中', low: '低' }
  return map[priority] || priority
}

const getPriorityType = (priority) => {
  const map = { high: 'danger', medium: 'warning', low: 'info' }
  return map[priority] || ''
}

// 状态映射
const getStatusText = (status) => {
  const map = {
    pending: '待处理',
    in_progress: '进行中',
    completed: '已完成',
    cancelled: '已取消'
  }
  return map[status] || status
}

const getStatusType = (status) => {
  const map = {
    pending: 'info',
    in_progress: 'primary',
    completed: 'success',
    cancelled: 'danger'
  }
  return map[status] || ''
}

// 格式化日期
const formatDate = (date) => {
  return date ? dayjs(date).format('YYYY-MM-DD') : '-'
}

// 过滤后的任务列表
const filteredTasks = computed(() => {
  let filtered = tasks.value.filter(task => {
    const matchesSearch = !searchQuery.value || 
      task.title?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      task.description?.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesStatus = !statusFilter.value || task.status === statusFilter.value
    const matchesPriority = !priorityFilter.value || task.priority === priorityFilter.value
    return matchesSearch && matchesStatus && matchesPriority
  })
  
  // 如果从项目页面跳转过来，过滤指定项目的任务
  const projectId = route.query.projectId
  if (projectId) {
    filtered = filtered.filter(task => task.project_id == projectId)
  }
  
  return filtered
})

// 加载任务列表
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

const loadTasks = async () => {
  try {
    loading.value = true
    
    // 先检查用户类型
    const user = await getCurrentUser()
    if (user && user.user_type === 'enterprise') {
      // 企业用户显示空列表
      console.log('企业用户访问个人任务页面')
      tasks.value = []
      ElMessage.info('企业用户请在左侧菜单选择"企业管理"模块')
      loading.value = false
      return
    }
    
    const response = await api.get('/persons/tasks/')
    
    const data = response.data.results || response.data || []
    tasks.value = data.map(task => ({
      id: task.id,
      title: task.title || '未命名任务',
      description: task.description || '',
      project: task.project_name || task.project || '',
      project_id: task.project_id || task.project,
      priority: task.priority || 'medium',
      status: task.status || 'pending',
      deadline: formatDate(task.due_date || task.deadline),
      createdAt: formatDate(task.created_at),
      ...task
    }))
    
    // 如果从项目页面跳转过来，显示提示
    const projectName = route.query.projectName
    if (projectName) {
      ElMessage.success(`已筛选项目"${projectName}"的任务`)
    }
  } catch (error) {
    console.error('加载任务列表失败:', error)
    // 如果是403错误，说明是企业用户或权限不足
    if (error.response?.status === 403) {
      ElMessage.warning('企业用户请在左侧菜单选择"企业管理"模块')
    } else {
      ElMessage.error('加载任务列表失败')
    }
    tasks.value = []
  } finally {
    loading.value = false
  }
}

// 创建任务
const createTask = () => {
  ElMessage.info('创建任务功能开发中')
}

// 完成任务
const completeTask = async (task) => {
  try {
    await ElMessageBox.confirm('确认完成此任务？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'success'
    })
    
    await api.post(`/persons/tasks/${task.id}/complete/`)
    ElMessage.success('任务已完成')
    loadTasks() // 刷新列表
  } catch (error) {
    if (error !== 'cancel') {
      console.error('完成任务失败:', error)
      ElMessage.error('操作失败')
    }
  }
}

// 编辑任务
const editTask = (task) => {
  editingTask.value = task
  editForm.value = {
    title: task.title,
    description: task.description,
    priority: task.priority,
    status: task.status,
    due_date: task.due_date || task.deadline
  }
  editDialogVisible.value = true
}

// 保存编辑
const saveEdit = async () => {
  if (!editForm.value.title) {
    ElMessage.error('请填写任务标题')
    return
  }
  
  try {
    saving.value = true
    await api.put(`/persons/tasks/${editingTask.value.id}/`, editForm.value)
    ElMessage.success('任务更新成功')
    editDialogVisible.value = false
    loadTasks() // 刷新列表
  } catch (error) {
    console.error('更新任务失败:', error)
    ElMessage.error('更新失败')
  } finally {
    saving.value = false
  }
}

// 取消编辑
const cancelEdit = () => {
  editDialogVisible.value = false
  editingTask.value = null
}

// 删除任务
const deleteTask = async (task) => {
  try {
    await ElMessageBox.confirm('确认删除此任务？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await api.delete(`/persons/tasks/${task.id}/`)
    ElMessage.success('删除成功')
    loadTasks() // 刷新列表
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除任务失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 组件挂载时加载数据
onMounted(() => {
  loadTasks()
})
</script>

<style scoped>
.personal-tasks {
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

.tasks-list {
  display: grid;
  gap: 20px;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
  font-size: 16px;
}

.task-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.task-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.task-header h3 {
  color: #333;
  margin: 0;
}

.task-badges {
  display: flex;
  gap: 8px;
}

.task-description {
  color: #666;
  margin-bottom: 15px;
}

.task-meta {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}

.task-actions {
  display: flex;
  gap: 10px;
}
</style>
