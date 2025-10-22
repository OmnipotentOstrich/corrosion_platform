<template>
  <div class="dashboard-home" v-loading="loading">
    <div class="page-container">
      <!-- 欢迎区域 -->
      <div class="welcome-section">
        <div class="welcome-content">
          <div class="greeting">
            <h1>{{ greetingText }}，{{ userStore.user?.username }}！</h1>
            <p class="date-info">
              <el-icon><Calendar /></el-icon>
              {{ currentDate }}
            </p>
            <p class="weather-info" v-if="weatherInfo">
              <el-icon><Sunny /></el-icon>
              {{ weatherInfo }}
            </p>
          </div>
        </div>
        <div class="welcome-stats">
          <div class="mini-stat">
            <div class="mini-stat-value">{{ stats[0]?.value || 0 }}</div>
            <div class="mini-stat-label">今日发布</div>
          </div>
          <div class="mini-stat">
            <div class="mini-stat-value">{{ stats[3]?.value || 0 }}</div>
            <div class="mini-stat-label">待办任务</div>
          </div>
          <div class="mini-stat">
            <div class="mini-stat-value">{{ loginDays }}</div>
            <div class="mini-stat-label">连续登录</div>
          </div>
        </div>
      </div>

      <!-- 快捷操作 -->
      <div class="quick-actions">
        <h3 class="section-title">
          <el-icon><Operation /></el-icon>
          快捷操作
        </h3>
        <div class="action-cards">
          <div class="action-card" @click="quickAction('publish')">
            <div class="action-icon primary">
              <el-icon><Edit /></el-icon>
            </div>
            <div class="action-info">
              <div class="action-title">发布信息</div>
              <div class="action-desc">发布供需、招标等信息</div>
            </div>
            <el-icon class="action-arrow"><ArrowRight /></el-icon>
          </div>
          
          <div class="action-card" @click="quickAction('resource')">
            <div class="action-icon success">
              <el-icon><Upload /></el-icon>
            </div>
            <div class="action-info">
              <div class="action-title">上传资源</div>
              <div class="action-desc">上传文档、视频等资源</div>
            </div>
            <el-icon class="action-arrow"><ArrowRight /></el-icon>
          </div>
          
          <div class="action-card" @click="quickAction('project')">
            <div class="action-icon warning">
              <el-icon><Folder /></el-icon>
            </div>
            <div class="action-info">
              <div class="action-title">项目管理</div>
              <div class="action-desc">查看和管理项目进度</div>
            </div>
            <el-icon class="action-arrow"><ArrowRight /></el-icon>
          </div>
          
          <div class="action-card" @click="quickAction('profile')">
            <div class="action-icon info">
              <el-icon><User /></el-icon>
            </div>
            <div class="action-info">
              <div class="action-title">个人资料</div>
              <div class="action-desc">编辑个人信息和设置</div>
            </div>
            <el-icon class="action-arrow"><ArrowRight /></el-icon>
          </div>
        </div>
      </div>

      <!-- 统计卡片 -->
      <div class="stats-section">
        <h3 class="section-title">
          <el-icon><DataAnalysis /></el-icon>
          数据概览
        </h3>
        <div class="stats-grid">
          <div class="stat-card" v-for="(stat, index) in stats" :key="stat.key" :style="{ animationDelay: `${index * 0.1}s` }">
            <div class="stat-header">
              <div class="stat-icon" :class="stat.iconClass">
                <el-icon><component :is="stat.icon" /></el-icon>
              </div>
              <div class="stat-trend" :class="stat.trend > 0 ? 'up' : 'down'">
                <el-icon v-if="stat.trend > 0"><CaretTop /></el-icon>
                <el-icon v-else><CaretBottom /></el-icon>
                {{ Math.abs(stat.trend) }}%
              </div>
            </div>
            <div class="stat-content">
              <div class="stat-value">
                <span class="count-up">{{ stat.value }}</span>
              </div>
              <div class="stat-label">{{ stat.label }}</div>
            </div>
            <div class="stat-progress">
              <el-progress 
                :percentage="stat.percentage || 75" 
                :stroke-width="4" 
                :show-text="false"
                :color="getStatColor(stat.iconClass)"
              />
            </div>
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
              <el-link type="primary" @click="viewAllActivities">查看全部</el-link>
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
              <h3>
                <el-icon><TrendCharts /></el-icon>
                数据统计
              </h3>
              <el-radio-group v-model="chartType" size="small">
                <el-radio-button label="week">本周</el-radio-button>
                <el-radio-button label="month">本月</el-radio-button>
                <el-radio-button label="year">本年</el-radio-button>
              </el-radio-group>
            </div>
            <div class="chart-container">
              <v-chart :option="chartOption" style="height: 350px;" />
            </div>
          </div>

          <!-- 项目进度 -->
          <div class="card">
            <div class="card-header">
              <h3>
                <el-icon><List /></el-icon>
                项目进度
              </h3>
              <el-link type="primary" @click="viewAllProjects">查看全部</el-link>
            </div>
            <div class="progress-list">
              <div class="progress-item" v-for="project in projectProgress" :key="project.id">
                <div class="progress-info">
                  <div class="progress-name">{{ project.name }}</div>
                  <div class="progress-meta">
                    <span class="progress-percent">{{ project.progress }}%</span>
                    <span class="progress-status" :class="project.status">{{ project.statusText }}</span>
                  </div>
                </div>
                <el-progress 
                  :percentage="project.progress" 
                  :status="project.progress === 100 ? 'success' : ''"
                  :stroke-width="8"
                />
                <div class="progress-footer">
                  <span class="progress-team">
                    <el-icon><User /></el-icon>
                    {{ project.team }}
                  </span>
                  <span class="progress-deadline">截止: {{ project.deadline }}</span>
                </div>
              </div>
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
                <el-link type="primary" @click="viewAllTasks">查看全部</el-link>
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
              <el-link type="primary" @click="viewAllNotifications">查看全部</el-link>
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
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'
import { 
  Edit, Plus, Box, Folder, List, Bell, Check, 
  Calendar, Sunny, Operation, Upload, User, ArrowRight,
  DataAnalysis, CaretTop, CaretBottom, TrendCharts
} from '@element-plus/icons-vue'
import api from '@/api'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart, BarChart, PieChart } from 'echarts/charts'
import { TitleComponent, TooltipComponent, LegendComponent, GridComponent } from 'echarts/components'
import VChart from 'vue-echarts'
import dayjs from 'dayjs'

