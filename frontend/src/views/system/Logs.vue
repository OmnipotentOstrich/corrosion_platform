<template>
  <div class="system-logs">
    <div class="page-header">
      <h1>系统日志</h1>
      <div class="header-actions">
        <button class="btn btn-outline" @click="refreshLogs">
          <i class="fas fa-sync-alt"></i> 刷新
        </button>
        <button class="btn btn-outline" @click="exportLogs">
          <i class="fas fa-download"></i> 导出日志
        </button>
        <button class="btn btn-danger" @click="clearLogs">
          <i class="fas fa-trash"></i> 清空日志
        </button>
      </div>
    </div>
    
    <div class="filters">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="搜索日志消息、用户、IP..."
        class="search-input"
        @input="onSearchInput"
      >
      <select v-model="levelFilter" class="filter-select">
        <option value="">全部级别</option>
        <option value="DEBUG">调试 (DEBUG)</option>
        <option value="INFO">信息 (INFO)</option>
        <option value="WARNING">警告 (WARNING)</option>
        <option value="ERROR">错误 (ERROR)</option>
        <option value="CRITICAL">严重 (CRITICAL)</option>
      </select>
      <select v-model="logTypeFilter" class="filter-select">
        <option value="">全部类型</option>
        <option value="system">系统日志</option>
        <option value="user">用户操作</option>
        <option value="api">API访问</option>
        <option value="database">数据库操作</option>
        <option value="security">安全日志</option>
        <option value="business">业务日志</option>
      </select>
      <input 
        type="date" 
        v-model="dateFilter" 
        class="date-input"
        placeholder="选择日期"
      >
      <button class="btn btn-sm btn-outline" @click="resetFilters">
        <i class="fas fa-redo"></i> 重置筛选
      </button>
    </div>
    
    <div class="stats-bar" v-if="logs.length > 0">
      <span>共找到 <strong>{{ totalCount }}</strong> 条日志</span>
      <span>当前页显示 <strong>{{ logs.length }}</strong> 条</span>
    </div>
    
    <div class="logs-table" v-loading="loading">
      <div v-if="logs.length === 0 && !loading" class="empty-state">
        <i class="fas fa-inbox"></i>
        <p>{{ emptyMessage }}</p>
      </div>
      <table v-else>
        <thead>
          <tr>
            <th width="180">时间</th>
            <th width="100">级别</th>
            <th width="100">类型</th>
            <th width="120">模块</th>
            <th width="120">用户</th>
            <th>操作</th>
            <th width="140">IP地址</th>
            <th width="100">详情</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="log in logs" :key="log.id" :class="getLevelClass(log.level)">
            <td>{{ formatDateTime(log.created_at) }}</td>
            <td>
              <span class="log-level" :class="getLevelClass(log.level)">
                {{ getLevelText(log.level) }}
              </span>
            </td>
            <td>
              <span class="log-type">{{ getLogTypeText(log.log_type) }}</span>
            </td>
            <td>{{ log.module || '-' }}</td>
            <td>{{ getUserDisplay(log.user, log.user_username) }}</td>
            <td class="message-cell">{{ log.message || '-' }}</td>
            <td>{{ log.ip_address || '-' }}</td>
            <td>
              <button class="btn btn-sm btn-outline" @click="viewLogDetail(log)">
                查看
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    
    <div class="pagination">
      <button class="btn btn-outline" @click="previousPage" :disabled="currentPage === 1">
        上一页
      </button>
      <span class="page-info">
        第 {{ currentPage }} 页，共 {{ totalPages }} 页
      </span>
      <button class="btn btn-outline" @click="nextPage" :disabled="currentPage === totalPages">
        下一页
      </button>
    </div>
  </div>
</template>

<script>
import api from '@/api'
import { ElMessage, ElMessageBox } from 'element-plus'

