from django.contrib import admin
from .models import (
    InfoCategory, InfoPost, InfoPostImage, InfoComment,
    InfoLike, InfoFavorite, InfoViewLog, InfoTag
)


@admin.register(InfoCategory)
class InfoCategoryAdmin(admin.ModelAdmin):
    """信息分类管理"""
    list_display = ['name', 'code', 'sort_order', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['name', 'code', 'description']
    ordering = ['sort_order', 'created_at']


@admin.register(InfoTag)
class InfoTagAdmin(admin.ModelAdmin):
    """信息标签管理"""
    list_display = ['name', 'color', 'use_count', 'created_at']
    list_filter = ['created_at']
    search_fields = ['name', 'description']
    ordering = ['-use_count', 'name']


@admin.register(InfoPost)
class InfoPostAdmin(admin.ModelAdmin):
    """信息发布管理"""
    list_display = [
        'title', 'author', 'category', 'post_type', 'status',
        'is_top', 'is_recommended', 'view_count', 'like_count',
        'published_at', 'created_at'
    ]
    list_filter = ['post_type', 'status', 'category', 'is_top', 'is_recommended', 'created_at']
    search_fields = ['title', 'content', 'author__username', 'tags', 'location']
    ordering = ['-created_at']
    readonly_fields = ['view_count', 'like_count', 'comment_count', 'share_count', 'published_at', 'created_at', 'updated_at']


@admin.register(InfoPostImage)
class InfoPostImageAdmin(admin.ModelAdmin):
    """信息发布图片管理"""
    list_display = ['post', 'caption', 'sort_order', 'created_at']
    list_filter = ['created_at']
    search_fields = ['post__title', 'caption']
    ordering = ['post', 'sort_order']


@admin.register(InfoComment)
class InfoCommentAdmin(admin.ModelAdmin):
    """信息评论管理"""
    list_display = ['post', 'author', 'is_approved', 'like_count', 'created_at']
    list_filter = ['is_approved', 'created_at']
    search_fields = ['post__title', 'author__username', 'content']
    ordering = ['-created_at']
    readonly_fields = ['like_count', 'created_at', 'updated_at']


@admin.register(InfoLike)
class InfoLikeAdmin(admin.ModelAdmin):
    """信息点赞管理"""
    list_display = ['post', 'user', 'created_at']
    list_filter = ['created_at']
    search_fields = ['post__title', 'user__username']
    ordering = ['-created_at']
    readonly_fields = ['created_at']


@admin.register(InfoFavorite)
class InfoFavoriteAdmin(admin.ModelAdmin):
    """信息收藏管理"""
    list_display = ['post', 'user', 'created_at']
    list_filter = ['created_at']
    search_fields = ['post__title', 'user__username']
    ordering = ['-created_at']
    readonly_fields = ['created_at']


@admin.register(InfoViewLog)
class InfoViewLogAdmin(admin.ModelAdmin):
    """信息浏览日志管理"""
    list_display = ['post', 'user', 'ip_address', 'created_at']
    list_filter = ['created_at']
    search_fields = ['post__title', 'user__username', 'ip_address']
    ordering = ['-created_at']
    readonly_fields = ['created_at']
