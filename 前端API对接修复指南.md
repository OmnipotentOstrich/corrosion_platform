# 前端API对接修复指南

## 概述

本指南说明如何将前端页面从使用模拟数据改为调用真实的后端API。

## 已完成的修复

### ✅ 1. 用户认证模块
**文件**: `frontend/src/stores/user.js`, `frontend/src/views/Login.vue`
- 登录功能
- 注册功能
- 用户信息获取
- 用户菜单获取
- 三个测试登录按钮

### ✅ 2. 仪表板模块
**文件**: `frontend/src/views/dashboard/Home.vue`
- 统计数据
- 最近活动
- 待办任务
- 系统通知

### ✅ 3. 个人中心模块
**文件**: `frontend/src/views/personal/index.vue`
- 个人统计数据（项目、任务、完成率）

### ✅ 4. 企业中心模块
**文件**: `frontend/src/views/enterprise/index.vue`
- 企业统计数据

### ✅ 5. 系统管理模块
**文件**: `frontend/src/views/system/index.vue`
- 系统统计数据

## 修复步骤模板

### 步骤1：从Options API转换为Composition API

**之前（Options API）:**
```vue
<script>
export default {
  data() {
    return {
      items: []
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    loadData() {
      // 模拟数据
      this.items = [{ id: 1, name: '测试' }]
    }
  }
}
</script>
```

**之后（Composition API）:**
```vue
<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import api from '@/api'

const items = ref([])

const loadData = async () => {
  try {
    const response = await api.get('/your-endpoint/')
    items.value = response.data
  } catch (error) {
    console.error('加载数据失败:', error)
    ElMessage.error('加载数据失败')
  }
}

onMounted(() => {
  loadData()
})
</script>
```

### 步骤2：修改模板绑定

**之前:**
```vue
<template>
  <div>{{ items }}</div>
</template>
```

**之后（Composition API不需要this）:**
```vue
<template>
  <div>{{ items }}</div>
</template>
```

### 步骤3：处理加载状态

```vue
<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import api from '@/api'

const loading = ref(false)
const items = ref([])

const loadData = async () => {
  try {
    loading.value = true
    const response = await api.get('/your-endpoint/')
    items.value = response.data
  } catch (error) {
    console.error('加载数据失败:', error)
    ElMessage.error('加载数据失败')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadData()
})
</script>

<template>
  <div v-loading="loading">
    <!-- 内容 -->
  </div>
</template>
```

## 待修复页面清单

### 优先级1：核心数据展示

#### 1. 个人项目列表
**文件**: `frontend/src/views/personal/Projects.vue`
**API**: `/api/v1/persons/projects/`
**修复内容**:
```javascript
// 加载项目列表
const loadProjects = async () => {
  try {
    const response = await api.get('/persons/projects/')
    projects.value = response.data
  } catch (error) {
    console.error('加载项目失败:', error)
  }
}
```

#### 2. 个人任务列表
**文件**: `frontend/src/views/personal/Tasks.vue`
**API**: `/api/v1/persons/tasks/`
**修复内容**:
```javascript
// 加载任务列表
const loadTasks = async () => {
  try {
    const response = await api.get('/persons/tasks/')
    tasks.value = response.data
  } catch (error) {
    console.error('加载任务失败:', error)
  }
}

// 完成任务
const completeTask = async (taskId) => {
  try {
    await api.post(`/persons/tasks/${taskId}/complete/`)
    ElMessage.success('任务已完成')
    loadTasks() // 刷新列表
  } catch (error) {
    ElMessage.error('操作失败')
  }
}
```

#### 3. 企业项目列表
**文件**: `frontend/src/views/enterprise/Projects.vue`
**API**: `/api/v1/enterprises/projects/`

#### 4. 企业员工列表
**文件**: `frontend/src/views/enterprise/Employees.vue`
**API**: `/api/v1/enterprises/employees/`

#### 5. 信息广场列表
**文件**: `frontend/src/views/info-plaza/index.vue`
**API**: `/api/v1/info-plaza/posts/`
**修复内容**:
```javascript
// 加载信息列表
const loadPosts = async () => {
  try {
    const response = await api.get('/info-plaza/posts/', {
      params: {
        page: currentPage.value,
        page_size: pageSize.value,
        status: 'published'
      }
    })
    posts.value = response.data.results || response.data
    total.value = response.data.count || 0
  } catch (error) {
    console.error('加载信息失败:', error)
  }
}

// 点赞
const likePost = async (postId) => {
  try {
    await api.post(`/info-plaza/posts/${postId}/like/`)
    ElMessage.success('点赞成功')
    loadPosts()
  } catch (error) {
    ElMessage.error('操作失败')
  }
}
```