export default {
  name: 'SystemLogs',
  data() {
    return {
      searchQuery: '',
      levelFilter: '',
      logTypeFilter: '',
      dateFilter: '',
      currentPage: 1,
      pageSize: 20,
      totalPages: 1,
      totalCount: 0,
      logs: [],
      loading: false,
      searchTimeout: null
    }
  },
  mounted() {
    this.loadLogs()
  },
  watch: {
    levelFilter() { 
      this.currentPage = 1
      this.loadLogs() 
    },
    logTypeFilter() { 
      this.currentPage = 1
      this.loadLogs() 
    },
    dateFilter() { 
      this.currentPage = 1
      this.loadLogs() 
    },
    currentPage() { this.loadLogs() }
  },
  computed: {
    emptyMessage() {
      if (this.searchQuery || this.levelFilter || this.logTypeFilter || this.dateFilter) {
        return '没有找到符合条件的日志'
      }
      return '暂无日志数据，请先生成一些日志或执行操作'
    }
  },
  methods: {
    getLevelText(level) {
      const levelMap = {
        'DEBUG': '调试',
        'INFO': '信息',
        'WARNING': '警告',
        'ERROR': '错误',
        'CRITICAL': '严重'
      }
      return levelMap[level?.toUpperCase()] || level || '-'
    },
    
    getLevelClass(level) {
      const levelUpper = level?.toUpperCase()
      const classMap = {
        'DEBUG': 'debug',
        'INFO': 'info',
        'WARNING': 'warning',
        'ERROR': 'error',
        'CRITICAL': 'critical'
      }
      return classMap[levelUpper] || 'info'
    },
    
    getLogTypeText(logType) {
      const typeMap = {
        'system': '系统',
        'user': '用户',
        'api': 'API',
        'database': '数据库',
        'security': '安全',
        'business': '业务'
      }
      return typeMap[logType] || logType || '-'
    },
    
    getUserDisplay(user, username) {
      if (username) return username
      if (user) {
        if (typeof user === 'object' && user.username) return user.username
        if (typeof user === 'string') return user
      }
      return '-'
    },
    
    formatDateTime(dateString) {
      if (!dateString) return '-'
      try {
        const date = new Date(dateString)
        const year = date.getFullYear()
        const month = String(date.getMonth() + 1).padStart(2, '0')
        const day = String(date.getDate()).padStart(2, '0')
        const hour = String(date.getHours()).padStart(2, '0')
        const minute = String(date.getMinutes()).padStart(2, '0')
        const second = String(date.getSeconds()).padStart(2, '0')
        return `${year}-${month}-${day} ${hour}:${minute}:${second}`
      } catch (e) {
        return dateString
      }
    },
    
    onSearchInput() {
      // 防抖处理，避免频繁请求
      if (this.searchTimeout) {
        clearTimeout(this.searchTimeout)
      }
      this.searchTimeout = setTimeout(() => {
        this.currentPage = 1
        this.loadLogs()
      }, 500)
    },
    
    resetFilters() {
      this.searchQuery = ''
      this.levelFilter = ''
      this.logTypeFilter = ''
      this.dateFilter = ''
      this.currentPage = 1
      this.loadLogs()
    },
    
    refreshLogs() {
      this.loadLogs()
      ElMessage.success('已刷新')
    },
    
    async loadLogs() {
      try {
        this.loading = true
        const params = {
          page: this.currentPage,
          page_size: this.pageSize
        }
        
        // 添加筛选参数
        if (this.searchQuery && this.searchQuery.trim()) {
          params.search = this.searchQuery.trim()
        }
        if (this.levelFilter) {
          params.level = this.levelFilter
        }
        if (this.logTypeFilter) {
          params.log_type = this.logTypeFilter
        }
        if (this.dateFilter) {
          params.date = this.dateFilter
        }
        
        const response = await api.get('/system/logs/', { params })
        const data = response.data.results || response.data || []
        
        // 直接使用返回的数据，不需要重新映射
        this.logs = data
        
        // 更新统计信息
        if (response.data.count !== undefined) {
          this.totalCount = response.data.count
          this.totalPages = Math.ceil(response.data.count / this.pageSize)
        } else {
          this.totalCount = data.length
          this.totalPages = 1
        }
        
      } catch (error) {
        console.error('加载日志失败:', error)
        ElMessage.error(error.response?.data?.detail || '加载日志失败，请稍后重试')
        this.logs = []
        this.totalCount = 0
        this.totalPages = 1
      } finally {
        this.loading = false
      }
    },
    
    viewLogDetail(log) {
      const user = this.getUserDisplay(log.user, log.user_username)
      const responseStatus = log.response_status || '-'
      const executionTime = log.execution_time ? `${log.execution_time.toFixed(3)}秒` : '-'
      const userAgent = log.user_agent || '-'
      const requestPath = log.request_path || '-'
      const requestMethod = log.request_method || '-'
      const extraData = log.extra_data ? JSON.stringify(log.extra_data, null, 2) : '-'
      
      ElMessageBox.alert(`
        <div style="text-align: left; max-height: 600px; overflow-y: auto;">
          <h3 style="margin-bottom: 15px;">日志详情</h3>
          <table style="width: 100%; border-collapse: collapse;">
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold; width: 120px;">时间</td>
              <td style="padding: 8px;">${this.formatDateTime(log.created_at)}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold;">级别</td>
              <td style="padding: 8px;">${this.getLevelText(log.level)}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold;">类型</td>
              <td style="padding: 8px;">${this.getLogTypeText(log.log_type)}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold;">模块</td>
              <td style="padding: 8px;">${log.module || '-'}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold;">用户</td>
              <td style="padding: 8px;">${user}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold;">消息</td>
              <td style="padding: 8px;">${log.message || '-'}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold;">IP地址</td>
              <td style="padding: 8px;">${log.ip_address || '-'}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold;">请求路径</td>
              <td style="padding: 8px;">${requestPath}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold;">请求方法</td>
              <td style="padding: 8px;">${requestMethod}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold;">响应状态</td>
              <td style="padding: 8px;">${responseStatus}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold;">执行时间</td>
              <td style="padding: 8px;">${executionTime}</td>
            </tr>
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold; vertical-align: top;">User Agent</td>
              <td style="padding: 8px; word-break: break-all;">${userAgent}</td>
            </tr>
            ${extraData !== '-' ? `
            <tr style="border-bottom: 1px solid #eee;">
              <td style="padding: 8px; font-weight: bold; vertical-align: top;">额外数据</td>
              <td style="padding: 8px;"><pre style="margin: 0; background: #f5f5f5; padding: 10px; border-radius: 4px; overflow-x: auto;">${extraData}</pre></td>
            </tr>
            ` : ''}
          </table>
        </div>
      `, '日志详情', {
        dangerouslyUseHTMLString: true,
        confirmButtonText: '关闭',
        customClass: 'log-detail-dialog'
      })
    },
    
    async exportLogs() {
      try {
        await ElMessageBox.confirm('确定要导出当前筛选的日志吗？', '确认导出', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'info'
        })
        
        const params = new URLSearchParams()
        if (this.levelFilter) params.append('level', this.levelFilter)
        if (this.moduleFilter) params.append('module', this.moduleFilter)
        if (this.dateFilter) params.append('date', this.dateFilter)
        
        window.open(`/api/v1/system/logs/export/?${params.toString()}`, '_blank')
        ElMessage.success('日志导出中，请稍候...')
      } catch (error) {
        if (error !== 'cancel') {
          ElMessage.info('已取消导出')
        }
      }
    },
    
    async clearLogs() {
      try {
        await ElMessageBox.confirm('确定要清空所有日志吗？此操作不可恢复！', '警告', {
          confirmButtonText: '确定清空',
          cancelButtonText: '取消',
          type: 'error'
        })
        
        await api.delete('/system/logs/clear/')
        ElMessage.success('日志已清空')
        this.loadLogs()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('清空日志失败:', error)
          ElMessage.error('清空日志失败')
        }
      }
    },
    
    previousPage() {
      if (this.currentPage > 1) {
        this.currentPage--
      }
    },
    
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
      }
    }
  }
}
</script>