// 注册ECharts组件
use([
  CanvasRenderer, 
  LineChart, 
  BarChart, 
  PieChart,
  TitleComponent, 
  TooltipComponent, 
  LegendComponent, 
  GridComponent
])

const router = useRouter()
const userStore = useUserStore()

// 当前日期
const currentDate = computed(() => dayjs().format('YYYY年MM月DD日 dddd'))

// 问候语
const greetingText = computed(() => {
  const hour = new Date().getHours()
  if (hour < 6) return '夜深了'
  if (hour < 9) return '早上好'
  if (hour < 12) return '上午好'
  if (hour < 14) return '中午好'
  if (hour < 18) return '下午好'
  if (hour < 22) return '晚上好'
  return '夜深了'
})

// 天气信息
const weatherInfo = ref('晴天 25°C')

// 连续登录天数
const loginDays = ref(15)

// 图表类型
const chartType = ref('week')

// 加载状态
const loading = ref(false)

// 统计数据
const stats = ref([
  { 
    key: 'posts', 
    label: '发布信息', 
    value: 0, 
    icon: 'Edit', 
    iconClass: 'primary',
    trend: 12,
    percentage: 68
  },
  { 
    key: 'resources', 
    label: '资源数量', 
    value: 0, 
    icon: 'Box', 
    iconClass: 'success',
    trend: 8,
    percentage: 85
  },
  { 
    key: 'projects', 
    label: '项目数量', 
    value: 0, 
    icon: 'Folder', 
    iconClass: 'warning',
    trend: -3,
    percentage: 45
  },
  { 
    key: 'tasks', 
    label: '待办任务', 
    value: 0, 
    icon: 'List', 
    iconClass: 'danger',
    trend: 5,
    percentage: 92
  }
])

