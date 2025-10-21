from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import (
    InfoCategory, InfoPost, InfoPostImage, InfoComment,
    InfoLike, InfoFavorite, InfoViewLog, InfoTag
)

User = get_user_model()


class InfoCategorySerializer(serializers.ModelSerializer):
    """信息分类序列化器"""
    
    class Meta:
        model = InfoCategory
        fields = [
            'id', 'name', 'code', 'description', 'icon',
            'sort_order', 'is_active', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class InfoTagSerializer(serializers.ModelSerializer):
    """信息标签序列化器"""
    
    class Meta:
        model = InfoTag
        fields = [
            'id', 'name', 'description', 'color', 'use_count', 'created_at'
        ]
        read_only_fields = ['id', 'use_count', 'created_at']


class InfoPostImageSerializer(serializers.ModelSerializer):
    """信息发布图片序列化器"""
    
    class Meta:
        model = InfoPostImage
        fields = [
            'id', 'post', 'image', 'caption', 'sort_order', 'created_at'
        ]
        read_only_fields = ['id', 'post', 'created_at']


class InfoPostListSerializer(serializers.ModelSerializer):
    """信息发布列表序列化器"""
    post_type_display = serializers.CharField(source='get_post_type_display', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    priority_display = serializers.CharField(source='get_priority_display', read_only=True)
    author_name = serializers.CharField(source='author.username', read_only=True)
    category_name = serializers.CharField(source='category.name', read_only=True)
    first_image = serializers.SerializerMethodField()
    is_liked = serializers.SerializerMethodField()
    is_favorited = serializers.SerializerMethodField()
    
    class Meta:
        model = InfoPost
        fields = [
            'id', 'author', 'author_name', 'category', 'category_name',
            'post_type', 'post_type_display', 'title', 'summary',
            'tags', 'priority', 'priority_display', 'status', 'status_display',
            'is_top', 'is_recommended', 'view_count', 'like_count',
            'comment_count', 'share_count', 'location', 'price',
            'valid_until', 'published_at', 'created_at', 'updated_at',
            'first_image', 'is_liked', 'is_favorited'
        ]
        read_only_fields = [
            'id', 'author', 'view_count', 'like_count', 'comment_count',
            'share_count', 'published_at', 'created_at', 'updated_at'
        ]
    
    def get_first_image(self, obj):
        first_image = obj.images.first()
        if first_image:
            return InfoPostImageSerializer(first_image).data
        return None
    
    def get_is_liked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return InfoLike.objects.filter(post=obj, user=request.user).exists()
        return False
    
    def get_is_favorited(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return InfoFavorite.objects.filter(post=obj, user=request.user).exists()
        return False


class InfoPostDetailSerializer(serializers.ModelSerializer):
    """信息发布详情序列化器"""
    post_type_display = serializers.CharField(source='get_post_type_display', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    priority_display = serializers.CharField(source='get_priority_display', read_only=True)
    author_name = serializers.CharField(source='author.username', read_only=True)
    category_name = serializers.CharField(source='category.name', read_only=True)
    images = InfoPostImageSerializer(many=True, read_only=True)
    is_liked = serializers.SerializerMethodField()
    is_favorited = serializers.SerializerMethodField()
    
    class Meta:
        model = InfoPost
        fields = [
            'id', 'author', 'author_name', 'category', 'category_name',
            'post_type', 'post_type_display', 'title', 'content', 'summary',
            'tags', 'priority', 'priority_display', 'status', 'status_display',
            'is_top', 'is_recommended', 'view_count', 'like_count',
            'comment_count', 'share_count', 'contact_info', 'location',
            'price', 'valid_until', 'published_at', 'created_at', 'updated_at',
            'images', 'is_liked', 'is_favorited'
        ]
        read_only_fields = [
            'id', 'author', 'view_count', 'like_count', 'comment_count',
            'share_count', 'published_at', 'created_at', 'updated_at'
        ]
    
    def get_is_liked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return InfoLike.objects.filter(post=obj, user=request.user).exists()
        return False
    
    def get_is_favorited(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return InfoFavorite.objects.filter(post=obj, user=request.user).exists()
        return False


class InfoPostCreateSerializer(serializers.ModelSerializer):
    """信息发布创建序列化器"""
    images = InfoPostImageSerializer(many=True, required=False)
    
    class Meta:
        model = InfoPost
        fields = [
            'category', 'post_type', 'title', 'content', 'summary',
            'tags', 'priority', 'contact_info', 'location', 'price', 'valid_until'
        ]
    
    def create(self, validated_data):
        images_data = validated_data.pop('images', [])
        post = InfoPost.objects.create(**validated_data)
        
        for image_data in images_data:
            InfoPostImage.objects.create(post=post, **image_data)
        
        return post


class InfoCommentSerializer(serializers.ModelSerializer):
    """信息评论序列化器"""
    author_name = serializers.CharField(source='author.username', read_only=True)
    author_avatar = serializers.CharField(source='author.avatar', read_only=True)
    replies = serializers.SerializerMethodField()
    is_liked = serializers.SerializerMethodField()
    
    class Meta:
        model = InfoComment
        fields = [
            'id', 'post', 'author', 'author_name', 'author_avatar',
            'parent', 'content', 'like_count', 'is_approved',
            'created_at', 'updated_at', 'replies', 'is_liked'
        ]
        read_only_fields = [
            'id', 'post', 'author', 'like_count', 'is_approved',
            'created_at', 'updated_at'
        ]
    
    def get_replies(self, obj):
        replies = InfoComment.objects.filter(parent=obj, is_approved=True).order_by('created_at')
        return InfoCommentSerializer(replies, many=True, context=self.context).data
    
    def get_is_liked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            # 这里可以添加评论点赞功能
            return False
        return False


class InfoCommentCreateSerializer(serializers.ModelSerializer):
    """信息评论创建序列化器"""
    
    class Meta:
        model = InfoComment
        fields = ['post', 'parent', 'content']
    
    def create(self, validated_data):
        validated_data['author'] = self.context['request'].user
        return super().create(validated_data)


class InfoLikeSerializer(serializers.ModelSerializer):
    """信息点赞序列化器"""
    user_name = serializers.CharField(source='user.username', read_only=True)
    
    class Meta:
        model = InfoLike
        fields = ['id', 'post', 'user', 'user_name', 'created_at']
        read_only_fields = ['id', 'user', 'created_at']


class InfoFavoriteSerializer(serializers.ModelSerializer):
    """信息收藏序列化器"""
    user_name = serializers.CharField(source='user.username', read_only=True)
    post_title = serializers.CharField(source='post.title', read_only=True)
    
    class Meta:
        model = InfoFavorite
        fields = ['id', 'post', 'post_title', 'user', 'user_name', 'created_at']
        read_only_fields = ['id', 'user', 'created_at']


class InfoViewLogSerializer(serializers.ModelSerializer):
    """信息浏览日志序列化器"""
    user_name = serializers.CharField(source='user.username', read_only=True)
    post_title = serializers.CharField(source='post.title', read_only=True)
    
    class Meta:
        model = InfoViewLog
        fields = [
            'id', 'post', 'post_title', 'user', 'user_name',
            'ip_address', 'user_agent', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']
