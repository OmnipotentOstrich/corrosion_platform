<template>
  <div class="system-roles">
    <div class="page-header">
      <h1>角色管理</h1>
      <div class="header-actions">
        <button class="btn btn-primary" @click="showAddRoleDialog">
          <span style="margin-right: 5px;">+</span> 添加角色
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
            <span v-for="permission in role.permissions" :key="permission.id || permission.code" class="permission-tag">
              {{ getPermissionName(permission) }}
            </span>
          </div>
        </div>
        <div class="role-actions">
          <button class="btn btn-sm btn-outline" @click="viewRole(role)">
            查看详情
          </button>
          <button class="btn btn-sm btn-primary" @click="showEditRoleDialog(role)">
            编辑
          </button>
          <button class="btn btn-sm btn-danger" @click="deleteRole(role)" v-if="role.deletable">
            删除
          </button>
        </div>
      </div>
    </div>

    <!-- 添加/编辑角色对话框 -->
    <el-dialog 
      v-model="roleDialogVisible" 
      :title="isEditing ? '编辑角色' : '添加角色'"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form :model="roleForm" :rules="roleFormRules" ref="roleFormRef" label-width="100px">
        <el-form-item label="角色名称" prop="name">
          <el-input 
            v-model="roleForm.name" 
            placeholder="请输入角色名称"
            clearable
          />
        </el-form-item>
        
        <el-form-item label="角色代码" prop="code">
          <el-input 
            v-model="roleForm.code" 
            placeholder="自动生成或手动输入，如: role_manager"
            clearable
          />
          <span style="font-size: 12px; color: #999;">留空将自动生成</span>
        </el-form-item>
        
        <el-form-item label="角色描述" prop="description">
          <el-input 
            v-model="roleForm.description" 
            type="textarea"
            :rows="3"
            placeholder="请输入角色描述"
            clearable
          />
        </el-form-item>
        
        <el-form-item label="角色状态" prop="is_active">
          <el-switch 
            v-model="roleForm.is_active"
            active-text="启用"
            inactive-text="禁用"
          />
        </el-form-item>
        
        <el-form-item label="权限配置">
          <div class="permissions-selector">
            <el-checkbox 
              v-model="checkAll" 
              :indeterminate="isIndeterminate"
              @change="handleCheckAllChange"
            >
              全选
            </el-checkbox>
            <div style="margin: 15px 0;"></div>
            <el-checkbox-group v-model="roleForm.selectedPermissions" @change="handleCheckedPermissionsChange">
              <div v-for="group in groupedPermissions" :key="group.category" class="permission-group">
                <h4>{{ group.category }}</h4>
                <el-checkbox 
                  v-for="permission in group.permissions" 
                  :key="permission.id" 
                  :label="permission.id"
                  style="display: block; margin: 8px 0;"
                >
                  {{ permission.name }} <span style="color: #999; font-size: 12px;">({{ permission.code }})</span>
                </el-checkbox>
              </div>
            </el-checkbox-group>
          </div>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="roleDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitRoleForm" :loading="submitting">
            {{ isEditing ? '保存' : '创建' }}
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import api from '@/api'
import { ElMessage, ElMessageBox } from 'element-plus'