// 项目进度
const projectProgress = ref([
  { id: 1, name: '防腐涂层项目', progress: 85, status: 'active', statusText: '进行中', team: '张三团队', deadline: '2025-11-30' },
  { id: 2, name: '保温材料研发', progress: 100, status: 'completed', statusText: '已完成', team: '李四团队', deadline: '2025-10-20' },
  { id: 3, name: '质量检测系统', progress: 45, status: 'active', statusText: '进行中', team: '王五团队', deadline: '2025-12-15' },
])

// 最近活动
const recentActivities = ref([])

// 待办任务
const pendingTasks = ref([])

// 系统通知
const notifications = ref([])

// 图表配置
const chartOption = ref({
  title: {
    text: '数据趋势',
    left: 'center',
    textStyle: {
      fontSize: 16,
      fontWeight: 'bold',
      color: '#303133'
    }
  },
  tooltip: {
    trigger: 'axis',
    backgroundColor: 'rgba(255, 255, 255, 0.95)',
    borderColor: '#ddd',
    borderWidth: 1,
    textStyle: {
      color: '#333'
    },
    formatter: function(params) {
      let result = `<div style="font-weight: bold; margin-bottom: 8px;">${params[0].axisValue}</div>`
      params.forEach(param => {
        result += `<div style="margin: 4px 0;">
          <span style="display: inline-block; width: 10px; height: 10px; background-color: ${param.color}; border-radius: 50%; margin-right: 8px;"></span>
          ${param.seriesName}: <span style="font-weight: bold; color: ${param.color};">${param.value}</span>
        </div>`
      })
      return result
    }
  },
  legend: {
    data: ['信息发布', '资源添加', '项目完成'],
    bottom: 0,
    textStyle: {
      fontSize: 12
    }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '15%',
    top: '15%',
    containLabel: true
  },
  xAxis: {
    type: 'category',
    data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
    axisLine: {
      lineStyle: {
        color: '#e4e7ed'
      }
    },
    axisTick: {
      alignWithLabel: true
    }
  },
  yAxis: {
    type: 'value',
    axisLine: {
      lineStyle: {
        color: '#e4e7ed'
      }
    },
    splitLine: {
      lineStyle: {
        color: '#f0f2f5',
        type: 'dashed'
      }
    }
  },
  series: [
    {
      name: '信息发布',
      type: 'line',
      data: [5, 8, 3, 7, 4, 6, 2],
      smooth: true,
      symbol: 'circle',
      symbolSize: 6,
      lineStyle: {
        width: 3,
        color: '#409eff'
      },
      itemStyle: {
        color: '#409eff'
      },
      areaStyle: {
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [{
            offset: 0, color: 'rgba(64, 158, 255, 0.3)'
          }, {
            offset: 1, color: 'rgba(64, 158, 255, 0.05)'
          }]
        }
      }
    },
    {
      name: '资源添加',
      type: 'line',
      data: [2, 4, 1, 3, 2, 5, 1],
      smooth: true,
      symbol: 'circle',
      symbolSize: 6,
      lineStyle: {
        width: 3,
        color: '#67c23a'
      },
      itemStyle: {
        color: '#67c23a'
      },
      areaStyle: {
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [{
            offset: 0, color: 'rgba(103, 194, 58, 0.3)'
          }, {
            offset: 1, color: 'rgba(103, 194, 58, 0.05)'
          }]
        }
      }
    },
    {
      name: '项目完成',
      type: 'line',
      data: [1, 2, 0, 1, 3, 1, 0],
      smooth: true,
      symbol: 'circle',
      symbolSize: 6,
      lineStyle: {
        width: 3,
        color: '#e6a23c'
      },
      itemStyle: {
        color: '#e6a23c'
      },
      areaStyle: {
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [{
            offset: 0, color: 'rgba(230, 162, 60, 0.3)'
          }, {
            offset: 1, color: 'rgba(230, 162, 60, 0.05)'
          }]
        }
      }
    }
  ]
})

