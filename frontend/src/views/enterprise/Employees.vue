<template>
  <div class="enterprise-employees">
    <div class="page-header">
      <h1>员工管理</h1>
      <div class="header-actions">
        <button class="btn btn-primary" @click="addEmployee">
          添加员工
        </button>
      </div>
    </div>
    
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
            <td>{{ employee.name }}</td>
            <td>{{ employee.employeeId }}</td>
            <td>{{ employee.department }}</td>
            <td>{{ employee.position }}</td>
            <td>{{ employee.hireDate }}</td>
            <td>
              <span class="status" :class="employee.status">{{ employee.statusText }}</span>
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
export default {
  name: 'EnterpriseEmployees',
  data() {
    return {
      searchQuery: '',
      departmentFilter: '',
      employees: [],
      loading: false
    }
  },
  mounted() {
    this.loadEmployees()
  },
  watch: {
    searchQuery() { this.loadEmployees() },
    departmentFilter() { this.loadEmployees() }
  },
  computed: {
    filteredEmployees() {
      return this.employees.filter(employee => {
        const matchesSearch = employee.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                             employee.employeeId.toLowerCase().includes(this.searchQuery.toLowerCase())
        const matchesDepartment = !this.departmentFilter || employee.department === this.departmentFilter
        return matchesSearch && matchesDepartment
      })
    }
  },
  methods: {
    async loadEmployees() {
      try {
        this.loading = true
        const params = {}
        if (this.searchQuery) params.search = this.searchQuery
        if (this.departmentFilter) params.department = this.departmentFilter
        
        const response = await this.$api.get('/enterprises/employees/', { params }).catch(() => ({ data: [] }))
        this.employees = response.data.results || response.data
      } catch (error) {
        console.error('加载员工列表失败:', error)
        this.employees = []
      } finally {
        this.loading = false
      }
    },
    
    async addEmployee() {
      try {
        const { value } = await this.$prompt('请输入员工姓名', '添加员工', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /.+/,
        inputErrorMessage: '姓名不能为空'
        })
        
        await this.$api.post('/enterprises/employees/', {
          name: value,
          employee_id: `EMP${Date.now().toString().slice(-6)}`,
          department: '待分配',
          position: '待分配'
        })
        
        this.$message.success(`员工 ${value} 添加成功`)
        this.loadEmployees()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('添加员工失败:', error)
          this.$message.error('添加员工失败')
        }
      }
    },
    viewEmployee(employee) {
      this.$alert(`
        <div style="text-align: left;">
          <h3>${employee.name}</h3>
          <p><strong>工号：</strong>${employee.employeeId}</p>
          <p><strong>部门：</strong>${employee.department}</p>
          <p><strong>职位：</strong>${employee.position}</p>
          <p><strong>入职日期：</strong>${employee.hireDate}</p>
          <p><strong>状态：</strong>${employee.statusText}</p>
        </div>
      `, '员工详情', {
        dangerouslyUseHTMLString: true,
        confirmButtonText: '关闭'
      })
    },
    async editEmployee(employee) {
      try {
        const { value } = await this.$prompt(`编辑员工信息 - ${employee.name}`, '编辑员工', {
          confirmButtonText: '保存',
          cancelButtonText: '取消',
          inputValue: employee.name,
          inputPattern: /.+/,
          inputErrorMessage: '姓名不能为空'
        })
        
        await this.$api.put(`/enterprises/employees/${employee.id}/`, {
          ...employee,
          name: value
        })
        
        this.$message.success('员工信息已更新')
        this.loadEmployees()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('更新员工失败:', error)
          this.$message.error('更新员工失败')
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
.enterprise-employees {
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

