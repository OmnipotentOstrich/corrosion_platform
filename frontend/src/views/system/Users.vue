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
      >
      <select v-model="roleFilter" class="filter-select">
        <option value="">全部角色</option>
        <option value="admin">管理员</option>
        <option value="manager">经理</option>
        <option value="user">普通用户</option>
      </select>
      <select v-model="statusFilter" class="filter-select">
        <option value="">全部状态</option>
        <option value="active">活跃</option>
        <option value="inactive">非活跃</option>
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
          <tr v-for="user in filteredUsers" :key="user.id">
            <td>
              <div class="user-info">
                <div class="avatar">{{ user.username.charAt(0).toUpperCase() }}</div>
                <span>{{ user.username }}</span>
              </div>
            </td>
            <td>{{ user.email }}</td>
            <td>
              <span class="role" :class="user.role">{{ user.roleText }}</span>
            </td>
            <td>
              <span class="status" :class="user.status">{{ user.statusText }}</span>
            </td>
            <td>{{ user.registerTime }}</td>
            <td>{{ user.lastLogin }}</td>
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
                v-if="user.status !== 'banned'"
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
      loading: false
    }
  },
  mounted() {
    this.loadUsers()
  },
  watch: {
    searchQuery() {
      this.loadUsers()
    },
    roleFilter() {
      this.loadUsers()
    },
    statusFilter() {
      this.loadUsers()
    }
  },
  computed: {
    filteredUsers() {
      return this.users.filter(user => {
        const matchesSearch = user.username.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                             user.email.toLowerCase().includes(this.searchQuery.toLowerCase())
        const matchesRole = !this.roleFilter || user.role === this.roleFilter
        const matchesStatus = !this.statusFilter || user.status === this.statusFilter
        return matchesSearch && matchesRole && matchesStatus
      })
    }
  },
  methods: {
    async loadUsers() {
      try {
        this.loading = true
        const params = {}
        if (this.searchQuery) params.search = this.searchQuery
        if (this.roleFilter) params.role = this.roleFilter
        if (this.statusFilter) params.status = this.statusFilter
        
        const response = await api.get('/auth/users/', { params }).catch(() => ({ data: [] }))
        this.users = (response.data.results || response.data).map(user => ({
          ...user,
          roleText: this.getRoleText(user.role || 'user'),
          statusText: this.getStatusText(user.status || 'active')
        }))
      } catch (error) {
        console.error('加载用户列表失败:', error)
        this.users = []
      } finally {
        this.loading = false
      }
    },
    
    getRoleText(role) {
      const roleMap = {
        'admin': '管理员',
        'manager': '经理',
        'user': '普通用户'
      }
      return roleMap[role] || role
    },
    
    getStatusText(status) {
      const statusMap = {
        'active': '活跃',
        'inactive': '非活跃',
        'banned': '已禁用'
      }
      return statusMap[status] || status
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
          <p><strong>角色：</strong>${user.roleText}</p>
          <p><strong>状态：</strong>${user.statusText}</p>
          <p><strong>注册时间：</strong>${user.registerTime}</p>
          <p><strong>最后登录：</strong>${user.lastLogin}</p>
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
      }).then(({ value }) => {
        user.email = value
        ElMessage.success('用户信息已更新')
        // TODO: 调用后端API更新用户信息
      }).catch(() => {
        ElMessage.info('已取消')
      })
    },
    async toggleUserStatus(user) {
      const action = user.status === 'banned' ? '启用' : '禁用'
      try {
        await ElMessageBox.confirm(`确定要${action}用户 ${user.username} 吗？`, '确认操作', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
        
        const newStatus = user.status === 'banned' ? 'active' : 'banned'
        await api.patch(`/auth/users/${user.id}/`, {
          is_active: newStatus === 'active'
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
</style>

