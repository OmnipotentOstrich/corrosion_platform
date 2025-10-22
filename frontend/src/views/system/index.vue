<template>
  <div class="system-management">
    <div class="page-header">
      <h1>系统管理</h1>
      <p>管理系统设置和配置</p>
    </div>
    
    <div class="management-grid">
      <div class="management-card">
        <div class="card-icon">
          <i class="fas fa-users"></i>
        </div>
        <div class="card-content">
          <h3>用户管理</h3>
          <p>管理系统用户账户和权限</p>
          <div class="card-stats">
            <span>总用户: {{ stats.totalUsers }}</span>
            <span>活跃用户: {{ stats.activeUsers }}</span>
          </div>
          <router-link to="/dashboard/system/users" class="btn btn-primary">
            进入管理
          </router-link>
        </div>
      </div>
      
      <div class="management-card">
        <div class="card-icon">
          <i class="fas fa-user-shield"></i>
        </div>
        <div class="card-content">
          <h3>角色管理</h3>
          <p>管理系统角色和权限分配</p>
          <div class="card-stats">
            <span>总角色: {{ stats.totalRoles }}</span>
            <span>权限项: {{ stats.totalPermissions }}</span>
          </div>
          <router-link to="/dashboard/system/roles" class="btn btn-primary">
            进入管理
          </router-link>
        </div>
      </div>
      
      <div class="management-card">
        <div class="card-icon">
          <i class="fas fa-file-alt"></i>
        </div>
        <div class="card-content">
          <h3>系统日志</h3>
          <p>查看系统操作日志和审计记录</p>
          <div class="card-stats">
            <span>今日日志: {{ stats.todayLogs }}</span>
            <span>总日志: {{ stats.totalLogs }}</span>
          </div>
          <router-link to="/dashboard/system/logs" class="btn btn-primary">
            查看日志
          </router-link>
        </div>
      </div>
      
      <div class="management-card">
        <div class="card-icon">
          <i class="fas fa-cog"></i>
        </div>
        <div class="card-content">
          <h3>系统配置</h3>
          <p>管理系统配置项和参数设置</p>
          <div class="card-stats">
            <span>配置项: {{ stats.configItems }}</span>
            <span>最后更新: {{ stats.lastUpdate }}</span>
          </div>
          <router-link to="/dashboard/system/configs" class="btn btn-primary">
            配置管理
          </router-link>
        </div>
      </div>
      
      <div class="management-card">
        <div class="card-icon">
          <i class="fas fa-database"></i>
        </div>
        <div class="card-content">
          <h3>系统备份</h3>
          <p>创建和管理系统数据备份</p>
          <div class="card-stats">
            <span>备份数量: {{ stats.totalBackups }}</span>
            <span>最新备份: {{ stats.lastBackup }}</span>
          </div>
          <router-link to="/dashboard/system/backups" class="btn btn-primary">
            备份管理
          </router-link>
        </div>
      </div>
      
      <div class="management-card">
        <div class="card-icon">
          <i class="fas fa-tachometer-alt"></i>
        </div>
        <div class="card-content">
          <h3>系统监控</h3>
          <p>实时监控系统资源和性能</p>
          <div class="card-stats">
            <span>CPU: {{ stats.cpuUsage }}%</span>
            <span>内存: {{ stats.memoryUsage }}%</span>
          </div>
          <router-link to="/dashboard/system/monitor" class="btn btn-primary">
            查看监控
          </router-link>
        </div>
      </div>
    </div>
    
    <div class="system-overview">
      <h2>系统概览</h2>
      <div class="overview-grid">
        <div class="overview-item">
          <div class="overview-value">{{ stats.totalUsers }}</div>
          <div class="overview-label">注册用户</div>
        </div>
        <div class="overview-item">
          <div class="overview-value">{{ stats.totalProjects }}</div>
          <div class="overview-label">项目总数</div>
        </div>
        <div class="overview-item">
          <div class="overview-value">{{ stats.totalResources }}</div>
          <div class="overview-label">资源文件</div>
        </div>
        <div class="overview-item">
          <div class="overview-value">{{ stats.totalInfos }}</div>
          <div class="overview-label">信息发布</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import api from '@/api'

// 系统统计数据
const stats = ref({
  totalUsers: 0,
  activeUsers: 0,
  totalRoles: 0,
  totalPermissions: 0,
  todayLogs: 0,
  totalLogs: 0,
  configItems: 0,
  lastUpdate: '-',
  totalProjects: 0,
  totalResources: 0,
  totalInfos: 0,
  totalBackups: 0,
  lastBackup: '-',
  cpuUsage: 0,
  memoryUsage: 0
})

// 加载系统统计数据
const loadSystemStats = async () => {
  try {
    // 加载仪表板统计数据
    const response = await api.get('/system/statistics/dashboard/')
    if (response.data) {
      stats.value = {
        totalUsers: response.data.total_users || 0,
        activeUsers: response.data.active_users || 0,
        totalRoles: response.data.total_roles || 0,
        totalPermissions: response.data.total_permissions || 0,
        todayLogs: response.data.today_logs || 0,
        totalLogs: response.data.total_logs || 0,
        configItems: response.data.config_items || 0,
        lastUpdate: response.data.last_update || '-',
        totalProjects: response.data.total_projects || 0,
        totalResources: response.data.total_resources || 0,
        totalInfos: response.data.total_infos || 0,
        totalBackups: response.data.total_backups || 0,
        lastBackup: response.data.last_backup || '-',
        cpuUsage: response.data.cpu_usage || 0,
        memoryUsage: response.data.memory_usage || 0
      }
    }
  } catch (error) {
    console.error('加载系统统计数据失败:', error)
    // 如果API调用失败，使用默认值
  }
}

onMounted(() => {
  loadSystemStats()
})
</script>

<style scoped>
.system-management {
  padding: 20px;
}

.page-header {
  margin-bottom: 30px;
}

.page-header h1 {
  color: #333;
  margin-bottom: 10px;
}

.page-header p {
  color: #666;
  font-size: 16px;
}

.management-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
}

.management-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
  display: flex;
  align-items: center;
  gap: 15px;
}

.card-icon {
  flex-shrink: 0;
}

.card-icon i {
  font-size: 2.5em;
  color: #007bff;
}

.card-content {
  flex: 1;
}

.card-content h3 {
  color: #333;
  margin-bottom: 8px;
}

.card-content p {
  color: #666;
  margin-bottom: 10px;
  font-size: 14px;
}

.card-stats {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
  font-size: 12px;
  color: #666;
}

.btn {
  padding: 8px 16px;
  border-radius: 4px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s;
  text-decoration: none;
  display: inline-block;
}

.btn-primary {
  background-color: #007bff;
  color: white;
}

.btn-primary:hover {
  background-color: #0056b3;
}

.system-overview {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.system-overview h2 {
  color: #333;
  margin-bottom: 20px;
}

.overview-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.overview-item {
  text-align: center;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 8px;
}

.overview-value {
  font-size: 2em;
  font-weight: bold;
  color: #007bff;
  margin-bottom: 5px;
}

.overview-label {
  color: #666;
  font-size: 14px;
}
</style>

