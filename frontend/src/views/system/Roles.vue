<template>
  <div class="system-roles">
    <div class="page-header">
      <h1>角色管理</h1>
      <div class="header-actions">
        <button class="btn btn-primary" @click="addRole">
          添加角色
        </button>
      </div>
    </div>
    
    <div class="roles-grid" v-loading="loading">
      <div v-for="role in roles" :key="role.id" class="role-card">
        <div class="role-header">
          <h3>{{ role.name }}</h3>
          <span class="role-badge" :class="role.level">{{ role.levelText }}</span>
        </div>
        <p class="role-description">{{ role.description }}</p>
        <div class="role-stats">
          <span>用户数: {{ role.userCount }}</span>
          <span>权限数: {{ role.permissionCount }}</span>
        </div>
        <div class="permissions">
          <h4>权限列表</h4>
          <div class="permission-list">
            <span v-for="permission in role.permissions" :key="permission" class="permission-tag">
              {{ permission }}
            </span>
          </div>
        </div>
        <div class="role-actions">
          <button class="btn btn-sm btn-outline" @click="viewRole(role)">
            查看详情
          </button>
          <button class="btn btn-sm btn-primary" @click="editRole(role)">
            编辑
          </button>
          <button class="btn btn-sm btn-danger" @click="deleteRole(role)" v-if="role.deletable">
            删除
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SystemRoles',
  data() {
    return {
      roles: [],
      loading: false
    }
  },
  mounted() {
    this.loadRoles()
  },
  methods: {
    async loadRoles() {
      try {
        this.loading = true
        const response = await this.$api.get('/auth/roles/').catch(() => ({ data: [] }))
        this.roles = response.data.results || response.data
      } catch (error) {
        console.error('加载角色列表失败:', error)
        this.roles = []
      } finally {
        this.loading = false
      }
    },
    
    async addRole() {
      try {
        const { value } = await this.$prompt('请输入角色名称', '添加角色', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /.+/,
        inputErrorMessage: '角色名称不能为空'
        })
        
        await this.$api.post('/auth/roles/', {
          name: value,
          description: '',
          permissions: []
        })
        
        this.$message.success(`角色 ${value} 添加成功`)
        this.loadRoles()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('添加角色失败:', error)
          this.$message.error('添加角色失败')
        }
      }
    },
    viewRole(role) {
      const permissionsHtml = role.permissions.map(p => `<span style="display: inline-block; background: #e9ecef; padding: 2px 6px; margin: 2px; border-radius: 3px; font-size: 12px;">${p}</span>`).join('')
      this.$alert(`
        <div style="text-align: left;">
          <h3>${role.name}</h3>
          <p><strong>描述：</strong>${role.description}</p>
          <p><strong>级别：</strong>${role.levelText}</p>
          <p><strong>用户数：</strong>${role.userCount}</p>
          <p><strong>权限数：</strong>${role.permissionCount}</p>
          <p><strong>权限列表：</strong></p>
          <div style="margin-top: 10px;">${permissionsHtml}</div>
        </div>
      `, '角色详情', {
        dangerouslyUseHTMLString: true,
        confirmButtonText: '关闭'
      })
    },
    async editRole(role) {
      try {
        const { value } = await this.$prompt(`编辑角色 - ${role.name}`, '编辑角色', {
          confirmButtonText: '保存',
          cancelButtonText: '取消',
          inputValue: role.description,
          inputPattern: /.+/,
          inputErrorMessage: '描述不能为空'
        })
        
        await this.$api.put(`/auth/roles/${role.id}/`, {
          ...role,
          description: value
        })
        
        this.$message.success('角色信息已更新')
        this.loadRoles()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('更新角色失败:', error)
          this.$message.error('更新角色失败')
        }
      }
    },
    
    async deleteRole(role) {
      try {
        await this.$confirm(`确定要删除角色"${role.name}"吗？此操作不可恢复。`, '确认删除', {
          confirmButtonText: '确定删除',
          cancelButtonText: '取消',
          type: 'error'
        })
        
        await this.$api.delete(`/auth/roles/${role.id}/`)
        this.$message.success('角色已删除')
        this.loadRoles()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('删除角色失败:', error)
          this.$message.error('删除角色失败')
        }
      }
    }
  },
  
  beforeCreate() {
    this.$api = this.$root.$options.globalProperties.$api || require('@/api').default
  }
}
</script>

<style scoped>
.system-roles {
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

.roles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 20px;
}

.role-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.role-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.role-header h3 {
  color: #333;
  margin: 0;
}

.role-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.role-badge.high {
  background-color: #f8d7da;
  color: #721c24;
}

.role-badge.medium {
  background-color: #fff3cd;
  color: #856404;
}

.role-badge.low {
  background-color: #d1ecf1;
  color: #0c5460;
}

.role-description {
  color: #666;
  margin-bottom: 15px;
  line-height: 1.5;
}

.role-stats {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}

.permissions h4 {
  color: #333;
  margin-bottom: 10px;
  font-size: 14px;
}

.permission-list {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin-bottom: 15px;
}

.permission-tag {
  background-color: #e9ecef;
  color: #495057;
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 12px;
}

.role-actions {
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

