# API连接实施方案

## 当前状态确认

### ✅ 后端API配置检查

**后端URL配置（backend/config/urls.py）：**
```python
# ✅ 已配置完整的API路由
path('api/v1/auth/', include('apps.users.urls')),
path('api/v1/enterprises/', include('apps.enterprises.urls')),
path('api/v1/persons/', include('apps.persons.urls')),
path('api/v1/info-plaza/', include('apps.info_plaza.urls')),
path('api/v1/resources/', include('apps.resources.urls')),
path('api/v1/system/', include('apps.system.urls'))
```

**前端API配置（frontend/src/api/index.js）：**
```javascript
// ✅ 已配置完整的axios实例
baseURL: '/api/v1'
// ✅ 已配置请求拦截器（自动添加Token）
// ✅ 已配置响应拦截器（统一错误处理）
```

**结论：基础设施完善，可以直接连接API** ✅

---

## 实施方案

### 阶段1：核心模块（1-2天）

#### 1.1 仪表板首页
**文件：** `frontend/src/views/dashboard/Home.vue`

**需要的API：**
- `GET /api/v1/dashboard/statistics/` - 获取统计数据
- `GET /api/v1/dashboard/activities/` - 获取最近活动
- `GET /api/v1/dashboard/tasks/` - 获取待办任务
- `GET /api/v1/dashboard/notifications/` - 获取系统通知

**修改方案：**
```javascript
// 添加数据加载方法
const loadDashboardData = async () => {
  try {
    loading.value = true
    
    // 并行加载所有数据
    const [statsRes, activitiesRes, tasksRes, notificationsRes] = await Promise.all([
      api.get('/dashboard/statistics/'),
      api.get('/dashboard/activities/'),
      api.get('/dashboard/tasks/'),
      api.get('/dashboard/notifications/')
    ])
    
    stats.value = statsRes.data
    recentActivities.value = activitiesRes.data
    pendingTasks.value = tasksRes.data
    notifications.value = notificationsRes.data
  } catch (error) {
    console.error('加载仪表板数据失败:', error)
    ElMessage.error('加载数据失败')
  } finally {
    loading.value = false
  }
}

// 在 onMounted 中调用
onMounted(() => {
  loadDashboardData()
})
```

---

#### 1.2 系统用户管理
**文件：** `frontend/src/views/system/Users.vue`

**需要的API：**
- `GET /api/v1/auth/users/` - 获取用户列表
- `POST /api/v1/auth/users/` - 创建用户
- `GET /api/v1/auth/users/{id}/` - 获取用户详情
- `PUT /api/v1/auth/users/{id}/` - 更新用户
- `PATCH /api/v1/auth/users/{id}/status/` - 更新用户状态

**修改方案：**
```javascript
data() {
  return {
    users: [],
    loading: false,
    // ... 其他数据
  }
},
mounted() {
  this.loadUsers()
},
methods: {
  async loadUsers() {
    try {
      this.loading = true
      const response = await api.get('/auth/users/', {
        params: {
          search: this.searchQuery,
          role: this.roleFilter,
          status: this.statusFilter
        }
      })
      this.users = response.data.results || response.data
    } catch (error) {
      this.$message.error('加载用户列表失败')
    } finally {
      this.loading = false
    }
  },
  
  async addUser() {
    try {
      const { value } = await this.$prompt('请输入用户名', '添加用户', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /^[a-zA-Z0-9_]{3,20}$/,
        inputErrorMessage: '用户名格式不正确'
      })
      
      await api.post('/auth/users/', {
        username: value,
        email: `${value}@example.com`,
        password: 'default123'
      })
      
      this.$message.success(`用户 ${value} 添加成功`)
      this.loadUsers()
    } catch (error) {
      if (error !== 'cancel') {
        this.$message.error('添加用户失败')
      }
    }
  },
  
  async toggleUserStatus(user) {
    const action = user.status === 'banned' ? '启用' : '禁用'
    try {
      await this.$confirm(`确定要${action}用户 ${user.username} 吗？`, '确认操作', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      
      await api.patch(`/auth/users/${user.id}/status/`, {
        status: user.status === 'banned' ? 'active' : 'banned'
      })
      
      this.$message.success(`用户已${action}`)
      this.loadUsers()
    } catch (error) {
      if (error !== 'cancel') {
        this.$message.error('操作失败')
      }
    }
  }
}
```

