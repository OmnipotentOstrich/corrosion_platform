<template>
  <div class="enterprise-projects">
    <div class="page-header">
      <h1>项目管理</h1>
      <div class="header-actions">
        <button class="btn btn-primary" @click="showCreateDialog = true">
          新建项目
        </button>
      </div>
    </div>
    
    <!-- 查看项目详情对话框 -->
    <el-dialog 
      v-model="showViewDialog" 
      title="项目详情" 
      width="700px"
    >
      <div class="project-detail" v-if="currentProject">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="项目名称" :span="2">
            <strong>{{ currentProject.name }}</strong>
          </el-descriptions-item>
          <el-descriptions-item label="项目编号">
            {{ currentProject.project_code || '未设置' }}
          </el-descriptions-item>
          <el-descriptions-item label="项目类型">
            {{ getProjectTypeDisplay(currentProject.project_type) }}
          </el-descriptions-item>
          <el-descriptions-item label="项目状态">
            <el-tag :type="getStatusTagType(currentProject.status)">
              {{ currentProject.statusText }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="进度">
            <el-progress :percentage="currentProject.progress || 0" />
          </el-descriptions-item>
          <el-descriptions-item label="项目描述" :span="2">
            {{ currentProject.description || '暂无描述' }}
          </el-descriptions-item>
          <el-descriptions-item label="开始日期">
            {{ currentProject.start_date || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="截止日期">
            {{ currentProject.end_date || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="项目负责人">
            {{ currentProject.manager || '未设置' }}
          </el-descriptions-item>
          <el-descriptions-item label="项目预算">
            {{ currentProject.budget ? `￥${Number(currentProject.budget).toLocaleString()}` : '未设置' }}
          </el-descriptions-item>
          <el-descriptions-item label="客户名称">
            {{ currentProject.client || '未设置' }}
          </el-descriptions-item>
          <el-descriptions-item label="合同金额">
            {{ currentProject.contract_amount ? `￥${Number(currentProject.contract_amount).toLocaleString()}` : '未设置' }}
          </el-descriptions-item>
          <el-descriptions-item label="项目地点" :span="2">
            {{ currentProject.location || '未设置' }}
          </el-descriptions-item>
          <el-descriptions-item label="联系电话">
            {{ currentProject.contact_phone || '未设置' }}
          </el-descriptions-item>
          <el-descriptions-item label="创建时间">
            {{ formatDate(currentProject.created_at) }}
          </el-descriptions-item>
          <el-descriptions-item label="备注" :span="2">
            {{ currentProject.notes || '无' }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="showViewDialog = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>
    
    <!-- 编辑项目对话框 -->
    <el-dialog 
      v-model="showEditDialog" 
      title="编辑项目" 
      width="700px"
      :before-close="handleCloseEditDialog"
    >
      <el-form 
        ref="editFormRef"
        :model="editForm" 
        :rules="editFormRules" 
        label-width="120px"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目名称" prop="name">
              <el-input v-model="editForm.name" placeholder="请输入项目名称"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="项目编号" prop="project_code">
              <el-input v-model="editForm.project_code" placeholder="请输入项目编号"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="项目描述" prop="description">
          <el-input 
            v-model="editForm.description" 
            type="textarea" 
            :rows="3"
            placeholder="请输入项目描述"
          ></el-input>
        </el-form-item>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目类型" prop="project_type">
              <el-select v-model="editForm.project_type" placeholder="请选择项目类型" style="width: 100%">
                <el-option label="防腐工程" value="corrosion"></el-option>
                <el-option label="保温工程" value="insulation"></el-option>
                <el-option label="综合工程" value="comprehensive"></el-option>
                <el-option label="维护工程" value="maintenance"></el-option>
                <el-option label="其他" value="other"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="项目状态" prop="status">
              <el-select v-model="editForm.status" placeholder="请选择项目状态" style="width: 100%">
                <el-option label="待开始" value="pending"></el-option>
                <el-option label="进行中" value="active"></el-option>
                <el-option label="已完成" value="completed"></el-option>
                <el-option label="暂停" value="paused"></el-option>
                <el-option label="已取消" value="cancelled"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="开始日期" prop="start_date">
              <el-date-picker 
                v-model="editForm.start_date" 
                type="date" 
                placeholder="请选择开始日期"
                style="width: 100%"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
              ></el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="截止日期" prop="end_date">
              <el-date-picker 
                v-model="editForm.end_date" 
                type="date" 
                placeholder="请选择截止日期"
                style="width: 100%"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
              ></el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目负责人" prop="manager">
              <el-input v-model="editForm.manager" placeholder="请输入负责人姓名"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="项目进度" prop="progress">
              <el-slider v-model="editForm.progress" :min="0" :max="100" show-input></el-slider>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目预算" prop="budget">
              <el-input-number 
                v-model="editForm.budget" 
                placeholder="请输入项目预算"
                :min="0"
                :precision="2"
                style="width: 100%"
                :controls="false"
              >
                <template #prefix>￥</template>
              </el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="客户名称" prop="client">
              <el-input v-model="editForm.client" placeholder="请输入客户名称"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="合同金额" prop="contract_amount">
              <el-input-number 
                v-model="editForm.contract_amount" 
                placeholder="请输入合同金额"
                :min="0"
                :precision="2"
                style="width: 100%"
                :controls="false"
              >
                <template #prefix>￥</template>
              </el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" prop="contact_phone">
              <el-input v-model="editForm.contact_phone" placeholder="请输入联系电话"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="项目地点" prop="location">
          <el-input v-model="editForm.location" placeholder="请输入项目地点"></el-input>
        </el-form-item>
        
        <el-form-item label="备注" prop="notes">
          <el-input 
            v-model="editForm.notes" 
            type="textarea" 
            :rows="2"
            placeholder="请输入备注信息（选填）"
          ></el-input>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleCloseEditDialog">取消</el-button>
          <el-button type="primary" @click="submitEditProject" :loading="editing">
            {{ editing ? '保存中...' : '确定保存' }}
          </el-button>
        </div>
      </template>
    </el-dialog>
    
    <!-- 新建项目对话框 -->
    <el-dialog 
      v-model="showCreateDialog" 
      title="新建项目" 
      width="700px"
      :before-close="handleCloseCreateDialog"
    >
      <el-form 
        ref="createFormRef"
        :model="createForm" 
        :rules="createFormRules" 
        label-width="120px"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目名称" prop="name">
              <el-input v-model="createForm.name" placeholder="请输入项目名称"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="项目编号" prop="project_code">
              <el-input v-model="createForm.project_code" placeholder="请输入项目编号"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="项目描述" prop="description">
          <el-input 
            v-model="createForm.description" 
            type="textarea" 
            :rows="3"
            placeholder="请输入项目描述"
          ></el-input>
        </el-form-item>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目类型" prop="project_type">
              <el-select v-model="createForm.project_type" placeholder="请选择项目类型" style="width: 100%">
                <el-option label="防腐工程" value="corrosion"></el-option>
                <el-option label="保温工程" value="insulation"></el-option>
                <el-option label="综合工程" value="comprehensive"></el-option>
                <el-option label="维护工程" value="maintenance"></el-option>
                <el-option label="其他" value="other"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="项目状态" prop="status">
              <el-select v-model="createForm.status" placeholder="请选择项目状态" style="width: 100%">
                <el-option label="待开始" value="pending"></el-option>
                <el-option label="进行中" value="active"></el-option>
                <el-option label="已完成" value="completed"></el-option>
                <el-option label="暂停" value="paused"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="开始日期" prop="start_date">
              <el-date-picker 
                v-model="createForm.start_date" 
                type="date" 
                placeholder="请选择开始日期"
                style="width: 100%"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
              ></el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="截止日期" prop="end_date">
              <el-date-picker 
                v-model="createForm.end_date" 
                type="date" 
                placeholder="请选择截止日期"
                style="width: 100%"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
              ></el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目负责人" prop="manager">
              <el-input v-model="createForm.manager" placeholder="请输入负责人姓名"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="项目预算" prop="budget">
              <el-input-number 
                v-model="createForm.budget" 
                placeholder="请输入项目预算"
                :min="0"
                :precision="2"
                style="width: 100%"
                :controls="false"
              >
                <template #prefix>￥</template>
              </el-input-number>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目地点" prop="location">
              <el-input v-model="createForm.location" placeholder="请输入项目地点"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" prop="contact_phone">
              <el-input v-model="createForm.contact_phone" placeholder="请输入联系电话"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="备注" prop="notes">
          <el-input 
            v-model="createForm.notes" 
            type="textarea" 
            :rows="2"
            placeholder="请输入备注信息（选填）"
          ></el-input>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleCloseCreateDialog">取消</el-button>
          <el-button type="primary" @click="submitCreateProject" :loading="creating">
            {{ creating ? '创建中...' : '确定创建' }}
          </el-button>
        </div>
      </template>
    </el-dialog>
    
    <div class="filters">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="搜索项目..."
        class="search-input"
      >
      <select v-model="statusFilter" class="filter-select">
        <option value="">全部状态</option>
        <option value="active">进行中</option>
        <option value="completed">已完成</option>
        <option value="paused">暂停</option>
      </select>
    </div>
    
    <div class="projects-list" v-loading="loading">
      <div v-if="filteredProjects.length === 0" class="empty-state">
        <p>暂无项目数据</p>
      </div>
      <div v-for="project in filteredProjects" :key="project.id" class="project-card">
        <div class="project-header">
          <h3>{{ project.name }}</h3>
          <span class="status" :class="project.status">{{ project.statusText }}</span>
        </div>
        <p class="project-description">{{ project.description }}</p>
        <div class="project-meta">
          <span>负责人: {{ project.manager }}</span>
          <span>截止日期: {{ project.deadline }}</span>
        </div>
        <div class="project-actions">
          <button class="btn btn-sm btn-outline" @click="viewProject(project)">查看详情</button>
          <button class="btn btn-sm btn-primary" @click="editProject(project)">编辑</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import api from '@/api'
import dayjs from 'dayjs'

// 响应式数据
const loading = ref(false)
const creating = ref(false)
const editing = ref(false)
const searchQuery = ref('')
const statusFilter = ref('')
const projects = ref([])
const showCreateDialog = ref(false)
const showEditDialog = ref(false)
const showViewDialog = ref(false)
const currentProject = ref(null)
const createFormRef = ref()
const editFormRef = ref()

// 创建项目表单
const createForm = ref({
  name: '',
  project_code: '',
  description: '',
  project_type: '',
  status: 'pending',
  start_date: '',
  end_date: '',
  manager: '',
  budget: null,
  location: '',
  contact_phone: '',
  notes: ''
})

// 编辑项目表单
const editForm = ref({
  id: null,
  name: '',
  project_code: '',
  description: '',
  project_type: '',
  status: 'pending',
  start_date: '',
  end_date: '',
  manager: '',
  progress: 0,
  budget: null,
  client: '',
  contract_amount: null,
  location: '',
  contact_phone: '',
  notes: ''
})

// 表单验证规则
const createFormRules = {
  name: [
    { required: true, message: '请输入项目名称', trigger: 'blur' }
  ],
  project_code: [
    { required: true, message: '请输入项目编号', trigger: 'blur' }
  ],
  project_type: [
    { required: true, message: '请选择项目类型', trigger: 'change' }
  ],
  start_date: [
    { required: true, message: '请选择开始日期', trigger: 'change' }
  ],
  end_date: [
    { required: true, message: '请选择截止日期', trigger: 'change' }
  ],
  manager: [
    { required: true, message: '请输入项目负责人', trigger: 'blur' }
  ]
}

const editFormRules = {
  name: [
    { required: true, message: '请输入项目名称', trigger: 'blur' }
  ],
  project_code: [
    { required: true, message: '请输入项目编号', trigger: 'blur' }
  ],
  project_type: [
    { required: true, message: '请选择项目类型', trigger: 'change' }
  ],
  start_date: [
    { required: true, message: '请选择开始日期', trigger: 'change' }
  ],
  end_date: [
    { required: true, message: '请选择截止日期', trigger: 'change' }
  ],
  manager: [
    { required: true, message: '请输入项目负责人', trigger: 'blur' }
  ]
}

// 状态映射
const statusMap = {
  'active': '进行中',
  'completed': '已完成',
  'paused': '暂停',
  'pending': '待开始'
}

// 格式化日期
const formatDate = (date) => {
  return date ? dayjs(date).format('YYYY-MM-DD') : '-'
}

// 过滤后的项目列表
const filteredProjects = computed(() => {
  return projects.value.filter(project => {
    const matchesSearch = !searchQuery.value || 
      project.name?.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      project.description?.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesStatus = !statusFilter.value || project.status === statusFilter.value
    return matchesSearch && matchesStatus
  })
})

// 加载项目列表
const loadProjects = async () => {
  try {
    loading.value = true
    const params = {}
    if (searchQuery.value) params.search = searchQuery.value
    if (statusFilter.value) params.status = statusFilter.value
    
    const response = await api.get('/enterprises/projects/', { params })
    const data = response.data.results || response.data || []
    
    projects.value = data.map(project => ({
      id: project.id,
      name: project.name || project.title || '未命名项目',
      description: project.description || '暂无描述',
      manager: project.manager_name || project.manager || '-',
      deadline: formatDate(project.end_date || project.deadline),
      status: project.status || 'active',
      statusText: statusMap[project.status] || project.status,
      ...project
    }))
  } catch (error) {
    console.error('加载项目列表失败:', error)
    ElMessage.error('加载项目列表失败')
    projects.value = []
  } finally {
    loading.value = false
  }
}

// 提交创建项目
const submitCreateProject = async () => {
  if (!createFormRef.value) return
  
  try {
    const valid = await createFormRef.value.validate()
    if (!valid) return
    
    creating.value = true
    
    // 准备提交数据
    const formData = {
      name: createForm.value.name,
      project_code: createForm.value.project_code,
      description: createForm.value.description,
      project_type: createForm.value.project_type,
      status: createForm.value.status,
      start_date: createForm.value.start_date,
      end_date: createForm.value.end_date,
      manager: createForm.value.manager,
      budget: createForm.value.budget,
      location: createForm.value.location,
      contact_phone: createForm.value.contact_phone,
      notes: createForm.value.notes
    }
    
    await api.post('/enterprises/projects/', formData)
    
    ElMessage.success(`项目 ${createForm.value.name} 创建成功`)
    handleCloseCreateDialog()
    loadProjects()
  } catch (error) {
    console.error('创建项目失败:', error)
    
    if (error.response?.data) {
      const errorData = error.response.data
      if (typeof errorData === 'object') {
        const firstError = Object.values(errorData)[0]
        ElMessage.error(Array.isArray(firstError) ? firstError[0] : firstError)
      } else {
        ElMessage.error(errorData)
      }
    } else {
      ElMessage.error('创建项目失败，请稍后重试')
    }
  } finally {
    creating.value = false
  }
}

// 关闭创建对话框
const handleCloseCreateDialog = () => {
  showCreateDialog.value = false
  resetCreateForm()
}

// 重置创建表单
const resetCreateForm = () => {
  createForm.value = {
    name: '',
    project_code: '',
    description: '',
    project_type: '',
    status: 'pending',
    start_date: '',
    end_date: '',
    manager: '',
    budget: null,
    location: '',
    contact_phone: '',
    notes: ''
  }
  
  if (createFormRef.value) {
    createFormRef.value.clearValidate()
  }
}

// 项目类型显示映射
const getProjectTypeDisplay = (type) => {
  const typeMap = {
    'corrosion': '防腐工程',
    'insulation': '保温工程',
    'comprehensive': '综合工程',
    'maintenance': '维护工程',
    'other': '其他'
  }
  return typeMap[type] || type || '未设置'
}

// 状态标签类型
const getStatusTagType = (status) => {
  const tagTypeMap = {
    'pending': 'info',
    'active': 'success',
    'completed': 'primary',
    'paused': 'warning',
    'cancelled': 'danger'
  }
  return tagTypeMap[status] || 'info'
}

// 查看项目详情
const viewProject = (project) => {
  currentProject.value = project
  showViewDialog.value = true
}

// 打开编辑对话框
const editProject = (project) => {
  // 填充编辑表单
  editForm.value = {
    id: project.id,
    name: project.name || '',
    project_code: project.project_code || '',
    description: project.description || '',
    project_type: project.project_type || '',
    status: project.status || 'pending',
    start_date: project.start_date || '',
    end_date: project.end_date || '',
    manager: project.manager || '',
    progress: project.progress || 0,
    budget: project.budget || null,
    client: project.client || '',
    contract_amount: project.contract_amount || null,
    location: project.location || '',
    contact_phone: project.contact_phone || '',
    notes: project.notes || ''
  }
  
  showEditDialog.value = true
}

// 提交编辑项目
const submitEditProject = async () => {
  if (!editFormRef.value) return
  
  try {
    const valid = await editFormRef.value.validate()
    if (!valid) return
    
    editing.value = true
    
    const formData = {
      name: editForm.value.name,
      project_code: editForm.value.project_code,
      description: editForm.value.description,
      project_type: editForm.value.project_type,
      status: editForm.value.status,
      start_date: editForm.value.start_date,
      end_date: editForm.value.end_date,
      manager: editForm.value.manager,
      progress: editForm.value.progress,
      budget: editForm.value.budget,
      client: editForm.value.client,
      contract_amount: editForm.value.contract_amount,
      location: editForm.value.location,
      contact_phone: editForm.value.contact_phone,
      notes: editForm.value.notes
    }
    
    await api.put(`/enterprises/projects/${editForm.value.id}/`, formData)
    
    ElMessage.success(`项目 ${editForm.value.name} 更新成功`)
    handleCloseEditDialog()
    loadProjects()
  } catch (error) {
    console.error('更新项目失败:', error)
    
    if (error.response?.data) {
      const errorData = error.response.data
      if (typeof errorData === 'object') {
        const firstError = Object.values(errorData)[0]
        ElMessage.error(Array.isArray(firstError) ? firstError[0] : firstError)
      } else {
        ElMessage.error(errorData)
      }
    } else {
      ElMessage.error('更新项目失败，请稍后重试')
    }
  } finally {
    editing.value = false
  }
}

// 关闭编辑对话框
const handleCloseEditDialog = () => {
  showEditDialog.value = false
  resetEditForm()
}

// 重置编辑表单
const resetEditForm = () => {
  editForm.value = {
    id: null,
    name: '',
    project_code: '',
    description: '',
    project_type: '',
    status: 'pending',
    start_date: '',
    end_date: '',
    manager: '',
    progress: 0,
    budget: null,
    client: '',
    contract_amount: null,
    location: '',
    contact_phone: '',
    notes: ''
  }
  
  if (editFormRef.value) {
    editFormRef.value.clearValidate()
  }
}

// 监听搜索和过滤条件变化
watch([searchQuery, statusFilter], () => {
  // 使用computed已经实现了过滤，这里不需要重新加载
})

// 组件挂载时加载数据
onMounted(() => {
  loadProjects()
})
</script>

<style scoped>
.enterprise-projects {
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

.projects-list {
  display: grid;
  gap: 20px;
}

.project-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.project-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.project-header h3 {
  color: #333;
  margin: 0;
}

.status {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.status.active {
  background-color: #d4edda;
  color: #155724;
}

.status.completed {
  background-color: #cce5ff;
  color: #004085;
}

.status.paused {
  background-color: #fff3cd;
  color: #856404;
}

.project-description {
  color: #666;
  margin-bottom: 15px;
}

.project-meta {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}

.project-actions {
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

.btn-outline {
  background-color: transparent;
  color: #007bff;
  border: 1px solid #007bff;
}

.btn-outline:hover {
  background-color: #007bff;
  color: white;
}

.btn-sm {
  padding: 4px 8px;
  font-size: 12px;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
  font-size: 16px;
}
</style>