<style scoped>
.system-logs {
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
  flex-wrap: wrap;
}

.search-input, .filter-select, .date-input {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-input {
  flex: 1;
  min-width: 250px;
}

.stats-bar {
  display: flex;
  justify-content: space-between;
  padding: 10px 15px;
  background: #f8f9fa;
  border-radius: 4px;
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}

.stats-bar strong {
  color: #007bff;
  font-weight: 600;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
}

.empty-state i {
  font-size: 48px;
  margin-bottom: 15px;
  display: block;
  color: #ddd;
}

.empty-state p {
  font-size: 16px;
  margin: 0;
}

.logs-table {
  background: white;
  border-radius: 8px;
  overflow-x: auto;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  min-height: 200px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

th {
  background-color: #f8f9fa;
  font-weight: 600;
  color: #333;
}

tbody tr:hover {
  background-color: #f5f5f5;
}

tr.info {
  background-color: #ffffff;
}

tr.warning {
  background-color: #fffbf0;
}

tr.error {
  background-color: #fff5f5;
}

tr.critical {
  background-color: #ffe6e6;
}

tr.debug {
  background-color: #f0f8ff;
}

.message-cell {
  max-width: 300px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.log-type {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 3px;
  font-size: 12px;
  background-color: #e9ecef;
  color: #495057;
}

.log-level {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.log-level.info {
  background-color: #d1ecf1;
  color: #0c5460;
}

.log-level.warning {
  background-color: #fff3cd;
  color: #856404;
}

.log-level.error {
  background-color: #f8d7da;
  color: #721c24;
}

.log-level.debug {
  background-color: #e2e3e5;
  color: #383d41;
}

.log-level.critical {
  background-color: #dc3545;
  color: #ffffff;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.header-actions .btn i {
  margin-right: 5px;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
}

.page-info {
  color: #666;
  font-size: 14px;
}

.btn {
  padding: 8px 16px;
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

.btn-outline:hover:not(:disabled) {
  background-color: #007bff;
  color: white;
}

.btn-outline:disabled {
  opacity: 0.5;
  cursor: not-allowed;
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