// 快速操作
const quickAction = (action) => {
  switch (action) {
    case 'publish':
      router.push('/dashboard/info-plaza/publish')
      break
    case 'resource':
      router.push('/dashboard/resources/add')
      break
    case 'project':
      if (userStore.isEnterprise) {
        router.push('/dashboard/enterprise/projects')
      } else {
        router.push('/dashboard/personal/projects')
      }
      break
    case 'profile':
      router.push('/dashboard/profile')
      break
  }
}

// 获取统计卡片颜色
const getStatColor = (iconClass) => {
  const colors = {
    'primary': '#409eff',
    'success': '#67c23a',
    'warning': '#e6a23c',
    'danger': '#f56c6c'
  }
  return colors[iconClass] || '#409eff'
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

// 查看全部功能
const viewAllActivities = () => {
  ElMessage.info('活动历史功能开发中')
  // TODO: 跳转到活动历史页面
  // router.push('/dashboard/activities')
}

const viewAllProjects = () => {
  if (userStore.user?.user_type === 'enterprise') {
    router.push('/dashboard/enterprise/projects')
  } else if (userStore.user?.user_type === 'personal') {
    router.push('/dashboard/personal/projects')
  } else {
    ElMessage.info('请先完善用户信息')
  }
}

const viewAllTasks = () => {
  if (userStore.user?.user_type === 'enterprise') {
    ElMessage.info('企业用户请在项目管理中查看任务')
    router.push('/dashboard/enterprise/projects')
  } else if (userStore.user?.user_type === 'personal') {
    router.push('/dashboard/personal/tasks')
  } else {
    ElMessage.info('请先完善用户信息')
  }
}

const viewAllNotifications = () => {
  ElMessage.info('通知中心功能开发中')
  // TODO: 跳转到通知中心页面
  // router.push('/dashboard/notifications')
}

// 加载仪表板数据
const loadDashboardData = async () => {
  try {
    loading.value = true
    
    // 检查用户是否已登录
    const token = localStorage.getItem('token')
    console.log('当前token:', token ? '已存在' : '不存在')
    
    // 并行加载所有数据
    const [statsRes, activitiesRes, tasksRes, notificationsRes, projectsRes, userStatsRes] = await Promise.all([
      api.get('/dashboard/statistics/').catch((error) => {
        console.error('统计API调用失败:', error)
        return { data: null }
      }),
      api.get('/dashboard/activities/').catch((error) => {
        console.error('活动API调用失败:', error)
        return { data: [] }
      }),
      api.get('/dashboard/tasks/').catch((error) => {
        console.error('任务API调用失败:', error)
        return { data: [] }
      }),
      api.get('/dashboard/notifications/').catch((error) => {
        console.error('通知API调用失败:', error)
        return { data: [] }
      }),
      api.get('/dashboard/projects/').catch((error) => {
        console.error('项目API调用失败:', error)
        return { data: [] }
      }),
      api.get('/dashboard/user-stats/').catch((error) => {
        console.error('用户统计API调用失败:', error)
        return { data: null }
      })
    ])
    
    // 更新统计数据（包括趋势和百分比）
    console.log('统计API响应:', statsRes)
    if (statsRes.data) {
      console.log('统计数据:', statsRes.data)
      console.log('posts:', statsRes.data.posts)
      console.log('resources:', statsRes.data.resources)
      console.log('projects:', statsRes.data.projects)
      console.log('tasks:', statsRes.data.tasks)
      
      stats.value[0].value = statsRes.data.posts || 0
      stats.value[0].trend = statsRes.data.posts_trend || 0
      stats.value[0].percentage = statsRes.data.posts_percentage || 0
      
      stats.value[1].value = statsRes.data.resources || 0
      stats.value[1].trend = statsRes.data.resources_trend || 0
      stats.value[1].percentage = statsRes.data.resources_percentage || 0
      
      stats.value[2].value = statsRes.data.projects || 0
      stats.value[2].trend = statsRes.data.projects_trend || 0
      stats.value[2].percentage = statsRes.data.projects_percentage || 0
      
      stats.value[3].value = statsRes.data.tasks || 0
      stats.value[3].trend = statsRes.data.tasks_trend || 0
      stats.value[3].percentage = statsRes.data.tasks_percentage || 0
      
      console.log('更新后的统计卡片数据:', stats.value)
    } else {
      console.error('统计API返回数据为空:', statsRes)
    }
    
    // 更新活动、任务、通知
    recentActivities.value = activitiesRes.data
    pendingTasks.value = tasksRes.data
    notifications.value = notificationsRes.data
    
    // 更新项目进度列表
    if (projectsRes.data && projectsRes.data.length > 0) {
      projectProgress.value = projectsRes.data
    }
    
    // 更新用户统计信息
    if (userStatsRes.data) {
      loginDays.value = userStatsRes.data.login_days || 1
      weatherInfo.value = userStatsRes.data.weather_info || '晴天 25°C'
    }
    
    // 加载图表数据
    loadChartData()
    
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

// 加载图表数据
const loadChartData = async () => {
  try {
    const periodMap = {
      'week': 'week',
      'month': 'month',
      'year': 'year'
    }
    const response = await api.get('/dashboard/chart-data/', {
      params: { period: periodMap[chartType.value] || 'week' }
    })
    
    if (response.data && response.data.labels && response.data.datasets) {
      // 更新图表配置
      chartOption.value.xAxis.data = response.data.labels
      chartOption.value.series[0].data = response.data.datasets.posts
      chartOption.value.series[1].data = response.data.datasets.resources
      chartOption.value.series[2].data = response.data.datasets.projects
      
      // 如果有元数据，动态调整Y轴最大值
      if (response.data.metadata && response.data.metadata.max_value > 0) {
        const maxValue = response.data.metadata.max_value
        chartOption.value.yAxis.max = Math.ceil(maxValue * 1.2) // 留出20%的余量
      }
      
      console.log('图表数据加载成功:', {
        period: response.data.metadata?.period,
        user_type: response.data.metadata?.user_type,
        totals: {
          posts: response.data.metadata?.total_posts,
          resources: response.data.metadata?.total_resources,
          projects: response.data.metadata?.total_projects
        }
      })
    }
  } catch (error) {
    console.error('加载图表数据失败:', error)
    ElMessage.error('加载图表数据失败')
  }
}

// 监听图表类型变化
watch(chartType, () => {
  loadChartData()
})

onMounted(() => {
  // 加载仪表板数据
  loadDashboardData()
})
</script>

<style lang="scss" scoped>
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.dashboard-home {
  animation: slideIn 0.5s ease-out;

  .section-title {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 18px;
    font-weight: 600;
    color: #333;
    margin-bottom: 20px;

    .el-icon {
      font-size: 20px;
      color: #409eff;
    }
  }

  .welcome-section {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 40px;
    border-radius: 16px;
    margin-bottom: 24px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
    position: relative;
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -10%;
      width: 300px;
      height: 300px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 50%;
    }
    
    .welcome-content {
      position: relative;
      z-index: 1;

      .greeting h1 {
        font-size: 32px;
        margin-bottom: 12px;
        font-weight: 700;
      }
      
      .date-info, .weather-info {
        font-size: 15px;
        opacity: 0.95;
        display: flex;
        align-items: center;
        gap: 6px;
        margin-top: 8px;

        .el-icon {
          font-size: 16px;
        }
      }
    }
    
    .welcome-stats {
      display: flex;
      gap: 30px;
      position: relative;
      z-index: 1;

      .mini-stat {
        text-align: center;
        background: rgba(255, 255, 255, 0.15);
        padding: 20px 30px;
        border-radius: 12px;
        backdrop-filter: blur(10px);
        transition: all 0.3s;

        &:hover {
          transform: translateY(-5px);
          background: rgba(255, 255, 255, 0.25);
        }

        .mini-stat-value {
          font-size: 28px;
          font-weight: 700;
          margin-bottom: 5px;
        }

        .mini-stat-label {
          font-size: 13px;
          opacity: 0.9;
        }
      }
    }
  }

  .quick-actions {
    margin-bottom: 24px;

    .action-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 16px;

      .action-card {
        background: white;
        padding: 20px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        gap: 15px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        cursor: pointer;
        transition: all 0.3s;

        &:hover {
          transform: translateY(-4px);
          box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);

          .action-arrow {
            transform: translateX(5px);
          }
        }

        .action-icon {
          width: 50px;
          height: 50px;
          border-radius: 12px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 22px;
          color: white;

          &.primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
          &.success { background: linear-gradient(135deg, #5ee7df 0%, #b490ca 100%); }
          &.warning { background: linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%); }
          &.info { background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); }
        }

        .action-info {
          flex: 1;

          .action-title {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
          }

          .action-desc {
            font-size: 13px;
            color: #666;
          }
        }

        .action-arrow {
          font-size: 18px;
          color: #999;
          transition: transform 0.3s;
        }
      }
    }
  }

  .stats-section {
    margin-bottom: 24px;
  }
  
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 20px;
    
    .stat-card {
      background: white;
      padding: 24px;
      border-radius: 12px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      animation: slideIn 0.5s ease-out;
      animation-fill-mode: both;
      transition: all 0.3s;
      border: 1px solid transparent;

      &:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
        border-color: rgba(64, 158, 255, 0.2);
      }

      .stat-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
      }
      
      .stat-icon {
        width: 54px;
        height: 54px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: white;
        
        &.primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        &.success { background: linear-gradient(135deg, #5ee7df 0%, #b490ca 100%); }
        &.warning { background: linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%); }
        &.danger { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
      }

      .stat-trend {
        display: flex;
        align-items: center;
        gap: 4px;
        font-size: 13px;
        font-weight: 600;
        padding: 4px 10px;
        border-radius: 20px;

        &.up {
          color: #67c23a;
          background: rgba(103, 194, 58, 0.1);
        }

        &.down {
          color: #f56c6c;
          background: rgba(245, 108, 108, 0.1);
        }
      }
      
      .stat-content {
        margin-bottom: 12px;

        .stat-value {
          font-size: 32px;
          font-weight: 700;
          color: #333;
          margin-bottom: 6px;
          
          .count-up {
            display: inline-block;
          }
        }
        
        .stat-label {
          font-size: 14px;
          color: #666;
        }
      }

      .stat-progress {
        margin-top: 12px;
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

  .progress-list {
    padding: 0 20px 20px;

    .progress-item {
      padding: 20px;
      background: #f8f9fa;
      border-radius: 12px;
      margin-bottom: 16px;
      transition: all 0.3s;

      &:last-child {
        margin-bottom: 0;
      }

      &:hover {
        background: #e9ecef;
        transform: translateX(4px);
      }

      .progress-info {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;

        .progress-name {
          font-size: 15px;
          font-weight: 600;
          color: #333;
        }

        .progress-meta {
          display: flex;
          align-items: center;
          gap: 12px;

          .progress-percent {
            font-size: 14px;
            font-weight: 600;
            color: #409eff;
          }

          .progress-status {
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;

            &.active {
              color: #409eff;
              background: rgba(64, 158, 255, 0.1);
            }

            &.completed {
              color: #67c23a;
              background: rgba(103, 194, 58, 0.1);
            }
          }
        }
      }

      .progress-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 12px;
        font-size: 13px;
        color: #666;

        .progress-team {
          display: flex;
          align-items: center;
          gap: 4px;
        }

        .progress-deadline {
          color: #999;
        }
      }
    }
  }
}

@media (max-width: 768px) {
  .dashboard-home {
    .welcome-section {
      flex-direction: column;
      padding: 24px;
      text-align: center;

      .welcome-content .greeting h1 {
        font-size: 24px;
      }
      
      .welcome-stats {
        margin-top: 20px;
        flex-wrap: wrap;
        gap: 12px;
        justify-content: center;

        .mini-stat {
          padding: 15px 20px;
        }
      }
    }

    .quick-actions .action-cards {
      grid-template-columns: 1fr;
    }
    
    .stats-grid {
      grid-template-columns: repeat(2, 1fr);
      gap: 12px;

      .stat-card {
        padding: 16px;

        .stat-content .stat-value {
          font-size: 24px;
        }
      }
    }

    .section-title {
      font-size: 16px;
    }
  }
}
</style>
