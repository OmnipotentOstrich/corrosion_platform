<template>
  <div class="system-configs">
    <div class="page-header">
      <h1>系统配置</h1>
      <div class="header-actions">
        <el-button type="primary" @click="showAddDialog">
          <el-icon><Plus /></el-icon>
          添加配置
        </el-button>
      </div>
    </div>

    <div class="filters">
      <el-input
        v-model="searchQuery"
        placeholder="搜索配置项..."
        clearable
        class="search-input"
        prefix-icon="Search"
      />
      <el-select v-model="typeFilter" placeholder="配置类型" clearable>
        <el-option label="全部类型" value="" />
        <el-option label="基础配置" value="basic" />
        <el-option label="邮件配置" value="email" />
        <el-option label="短信配置" value="sms" />
        <el-option label="存储配置" value="storage" />
        <el-option label="安全配置" value="security" />
        <el-option label="业务配置" value="business" />
        <el-option label="其他配置" value="other" />
      </el-select>
      <el-select v-model="statusFilter" placeholder="状态" clearable>
        <el-option label="全部状态" value="" />
        <el-option label="已启用" value="true" />
        <el-option label="已禁用" value="false" />
      </el-select>
    </div>

    <el-table
      v-loading="loading"
      :data="configs"
      stripe
      border
      style="width: 100%"
    >
      <el-table-column prop="key" label="配置键" width="200" />
      <el-table-column prop="config_type_display" label="类型" width="120">
        <template #default="{ row }">
          <el-tag :type="getTypeColor(row.config_type)">
            {{ row.config_type_display }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="value" label="配置值" show-overflow-tooltip>
        <template #default="{ row }">
          <span v-if="row.is_encrypted">********</span>
          <span v-else>{{ row.value }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="description" label="描述" show-overflow-tooltip />
      <el-table-column prop="is_active" label="状态" width="100">
        <template #default="{ row }">
          <el-switch
            v-model="row.is_active"
            @change="toggleStatus(row)"
          />
        </template>
      </el-table-column>
      <el-table-column prop="updated_at" label="更新时间" width="180">
        <template #default="{ row }">
          {{ formatDate(row.updated_at) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right">
        <template #default="{ row }">
          <el-button
            type="primary"
            size="small"
            @click="editConfig(row)"
          >
            编辑
          </el-button>
          <el-button
            type="danger"
            size="small"
            @click="deleteConfig(row)"
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
        :page-sizes="[10, 20, 50, 100]"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="loadConfigs"
        @current-change="loadConfigs"
      />
    </div>

    <!-- 添加/编辑配置对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑配置' : '添加配置'"
      width="600px"
    >
      <el-form
        ref="configFormRef"
        :model="configForm"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="配置键" prop="key">
          <el-input
            v-model="configForm.key"
            placeholder="例如: site_name"
            :disabled="isEdit"
          />
        </el-form-item>
        <el-form-item label="配置类型" prop="config_type">
          <el-select v-model="configForm.config_type" style="width: 100%">
            <el-option label="基础配置" value="basic" />
            <el-option label="邮件配置" value="email" />
            <el-option label="短信配置" value="sms" />
            <el-option label="存储配置" value="storage" />
            <el-option label="安全配置" value="security" />
            <el-option label="业务配置" value="business" />
            <el-option label="其他配置" value="other" />
          </el-select>
        </el-form-item>
        <el-form-item label="配置值" prop="value">
          <el-input
            v-model="configForm.value"
            type="textarea"
            :rows="3"
            placeholder="输入配置值"
          />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="configForm.description"
            type="textarea"
            :rows="2"
            placeholder="配置项的描述说明"
          />
        </el-form-item>
        <el-form-item label="是否加密">
          <el-switch v-model="configForm.is_encrypted" />
          <span class="form-tip">启用后配置值将被加密存储</span>
        </el-form-item>
        <el-form-item label="是否启用">
          <el-switch v-model="configForm.is_active" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search } from '@element-plus/icons-vue'
import api from '@/api'

const loading = ref(false)
const searchQuery = ref('')
const typeFilter = ref('')
const statusFilter = ref('')
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)
const configs = ref([])

const dialogVisible = ref(false)
const isEdit = ref(false)
const configFormRef = ref(null)
const configForm = ref({
  key: '',
  config_type: 'basic',
  value: '',
  description: '',
  is_encrypted: false,
  is_active: true
})

const formRules = {
  key: [
    { required: true, message: '请输入配置键', trigger: 'blur' },
    { pattern: /^[a-z_]+$/, message: '配置键只能包含小写字母和下划线', trigger: 'blur' }
  ],
  config_type: [
    { required: true, message: '请选择配置类型', trigger: 'change' }
  ],
  value: [
    { required: true, message: '请输入配置值', trigger: 'blur' }
  ]
}

// 加载配置列表
const loadConfigs = async () => {
  try {
    loading.value = true
    const params = {
      page: currentPage.value,
      page_size: pageSize.value
    }
    if (searchQuery.value) params.search = searchQuery.value
    if (typeFilter.value) params.config_type = typeFilter.value
    if (statusFilter.value) params.is_active = statusFilter.value

    const response = await api.get('/system/configs/', { params })
    configs.value = response.data.results || response.data
    total.value = response.data.count || configs.value.length

    // 添加类型显示名称
    configs.value = configs.value.map(config => ({
      ...config,
      config_type_display: getTypeDisplay(config.config_type)
    }))
  } catch (error) {
    console.error('加载配置失败:', error)
    ElMessage.error('加载配置失败')
  } finally {
    loading.value = false
  }
}

// 获取类型显示名称
const getTypeDisplay = (type) => {
  const typeMap = {
    basic: '基础配置',
    email: '邮件配置',
    sms: '短信配置',
    storage: '存储配置',
    security: '安全配置',
    business: '业务配置',
    other: '其他配置'
  }
  return typeMap[type] || type
}

// 获取类型颜色
const getTypeColor = (type) => {
  const colorMap = {
    basic: 'primary',
    email: 'success',
    sms: 'warning',
    storage: 'info',
    security: 'danger',
    business: '',
    other: 'info'
  }
  return colorMap[type] || ''
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleString('zh-CN')
}

// 显示添加对话框
const showAddDialog = () => {
  isEdit.value = false
  configForm.value = {
    key: '',
    config_type: 'basic',
    value: '',
    description: '',
    is_encrypted: false,
    is_active: true
  }
  dialogVisible.value = true
}

// 编辑配置
const editConfig = (row) => {
  isEdit.value = true
  configForm.value = { ...row }
  dialogVisible.value = true
}

// 切换状态
const toggleStatus = async (row) => {
  try {
    await api.patch(`/system/configs/${row.id}/`, {
      is_active: row.is_active
    })
    ElMessage.success('状态更新成功')
  } catch (error) {
    console.error('更新状态失败:', error)
    ElMessage.error('更新状态失败')
    row.is_active = !row.is_active // 回滚状态
  }
}

// 删除配置
const deleteConfig = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除配置"${row.key}"吗？此操作不可恢复！`,
      '警告',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )

    await api.delete(`/system/configs/${row.id}/`)
    ElMessage.success('删除成功')
    loadConfigs()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除配置失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 提交表单
const submitForm = async () => {
  try {
    await configFormRef.value.validate()

    if (isEdit.value) {
      await api.put(`/system/configs/${configForm.value.id}/`, configForm.value)
      ElMessage.success('更新成功')
    } else {
      await api.post('/system/configs/', configForm.value)
      ElMessage.success('添加成功')
    }

    dialogVisible.value = false
    loadConfigs()
  } catch (error) {
    if (error !== false) { // 不是表单验证错误
      console.error('保存配置失败:', error)
      ElMessage.error('保存失败')
    }
  }
}

// 监听筛选条件变化
watch([searchQuery, typeFilter, statusFilter], () => {
  currentPage.value = 1
  loadConfigs()
})

onMounted(() => {
  loadConfigs()
})
</script>

<style scoped>
.system-configs {
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

.search-input {
  width: 300px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.form-tip {
  margin-left: 10px;
  font-size: 12px;
  color: #999;
}
</style>

