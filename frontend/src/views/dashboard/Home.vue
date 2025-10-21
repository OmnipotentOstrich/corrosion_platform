<template>
  <div class="dashboard-home" v-loading="loading">
    <div class="page-container">
      <!-- 欢迎区域 -->
      <div class="welcome-section">
        <div class="welcome-content">
          <h1>欢迎回来，{{ userStore.user?.username }}！</h1>
          <p>今天是 {{ currentDate }}，祝您工作愉快！</p>
        </div>
        <div class="welcome-actions">
          <el-button type="primary" @click="quickAction('publish')">
            <el-icon><Edit /></el-icon>
            发布信息
          </el-button>
          <el-button type="success" @click="quickAction('resource')">
            <el-icon><Plus /></el-icon>
            添加资源
          </el-button>
        </div>
      </div>

      <!-- 统计卡片 -->
      <div class="stats-grid">
        <div class="stat-card" v-for="stat in stats" :key="stat.key">
          <div class="stat-icon" :class="stat.iconClass">
            <el-icon><component :is="stat.icon" /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stat.value }}</div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
        </div>
      </div>

      <!-- 主要内容区域 -->
      <el-row :gutter="20">
        <!-- 左侧内容 -->
        <el-col :span="16">
          <!-- 最近活动 -->
          <div class="card">
            <div class="card-header">
              <h3>最近活动</h3>
              <el-link type="primary">查看全部</el-link>
            </div>
            <div class="activity-list">
              <div class="activity-item" v-for="activity in recentActivities" :key="activity.id">
                <div class="activity-icon" :class="activity.type">
                  <el-icon><component :is="activity.icon" /></el-icon>
                </div>
                <div class="activity-content">
                  <div class="activity-title">{{ activity.title }}</div>
                  <div class="activity-desc">{{ activity.description }}</div>
                  <div class="activity-time">{{ activity.time }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- 数据图表 -->
          <div class="card">
            <div class="card-header">
              <h3>数据统计</h3>
              <el-radio-group v-model="chartType" size="small">
                <el-radio-button label="week">本周</el-radio-button>
                <el-radio-button label="month">本月</el-radio-button>
                <el-radio-button label="year">本年</el-radio-button>
              </el-radio-group>
            </div>
            <div class="chart-container">
              <v-chart :option="chartOption" style="height: 300px;" />
            </div>
          </div>
        </el-col>

        <!-- 右侧内容 -->
        <el-col :span="8">
          <!-- 待办事项 -->
          <div class="card">
            <div class="card-header">
              <h3>待办事项</h3>
              <el-badge :value="pendingTasks.length" class="badge">
                <el-link type="primary">查看全部</el-link>
              </el-badge>
            </div>
            <div class="todo-list">
              <div class="todo-item" v-for="task in pendingTasks" :key="task.id">
                <el-checkbox v-model="task.completed" @change="toggleTask(task)">
                  {{ task.title }}
                </el-checkbox>
                <div class="todo-meta">
                  <el-tag :type="getPriorityType(task.priority)" size="small">
                    {{ task.priority }}
                  </el-tag>
                  <span class="todo-time">{{ task.dueDate }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 系统通知 -->
          <div class="card">
            <div class="card-header">
              <h3>系统通知</h3>
              <el-link type="primary">查看全部</el-link>
            </div>
            <div class="notification-list">
              <div class="notification-item" v-for="notification in notifications" :key="notification.id">
                <div class="notification-icon" :class="notification.type">
                  <el-icon><component :is="notification.icon" /></el-icon>
                </div>
                <div class="notification-content">
                  <div class="notification-title">{{ notification.title }}</div>
                  <div class="notification-desc">{{ notification.content }}</div>
                  <div class="notification-time">{{ notification.time }}</div>
                </div>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'
import { Edit, Plus, Box, Folder, List, Bell, Check } from '@element-plus/icons-vue'
import api from '@/api'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart } from 'echarts/charts'
import { TitleComponent, TooltipComponent, LegendComponent, GridComponent } from 'echarts/components'
import VChart from 'vue-echarts'
import dayjs from 'dayjs'

// 注册ECharts组件
use([CanvasRenderer, LineChart, TitleComponent, TooltipComponent, LegendComponent, GridComponent])

const router = useRouter()
const userStore = useUserStore()

// 当前日期
const currentDate = computed(() => dayjs().format('YYYY年MM月DD日 dddd'))

// 图表类型
const chartType = ref('week')

// 加载状态
const loading = ref(false)

// 统计数据
const stats = ref([
  { key: 'posts', label: '发布信息', value: 0, icon: 'Edit', iconClass: 'primary' },
  { key: 'resources', label: '资源数量', value: 0, icon: 'Box', iconClass: 'success' },
  { key: 'projects', label: '项目数量', value: 0, icon: 'Folder', iconClass: 'warning' },
  { key: 'tasks', label: '待办任务', value: 0, icon: 'List', iconClass: 'danger' }
])

// 最近活动
const recentActivities = ref([])

// 待办任务
const pendingTasks = ref([])

// 系统通知
const notifications = ref([])

// 图表配置
const chartOption = computed(() => ({
  title: {
    text: '数据趋势',
    left: 'center'
  },
  tooltip: {
    trigger: 'axis'
  },
  legend: {
    data: ['信息发布', '资源添加', '项目完成'],
    bottom: 0
  },
  xAxis: {
    type: 'category',
    data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
  },
  yAxis: {
    type: 'value'
  },
  series: [
    {
      name: '信息发布',
      type: 'line',
      data: [5, 8, 3, 7, 4, 6, 2],
      smooth: true
    },
    {
      name: '资源添加',
      type: 'line',
      data: [2, 4, 1, 3, 2, 5, 1],
      smooth: true
    },
    {
      name: '项目完成',
      type: 'line',
      data: [1, 2, 0, 1, 3, 1, 0],
      smooth: true
    }
  ]
}))

// 快速操作
const quickAction = (action) => {
  switch (action) {
    case 'publish':
      router.push('/dashboard/info-plaza/publish')
      break
    case 'resource':
      router.push('/dashboard/resources/add')
      break
  }
}

// 切换任务状态
const toggleTask = async (task) => {
  try {
    // 调用API更新任务状态
    if (task.completed) {
      ElMessage.success('任务已完成')
    } else {
      ElMessage.info('任务已标记为待处理')
    }
    // TODO: 调用后端API保存状态
    // await api.post(`/tasks/${task.id}/toggle/`)
  } catch (error) {
    console.error('更新任务状态失败:', error)
    ElMessage.error('操作失败')
  }
}

// 获取优先级类型
const getPriorityType = (priority) => {
  const types = {
    '高': 'danger',
    '中': 'warning',
    '低': 'info'
  }
  return types[priority] || 'info'
}

// 加载仪表板数据
const loadDashboardData = async () => {
  try {
    loading.value = true
    
    // 并行加载所有数据
    const [statsRes, activitiesRes, tasksRes, notificationsRes] = await Promise.all([
      api.get('/dashboard/statistics/').catch(() => ({ data: null })),
      api.get('/dashboard/activities/').catch(() => ({ data: [] })),
      api.get('/dashboard/tasks/').catch(() => ({ data: [] })),
      api.get('/dashboard/notifications/').catch(() => ({ data: [] }))
    ])
    
    // 更新统计数据
    if (statsRes.data) {
      stats.value[0].value = statsRes.data.posts || 0
      stats.value[1].value = statsRes.data.resources || 0
      stats.value[2].value = statsRes.data.projects || 0
      stats.value[3].value = statsRes.data.tasks || 0
    }
    
    // 更新活动、任务、通知
    recentActivities.value = activitiesRes.data
    pendingTasks.value = tasksRes.data
    notifications.value = notificationsRes.data
    
  } catch (error) {
    console.error('加载仪表板数据失败:', error)
    ElMessage.error('加载仪表板数据失败，显示默认数据')
    
    // 使用默认数据
    recentActivities.value = [
      { id: 1, type: 'info', icon: 'Edit', title: '暂无活动', description: '开始使用系统吧', time: '刚刚' }
    ]
    pendingTasks.value = [
      { id: 1, title: '欢迎使用系统', priority: '低', dueDate: '今天', completed: false }
    ]
    notifications.value = [
      { id: 1, type: 'info', icon: 'Bell', title: '欢迎', content: '欢迎使用防腐保温智能数字平台', time: '刚刚' }
    ]
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  // 加载仪表板数据
  loadDashboardData()
})
</script>

<style lang="scss" scoped>
.dashboard-home {
  .welcome-section {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 30px;
    border-radius: 10px;
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .welcome-content {
      h1 {
        font-size: 28px;
        margin-bottom: 10px;
      }
      
      p {
        font-size: 16px;
        opacity: 0.9;
      }
    }
    
    .welcome-actions {
      .el-button {
        margin-left: 10px;
      }
    }
  }
  
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 20px;
    
    .stat-card {
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
      display: flex;
      align-items: center;
      
      .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
        font-size: 24px;
        color: white;
        
        &.primary { background: #409eff; }
        &.success { background: #67c23a; }
        &.warning { background: #e6a23c; }
        &.danger { background: #f56c6c; }
      }
      
      .stat-content {
        .stat-value {
          font-size: 24px;
          font-weight: 600;
          color: #333;
          margin-bottom: 5px;
        }
        
        .stat-label {
          font-size: 14px;
          color: #666;
        }
      }
    }
  }
  
  .card {
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
    
    .card-header {
      padding: 20px 20px 0;
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      
      h3 {
        font-size: 18px;
        color: #333;
      }
    }
    
    .activity-list, .todo-list, .notification-list {
      padding: 0 20px 20px;
      
      .activity-item, .todo-item, .notification-item {
        display: flex;
        align-items: flex-start;
        padding: 15px 0;
        border-bottom: 1px solid #f0f0f0;
        
        &:last-child {
          border-bottom: none;
        }
      }
    }
    
    .activity-icon, .notification-icon {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 15px;
      font-size: 18px;
      color: white;
      
      &.info { background: #409eff; }
      &.resource { background: #67c23a; }
      &.project { background: #e6a23c; }
      &.success { background: #67c23a; }
    }
    
    .activity-content, .notification-content {
      flex: 1;
      
      .activity-title, .notification-title {
        font-size: 14px;
        color: #333;
        margin-bottom: 5px;
      }
      
      .activity-desc, .notification-desc {
        font-size: 12px;
        color: #666;
        margin-bottom: 5px;
      }
      
      .activity-time, .notification-time {
        font-size: 12px;
        color: #999;
      }
    }
    
    .todo-item {
      .todo-meta {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-top: 5px;
        
        .todo-time {
          font-size: 12px;
          color: #999;
        }
      }
    }
  }
  
  .chart-container {
    padding: 0 20px 20px;
  }
}

@media (max-width: 768px) {
  .dashboard-home {
    .welcome-section {
      flex-direction: column;
      text-align: center;
      
      .welcome-actions {
        margin-top: 20px;
      }
    }
    
    .stats-grid {
      grid-template-columns: repeat(2, 1fr);
    }
  }
}
</style>
