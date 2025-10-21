<template>
  <div class="personal-projects">
    <div class="page-header">
      <h1>我的项目</h1>
      <div class="header-actions">
        <button class="btn btn-primary" @click="joinProject">
          加入项目
        </button>
      </div>
    </div>
    
    <div class="filters">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="搜索项目..."
        class="search-input"
      >
      <select v-model="roleFilter" class="filter-select">
        <option value="">全部角色</option>
        <option value="manager">项目经理</option>
        <option value="developer">开发人员</option>
        <option value="designer">设计师</option>
        <option value="tester">测试人员</option>
      </select>
    </div>
    
    <div class="projects-list">
      <div v-for="project in filteredProjects" :key="project.id" class="project-card">
        <div class="project-header">
          <h3>{{ project.name }}</h3>
          <span class="role">{{ project.role }}</span>
        </div>
        <p class="project-description">{{ project.description }}</p>
        <div class="project-progress">
          <div class="progress-bar">
            <div class="progress-fill" :style="{ width: project.progress + '%' }"></div>
          </div>
          <span class="progress-text">{{ project.progress }}%</span>
        </div>
        <div class="project-meta">
          <span>开始时间: {{ project.startDate }}</span>
          <span>截止时间: {{ project.deadline }}</span>
        </div>
        <div class="project-actions">
          <button class="btn btn-sm btn-outline" @click="viewProject(project)">
            查看详情
          </button>
          <button class="btn btn-sm btn-primary" @click="viewTasks(project)">
            查看任务
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PersonalProjects',
  data() {
    return {
      searchQuery: '',
      roleFilter: '',
      projects: [
        {
          id: 1,
          name: '防腐保温项目A',
          description: '大型工业设备防腐保温工程',
          role: '项目经理',
          progress: 75,
          startDate: '2024-01-01',
          deadline: '2024-12-31'
        },
        {
          id: 2,
          name: '管道维护项目B',
          description: '地下管道防腐维护工程',
          role: '开发人员',
          progress: 60,
          startDate: '2024-02-01',
          deadline: '2024-11-30'
        },
        {
          id: 3,
          name: '设备检测项目C',
          description: '工业设备腐蚀检测系统',
          role: '测试人员',
          progress: 30,
          startDate: '2024-03-01',
          deadline: '2024-10-31'
        }
      ]
    }
  },
  computed: {
    filteredProjects() {
      return this.projects.filter(project => {
        const matchesSearch = project.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                             project.description.toLowerCase().includes(this.searchQuery.toLowerCase())
        const matchesRole = !this.roleFilter || project.role === this.roleFilter
        return matchesSearch && matchesRole
      })
    }
  },
  methods: {
    joinProject() {
      this.$message.info('加入项目功能开发中')
    },
    viewProject(project) {
      // 打开项目详情对话框
      this.$alert(`
        <div style="text-align: left;">
          <h3>${project.name}</h3>
          <p><strong>描述：</strong>${project.description}</p>
          <p><strong>角色：</strong>${project.role}</p>
          <p><strong>进度：</strong>${project.progress}%</p>
          <p><strong>开始时间：</strong>${project.startDate}</p>
          <p><strong>截止时间：</strong>${project.deadline}</p>
        </div>
      `, '项目详情', {
        dangerouslyUseHTMLString: true,
        confirmButtonText: '关闭'
      })
    },
    viewTasks(project) {
      // 跳转到任务页面，并传递项目ID
      this.$router.push({
        name: 'PersonalTasks',
        query: { projectId: project.id, projectName: project.name }
      })
    }
  }
}
</script>

<style scoped>
.personal-projects {
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

.projects-list {
  display: grid;
  gap: 20px;
}

.project-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.project-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.project-header h3 {
  color: #333;
  margin: 0;
}

.role {
  background-color: #e9ecef;
  color: #495057;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.project-description {
  color: #666;
  margin-bottom: 15px;
}

.project-progress {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 15px;
}

.progress-bar {
  flex: 1;
  height: 8px;
  background-color: #e9ecef;
  border-radius: 4px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background-color: #007bff;
  transition: width 0.3s ease;
}

.progress-text {
  font-size: 14px;
  color: #666;
  min-width: 40px;
}

.project-meta {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}

.project-actions {
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

.btn-sm {
  padding: 4px 8px;
  font-size: 12px;
}
</style>

