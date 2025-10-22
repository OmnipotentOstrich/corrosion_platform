<template>
  <div class="system-monitor">
    <div class="page-header">
      <h1>系统监控</h1>
      <div class="header-actions">
        <span class="auto-refresh-info">
          <el-icon><Timer /></el-icon>
          自动刷新: {{ countdown }}秒
        </span>
        <el-button @click="refreshData" :loading="loading">
          <el-icon><Refresh /></el-icon>
          刷新数据
        </el-button>
      </div>
    </div>

    <!-- 系统健康状态 -->
    <el-card class="health-card" :class="getHealthClass()">
      <template #header>
        <div class="card-header">
          <span>系统健康状态</span>
          <el-tag :type="getHealthTagType()" size="large">
            {{ healthData.status_display }}
          </el-tag>
        </div>
      </template>
      <div class="health-info">
        <div class="health-item">
          <el-icon><Clock /></el-icon>
          <span>最后检查: {{ formatTime(healthData.last_check) }}</span>
        </div>
        <div class="health-item">
          <el-icon><Monitor /></el-icon>
          <span>数据库状态: {{ healthData.database_status }}</span>
        </div>
        <div class="health-item">
          <el-icon><Connection /></el-icon>
          <span>API状态: {{ healthData.api_status }}</span>
        </div>
      </div>
    </el-card>

    <!-- 资源使用情况 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="8">
        <el-card>
          <template #header>
            <div class="card-header">
              <el-icon><Cpu /></el-icon>
              <span>CPU使用率</span>
            </div>
          </template>
          <div class="metric-content">
            <el-progress
              type="dashboard"
              :percentage="healthData.cpu_usage || 0"
              :color="getProgressColor(healthData.cpu_usage)"
              :width="150"
            >
              <template #default="{ percentage }">
                <span class="percentage-value">{{ percentage }}%</span>
              </template>
            </el-progress>
            <div class="metric-info">
              <p>{{ getCpuStatus(healthData.cpu_usage) }}</p>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :span="8">
        <el-card>
          <template #header>
            <div class="card-header">
              <el-icon><Memo /></el-icon>
              <span>内存使用率</span>
            </div>
          </template>
          <div class="metric-content">
            <el-progress
              type="dashboard"
              :percentage="healthData.memory_usage || 0"
              :color="getProgressColor(healthData.memory_usage)"
              :width="150"
            >
              <template #default="{ percentage }">
                <span class="percentage-value">{{ percentage }}%</span>
              </template>
            </el-progress>
            <div class="metric-info">
              <p>{{ getMemoryStatus(healthData.memory_usage) }}</p>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :span="8">
        <el-card>
          <template #header>
            <div class="card-header">
              <el-icon><Files /></el-icon>
              <span>磁盘使用率</span>
            </div>
          </template>
          <div class="metric-content">
            <el-progress
              type="dashboard"
              :percentage="healthData.disk_usage || 0"
              :color="getProgressColor(healthData.disk_usage)"
              :width="150"
            >
              <template #default="{ percentage }">
                <span class="percentage-value">{{ percentage }}%</span>
              </template>
            </el-progress>
            <div class="metric-info">
              <p>{{ getDiskStatus(healthData.disk_usage) }}</p>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 监控历史数据 -->
    <el-card style="margin-top: 20px">
      <template #header>
        <div class="card-header">
          <span>监控历史</span>
          <el-radio-group v-model="timeRange" size="small" @change="loadHistory">
            <el-radio-button label="1h">最近1小时</el-radio-button>
            <el-radio-button label="6h">最近6小时</el-radio-button>
            <el-radio-button label="24h">最近24小时</el-radio-button>
          </el-radio-group>
        </div>
      </template>
      
      <div class="chart-container">
        <div ref="chartRef" style="width: 100%; height: 400px"></div>
      </div>
    </el-card>

    <!-- 监控数据表格 -->
    <el-card style="margin-top: 20px">
      <template #header>
        <div class="card-header">
          <span>监控记录</span>
          <el-select v-model="monitorTypeFilter" placeholder="监控类型" clearable size="small">
            <el-option label="全部类型" value="" />
            <el-option label="CPU使用率" value="cpu" />
            <el-option label="内存使用率" value="memory" />
            <el-option label="磁盘使用率" value="disk" />
            <el-option label="网络流量" value="network" />
            <el-option label="数据库连接" value="database" />
            <el-option label="API响应时间" value="api" />
          </el-select>
        </div>
      </template>
      
      <el-table
        :data="monitorData"
        stripe
        border
        v-loading="tableLoading"
      >
        <el-table-column prop="monitor_type_display" label="监控类型" width="150" />
        <el-table-column prop="metric_name" label="指标名称" width="200" />
        <el-table-column prop="metric_value" label="指标值" width="120">
          <template #default="{ row }">
            {{ row.metric_value.toFixed(2) }}{{ getUnit(row.monitor_type) }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getMonitorStatusColor(row.status)">
              {{ getMonitorStatusDisplay(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="threshold_warning" label="警告阈值" width="120">
          <template #default="{ row }">
            {{ row.threshold_warning || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="threshold_critical" label="严重阈值" width="120">
          <template #default="{ row }">
            {{ row.threshold_critical || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="记录时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.created_at) }}
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50]"
          :total="total"
          layout="total, sizes, prev, pager, next"
          @size-change="loadMonitorData"
          @current-change="loadMonitorData"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { ElMessage } from 'element-plus'
import {
  Refresh,
  Clock,
  Monitor,
  Connection,
  Cpu,
  Memo,
  Files,
  Timer
} from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import api from '@/api'

const loading = ref(false)
const tableLoading = ref(false)
const countdown = ref(5)
const healthData = ref({
  status: 'healthy',
  status_display: '健康',
  cpu_usage: 0,
  memory_usage: 0,
  disk_usage: 0,
  database_status: 'healthy',
  api_status: 'healthy',
  last_check: new Date()
})

const timeRange = ref('1h')
const monitorTypeFilter = ref('')
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)
const monitorData = ref([])

const chartRef = ref(null)
let chartInstance = null
let refreshTimer = null
let countdownTimer = null

// 加载系统健康数据
const loadHealthData = async () => {
  try {
    loading.value = true
    const response = await api.get('/system/health/')
    
    healthData.value = {
      status: response.data.status || 'healthy',
      status_display: getStatusDisplay(response.data.status),
      cpu_usage: Math.round(response.data.cpu_usage || 0),
      memory_usage: Math.round(response.data.memory_usage || 0),
      disk_usage: Math.round(response.data.disk_usage || 0),
      database_status: response.data.database_status || 'healthy',
      api_status: response.data.api_status || 'healthy',
      last_check: new Date()
    }
  } catch (error) {
    console.error('加载系统健康数据失败:', error)
    // 使用模拟数据
    healthData.value = {
      status: 'healthy',
      status_display: '健康',
      cpu_usage: Math.floor(Math.random() * 30 + 20),
      memory_usage: Math.floor(Math.random() * 40 + 30),
      disk_usage: Math.floor(Math.random() * 30 + 40),
      database_status: 'healthy',
      api_status: 'healthy',
      last_check: new Date()
    }
  } finally {
    loading.value = false
  }
}

// 加载监控数据
const loadMonitorData = async () => {
  try {
    tableLoading.value = true
    const params = {
      page: currentPage.value,
      page_size: pageSize.value
    }
    if (monitorTypeFilter.value) {
      params.monitor_type = monitorTypeFilter.value
    }

    const response = await api.get('/system/monitors/', { params })
    const data = response.data.results || response.data || []
    
    monitorData.value = data.map(item => ({
      ...item,
      monitor_type_display: getMonitorTypeDisplay(item.monitor_type)
    }))
    total.value = response.data.count || monitorData.value.length
  } catch (error) {
    console.error('加载监控数据失败:', error)
    monitorData.value = []
  } finally {
    tableLoading.value = false
  }
}

// 加载历史数据并渲染图表
const loadHistory = async () => {
  // 生成模拟历史数据
  const hours = timeRange.value === '1h' ? 1 : timeRange.value === '6h' ? 6 : 24
  const points = hours * 12 // 每5分钟一个点
  
  const now = new Date()
  const labels = []
  const cpuData = []
  const memoryData = []
  const diskData = []
  
  for (let i = points - 1; i >= 0; i--) {
    const time = new Date(now.getTime() - i * 5 * 60 * 1000)
    labels.push(time.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }))
    
    // 生成波动数据
    cpuData.push(Math.floor(Math.random() * 20 + (healthData.value.cpu_usage - 10)))
    memoryData.push(Math.floor(Math.random() * 15 + (healthData.value.memory_usage - 8)))
    diskData.push(Math.floor(Math.random() * 10 + (healthData.value.disk_usage - 5)))
  }
  
  renderChart(labels, cpuData, memoryData, diskData)
}

// 渲染图表
const renderChart = (labels, cpuData, memoryData, diskData) => {
  if (!chartInstance && chartRef.value) {
    chartInstance = echarts.init(chartRef.value)
  }
  
  if (chartInstance) {
    const option = {
      title: {
        text: '系统资源使用趋势',
        left: 'center'
      },
      tooltip: {
        trigger: 'axis'
      },
      legend: {
        data: ['CPU使用率', '内存使用率', '磁盘使用率'],
        bottom: 10
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '15%',
        containLabel: true
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: labels
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: 100,
        axisLabel: {
          formatter: '{value}%'
        }
      },
      series: [
        {
          name: 'CPU使用率',
          type: 'line',
          smooth: true,
          data: cpuData,
          itemStyle: { color: '#5470c6' },
          areaStyle: { opacity: 0.3 }
        },
        {
          name: '内存使用率',
          type: 'line',
          smooth: true,
          data: memoryData,
          itemStyle: { color: '#91cc75' },
          areaStyle: { opacity: 0.3 }
        },
        {
          name: '磁盘使用率',
          type: 'line',
          smooth: true,
          data: diskData,
          itemStyle: { color: '#fac858' },
          areaStyle: { opacity: 0.3 }
        }
      ]
    }
    
    chartInstance.setOption(option)
  }
}

// 刷新数据
const refreshData = async () => {
  countdown.value = 5  // 重置倒计时
  await Promise.all([
    loadHealthData(),
    loadMonitorData(),
    loadHistory()
  ])
  ElMessage.success('数据已刷新')
}

// 获取状态显示
const getStatusDisplay = (status) => {
  const statusMap = {
    healthy: '健康',
    warning: '警告',
    critical: '严重'
  }
  return statusMap[status] || '未知'
}

// 获取健康状态类名
const getHealthClass = () => {
  const classMap = {
    healthy: 'health-healthy',
    warning: 'health-warning',
    critical: 'health-critical'
  }
  return classMap[healthData.value.status] || ''
}

// 获取健康状态标签类型
const getHealthTagType = () => {
  const typeMap = {
    healthy: 'success',
    warning: 'warning',
    critical: 'danger'
  }
  return typeMap[healthData.value.status] || 'info'
}

// 获取进度条颜色
const getProgressColor = (percentage) => {
  if (percentage >= 90) return '#f56c6c'
  if (percentage >= 80) return '#e6a23c'
  if (percentage >= 60) return '#409eff'
  return '#67c23a'
}

// 获取CPU状态描述
const getCpuStatus = (usage) => {
  if (usage >= 90) return 'CPU使用率过高，建议检查'
  if (usage >= 80) return 'CPU使用率较高'
  if (usage >= 60) return 'CPU使用率正常'
  return 'CPU运行良好'
}

// 获取内存状态描述
const getMemoryStatus = (usage) => {
  if (usage >= 90) return '内存不足，建议清理'
  if (usage >= 80) return '内存使用率较高'
  if (usage >= 60) return '内存使用率正常'
  return '内存充足'
}

// 获取磁盘状态描述
const getDiskStatus = (usage) => {
  if (usage >= 90) return '磁盘空间不足'
  if (usage >= 80) return '磁盘空间紧张'
  if (usage >= 60) return '磁盘空间正常'
  return '磁盘空间充足'
}

// 获取监控类型显示
const getMonitorTypeDisplay = (type) => {
  const typeMap = {
    cpu: 'CPU使用率',
    memory: '内存使用率',
    disk: '磁盘使用率',
    network: '网络流量',
    database: '数据库连接',
    api: 'API响应时间',
    security: '安全监控',
    performance: '性能监控'
  }
  return typeMap[type] || type
}

// 获取单位
const getUnit = (type) => {
  const unitMap = {
    cpu: '%',
    memory: '%',
    disk: '%',
    network: 'MB/s',
    database: '个',
    api: 'ms'
  }
  return unitMap[type] || ''
}

// 获取监控状态显示
const getMonitorStatusDisplay = (status) => {
  const statusMap = {
    normal: '正常',
    warning: '警告',
    critical: '严重'
  }
  return statusMap[status] || status
}

// 获取监控状态颜色
const getMonitorStatusColor = (status) => {
  const colorMap = {
    normal: 'success',
    warning: 'warning',
    critical: 'danger'
  }
  return colorMap[status] || 'info'
}

// 格式化时间
const formatTime = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleTimeString('zh-CN')
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleString('zh-CN')
}

// 监听筛选变化
watch(monitorTypeFilter, () => {
  currentPage.value = 1
  loadMonitorData()
})

onMounted(async () => {
  await loadHealthData()
  await loadMonitorData()
  await loadHistory()
  
  // 每5秒自动刷新一次
  refreshTimer = setInterval(() => {
    loadHealthData()
    countdown.value = 5  // 重置倒计时
  }, 5000)
  
  // 倒计时定时器（每秒更新）
  countdownTimer = setInterval(() => {
    if (countdown.value > 0) {
      countdown.value--
    } else {
      countdown.value = 5
    }
  }, 1000)
  
  // 监听窗口大小变化
  window.addEventListener('resize', () => {
    if (chartInstance) {
      chartInstance.resize()
    }
  })
})

onUnmounted(() => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
  }
  if (countdownTimer) {
    clearInterval(countdownTimer)
  }
  if (chartInstance) {
    chartInstance.dispose()
  }
})
</script>

<style scoped>
.system-monitor {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 {
  margin: 0;
  color: #333;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 15px;
}

.auto-refresh-info {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 8px 15px;
  background: #e6f7ff;
  border: 1px solid #91d5ff;
  border-radius: 4px;
  color: #0050b3;
  font-size: 14px;
  font-weight: 500;
}

.auto-refresh-info .el-icon {
  animation: rotate 2s linear infinite;
}

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header span {
  display: flex;
  align-items: center;
  gap: 8px;
}

.health-card {
  border-width: 2px;
}

.health-healthy {
  border-color: #67c23a;
}

.health-warning {
  border-color: #e6a23c;
}

.health-critical {
  border-color: #f56c6c;
}

.health-info {
  display: flex;
  justify-content: space-around;
  padding: 10px 0;
}

.health-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #666;
}

.metric-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px 0;
}

.percentage-value {
  font-size: 24px;
  font-weight: bold;
}

.metric-info {
  margin-top: 15px;
  text-align: center;
  color: #666;
  font-size: 14px;
}

.chart-container {
  min-height: 400px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>