---

#### 1.3 系统角色管理
**文件：** `frontend/src/views/system/Roles.vue`

**需要的API：**
- `GET /api/v1/auth/roles/` - 获取角色列表
- `POST /api/v1/auth/roles/` - 创建角色
- `PUT /api/v1/auth/roles/{id}/` - 更新角色
- `DELETE /api/v1/auth/roles/{id}/` - 删除角色

---

#### 1.4 系统日志
**文件：** `frontend/src/views/system/Logs.vue`

**需要的API：**
- `GET /api/v1/system/logs/` - 获取日志列表
- `GET /api/v1/system/logs/export/` - 导出日志
- `DELETE /api/v1/system/logs/clear/` - 清空日志

---

### 阶段2：业务模块（2-3天）

#### 2.1 企业员工管理
**文件：** `frontend/src/views/enterprise/Employees.vue`

**需要的API：**
- `GET /api/v1/enterprises/employees/` - 获取员工列表
- `POST /api/v1/enterprises/employees/` - 添加员工
- `PUT /api/v1/enterprises/employees/{id}/` - 更新员工

---

#### 2.2 企业项目管理
**文件：** `frontend/src/views/enterprise/Projects.vue`

**需要的API：**
- `GET /api/v1/enterprises/projects/` - 获取项目列表
- `POST /api/v1/enterprises/projects/` - 创建项目
- `PUT /api/v1/enterprises/projects/{id}/` - 更新项目

---

#### 2.3 个人项目管理
**文件：** `frontend/src/views/personal/Projects.vue`

**需要的API：**
- `GET /api/v1/persons/projects/` - 获取个人项目列表

---

#### 2.4 个人任务管理
**文件：** `frontend/src/views/personal/Tasks.vue`

**需要的API：**
- `GET /api/v1/persons/tasks/` - 获取任务列表
- `POST /api/v1/persons/tasks/` - 创建任务
- `PUT /api/v1/persons/tasks/{id}/` - 更新任务
- `DELETE /api/v1/persons/tasks/{id}/` - 删除任务
- `PATCH /api/v1/persons/tasks/{id}/complete/` - 完成任务

---

#### 2.5 资源管理
**文件：** `frontend/src/views/resources/index.vue`

**需要的API：**
- `GET /api/v1/resources/` - 获取资源列表
- `GET /api/v1/resources/{id}/download/` - 下载资源

**文件：** `frontend/src/views/resources/Detail.vue`

**需要的API：**
- `GET /api/v1/resources/{id}/` - 获取资源详情
- `GET /api/v1/resources/{id}/comments/` - 获取评论
- `POST /api/v1/resources/{id}/comments/` - 发表评论

---

## 通用代码模板

### 模板1：列表页面

```javascript
export default {
  name: 'ListPage',
  data() {
    return {
      items: [],
      loading: false,
      searchQuery: '',
      filters: {}
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    async loadData() {
      try {
        this.loading = true
        const response = await api.get('/endpoint/', {
          params: {
            search: this.searchQuery,
            ...this.filters
          }
        })
        this.items = response.data.results || response.data
      } catch (error) {
        this.$message.error('加载数据失败')
      } finally {
        this.loading = false
      }
    },
    
    async createItem() {
      try {
        const { value } = await this.$prompt('输入信息', '创建')
        await api.post('/endpoint/', { name: value })
        this.$message.success('创建成功')
        this.loadData()
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error('创建失败')
        }
      }
    },
    
    async updateItem(item) {
      try {
        await api.put(`/endpoint/${item.id}/`, item)
        this.$message.success('更新成功')
        this.loadData()
      } catch (error) {
        this.$message.error('更新失败')
      }
    },
    
    async deleteItem(item) {
      try {
        await this.$confirm('确定删除？', '警告', { type: 'error' })
        await api.delete(`/endpoint/${item.id}/`)
        this.$message.success('删除成功')
        this.loadData()
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error('删除失败')
        }
      }
    }
  }
}
```

