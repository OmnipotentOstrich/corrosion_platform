<template>
  <div class="system-backups">
    <div class="page-header">
      <h1>系统备份</h1>
      <div class="header-actions">
        <el-button type="primary" @click="showBackupDialog">
          <el-icon><FolderAdd /></el-icon>
          创建备份
        </el-button>
      </div>
    </div>

    <el-alert
      title="备份提示"
      type="info"
      description="建议定期进行系统备份，以防数据丢失。数据库备份会包含所有业务数据，文件备份会包含上传的资源文件。"
      :closable="false"
      style="margin-bottom: 20px"
    />

    <div class="filters">
      <el-select v-model="typeFilter" placeholder="备份类型" clearable>
        <el-option label="全部类型" value="" />
        <el-option label="数据库备份" value="database" />
        <el-option label="文件备份" value="files" />
        <el-option label="完整备份" value="full" />
      </el-select>
      <el-select v-model="statusFilter" placeholder="备份状态" clearable>
        <el-option label="全部状态" value="" />
        <el-option label="待执行" value="pending" />
        <el-option label="执行中" value="running" />
        <el-option label="已完成" value="completed" />
        <el-option label="失败" value="failed" />
      </el-select>
    </div>

    <el-table
      v-loading="loading"
      :data="backups"
      stripe
      border
      style="width: 100%"
    >
      <el-table-column prop="name" label="备份名称" width="250" />
      <el-table-column prop="backup_type" label="类型" width="120">
        <template #default="{ row }">
          <el-tag :type="getBackupTypeColor(row.backup_type)">
            {{ getBackupTypeDisplay(row.backup_type) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="getStatusColor(row.status)">
            {{ getStatusDisplay(row.status) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="file_size" label="文件大小" width="120">
        <template #default="{ row }">
          {{ formatFileSize(row.file_size) }}
        </template>
      </el-table-column>
      <el-table-column prop="description" label="描述" show-overflow-tooltip />
      <el-table-column prop="start_time" label="开始时间" width="180">
        <template #default="{ row }">
          {{ formatDate(row.start_time) }}
        </template>
      </el-table-column>
      <el-table-column prop="end_time" label="完成时间" width="180">
        <template #default="{ row }">
          {{ formatDate(row.end_time) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button
            v-if="row.status === 'completed'"
            type="success"
            size="small"
            @click="downloadBackup(row)"
          >
            下载
          </el-button>
          <el-button
            type="primary"
            size="small"
            @click="viewBackupDetail(row)"
          >
            详情
          </el-button>
          <el-button
            type="danger"
            size="small"
            @click="deleteBackup(row)"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <div class="pagination">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50]"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="loadBackups"
        @current-change="loadBackups"
      />
    </div>

    <!-- 创建备份对话框 -->
    <el-dialog
      v-model="dialogVisible"
      title="创建系统备份"
      width="500px"
    >
      <el-form
        ref="backupFormRef"
        :model="backupForm"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="备份类型" prop="backup_type">
          <el-radio-group v-model="backupForm.backup_type">
            <el-radio label="database">数据库备份</el-radio>
            <el-radio label="files">文件备份</el-radio>
            <el-radio label="full">完整备份</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备份名称" prop="name">
          <el-input
            v-model="backupForm.name"
            placeholder="留空将自动生成"
          />
        </el-form-item>
        <el-form-item label="备份描述">
          <el-input
            v-model="backupForm.description"
            type="textarea"
            :rows="3"
            placeholder="可选的备份说明"
          />
        </el-form-item>
        <el-alert
          :title="getBackupTypeHint(backupForm.backup_type)"
          type="info"
          :closable="false"
          show-icon
        />
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="creating" @click="createBackup">
          开始备份
        </el-button>
      </template>
    </el-dialog>

    <!-- 备份详情对话框 -->
    <el-dialog
      v-model="detailVisible"
      title="备份详情"
      width="600px"
    >
      <el-descriptions :column="2" border>
        <el-descriptions-item label="备份名称">
          {{ currentBackup.name }}
        </el-descriptions-item>
        <el-descriptions-item label="备份类型">
          <el-tag :type="getBackupTypeColor(currentBackup.backup_type)">
            {{ getBackupTypeDisplay(currentBackup.backup_type) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="备份状态">
          <el-tag :type="getStatusColor(currentBackup.status)">
            {{ getStatusDisplay(currentBackup.status) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="文件大小">
          {{ formatFileSize(currentBackup.file_size) }}
        </el-descriptions-item>
        <el-descriptions-item label="文件路径" :span="2">
          {{ currentBackup.file_path || '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="开始时间">
          {{ formatDate(currentBackup.start_time) }}
        </el-descriptions-item>
        <el-descriptions-item label="完成时间">
          {{ formatDate(currentBackup.end_time) }}
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">
          {{ formatDate(currentBackup.created_at) }}
        </el-descriptions-item>
        <el-descriptions-item label="创建人">
          {{ currentBackup.created_by_name || '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="描述" :span="2">
          {{ currentBackup.description || '-' }}
        </el-descriptions-item>
        <el-descriptions-item v-if="currentBackup.error_message" label="错误信息" :span="2">
          <el-text type="danger">{{ currentBackup.error_message }}</el-text>
        </el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { FolderAdd } from '@element-plus/icons-vue'
import api from '@/api'

const loading = ref(false)
const creating = ref(false)
const typeFilter = ref('')
const statusFilter = ref('')
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)
const backups = ref([])

const dialogVisible = ref(false)
const detailVisible = ref(false)
const backupFormRef = ref(null)
const backupForm = ref({
  backup_type: 'database',
  name: '',
  description: ''
})
const currentBackup = ref({})

const formRules = {
  backup_type: [
    { required: true, message: '请选择备份类型', trigger: 'change' }
  ]
}

// 加载备份列表
const loadBackups = async () => {
  try {
    loading.value = true
    const params = {
      page: currentPage.value,
      page_size: pageSize.value
    }
    if (typeFilter.value) params.backup_type = typeFilter.value
    if (statusFilter.value) params.status = statusFilter.value

    const response = await api.get('/system/backups/', { params })
    backups.value = response.data.results || response.data
    total.value = response.data.count || backups.value.length
  } catch (error) {
    console.error('加载备份列表失败:', error)
    ElMessage.error('加载备份列表失败')
  } finally {
    loading.value = false
  }
}

// 获取备份类型显示
const getBackupTypeDisplay = (type) => {
  const typeMap = {
    database: '数据库',
    files: '文件',
    full: '完整'
  }
  return typeMap[type] || type
}

// 获取备份类型颜色
const getBackupTypeColor = (type) => {
  const colorMap = {
    database: 'primary',
    files: 'success',
    full: 'warning'
  }
  return colorMap[type] || ''
}

// 获取状态显示
const getStatusDisplay = (status) => {
  const statusMap = {
    pending: '待执行',
    running: '执行中',
    completed: '已完成',
    failed: '失败'
  }
  return statusMap[status] || status
}

// 获取状态颜色
const getStatusColor = (status) => {
  const colorMap = {
    pending: 'info',
    running: 'warning',
    completed: 'success',
    failed: 'danger'
  }
  return colorMap[status] || ''
}

// 获取备份类型提示
const getBackupTypeHint = (type) => {
  const hints = {
    database: '将备份所有数据库表和数据，包括用户、企业、项目、资源等业务数据',
    files: '将备份所有上传的文件，包括图片、文档、资源文件等',
    full: '将同时备份数据库和文件，这是最完整的备份方式，但需要较长时间'
  }
  return hints[type] || ''
}

// 格式化文件大小
const formatFileSize = (bytes) => {
  if (!bytes) return '-'
  if (bytes < 1024) return bytes + ' B'
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + ' KB'
  if (bytes < 1024 * 1024 * 1024) return (bytes / (1024 * 1024)).toFixed(2) + ' MB'
  return (bytes / (1024 * 1024 * 1024)).toFixed(2) + ' GB'
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleString('zh-CN')
}

// 显示备份对话框
const showBackupDialog = () => {
  backupForm.value = {
    backup_type: 'database',
    name: '',
    description: ''
  }
  dialogVisible.value = true
}

// 创建备份
const createBackup = async () => {
  try {
    await backupFormRef.value.validate()
    creating.value = true

    await api.post('/system/backups/', backupForm.value)
    ElMessage.success('备份任务已创建，正在执行...')
    dialogVisible.value = false
    
    // 延迟刷新列表，给后端一点时间处理
    setTimeout(() => {
      loadBackups()
    }, 1000)
  } catch (error) {
    if (error !== false) {
      console.error('创建备份失败:', error)
      ElMessage.error('创建备份失败')
    }
  } finally {
    creating.value = false
  }
}

// 查看备份详情
const viewBackupDetail = (row) => {
  currentBackup.value = { ...row }
  detailVisible.value = true
}

// 下载备份
const downloadBackup = async (row) => {
  try {
    if (!row.file_path) {
      ElMessage.warning('该备份没有可下载的文件')
      return
    }

    ElMessage.info('备份下载功能开发中...')
    // 实际项目中应该调用下载API
    // window.open(`/api/v1/system/backups/${row.id}/download/`, '_blank')
  } catch (error) {
    console.error('下载备份失败:', error)
    ElMessage.error('下载失败')
  }
}

// 删除备份
const deleteBackup = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除备份"${row.name}"吗？删除后无法恢复！`,
      '警告',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )

    await api.delete(`/system/backups/${row.id}/`)
    ElMessage.success('删除成功')
    loadBackups()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除备份失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 监听筛选条件变化
watch([typeFilter, statusFilter], () => {
  currentPage.value = 1
  loadBackups()
})

onMounted(() => {
  loadBackups()
})
</script>

<style scoped>
.system-backups {
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

.filters {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>

