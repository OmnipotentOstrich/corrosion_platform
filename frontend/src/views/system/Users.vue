<template>
  <div class="system-users">
    <div class="page-header">
      <h1>用户管理</h1>
      <div class="header-actions">
        <button class="btn btn-primary" @click="addUser">
          添加用户
        </button>
      </div>
    </div>
    
    <div class="filters">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="搜索用户..."
        class="search-input"
        @input="debouncedSearch"
      >
      <select v-model="roleFilter" class="filter-select" @change="loadUsers">
        <option value="">全部角色</option>
        <option value="admin">管理员</option>
        <option value="enterprise_admin">企业管理员</option>
        <option value="enterprise_employee">企业员工</option>
        <option value="project_manager">项目经理</option>
        <option value="personal_user">个人用户</option>
        <option value="technician">技术员</option>
        <option value="engineer">工程师</option>
      </select>
      <select v-model="statusFilter" class="filter-select" @change="loadUsers">
        <option value="">全部状态</option>
        <option value="active">活跃</option>
        <option value="banned">已禁用</option>
      </select>
    </div>
    
    <div class="users-table" v-loading="loading">
      <table>
        <thead>
          <tr>
            <th>用户名</th>
            <th>邮箱</th>
            <th>角色</th>
            <th>状态</th>
            <th>注册时间</th>
            <th>最后登录</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id">
            <td>
              <div class="user-info">
                <div class="avatar">{{ user.username.charAt(0).toUpperCase() }}</div>
                <span>{{ user.username }}</span>
              </div>
            </td>
            <td>{{ user.email }}</td>
            <td>
              <span class="role" :class="getRoleClass(user.roles)">{{ user.role_text }}</span>
            </td>
            <td>
              <span class="status" :class="user.status">{{ user.status_text }}</span>
            </td>
            <td>{{ user.register_time }}</td>
            <td>{{ user.last_login }}</td>
            <td>
              <button class="btn btn-sm btn-outline" @click="viewUser(user)">
                查看
              </button>
              <button class="btn btn-sm btn-primary" @click="editUser(user)">
                编辑
              </button>
              <button 
                class="btn btn-sm btn-danger" 
                @click="toggleUserStatus(user)"
                v-if="user.is_active"
              >
                禁用
              </button>
              <button 
                class="btn btn-sm btn-success" 
                @click="toggleUserStatus(user)"
                v-else
              >
                启用
              </button>
            </td>
          </tr>
        </tbody>
      </table>
      
      <!-- 分页组件 -->
      <div class="pagination" v-if="totalPages > 1">
        <button 
          class="btn btn-outline" 
          :disabled="currentPage === 1"
          @click="goToPage(currentPage - 1)"
        >
          上一页
        </button>
        
        <span class="page-info">
          第 {{ currentPage }} 页，共 {{ totalPages }} 页
        </span>
        
        <button 
          class="btn btn-outline" 
          :disabled="currentPage === totalPages"
          @click="goToPage(currentPage + 1)"
        >
          下一页
        </button>
        
        <div class="page-size-selector">
          <label>每页显示：</label>
          <select v-model="pageSize" @change="changePageSize">
            <option value="10">10</option>
            <option value="20">20</option>
            <option value="50">50</option>
            <option value="100">100</option>
          </select>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import api from '@/api'
import { ElMessage, ElMessageBox } from 'element-plus'

