<template>
  <div class="enterprise-employees">
    <div class="page-header">
      <h1>员工管理</h1>
      <div class="header-actions">
        <button class="btn btn-primary" @click="showAddDialog = true">
          添加员工
        </button>
      </div>
    </div>
    
    <!-- 编辑员工对话框 -->
    <el-dialog 
      v-model="showEditDialog" 
      title="编辑员工" 
      width="600px"
      :before-close="handleCloseEditDialog"
    >
      <el-form 
        ref="editFormRef"
        :model="editForm" 
        :rules="editFormRules" 
        label-width="100px"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="用户名" prop="username">
              <el-input v-model="editForm.username" placeholder="请输入用户名" disabled></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="工号" prop="employee_id">
              <el-input v-model="editForm.employee_id" placeholder="请输入工号"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="姓名" prop="first_name">
              <el-input v-model="editForm.first_name" placeholder="请输入姓名"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="editForm.email" placeholder="请输入邮箱"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="手机号" prop="phone">
              <el-input v-model="editForm.phone" placeholder="请输入手机号"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="职位" prop="position">
              <el-select v-model="editForm.position" placeholder="请选择职位" style="width: 100%">
                <el-option label="管理员" value="admin"></el-option>
                <el-option label="经理" value="manager"></el-option>
                <el-option label="工程师" value="engineer"></el-option>
                <el-option label="技术员" value="technician"></el-option>
                <el-option label="销售" value="sales"></el-option>
                <el-option label="其他" value="other"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="部门" prop="department">
              <el-select v-model="editForm.department" placeholder="请选择部门" style="width: 100%">
                <el-option label="工程部" value="engineering"></el-option>
                <el-option label="管理部" value="management"></el-option>
                <el-option label="销售部" value="sales"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="入职日期" prop="hire_date">
              <el-date-picker 
                v-model="editForm.hire_date" 
                type="date" 
                placeholder="请选择入职日期"
                style="width: 100%"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
              ></el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="薪资" prop="salary">
              <el-input-number 
                v-model="editForm.salary" 
                placeholder="请输入薪资"
                :min="0"
                :precision="2"
                style="width: 100%"
              ></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="is_active">
              <el-radio-group v-model="editForm.is_active">
                <el-radio :label="true">在职</el-radio>
                <el-radio :label="false">离职</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleCloseEditDialog">取消</el-button>
          <el-button type="primary" @click="submitEditEmployee" :loading="editing">
            {{ editing ? '保存中...' : '确定保存' }}
          </el-button>
        </div>
      </template>
    </el-dialog>
    
    <!-- 添加员工对话框 -->
    <el-dialog 
      v-model="showAddDialog" 
      title="添加员工" 
      width="600px"
      :before-close="handleCloseDialog"
    >
      <div class="form-header">
        <h4>填写员工信息</h4>
        <el-button type="text" @click="generateSuggestions" style="color: #409eff;">
          生成建议信息
        </el-button>
      </div>
      
      <el-form 
        ref="addFormRef"
        :model="addForm" 
        :rules="addFormRules" 
        label-width="100px"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="用户名" prop="username">
              <el-input v-model="addForm.username" placeholder="请输入用户名"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="工号" prop="employee_id">
              <el-input v-model="addForm.employee_id" placeholder="请输入工号"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="姓名" prop="first_name">
              <el-input v-model="addForm.first_name" placeholder="请输入姓名"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="addForm.email" placeholder="请输入邮箱"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="手机号" prop="phone">
              <el-input v-model="addForm.phone" placeholder="请输入手机号"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="密码" prop="password">
              <el-input 
                v-model="addForm.password" 
                type="password" 
                placeholder="请输入密码"
                show-password
              ></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="职位" prop="position">
              <el-select v-model="addForm.position" placeholder="请选择职位" style="width: 100%">
                <el-option label="管理员" value="admin"></el-option>
                <el-option label="经理" value="manager"></el-option>
                <el-option label="工程师" value="engineer"></el-option>
                <el-option label="技术员" value="technician"></el-option>
                <el-option label="销售" value="sales"></el-option>
                <el-option label="其他" value="other"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="部门" prop="department">
              <el-select v-model="addForm.department" placeholder="请选择部门" style="width: 100%">
                <el-option label="工程部" value="engineering"></el-option>
                <el-option label="管理部" value="management"></el-option>
                <el-option label="销售部" value="sales"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="入职日期" prop="hire_date">
              <el-date-picker 
                v-model="addForm.hire_date" 
                type="date" 
                placeholder="请选择入职日期"
                style="width: 100%"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
              ></el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="薪资" prop="salary">
              <el-input-number 
                v-model="addForm.salary" 
                placeholder="请输入薪资"
                :min="0"
                :precision="2"
                style="width: 100%"
              ></el-input-number>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="企业" prop="enterprise_id" v-if="userType === 'admin'">
          <el-select v-model="addForm.enterprise_id" placeholder="请选择企业" style="width: 100%">
            <el-option 
              v-for="enterprise in enterprises" 
              :key="enterprise.id" 
              :label="enterprise.name" 
              :value="enterprise.id"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleCloseDialog">取消</el-button>
          <el-button type="primary" @click="submitAddEmployee" :loading="adding">
            {{ adding ? '添加中...' : '确定添加' }}
          </el-button>
        </div>
      </template>
    </el-dialog>
    
    <div class="filters">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="搜索员工..."
        class="search-input"
      >
      <select v-model="departmentFilter" class="filter-select">
        <option value="">全部部门</option>
        <option value="engineering">工程部</option>
        <option value="management">管理部</option>
        <option value="sales">销售部</option>
      </select>
    </div>
    
    <div class="employees-table" v-loading="loading">
      <table>
        <thead>
          <tr>
            <th>姓名</th>
            <th>工号</th>
            <th>部门</th>
            <th>职位</th>
            <th>入职日期</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="employee in filteredEmployees" :key="employee.id">
            <td>{{ employee.username || (employee.first_name + ' ' + employee.last_name) }}</td>
            <td>{{ employee.employee_id }}</td>
            <td>{{ departmentDisplayMap[employee.department] || employee.department }}</td>
            <td>{{ employee.position_display || employee.position }}</td>
            <td>{{ employee.hire_date }}</td>
            <td>
              <span class="status" :class="employee.is_active ? 'active' : 'inactive'">
                {{ employee.is_active ? '在职' : '离职' }}
              </span>
            </td>
            <td>
              <button class="btn btn-sm btn-outline" @click="viewEmployee(employee)">
                查看
              </button>
              <button class="btn btn-sm btn-primary" @click="editEmployee(employee)">
                编辑
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
  name: 'EnterpriseEmployees',
  data() {
    return {
      searchQuery: '',
      departmentFilter: '',
      employees: [],
      loading: false,
      showAddDialog: false,
      showEditDialog: false,
      adding: false,
      editing: false,
      enterprises: [],
      userType: 'enterprise', // 默认企业用户，管理员会动态设置
      addForm: {
        username: '',
        employee_id: '',
        first_name: '',
        email: '',
        phone: '',
        password: '',
        position: '',
        department: '',
        hire_date: '',
        salary: null,
        enterprise_id: null
      },
      editForm: {
        id: null,
        username: '',
        employee_id: '',
        first_name: '',
        email: '',
        phone: '',
        position: '',
        department: '',
        hire_date: '',
        salary: null,
        is_active: true
      },
      addFormRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
        ],
        employee_id: [
          { required: true, message: '请输入工号', trigger: 'blur' }
        ],
        first_name: [
          { required: true, message: '请输入姓名', trigger: 'blur' }
        ],
        email: [
          { required: true, message: '请输入邮箱', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
        ],
        phone: [
          { required: true, message: '请输入手机号', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
        ],
        position: [
          { required: true, message: '请选择职位', trigger: 'change' }
        ],
        department: [
          { required: true, message: '请输入部门', trigger: 'blur' }
        ],
        hire_date: [
          { required: true, message: '请选择入职日期', trigger: 'change' }
        ]
      },
      editFormRules: {
        employee_id: [
          { required: true, message: '请输入工号', trigger: 'blur' }
        ],
        first_name: [
          { required: true, message: '请输入姓名', trigger: 'blur' }
        ],
        email: [
          { required: true, message: '请输入邮箱', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
        ],
        phone: [
          { required: true, message: '请输入手机号', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
        ]
      }
    }
  },
  mounted() {
    this.loadEmployees()
    this.loadEnterprises()
    this.getUserType()
  },
  watch: {
    searchQuery() { this.loadEmployees() },
    departmentFilter() { this.loadEmployees() }
  },
  computed: {
    filteredEmployees() {
      return this.employees.filter(employee => {
        const name = employee.username || employee.first_name || employee.last_name || ''
        const employeeId = employee.employee_id || ''
        
        const matchesSearch = name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                             employeeId.toLowerCase().includes(this.searchQuery.toLowerCase())
        const matchesDepartment = !this.departmentFilter || employee.department === this.departmentFilter
        return matchesSearch && matchesDepartment
      })
    },
    // 部门显示映射
    departmentDisplayMap() {
      return {
        'engineering': '工程部',
        'management': '管理部',
        'sales': '销售部'
      }
    }
  },
  methods: {
    async loadEmployees() {
      try {
        this.loading = true
        const params = {}
        if (this.searchQuery) params.search = this.searchQuery
        if (this.departmentFilter) params.department = this.departmentFilter
        
        const response = await api.get('/enterprises/employees/', { params }).catch(() => ({ data: [] }))
        this.employees = response.data.results || response.data
      } catch (error) {
        console.error('加载员工列表失败:', error)
        this.employees = []
      } finally {
        this.loading = false
      }
    },
    
    // 获取用户类型
    async getUserType() {
      try {
        const response = await api.get('/auth/profile/')
        this.userType = response.data.user_type || 'enterprise'
      } catch (error) {
        console.error('获取用户类型失败:', error)
      }
    },
    
    // 加载企业列表（仅管理员需要）
    async loadEnterprises() {
      if (this.userType === 'admin') {
        try {
          const response = await api.get('/enterprises/')
          this.enterprises = response.data.results || response.data
        } catch (error) {
          console.error('加载企业列表失败:', error)
        }
      }
    },
    
    // 生成建议的用户名和工号
    generateSuggestions() {
      const timestamp = Date.now().toString().slice(-6)
      const randomNum = Math.floor(Math.random() * 1000).toString().padStart(3, '0')
      
      // 生成用户名：emp_时间戳
      this.addForm.username = `emp_${timestamp}`
      
      // 生成工号：EMP + 时间戳
      this.addForm.employee_id = `EMP${timestamp}`
      
      // 生成姓名：员工 + 时间戳后4位
      this.addForm.first_name = `员工${timestamp.slice(-4)}`
      
      // 生成邮箱：emp时间戳@company.com
      this.addForm.email = `emp${timestamp}@company.com`
      
      // 生成手机号：138 + 8位数字
      this.addForm.phone = `138${timestamp}${randomNum.slice(0, 2)}`
      
      // 生成默认密码
      this.addForm.password = 'Employee123'
      
      // 设置默认部门为工程部
      this.addForm.department = 'engineering'
      
      // 设置入职日期为今天
      this.addForm.hire_date = new Date().toISOString().split('T')[0]
      
      // 清除之前的验证错误
      this.$nextTick(() => {
        if (this.$refs.addFormRef) {
          this.$refs.addFormRef.clearValidate()
        }
      })
      
      ElMessage.success('已生成建议信息，请检查并修改')
    },
    
    // 提交添加员工
    async submitAddEmployee() {
      try {
        await this.$refs.addFormRef.validate()
        
        this.adding = true
        
        const formData = { ...this.addForm }
        
        // 如果不是管理员，不需要传递enterprise_id
        if (this.userType !== 'admin') {
          delete formData.enterprise_id
        }
        
        await api.post('/enterprises/employees/', formData)
        
        ElMessage.success('员工添加成功')
        this.handleCloseDialog()
        this.loadEmployees()
      } catch (error) {
        console.error('添加员工失败:', error)
        
        if (error.response?.data) {
          const errorData = error.response.data
          if (typeof errorData === 'object') {
            // 显示第一个错误消息
            const firstError = Object.values(errorData)[0]
            ElMessage.error(Array.isArray(firstError) ? firstError[0] : firstError)
          } else {
            ElMessage.error(errorData)
          }
        } else {
          ElMessage.error('添加员工失败，请稍后重试')
        }
      } finally {
        this.adding = false
      }
    },
    
    // 关闭对话框
    handleCloseDialog() {
      this.showAddDialog = false
      this.resetAddForm()
    },
    
    // 重置添加表单
    resetAddForm() {
      this.addForm = {
        username: '',
        employee_id: '',
        first_name: '',
        email: '',
        phone: '',
        password: '',
        position: '',
        department: '',
        hire_date: '',
        salary: null,
        enterprise_id: null
      }
      // 清除表单验证
      if (this.$refs.addFormRef) {
        this.$refs.addFormRef.clearValidate()
      }
    },
    viewEmployee(employee) {
      // 安全获取字段值，避免undefined
      const getName = () => {
        return employee.username || employee.first_name || employee.last_name || '未设置姓名'
      }
      
      const getEmployeeId = () => {
        return employee.employee_id || '未设置'
      }
      
      const getDepartment = () => {
        const deptMap = {
          'engineering': '工程部',
          'management': '管理部',
          'sales': '销售部'
        }
        return deptMap[employee.department] || employee.department || '未分配部门'
      }
      
      const getPosition = () => {
        return employee.position_display || employee.position || '未设置职位'
      }
      
      const getHireDate = () => {
        return employee.hire_date || employee.created_at || '未设置'
      }
      
      const getStatus = () => {
        return employee.is_active ? '在职' : '离职'
      }
      
      const getEmail = () => {
        return employee.email || '未设置'
      }
      
      const getPhone = () => {
        return employee.phone || '未设置'
      }
      
      const getSalary = () => {
        return employee.salary ? `￥${employee.salary}` : '未设置'
      }
      
      ElMessageBox.alert(`
        <div style="text-align: left; line-height: 1.8;">
          <h3 style="margin-bottom: 15px; color: #333;">${getName()}</h3>
          <p><strong>工号：</strong>${getEmployeeId()}</p>
          <p><strong>邮箱：</strong>${getEmail()}</p>
          <p><strong>手机号：</strong>${getPhone()}</p>
          <p><strong>部门：</strong>${getDepartment()}</p>
          <p><strong>职位：</strong>${getPosition()}</p>
          <p><strong>入职日期：</strong>${getHireDate()}</p>
          <p><strong>薪资：</strong>${getSalary()}</p>
          <p><strong>状态：</strong><span style="color: ${employee.is_active ? '#67C23A' : '#F56C6C'}">${getStatus()}</span></p>
        </div>
      `, '员工详情', {
        dangerouslyUseHTMLString: true,
        confirmButtonText: '关闭'
      })
    },
    // 打开编辑对话框
    editEmployee(employee) {
      // 填充编辑表单
      this.editForm = {
        id: employee.id,
        username: employee.username || '',
        employee_id: employee.employee_id || '',
        first_name: employee.first_name || employee.username || '',
        email: employee.email || '',
        phone: employee.phone || '',
        position: employee.position || '',
        department: employee.department || '',
        hire_date: employee.hire_date || '',
        salary: employee.salary || null,
        is_active: employee.is_active !== undefined ? employee.is_active : true
      }
      
      // 显示编辑对话框
      this.showEditDialog = true
    },
    
    // 提交编辑员工
    async submitEditEmployee() {
      try {
        await this.$refs.editFormRef.validate()
        
        this.editing = true
        
        // 准备更新数据（不包含username，因为用户名不允许修改）
        const updateData = {
          employee_id: this.editForm.employee_id,
          first_name: this.editForm.first_name,
          email: this.editForm.email,
          phone: this.editForm.phone,
          position: this.editForm.position,
          department: this.editForm.department,
          hire_date: this.editForm.hire_date,
          salary: this.editForm.salary,
          is_active: this.editForm.is_active
        }
        
        await api.put(`/enterprises/employees/${this.editForm.id}/`, updateData)
        
        ElMessage.success('员工信息已更新')
        this.handleCloseEditDialog()
        this.loadEmployees()
      } catch (error) {
        console.error('更新员工失败:', error)
        
        if (error.response?.data) {
          const errorData = error.response.data
          if (typeof errorData === 'object') {
            // 显示第一个错误消息
            const firstError = Object.values(errorData)[0]
            ElMessage.error(Array.isArray(firstError) ? firstError[0] : firstError)
          } else {
            ElMessage.error(errorData)
          }
        } else {
          ElMessage.error('更新员工失败，请稍后重试')
        }
      } finally {
        this.editing = false
      }
    },
    
    // 关闭编辑对话框
    handleCloseEditDialog() {
      this.showEditDialog = false
      this.resetEditForm()
    },
    
    // 重置编辑表单
    resetEditForm() {
      this.editForm = {
        id: null,
        username: '',
        employee_id: '',
        first_name: '',
        email: '',
        phone: '',
        position: '',
        department: '',
        hire_date: '',
        salary: null,
        is_active: true
      }
      // 清除表单验证
      if (this.$refs.editFormRef) {
        this.$refs.editFormRef.clearValidate()
      }
    }
  }
}
</script>

<style scoped>
.enterprise-employees {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.form-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid #e0e0e0;
}

.form-header h4 {
  margin: 0;
  color: #333;
  font-weight: 500;
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

.employees-table {
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

.status.inactive {
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

.btn-sm {
  padding: 4px 8px;
  font-size: 12px;
}
</style>

