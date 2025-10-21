<template>
  <div class="system-logs">
    <div class="page-header">
      <h1>系统日志</h1>
      <div class="header-actions">
        <button class="btn btn-outline" @click="exportLogs">
          导出日志
        </button>
        <button class="btn btn-danger" @click="clearLogs">
          清空日志
        </button>
      </div>
    </div>
    
    <div class="filters">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="搜索日志..."
        class="search-input"
      >
      <select v-model="levelFilter" class="filter-select">
        <option value="">全部级别</option>
        <option value="info">信息</option>
        <option value="warning">警告</option>
        <option value="error">错误</option>
        <option value="debug">调试</option>
      </select>
      <select v-model="moduleFilter" class="filter-select">
        <option value="">全部模块</option>
        <option value="auth">认证模块</option>
        <option value="user">用户模块</option>
        <option value="project">项目模块</option>
        <option value="system">系统模块</option>
      </select>
      <input 
        type="date" 
        v-model="dateFilter" 
        class="date-input"
      >
    </div>
    
    <div class="logs-table" v-loading="loading">
      <table>
        <thead>
          <tr>
            <th>时间</th>
            <th>级别</th>
            <th>模块</th>
            <th>用户</th>
            <th>操作</th>
            <th>IP地址</th>
            <th>详情</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="log in filteredLogs" :key="log.id" :class="log.level">
            <td>{{ log.timestamp }}</td>
            <td>
              <span class="log-level" :class="log.level">{{ log.levelText }}</span>
            </td>
            <td>{{ log.module }}</td>
            <td>{{ log.user }}</td>
            <td>{{ log.action }}</td>
            <td>{{ log.ip }}</td>
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
export default {
  name: 'SystemLogs',
  data() {
    return {
      searchQuery: '',
      levelFilter: '',
      moduleFilter: '',
      dateFilter: '',
      currentPage: 1,
      pageSize: 20,
      totalPages: 1,
      logs: [],
      loading: false
    }
  },
  mounted() {
    this.loadLogs()
  },
  watch: {
    searchQuery() { this.loadLogs() },
    levelFilter() { this.loadLogs() },
    moduleFilter() { this.loadLogs() },
    dateFilter() { this.loadLogs() },
    currentPage() { this.loadLogs() }
  },
  computed: {
    filteredLogs() {
      return this.logs.filter(log => {
        const matchesSearch = log.action.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                             log.detail.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                             log.user.toLowerCase().includes(this.searchQuery.toLowerCase())
        const matchesLevel = !this.levelFilter || log.level === this.levelFilter
        const matchesModule = !this.moduleFilter || log.module === this.moduleFilter
        const matchesDate = !this.dateFilter || log.timestamp.startsWith(this.dateFilter)
        return matchesSearch && matchesLevel && matchesModule && matchesDate
      })
    }
  },
  methods: {
    async loadLogs() {
      try {
        this.loading = true
        const params = {
          page: this.currentPage,
          page_size: this.pageSize
        }
        if (this.searchQuery) params.search = this.searchQuery
        if (this.levelFilter) params.level = this.levelFilter
        if (this.moduleFilter) params.module = this.moduleFilter
        if (this.dateFilter) params.date = this.dateFilter
        
        const response = await this.$api.get('/system/logs/', { params }).catch(() => ({ data: { results: [] } }))
        this.logs = response.data.results || response.data
        if (response.data.count) {
          this.totalPages = Math.ceil(response.data.count / this.pageSize)
        }
      } catch (error) {
        console.error('加载日志失败:', error)
        this.$message.error('加载日志失败')
      } finally {
        this.loading = false
      }
    },
    
    viewLogDetail(log) {
      this.$alert(`
        <div style="text-align: left;">
          <h3>日志详情</h3>
          <p><strong>时间：</strong>${log.timestamp}</p>
          <p><strong>级别：</strong>${log.levelText}</p>
          <p><strong>模块：</strong>${log.module}</p>
          <p><strong>用户：</strong>${log.user}</p>
          <p><strong>操作：</strong>${log.action}</p>
          <p><strong>IP地址：</strong>${log.ip}</p>
          <p><strong>详情：</strong>${log.detail}</p>
        </div>
      `, '日志详情', {
        dangerouslyUseHTMLString: true,
        confirmButtonText: '关闭'
      })
    },
    async exportLogs() {
      try {
        await this.$confirm('确定要导出当前筛选的日志吗？', '确认导出', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'info'
        })
        
        const params = new URLSearchParams()
        if (this.levelFilter) params.append('level', this.levelFilter)
        if (this.moduleFilter) params.append('module', this.moduleFilter)
        if (this.dateFilter) params.append('date', this.dateFilter)
        
        window.open(`/api/v1/system/logs/export/?${params.toString()}`, '_blank')
        this.$message.success('日志导出中，请稍候...')
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.info('已取消导出')
        }
      }
    },
    
    async clearLogs() {
      try {
        await this.$confirm('确定要清空所有日志吗？此操作不可恢复！', '警告', {
          confirmButtonText: '确定清空',
          cancelButtonText: '取消',
          type: 'error'
        })
        
        await this.$api.delete('/system/logs/clear/')
        this.$message.success('日志已清空')
        this.loadLogs()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('清空日志失败:', error)
          this.$message.error('清空日志失败')
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
  },
  
  beforeCreate() {
    this.$api = this.$root.$options.globalProperties.$api || require('@/api').default
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
  max-width: 300px;
}

.logs-table {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
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

tr.info {
  background-color: #f8f9fa;
}

tr.warning {
  background-color: #fff3cd;
}

tr.error {
  background-color: #f8d7da;
}

tr.debug {
  background-color: #d1ecf1;
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

