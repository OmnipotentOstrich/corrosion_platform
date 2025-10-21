<template>
  <div class="personal-center">
    <div class="page-header">
      <h1>个人中心</h1>
      <p>管理个人项目和任务</p>
    </div>
    
    <div class="content-grid">
      <div class="card">
        <h3>我的项目</h3>
        <p>查看和管理个人参与的项目</p>
        <router-link to="/dashboard/personal/projects" class="btn btn-primary">
          查看项目
        </router-link>
      </div>
      
      <div class="card">
        <h3>我的任务</h3>
        <p>查看和管理个人任务</p>
        <router-link to="/dashboard/personal/tasks" class="btn btn-primary">
          查看任务
        </router-link>
      </div>
      
      <div class="card">
        <h3>个人资料</h3>
        <p>管理个人信息和设置</p>
        <router-link to="/dashboard/profile" class="btn btn-primary">
          编辑资料
        </router-link>
      </div>
    </div>
    
    <div class="stats-section">
      <h2>统计信息</h2>
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-number">12</div>
          <div class="stat-label">进行中的项目</div>
        </div>
        <div class="stat-card">
          <div class="stat-number">8</div>
          <div class="stat-label">待完成任务</div>
        </div>
        <div class="stat-card">
          <div class="stat-number">25</div>
          <div class="stat-label">已完成任务</div>
        </div>
        <div class="stat-card">
          <div class="stat-number">95%</div>
          <div class="stat-label">任务完成率</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PersonalCenter',
  data() {
    return {
      // 个人中心数据
    }
  },
  mounted() {
    // 组件挂载后的逻辑
  }
}
</script>

<style scoped>
.personal-center {
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
  margin-bottom: 40px;
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

.stats-section {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.stats-section h2 {
  color: #333;
  margin-bottom: 20px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.stat-card {
  text-align: center;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 8px;
}

.stat-number {
  font-size: 2em;
  font-weight: bold;
  color: #007bff;
  margin-bottom: 5px;
}

.stat-label {
  color: #666;
  font-size: 14px;
}
</style>