export default {
  name: 'SystemRoles',
  data() {
    return {
      roles: [],
      loading: false,
      roleDialogVisible: false,
      isEditing: false,
      submitting: false,
      allPermissions: [],
      checkAll: false,
      isIndeterminate: false,
      roleForm: {
        id: null,
        name: '',
        code: '',
        description: '',
        is_active: true,
        selectedPermissions: []
      },
      roleFormRules: {
        name: [
          { required: true, message: '请输入角色名称', trigger: 'blur' },
          { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
        ],
        code: [
          { max: 50, message: '长度不能超过 50 个字符', trigger: 'blur' }
        ]
      }
    }
  },
  computed: {
    groupedPermissions() {
      // 按照权限代码前缀分组
      const groups = {}
      this.allPermissions.forEach(permission => {
        const category = this.getPermissionCategory(permission.code)
        if (!groups[category]) {
          groups[category] = []
        }
        groups[category].push(permission)
      })
      
      return Object.keys(groups).map(category => ({
        category,
        permissions: groups[category]
      }))
    }
  },
  mounted() {
    this.loadRoles()
    this.loadPermissions()
  },
  methods: {
    async loadRoles() {
      try {
        this.loading = true
        const response = await api.get('/auth/roles/')
        const data = response.data.results || response.data || []
        
        // 格式化角色数据
        this.roles = data.map(role => ({
          id: role.id,
          name: role.name || '未命名角色',
          description: role.description || '暂无描述',
          level: role.level || 'low',
          levelText: this.getLevelText(role.level),
          userCount: role.user_count || role.users?.length || 0,
          permissionCount: role.permission_count || role.permissions?.length || 0,
          permissions: role.permissions || [],
          deletable: !role.is_system && role.id > 3, // 系统角色不可删除
          ...role
        }))
      } catch (error) {
        console.error('加载角色列表失败:', error)
        ElMessage.error('加载角色列表失败')
        this.roles = []
      } finally {
        this.loading = false
      }
    },
    
    getLevelText(level) {
      const levelMap = {
        'high': '高级',
        'medium': '中级',
        'low': '普通'
      }
      return levelMap[level] || '普通'
    },
    
    async loadPermissions() {
      try {
        const response = await api.get('/auth/permissions/')
        this.allPermissions = response.data.results || response.data || []
      } catch (error) {
        console.error('加载权限列表失败:', error)
        this.allPermissions = []
      }
    },
    
    getPermissionName(permission) {
      // 如果permission是字符串，直接返回
      if (typeof permission === 'string') {
        return permission
      }
      // 如果是对象，返回name属性
      return permission?.name || permission?.code || '未知权限'
    },
    
    getPermissionCategory(code) {
      // 根据权限代码前缀分类
      const categoryMap = {
        'user': '用户管理',
        'role': '角色管理',
        'enterprise': '企业管理',
        'info': '信息管理',
        'resource': '资源管理',
        'system': '系统管理'
      }
      
      const prefix = code.split('_')[0]
      return categoryMap[prefix] || '其他权限'
    },
    
    showAddRoleDialog() {
      this.isEditing = false
      this.roleForm = {
        id: null,
        name: '',
        code: '',
        description: '',
        is_active: true,
        selectedPermissions: []
      }
      this.checkAll = false
      this.isIndeterminate = false
      this.roleDialogVisible = true
      // 重置表单验证
      this.$nextTick(() => {
        this.$refs.roleFormRef?.clearValidate()
      })
    },
    
    showEditRoleDialog(role) {
      this.isEditing = true
      this.roleForm = {
        id: role.id,
        name: role.name,
        code: role.code,
        description: role.description || '',
        is_active: role.is_active !== false,
        selectedPermissions: role.permissions.map(p => p.id)
      }
      this.updateCheckAllStatus()
      this.roleDialogVisible = true
      // 重置表单验证
      this.$nextTick(() => {
        this.$refs.roleFormRef?.clearValidate()
      })
    },
    
    handleCheckAllChange(val) {
      this.roleForm.selectedPermissions = val ? this.allPermissions.map(p => p.id) : []
      this.isIndeterminate = false
    },
    
    handleCheckedPermissionsChange(value) {
      this.updateCheckAllStatus()
    },
    
    updateCheckAllStatus() {
      const checkedCount = this.roleForm.selectedPermissions.length
      this.checkAll = checkedCount === this.allPermissions.length
      this.isIndeterminate = checkedCount > 0 && checkedCount < this.allPermissions.length
    },
    
    async submitRoleForm() {
      // 验证表单
      const valid = await this.$refs.roleFormRef.validate().catch(() => false)
      if (!valid) {
        return
      }
      
      try {
        this.submitting = true
        
        const formData = {
          name: this.roleForm.name,
          code: this.roleForm.code || ('role_' + Date.now()),
          description: this.roleForm.description,
          is_active: this.roleForm.is_active,
          permission_ids: this.roleForm.selectedPermissions
        }
        
        if (this.isEditing) {
          // 编辑角色
          await api.put(`/auth/roles/${this.roleForm.id}/`, formData)
          ElMessage.success('角色更新成功')
        } else {
          // 创建角色
          await api.post('/auth/roles/', formData)
          ElMessage.success('角色创建成功')
        }
        
        this.roleDialogVisible = false
        this.loadRoles()
      } catch (error) {
        console.error('提交角色失败:', error)
        let errorMsg = this.isEditing ? '更新角色失败' : '创建角色失败'
        if (error.response?.data) {
          const errData = error.response.data
          if (errData.code) {
            errorMsg += ': 角色代码已存在'
          } else if (errData.name) {
            errorMsg += ': 角色名称已存在'
          } else if (typeof errData === 'string') {
            errorMsg += ': ' + errData
          } else if (errData.detail) {
            errorMsg += ': ' + errData.detail
          }
        }
        ElMessage.error(errorMsg)
      } finally {
        this.submitting = false
      }
    },
    
    viewRole(role) {
      const permissionsHtml = role.permissions.map(p => {
        const name = this.getPermissionName(p)
        return `<span style="display: inline-block; background: #e9ecef; padding: 2px 6px; margin: 2px; border-radius: 3px; font-size: 12px;">${name}</span>`
      }).join('')
      
      ElMessageBox.alert(`
        <div style="text-align: left;">
          <h3>${role.name}</h3>
          <p><strong>描述：</strong>${role.description}</p>
          <p><strong>级别：</strong>${role.levelText}</p>
          <p><strong>用户数：</strong>${role.userCount}</p>
          <p><strong>权限数：</strong>${role.permissionCount}</p>
          <p><strong>权限列表：</strong></p>
          <div style="margin-top: 10px;">${permissionsHtml || '暂无权限'}</div>
        </div>
      `, '角色详情', {
        dangerouslyUseHTMLString: true,
        confirmButtonText: '关闭'
      })
    },
    
    
    async deleteRole(role) {
      try {
        await ElMessageBox.confirm(
          `确定要删除角色"${role.name}"吗？此操作不可恢复。`, 
          '确认删除', 
          {
            confirmButtonText: '确定删除',
            cancelButtonText: '取消',
            type: 'error'
          }
        )
        
        await api.delete(`/auth/roles/${role.id}/`)
        ElMessage.success('角色已删除')
        this.loadRoles()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('删除角色失败:', error)
          ElMessage.error('删除角色失败')
        }
      }
    }
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

/* 对话框样式 */
.permissions-selector {
  max-height: 400px;
  overflow-y: auto;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  padding: 15px;
  background: #f8f9fa;
}

.permission-group {
  margin-bottom: 20px;
}

.permission-group:last-child {
  margin-bottom: 0;
}

.permission-group h4 {
  color: #333;
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 10px;
  padding-bottom: 8px;
  border-bottom: 2px solid #007bff;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>