export default {
  name: 'SystemUsers',
  data() {
    return {
      searchQuery: '',
      roleFilter: '',
      statusFilter: '',
      users: [],
      loading: false,
      // 分页相关
      currentPage: 1,
      pageSize: 20,
      totalCount: 0,
      totalPages: 0,
      // 防抖搜索
      searchTimeout: null
    }
  },
  mounted() {
    this.loadUsers()
  },
  methods: {
    async loadUsers() {
      try {
        this.loading = true
        const params = {
          page: this.currentPage,
          page_size: this.pageSize
        }
        
        if (this.searchQuery) params.search = this.searchQuery
        if (this.statusFilter) params.is_active = this.statusFilter === 'active'
        
        const response = await api.get('/auth/users/', { params }).catch(() => ({ 
          data: { 
            results: [], 
            count: 0, 
            total_pages: 0 
          } 
        }))
        
        const data = response.data
        this.users = (data.results || data).map(user => ({
          ...user,
          role_text: user.role_text || this.getRoleText(user.roles),
          status_text: user.status_text || this.getStatusText(user.is_active)
        }))
        
        // 更新分页信息
        this.totalCount = data.count || 0
        this.totalPages = data.total_pages || Math.ceil(this.totalCount / this.pageSize)
        
        // 如果当前页超过总页数，重置到第一页
        if (this.currentPage > this.totalPages && this.totalPages > 0) {
          this.currentPage = 1
          this.loadUsers()
        }
      } catch (error) {
        console.error('加载用户列表失败:', error)
        this.users = []
        this.totalCount = 0
        this.totalPages = 0
      } finally {
        this.loading = false
      }
    },
    
    debouncedSearch() {
      if (this.searchTimeout) {
        clearTimeout(this.searchTimeout)
      }
      this.searchTimeout = setTimeout(() => {
        this.currentPage = 1
        this.loadUsers()
      }, 500)
    },
    
    goToPage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page
        this.loadUsers()
      }
    },
    
    changePageSize() {
      // 确保pageSize是数字类型
      this.pageSize = parseInt(this.pageSize)
      this.currentPage = 1
      this.loadUsers()
    },
    
    getRoleClass(roles) {
      if (!roles || roles.length === 0) return 'user'
      const roleCode = roles[0].code
      const roleMap = {
        'admin': 'admin',
        'enterprise_admin': 'manager',
        'enterprise_employee': 'user',
        'project_manager': 'manager',
        'personal_user': 'user',
        'technician': 'user',
        'engineer': 'manager'
      }
      return roleMap[roleCode] || 'user'
    },
    
    getRoleText(roles) {
      if (!roles || roles.length === 0) return '普通用户'
      const role = roles[0]
      const roleMap = {
        'admin': '管理员',
        'enterprise_admin': '企业管理员',
        'enterprise_employee': '企业员工',
        'project_manager': '项目经理',
        'quality_supervisor': '质量监督员',
        'safety_manager': '安全管理员',
        'material_manager': '材料管理员',
        'personal_user': '个人用户',
        'technician': '技术员',
        'engineer': '工程师',
        'construction_worker': '建筑工人',
        'labor_worker': '劳务工人',
        'industry_consultant': '行业顾问',
        'industry_expert': '行业专家'
      }
      return roleMap[role.code] || role.name
    },
    
    getStatusText(isActive) {
      return isActive ? '活跃' : '已禁用'
    },
    
    async addUser() {
      try {
        const { value } = await ElMessageBox.prompt('请输入用户名', '添加用户', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          inputPattern: /^[a-zA-Z0-9_]{3,20}$/,
          inputErrorMessage: '用户名格式不正确（3-20个字符，仅支持字母、数字、下划线）'
        })
        
        await api.post('/auth/users/', {
          username: value,
          email: `${value}@example.com`,
          password: 'default123'
        })
        
        ElMessage.success(`用户 ${value} 添加成功`)
        this.loadUsers()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('添加用户失败:', error)
          ElMessage.error('添加用户失败')
        }
      }
    },
    
    viewUser(user) {
      ElMessageBox.alert(`
        <div style="text-align: left;">
          <h3>${user.username}</h3>
          <p><strong>邮箱：</strong>${user.email}</p>
          <p><strong>角色：</strong>${user.role_text}</p>
          <p><strong>状态：</strong>${user.status_text}</p>
          <p><strong>注册时间：</strong>${user.register_time}</p>
          <p><strong>最后登录：</strong>${user.last_login}</p>
        </div>
      `, '用户详情', {
        dangerouslyUseHTMLString: true,
        confirmButtonText: '关闭'
      })
    },
    
    editUser(user) {
      ElMessageBox.prompt(`编辑用户 - ${user.username}`, '编辑用户', {
        confirmButtonText: '保存',
        cancelButtonText: '取消',
        inputValue: user.email,
        inputPattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
        inputErrorMessage: '请输入正确的邮箱地址'
      }).then(async ({ value }) => {
        try {
          await api.patch(`/auth/users/${user.id}/`, {
            email: value
          })
          ElMessage.success('用户信息已更新')
          this.loadUsers()
        } catch (error) {
          console.error('更新用户信息失败:', error)
          ElMessage.error('更新用户信息失败')
        }
      }).catch(() => {
        ElMessage.info('已取消')
      })
    },
    
    async toggleUserStatus(user) {
      const action = user.is_active ? '禁用' : '启用'
      try {
        await ElMessageBox.confirm(`确定要${action}用户 ${user.username} 吗？`, '确认操作', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
        
        await api.patch(`/auth/users/${user.id}/status/`, {
          is_active: !user.is_active
        })
        
        ElMessage.success(`用户已${action}`)
        this.loadUsers()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('更新用户状态失败:', error)
          ElMessage.error('操作失败')
        }
      }
    }
  }
}
</script>

<style scoped>
.system-users {
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

.users-table {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
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

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background-color: #007bff;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 14px;
}

.role, .status {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.role.admin {
  background-color: #f8d7da;
  color: #721c24;
}

.role.manager {
  background-color: #fff3cd;
  color: #856404;
}

.role.user {
  background-color: #d1ecf1;
  color: #0c5460;
}

.status.active {
  background-color: #d4edda;
  color: #155724;
}

.status.inactive {
  background-color: #e2e3e5;
  color: #383d41;
}

.status.banned {
  background-color: #f8d7da;
  color: #721c24;
}

.btn {
  padding: 6px 12px;
  border-radius: 4px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s;
  margin-right: 5px;
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

.btn-success {
  background-color: #28a745;
  color: white;
}

.btn-success:hover {
  background-color: #1e7e34;
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

/* 分页样式 */
.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  padding: 15px;
  background-color: #f8f9fa;
  border-radius: 8px;
}

.page-info {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.page-size-selector {
  display: flex;
  align-items: center;
  gap: 8px;
}

.page-size-selector label {
  font-size: 14px;
  color: #666;
}

.page-size-selector select {
  padding: 4px 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn:disabled:hover {
  background-color: inherit;
  color: inherit;
}
</style>
