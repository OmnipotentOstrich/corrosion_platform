from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone

User = get_user_model()


class InfoCategory(models.Model):
    """信息分类"""
    name = models.CharField(max_length=50, unique=True, verbose_name='分类名称')
    code = models.CharField(max_length=50, unique=True, verbose_name='分类代码')
    description = models.TextField(blank=True, verbose_name='分类描述')
    icon = models.CharField(max_length=50, blank=True, verbose_name='分类图标')
    sort_order = models.IntegerField(default=0, verbose_name='排序')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'info_categories'
        verbose_name = '信息分类'
        verbose_name_plural = '信息分类'
        ordering = ['sort_order', 'id']
    
    def __str__(self):
        return self.name


class InfoPost(models.Model):
    """信息发布"""
    POST_TYPE_CHOICES = [
        ('supply', '供应信息'),
        ('demand', '需求信息'),
        ('recruitment', '招聘信息'),
        ('tender', '招标信息'),
        ('technology', '技术文章'),
        ('news', '行业资讯'),
        ('other', '其他'),
    ]
    
    STATUS_CHOICES = [
        ('draft', '草稿'),
        ('pending', '待审核'),
        ('published', '已发布'),
        ('rejected', '已拒绝'),
        ('archived', '已归档'),
    ]
    
    PRIORITY_CHOICES = [
        ('normal', '普通'),
        ('high', '高'),
        ('urgent', '紧急'),
    ]
    
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name='info_posts', verbose_name='发布者')
    category = models.ForeignKey(InfoCategory, on_delete=models.SET_NULL, null=True, blank=True, related_name='posts', verbose_name='分类')
    post_type = models.CharField(max_length=20, choices=POST_TYPE_CHOICES, verbose_name='信息类型')
    title = models.CharField(max_length=200, verbose_name='标题')
    content = models.TextField(verbose_name='内容')
    summary = models.TextField(blank=True, verbose_name='摘要')
    tags = models.CharField(max_length=500, blank=True, verbose_name='标签')
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES, default='normal', verbose_name='优先级')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='draft', verbose_name='状态')
    is_top = models.BooleanField(default=False, verbose_name='是否置顶')
    is_recommended = models.BooleanField(default=False, verbose_name='是否推荐')
    view_count = models.IntegerField(default=0, verbose_name='浏览次数')
    like_count = models.IntegerField(default=0, verbose_name='点赞数')
    comment_count = models.IntegerField(default=0, verbose_name='评论数')
    share_count = models.IntegerField(default=0, verbose_name='分享数')
    contact_info = models.TextField(blank=True, verbose_name='联系信息')
    location = models.CharField(max_length=200, blank=True, verbose_name='地点')
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, verbose_name='价格')
    valid_until = models.DateTimeField(null=True, blank=True, verbose_name='有效期至')
    published_at = models.DateTimeField(null=True, blank=True, verbose_name='发布时间')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'info_posts'
        verbose_name = '信息发布'
        verbose_name_plural = '信息发布'
        ordering = ['-is_top', '-published_at', '-created_at']
    
    def __str__(self):
        return self.title


class InfoPostImage(models.Model):
    """信息发布图片"""
    post = models.ForeignKey(InfoPost, on_delete=models.CASCADE, related_name='images', verbose_name='信息发布')
    image = models.ImageField(upload_to='info_post_images/', verbose_name='图片')
    caption = models.CharField(max_length=200, blank=True, verbose_name='图片说明')
    sort_order = models.IntegerField(default=0, verbose_name='排序')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'info_post_images'
        verbose_name = '信息发布图片'
        verbose_name_plural = '信息发布图片'
        ordering = ['sort_order', 'id']
    
    def __str__(self):
        return f"{self.post.title} - 图片{self.sort_order}"


class InfoComment(models.Model):
    """信息评论"""
    post = models.ForeignKey(InfoPost, on_delete=models.CASCADE, related_name='comments', verbose_name='信息发布')
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name='info_comments', verbose_name='评论者')
    parent = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='replies', verbose_name='父评论')
    content = models.TextField(verbose_name='评论内容')
    like_count = models.IntegerField(default=0, verbose_name='点赞数')
    is_approved = models.BooleanField(default=True, verbose_name='是否审核通过')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'info_comments'
        verbose_name = '信息评论'
        verbose_name_plural = '信息评论'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.post.title} - {self.author.username}的评论"


class InfoLike(models.Model):
    """信息点赞"""
    post = models.ForeignKey(InfoPost, on_delete=models.CASCADE, related_name='likes', verbose_name='信息发布')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='info_likes', verbose_name='用户')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'info_likes'
        verbose_name = '信息点赞'
        verbose_name_plural = '信息点赞'
        unique_together = ['post', 'user']
    
    def __str__(self):
        return f"{self.user.username} 点赞了 {self.post.title}"


class InfoFavorite(models.Model):
    """信息收藏"""
    post = models.ForeignKey(InfoPost, on_delete=models.CASCADE, related_name='favorites', verbose_name='信息发布')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='info_favorites', verbose_name='用户')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'info_favorites'
        verbose_name = '信息收藏'
        verbose_name_plural = '信息收藏'
        unique_together = ['post', 'user']
    
    def __str__(self):
        return f"{self.user.username} 收藏了 {self.post.title}"


class InfoViewLog(models.Model):
    """信息浏览日志"""
    post = models.ForeignKey(InfoPost, on_delete=models.CASCADE, related_name='view_logs', verbose_name='信息发布')
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='info_view_logs', verbose_name='用户')
    ip_address = models.GenericIPAddressField(verbose_name='IP地址')
    user_agent = models.TextField(verbose_name='用户代理')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'info_view_logs'
        verbose_name = '信息浏览日志'
        verbose_name_plural = '信息浏览日志'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.post.title} - 浏览记录"


class InfoTag(models.Model):
    """信息标签"""
    name = models.CharField(max_length=50, unique=True, verbose_name='标签名称')
    description = models.TextField(blank=True, verbose_name='标签描述')
    color = models.CharField(max_length=7, default='#1890ff', verbose_name='标签颜色')
    use_count = models.IntegerField(default=0, verbose_name='使用次数')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'info_tags'
        verbose_name = '信息标签'
        verbose_name_plural = '信息标签'
        ordering = ['-use_count', 'name']
    
    def __str__(self):
        return self.name
