<template>
  <div class="info-plaza">
    <div class="page-header">
      <h1>信息广场</h1>
      <div class="header-actions">
        <router-link to="/dashboard/info-plaza/publish" class="btn btn-primary">
          发布信息
        </router-link>
      </div>
    </div>
    
    <div class="filters">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="搜索信息..."
        class="search-input"
      >
      <select v-model="postTypeFilter" class="filter-select">
        <option value="">全部类型</option>
        <option value="supply">供应信息</option>
        <option value="demand">需求信息</option>
        <option value="recruitment">招聘信息</option>
        <option value="tender">招标信息</option>
        <option value="technology">技术文章</option>
        <option value="news">行业资讯</option>
        <option value="other">其他</option>
      </select>
      <select v-model="sortBy" class="filter-select">
        <option value="-published_at">最新发布</option>
        <option value="-like_count">最受欢迎</option>
        <option value="-view_count">最多浏览</option>
      </select>
    </div>
    
    <div v-if="loading" class="loading">加载中...</div>
    
    <div v-else class="info-list">
      <div v-if="infos.length === 0" class="empty-state">
        <p>暂无信息</p>
      </div>
      <div v-for="info in infos" :key="info.id" class="info-card">
        <div class="info-header">
          <h3>{{ info.title }}</h3>
          <span class="category">{{ info.post_type_display }}</span>
        </div>
        <p class="info-summary">{{ info.summary || '暂无摘要' }}</p>
        <div class="info-meta">
          <span>发布者: {{ info.author_name }}</span>
          <span>发布时间: {{ formatDate(info.published_at) }}</span>
          <span>浏览: {{ info.view_count }}</span>
          <span>点赞: {{ info.like_count }}</span>
        </div>
        <div class="info-actions">
          <router-link :to="`/dashboard/info-plaza/detail/${info.id}`" class="btn btn-sm btn-primary">
            查看详情
          </router-link>
          <button 
            :class="['btn', 'btn-sm', info.is_liked ? 'btn-liked' : 'btn-outline']" 
            @click="toggleLike(info)"
          >
            <span v-if="info.is_liked">❤️ 已点赞</span>
            <span v-else>🤍 点赞</span>
            ({{ info.like_count }})
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { ElMessage } from 'element-plus'
import api from '@/api'

const loading = ref(false)
const searchQuery = ref('')
const postTypeFilter = ref('')
const sortBy = ref('-published_at')
const infos = ref([])

// 加载信息列表
const loadInfos = async () => {
  try {
    loading.value = true
    
    const params = {
      ordering: sortBy.value
    }
    
    if (searchQuery.value) {
      params.search = searchQuery.value
    }
    
    if (postTypeFilter.value) {
      params.post_type = postTypeFilter.value
    }
    
    const response = await api.get('/info-plaza/posts/', { params })
    infos.value = response.data.results || response.data
  } catch (error) {
    console.error('加载信息失败:', error)
    ElMessage.error('加载信息失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 点赞/取消点赞
const toggleLike = async (info) => {
  try {
    const response = await api.post(`/info-plaza/posts/${info.id}/like/`)
    
    // 更新点赞状态和数量
    if (response.data.liked) {
      info.is_liked = true
      info.like_count += 1
      ElMessage.success('点赞成功')
    } else {
      info.is_liked = false
      info.like_count -= 1
      ElMessage.success('已取消点赞')
    }
  } catch (error) {
    console.error('点赞失败:', error)
    ElMessage.error('操作失败，请重试')
  }
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  })
}

// 监听筛选条件变化
watch([searchQuery, postTypeFilter, sortBy], () => {
  loadInfos()
})

// 组件挂载时加载数据
onMounted(() => {
  loadInfos()
})
</script>

<style scoped>
.info-plaza {
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

.info-list {
  display: grid;
  gap: 20px;
}

.info-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.info-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.info-header h3 {
  color: #333;
  margin: 0;
}

.category {
  background-color: #e9ecef;
  color: #495057;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.info-summary {
  color: #666;
  margin-bottom: 15px;
  line-height: 1.5;
}

.info-meta {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}

.info-actions {
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
  text-decoration: none;
  display: inline-block;
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

.btn-liked {
  background-color: #ff4d4f;
  color: white;
  border: 1px solid #ff4d4f;
}

.btn-liked:hover {
  background-color: #ff7875;
  border-color: #ff7875;
}

.loading {
  text-align: center;
  padding: 40px;
  color: #666;
  font-size: 16px;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
  font-size: 16px;
}
</style>