#### 6. 信息详情
**文件**: `frontend/src/views/info-plaza/Detail.vue`
**API**: `/api/v1/info-plaza/posts/{id}/`

#### 7. 资源列表
**文件**: `frontend/src/views/resources/index.vue`
**API**: `/api/v1/resources/`

#### 8. 资源详情
**文件**: `frontend/src/views/resources/Detail.vue`
**API**: `/api/v1/resources/{id}/`

### 优先级2：管理功能

#### 9. 用户管理
**文件**: `frontend/src/views/system/Users.vue`
**API**: `/api/v1/auth/users/`

#### 10. 角色管理
**文件**: `frontend/src/views/system/Roles.vue`
**API**: `/api/v1/auth/roles/`

#### 11. 系统日志
**文件**: `frontend/src/views/system/Logs.vue`
**API**: `/api/v1/system/logs/`

## 通用API调用模式

### 1. 列表查询（带分页）

```javascript
const loadList = async () => {
  try {
    loading.value = true
    const response = await api.get('/endpoint/', {
      params: {
        page: currentPage.value,
        page_size: pageSize.value,
        search: searchKeyword.value,
        // 其他过滤参数
      }
    })
    
    // Django REST framework分页格式
    items.value = response.data.results || response.data
    total.value = response.data.count || 0
  } catch (error) {
    console.error('加载失败:', error)
    ElMessage.error('加载数据失败')
  } finally {
    loading.value = false
  }
}
```

### 2. 详情查询

```javascript
const loadDetail = async (id) => {
  try {
    loading.value = true
    const response = await api.get(`/endpoint/${id}/`)
    detailData.value = response.data
  } catch (error) {
    console.error('加载详情失败:', error)
    ElMessage.error('加载详情失败')
  } finally {
    loading.value = false
  }
}
```

### 3. 创建资源

```javascript
const createItem = async (formData) => {
  try {
    loading.value = true
    const response = await api.post('/endpoint/', formData)
    ElMessage.success('创建成功')
    router.push('/list') // 返回列表页
  } catch (error) {
    console.error('创建失败:', error)
    
    // 处理验证错误
    if (error.response?.data) {
      const errors = error.response.data
      // 显示字段错误
      for (const [field, messages] of Object.entries(errors)) {
        ElMessage.error(`${field}: ${messages.join(', ')}`)
      }
    } else {
      ElMessage.error('创建失败')
    }
  } finally {
    loading.value = false
  }
}
```

### 4. 更新资源

```javascript
const updateItem = async (id, formData) => {
  try {
    loading.value = true
    const response = await api.put(`/endpoint/${id}/`, formData)
    ElMessage.success('更新成功')
    loadDetail(id) // 刷新详情
  } catch (error) {
    console.error('更新失败:', error)
    ElMessage.error('更新失败')
  } finally {
    loading.value = false
  }
}
```

### 5. 删除资源

```javascript
const deleteItem = async (id) => {
  try {
    await ElMessageBox.confirm('确定要删除吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await api.delete(`/endpoint/${id}/`)
    ElMessage.success('删除成功')
    loadList() // 刷新列表
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  }
}
```

### 6. 自定义动作

```javascript
const customAction = async (id) => {
  try {
    loading.value = true
    const response = await api.post(`/endpoint/${id}/action/`, {
      // 参数
    })
    ElMessage.success('操作成功')
    loadList() // 刷新
  } catch (error) {
    console.error('操作失败:', error)
    ElMessage.error('操作失败')
  } finally {
    loading.value = false
  }
}
```

## 错误处理最佳实践

### 1. 统一错误处理

```javascript
const handleApiError = (error, defaultMessage = '操作失败') => {
  console.error('API错误:', error)
  
  if (error.response) {
    // 服务器返回错误
    const { status, data } = error.response
    
    switch (status) {
      case 400:
        // 验证错误
        if (typeof data === 'object') {
          const messages = []
          for (const [field, errors] of Object.entries(data)) {
            messages.push(`${field}: ${Array.isArray(errors) ? errors.join(', ') : errors}`)
          }
          ElMessage.error(messages.join('; '))
        } else {
          ElMessage.error(data.detail || defaultMessage)
        }
        break
      case 401:
        ElMessage.error('未授权，请重新登录')
        // 跳转到登录页
        router.push('/login')
        break
      case 403:
        ElMessage.error('没有权限执行此操作')
        break
      case 404:
        ElMessage.error('资源不存在')
        break
      case 500:
        ElMessage.error('服务器错误')
        break
      default:
        ElMessage.error(defaultMessage)
    }
  } else if (error.request) {
    // 请求已发送但没有收到响应
    ElMessage.error('网络连接失败')
  } else {
    // 其他错误
    ElMessage.error(defaultMessage)
  }
}

// 使用示例
try {
  await api.post('/endpoint/', data)
} catch (error) {
  handleApiError(error, '创建失败')
}
```