### 模板2：详情页面

```javascript
export default {
  name: 'DetailPage',
  data() {
    return {
      item: {},
      loading: false
    }
  },
  mounted() {
    this.loadDetail()
  },
  methods: {
    async loadDetail() {
      try {
        this.loading = true
        const id = this.$route.params.id
        const response = await api.get(`/endpoint/${id}/`)
        this.item = response.data
      } catch (error) {
        this.$message.error('加载详情失败')
      } finally {
        this.loading = false
      }
    }
  }
}
```

---

## 实施注意事项

### 1. 加载状态
每个数据加载都应该有loading状态：
```html
<div v-loading="loading">
  <!-- 内容 -->
</div>
```

### 2. 错误处理
统一的错误处理模式：
```javascript
try {
  // API调用
} catch (error) {
  if (error !== 'cancel') {  // 排除用户取消操作
    this.$message.error('操作失败')
  }
}
```

### 3. 数据刷新
增删改操作后需要刷新列表：
```javascript
this.$message.success('操作成功')
this.loadData()  // 重新加载数据
```

### 4. 搜索和筛选
使用watch监听筛选条件变化：
```javascript
watch: {
  searchQuery() {
    this.loadData()
  },
  statusFilter() {
    this.loadData()
  }
}
```

### 5. 分页
如果数据量大，需要添加分页：
```javascript
data() {
  return {
    currentPage: 1,
    pageSize: 20,
    total: 0
  }
},
async loadData() {
  const response = await api.get('/endpoint/', {
    params: {
      page: this.currentPage,
      page_size: this.pageSize
    }
  })
  this.items = response.data.results
  this.total = response.data.count
}
```

---

## 后端API需求

### 需要后端实现的API端点

如果后端还没有实现某些API，需要添加：

#### 1. 仪表板统计API
```python
# backend/apps/users/views.py 或新建 dashboard app
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def dashboard_statistics(request):
    return Response({
        'posts': InfoPost.objects.count(),
        'resources': Resource.objects.count(),
        'projects': Project.objects.filter(
            members=request.user
        ).count(),
        'tasks': Task.objects.filter(
            assigned_to=request.user,
            status='pending'
        ).count()
    })
```

#### 2. 用户状态更新API
```python
# backend/apps/users/views.py
class UserViewSet(viewsets.ModelViewSet):
    @action(detail=True, methods=['patch'])
    def status(self, request, pk=None):
        user = self.get_object()
        user.is_active = request.data.get('status') == 'active'
        user.save()
        return Response({'status': 'success'})
```

---

## 测试清单

### 前端测试
- [ ] 页面加载时显示loading状态
- [ ] 数据成功加载并显示
- [ ] 搜索和筛选功能正常
- [ ] 创建操作成功并刷新列表
- [ ] 更新操作成功并刷新列表
- [ ] 删除操作有确认提示
- [ ] 错误情况显示友好提示
- [ ] 网络断开时显示错误

### API测试
- [ ] 所有接口返回正确的数据格式
- [ ] 分页参数正常工作
- [ ] 搜索和筛选参数正常工作
- [ ] 权限验证正常工作
- [ ] 错误情况返回正确的状态码和消息

---

## 时间估算

| 阶段 | 模块 | 预计时间 |
|------|------|---------|
| 1 | 仪表板首页 | 2小时 |
| 1 | 系统用户管理 | 3小时 |
| 1 | 系统角色管理 | 2小时 |
| 1 | 系统日志 | 2小时 |
| 2 | 企业员工管理 | 2小时 |
| 2 | 企业项目管理 | 2小时 |
| 2 | 个人项目管理 | 2小时 |
| 2 | 个人任务管理 | 3小时 |
| 2 | 资源管理 | 3小时 |
| 3 | 测试和优化 | 4小时 |
| **总计** | | **25小时（3-4天）** |

---

## 下一步行动

1. **立即开始**：从仪表板首页开始实施
2. **并行开发**：可以多人同时开发不同模块
3. **持续测试**：每完成一个模块立即测试
4. **记录问题**：遇到后端API问题记录下来统一处理

