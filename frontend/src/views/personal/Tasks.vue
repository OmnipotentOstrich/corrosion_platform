<template>
  <div class="personal-tasks">
    <div class="page-header">
      <h1>我的任务</h1>
      <div class="header-actions">
        <button class="btn btn-primary" @click="createTask">
          创建任务
        </button>
      </div>
    </div>
    
    <div class="filters">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="搜索任务..."
        class="search-input"
      >
      <select v-model="statusFilter" class="filter-select">
        <option value="">全部状态</option>
        <option value="pending">待处理</option>
        <option value="in-progress">进行中</option>
        <option value="completed">已完成</option>
        <option value="cancelled">已取消</option>
      </select>
      <select v-model="priorityFilter" class="filter-select">
        <option value="">全部优先级</option>
        <option value="high">高</option>
        <option value="medium">中</option>
        <option value="low">低</option>
      </select>
    </div>
    
    <div class="tasks-list">
      <div v-for="task in filteredTasks" :key="task.id" class="task-card">
        <div class="task-header">
          <h3>{{ task.title }}</h3>
          <div class="task-badges">
            <span class="priority" :class="task.priority">{{ task.priorityText }}</span>
            <span class="status" :class="task.status">{{ task.statusText }}</span>
          </div>
        </div>
        <p class="task-description">{{ task.description }}</p>
        <div class="task-meta">
          <span>项目: {{ task.project }}</span>
          <span>截止时间: {{ task.deadline }}</span>
          <span>创建时间: {{ task.createdAt }}</span>
        </div>
        <div class="task-actions">
          <button 
            v-if="task.status !== 'completed'" 
            class="btn btn-sm btn-success" 
            @click="completeTask(task)"
          >
            完成
          </button>
          <button class="btn btn-sm btn-outline" @click="editTask(task)">
            编辑
          </button>
          <button class="btn btn-sm btn-danger" @click="deleteTask(task)">
            删除
          </button>
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
            <el-option label="进行中" value="in-progress" />
            <el-option label="已完成" value="completed" />
            <el-option label="已取消" value="cancelled" />
          </el-select>
        </el-form-item>
        <el-form-item label="截止时间">
          <el-date-picker
            v-model="editForm.deadline"
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
          <el-button type="primary" @click="saveEdit">保存</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'PersonalTasks',
  data() {
    return {
      searchQuery: '',
      statusFilter: '',
      priorityFilter: '',
      editDialogVisible: false,
      editingTask: null,
      editForm: {
        title: '',
        description: '',
        priority: '',
        status: '',
        deadline: ''
      },
      tasks: [
        {
          id: 1,
          title: '设计防腐方案',
          description: '为工业设备设计防腐保温方案',
          project: '防腐保温项目A',
          priority: 'high',
          priorityText: '高',
          status: 'in-progress',
          statusText: '进行中',
          deadline: '2024-11-15',
          createdAt: '2024-10-01'
        },
        {
          id: 2,
          title: '材料采购',
          description: '采购防腐保温所需材料',
          project: '管道维护项目B',
          priority: 'medium',
          priorityText: '中',
          status: 'pending',
          statusText: '待处理',
          deadline: '2024-11-20',
          createdAt: '2024-10-05'
        },
        {
          id: 3,
          title: '质量检测',
          description: '对完成的防腐工程进行质量检测',
          project: '设备检测项目C',
          priority: 'high',
          priorityText: '高',
          status: 'completed',
          statusText: '已完成',
          deadline: '2024-10-30',
          createdAt: '2024-09-20'
        }
      ]
    }
  },
  computed: {
    filteredTasks() {
      let tasks = this.tasks.filter(task => {
        const matchesSearch = task.title.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                             task.description.toLowerCase().includes(this.searchQuery.toLowerCase())
        const matchesStatus = !this.statusFilter || task.status === this.statusFilter
        const matchesPriority = !this.priorityFilter || task.priority === this.priorityFilter
        return matchesSearch && matchesStatus && matchesPriority
      })
      
      // 如果从项目页面跳转过来，过滤指定项目的任务
      const projectName = this.$route.query.projectName
      if (projectName) {
        tasks = tasks.filter(task => task.project === projectName)
      }
      
      return tasks
    }
  },
  mounted() {
    // 如果从项目页面跳转过来，显示提示
    const projectName = this.$route.query.projectName
    if (projectName) {
      this.$message.success(`已筛选项目"${projectName}"的任务`)
    }
  },
  methods: {
    createTask() {
      this.$message.info('创建任务功能开发中')
    },
    completeTask(task) {
      this.$confirm('确认完成此任务？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'success'
      }).then(() => {
        task.status = 'completed'
        task.statusText = '已完成'
        this.$message.success('任务已完成')
      }).catch(() => {
        this.$message.info('已取消')
      })
    },
    editTask(task) {
      // 复制任务数据到编辑表单
      this.editingTask = task
      this.editForm = {
        title: task.title,
        description: task.description,
        priority: task.priority,
        status: task.status,
        deadline: task.deadline
      }
      this.editDialogVisible = true
    },
    saveEdit() {
      // 验证表单
      if (!this.editForm.title || !this.editForm.description) {
        this.$message.error('请填写完整信息')
        return
      }
      
      // 更新任务数据
      this.editingTask.title = this.editForm.title
      this.editingTask.description = this.editForm.description
      this.editingTask.priority = this.editForm.priority
      this.editingTask.status = this.editForm.status
      this.editingTask.deadline = this.editForm.deadline
      
      // 更新显示文本
      const priorityMap = { high: '高', medium: '中', low: '低' }
      const statusMap = { 
        pending: '待处理', 
        'in-progress': '进行中', 
        completed: '已完成', 
        cancelled: '已取消' 
      }
      this.editingTask.priorityText = priorityMap[this.editForm.priority]
      this.editingTask.statusText = statusMap[this.editForm.status]
      
      this.editDialogVisible = false
      this.$message.success('任务更新成功')
    },
    cancelEdit() {
      this.editDialogVisible = false
      this.editingTask = null
    },
    deleteTask(task) {
      this.$confirm('确认删除此任务？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        const index = this.tasks.findIndex(t => t.id === task.id)
        if (index > -1) {
          this.tasks.splice(index, 1)
          this.$message.success('删除成功')
        }
      }).catch(() => {
        this.$message.info('已取消删除')
      })
    }
  }
}
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

.tasks-list {
  display: grid;
  gap: 20px;
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

.priority, .status {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.priority.high {
  background-color: #f8d7da;
  color: #721c24;
}

.priority.medium {
  background-color: #fff3cd;
  color: #856404;
}

.priority.low {
  background-color: #d1ecf1;
  color: #0c5460;
}

.status.pending {
  background-color: #e2e3e5;
  color: #383d41;
}

.status.in-progress {
  background-color: #cce5ff;
  color: #004085;
}

.status.completed {
  background-color: #d4edda;
  color: #155724;
}

.status.cancelled {
  background-color: #f8d7da;
  color: #721c24;
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

.btn-success {
  background-color: #28a745;
  color: white;
}

.btn-success:hover {
  background-color: #1e7e34;
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

.btn-danger {
  background-color: #dc3545;
  color: white;
}

.btn-danger:hover {
  background-color: #c82333;
}

.btn-sm {
  padding: 4px 8px;
  font-size: 12px;
}
</style>