### 2. 加载状态管理

```javascript
// 定义加载状态
const loading = ref(false)
const saving = ref(false)
const deleting = ref(false)

// 在template中使用
<el-button :loading="saving" @click="save">保存</el-button>
<el-button :loading="deleting" @click="del">删除</el-button>
```

## 数据格式处理

### 1. 日期格式化

```javascript
import dayjs from 'dayjs'

// 格式化日期
const formatDate = (date) => {
  return date ? dayjs(date).format('YYYY-MM-DD HH:mm:ss') : '-'
}

// 在template中使用
<span>{{ formatDate(item.created_at) }}</span>
```

### 2. 状态映射

```javascript
const statusMap = {
  'pending': '待处理',
  'in_progress': '进行中',
  'completed': '已完成',
  'cancelled': '已取消'
}

const getStatusText = (status) => {
  return statusMap[status] || status
}
```

### 3. 类型映射

```javascript
const typeColors = {
  'success': 'success',
  'warning': 'warning',
  'danger': 'danger',
  'info': 'info'
}
```

## 表单处理

### 1. 表单数据定义

```javascript
const formData = ref({
  title: '',
  content: '',
  category: '',
  tags: [],
  status: 'draft'
})

const formRules = {
  title: [
    { required: true, message: '请输入标题', trigger: 'blur' }
  ],
  content: [
    { required: true, message: '请输入内容', trigger: 'blur' }
  ]
}
```

### 2. 表单提交

```javascript
const formRef = ref()

const submitForm = async () => {
  try {
    // 验证表单
    await formRef.value.validate()
    
    // 提交数据
    saving.value = true
    if (isEdit.value) {
      await api.put(`/endpoint/${itemId.value}/`, formData.value)
      ElMessage.success('更新成功')
    } else {
      await api.post('/endpoint/', formData.value)
      ElMessage.success('创建成功')
    }
    
    router.push('/list')
  } catch (error) {
    if (error !== 'cancel') {
      handleApiError(error)
    }
  } finally {
    saving.value = false
  }
}
```

## 文件上传

```javascript
const handleFileUpload = async (file) => {
  const formData = new FormData()
  formData.append('file', file.raw)
  formData.append('title', file.name)
  
  try {
    uploading.value = true
    const response = await api.post('/endpoint/upload/', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      },
      onUploadProgress: (progressEvent) => {
        uploadProgress.value = Math.round((progressEvent.loaded * 100) / progressEvent.total)
      }
    })
    ElMessage.success('上传成功')
    return response.data
  } catch (error) {
    ElMessage.error('上传失败')
    throw error
  } finally {
    uploading.value = false
  }
}
```

## 调试技巧

### 1. 使用浏览器开发者工具

- Network标签：查看API请求和响应
- Console标签：查看console.log输出
- Vue DevTools：查看组件状态

### 2. 添加调试日志

```javascript
const loadData = async () => {
  console.log('开始加载数据')
  try {
    const response = await api.get('/endpoint/')
    console.log('API响应:', response.data)
    items.value = response.data
  } catch (error) {
    console.error('加载失败:', error)
    console.error('错误详情:', error.response?.data)
  }
}
```

### 3. 使用Postman测试API

在修复前端之前，先用Postman测试后端API是否正常工作。

## 检查清单

修复每个页面后，检查以下项目：

- [ ] 移除了所有硬编码的模拟数据
- [ ] 添加了API调用函数
- [ ] 添加了加载状态
- [ ] 添加了错误处理
- [ ] 测试了正常情况
- [ ] 测试了错误情况（如网络断开）
- [ ] 检查了控制台无错误
- [ ] 检查了Network标签中API调用成功

## 常见问题

### Q1: API返回404

**原因**: URL路径错误或后端路由未配置
**解决**: 检查API路径是否正确，查看后端urls.py配置

### Q2: API返回401未授权

**原因**: Token未携带或已过期
**解决**: 检查localStorage中是否有token，查看api/index.js中的拦截器配置

### Q3: API返回403无权限

**原因**: 用户角色没有对应权限
**解决**: 检查用户角色和权限配置

### Q4: 数据格式不匹配

**原因**: 前后端数据结构不一致
**解决**: 查看后端serializer定义，调整前端数据处理

### Q5: 分页数据不显示

**原因**: 分页格式处理错误
**解决**: 使用 `response.data.results` 获取数据列表，`response.data.count` 获取总数

## 下一步

1. 按照本指南修复剩余页面
2. 测试所有功能
3. 处理边界情况
4. 优化用户体验

---

**更新日期**: 2024-10-21


