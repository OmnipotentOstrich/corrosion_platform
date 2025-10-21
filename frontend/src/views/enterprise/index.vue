<template>
  <div class="enterprise-center">
    <div class="page-header">
      <h1>企业中心</h1>
      <p>管理企业信息和相关业务</p>
    </div>
    
    <div class="content-grid">
      <div class="card">
        <h3>项目管理</h3>
        <p>查看和管理企业项目</p>
        <router-link to="/dashboard/enterprise/projects" class="btn btn-primary">
          进入项目管理
        </router-link>
      </div>
      
      <div class="card">
        <h3>员工管理</h3>
        <p>管理企业员工信息</p>
        <router-link to="/dashboard/enterprise/employees" class="btn btn-primary">
          进入员工管理
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'EnterpriseCenter',
  data() {
    return {
      // 企业中心数据
    }
  },
  mounted() {
    // 组件挂载后的逻辑
  }
}
</script>

<style scoped>
.enterprise-center {
  padding: 20px;
}

.page-header {
  margin-bottom: 30px;
}

.page-header h1 {
  color: #333;
  margin-bottom: 10px;
}

.page-header p {
  color: #666;
  font-size: 16px;
}

.content-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.card h3 {
  color: #333;
  margin-bottom: 10px;
}

.card p {
  color: #666;
  margin-bottom: 15px;
}

.btn {
  display: inline-block;
  padding: 8px 16px;
  border-radius: 4px;
  text-decoration: none;
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
</style>

