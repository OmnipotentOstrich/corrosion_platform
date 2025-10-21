<template>
  <div class="info-detail">
    <div class="detail-header">
      <div class="breadcrumb">
        <router-link to="/dashboard/info-plaza">信息广场</router-link>
        <span class="separator">></span>
        <span>信息详情</span>
      </div>
      
      <div class="info-meta">
        <h1>{{ info.title }}</h1>
        <div class="meta-info">
          <span class="author">发布者: {{ info.author_name }}</span>
          <span class="time">发布时间: {{ formatDate(info.published_at) }}</span>
          <span class="category">{{ info.post_type_display }}</span>
        </div>
        <div class="stats">
          <span>浏览: {{ info.view_count || 0 }}</span>
          <span>点赞: {{ info.like_count || 0 }}</span>
          <span>评论: {{ info.comment_count || 0 }}</span>
        </div>
      </div>
      
      <div class="actions">
        <button 
          :class="['btn', info.is_liked ? 'btn-liked' : 'btn-outline']" 
          @click="toggleLike"
        >
          <span v-if="info.is_liked">❤️ 已点赞</span>
          <span v-else>🤍 点赞</span>
          ({{ info.like_count }})
        </button>
        <button class="btn btn-primary" @click="shareInfo">
          分享
        </button>
      </div>
    </div>
    
    <div class="detail-content">
      <div class="content-body">
        <h3>摘要</h3>
        <p class="summary">{{ info.summary }}</p>
        
        <h3>详细内容</h3>
        <div class="content-text">{{ info.content }}</div>
        
        <div v-if="info.tags" class="tags">
          <h4>标签</h4>
          <div class="tag-list">
            <span v-for="tag in info.tags" :key="tag" class="tag">{{ tag }}</span>
          </div>
        </div>
      </div>
      
      <div class="comments-section">
        <h3>评论 ({{ info.comment_count }})</h3>
        
        <div class="comment-form">
          <textarea 
            v-model="newComment" 
            placeholder="写下您的评论..."
            rows="3"
          ></textarea>
          <button class="btn btn-primary" @click="submitComment">
            发表评论
          </button>
        </div>
        
        <div class="comments-list">
          <div v-if="comments.length === 0" class="no-comments">
            暂无评论，快来发表第一条评论吧！
          </div>
          <div v-for="comment in comments" :key="comment.id" class="comment">
            <div class="comment-header">
              <span class="comment-author">{{ comment.author_name }}</span>
              <span class="comment-time">{{ formatDate(comment.created_at) }}</span>
            </div>
            <div class="comment-content">{{ comment.content }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import api from '@/api'

const route = useRoute()
const info = ref({
  title: '',
  summary: '',
  content: '',
  author_name: '',
  published_at: '',
  view_count: 0,
  like_count: 0,
  comment_count: 0,
  is_liked: false,
  post_type_display: '',
  tags: ''
})
const newComment = ref('')
const comments = ref([])
const loading = ref(false)

// 加载信息详情
const loadInfoDetail = async () => {
  try {
    loading.value = true
    const infoId = route.params.id
    const response = await api.get(`/info-plaza/posts/${infoId}/`)
    info.value = response.data
    
    // 加载评论
    loadComments()
  } catch (error) {
    console.error('加载信息详情失败:', error)
    ElMessage.error('加载信息详情失败')
  } finally {
    loading.value = false
  }
}

// 加载评论
const loadComments = async () => {
  try {
    const response = await api.get('/info-plaza/comments/', {
      params: { post: route.params.id }
    })
    comments.value = response.data.results || response.data
  } catch (error) {
    console.error('加载评论失败:', error)
  }
}

// 点赞/取消点赞
const toggleLike = async () => {
  try {
    const response = await api.post(`/info-plaza/posts/${route.params.id}/like/`)
    
    if (response.data.liked) {
      info.value.is_liked = true
      info.value.like_count += 1
      ElMessage.success('点赞成功')
    } else {
      info.value.is_liked = false
      info.value.like_count -= 1
      ElMessage.success('已取消点赞')
    }
  } catch (error) {
    console.error('点赞失败:', error)
    ElMessage.error('操作失败，请重试')
  }
}

// 分享信息
const shareInfo = () => {
  // 复制链接到剪贴板
  const url = window.location.href
  navigator.clipboard.writeText(url).then(() => {
    ElMessage.success('链接已复制到剪贴板')
  }).catch(() => {
    ElMessage.error('复制失败，请手动复制')
  })
}

// 提交评论
const submitComment = async () => {
  if (!newComment.value.trim()) {
    ElMessage.warning('请输入评论内容')
    return
  }
  
  try {
    await api.post('/info-plaza/comments/', {
      post: route.params.id,
      content: newComment.value
    })
    
    ElMessage.success('评论发表成功')
    newComment.value = ''
    info.value.comment_count += 1
    
    // 重新加载评论
    loadComments()
  } catch (error) {
    console.error('发表评论失败:', error)
    ElMessage.error('发表评论失败，请重试')
  }
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 组件挂载时加载数据
onMounted(() => {
  loadInfoDetail()
})
</script>

<style scoped>
.info-detail {
  padding: 20px;
}

.detail-header {
  background: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.breadcrumb {
  margin-bottom: 15px;
  font-size: 14px;
  color: #666;
}

.breadcrumb a {
  color: #007bff;
  text-decoration: none;
}

.breadcrumb a:hover {
  text-decoration: underline;
}

.separator {
  margin: 0 8px;
}

.info-meta h1 {
  color: #333;
  margin-bottom: 15px;
}

.meta-info {
  display: flex;
  gap: 20px;
  margin-bottom: 10px;
  font-size: 14px;
  color: #666;
}

.category {
  background-color: #e9ecef;
  color: #495057;
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 12px;
}

.stats {
  display: flex;
  gap: 20px;
  font-size: 14px;
  color: #666;
}

.actions {
  margin-top: 15px;
  display: flex;
  gap: 10px;
}

.detail-content {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 20px;
}

.content-body {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.content-body h3 {
  color: #333;
  margin-bottom: 10px;
}

.summary {
  color: #666;
  margin-bottom: 20px;
  font-style: italic;
}

.content-text {
  color: #333;
  line-height: 1.6;
  white-space: pre-line;
  margin-bottom: 20px;
}

.tags h4 {
  color: #333;
  margin-bottom: 10px;
}

.tag-list {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.tag {
  background-color: #e9ecef;
  color: #495057;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.comments-section {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #e0e0e0;
}

.comments-section h3 {
  color: #333;
  margin-bottom: 15px;
}

.comment-form {
  margin-bottom: 20px;
}

.comment-form textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  font-family: inherit;
  margin-bottom: 10px;
}

.comment-form textarea:focus {
  outline: none;
  border-color: #007bff;
}

.comments-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.comment {
  padding: 15px;
  background: #f8f9fa;
  border-radius: 6px;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 14px;
}

.comment-author {
  font-weight: 600;
  color: #333;
}

.comment-time {
  color: #666;
}

.comment-content {
  color: #333;
  line-height: 1.5;
}

.btn {
  padding: 8px 16px;
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

.btn-liked {
  background-color: #ff4d4f;
  color: white;
  border: 1px solid #ff4d4f;
}

.btn-liked:hover {
  background-color: #ff7875;
  border-color: #ff7875;
}

.no-comments {
  text-align: center;
  padding: 30px;
  color: #999;
  font-size: 14px;
}
</style>

