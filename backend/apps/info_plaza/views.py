from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.db.models import Q, Count, F
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.utils import timezone
from datetime import datetime, timedelta

from .models import (
    InfoCategory, InfoPost, InfoPostImage, InfoComment,
    InfoLike, InfoFavorite, InfoViewLog, InfoTag
)
from .serializers import (
    InfoCategorySerializer, InfoTagSerializer, InfoPostListSerializer,
    InfoPostDetailSerializer, InfoPostCreateSerializer, InfoPostImageSerializer,
    InfoCommentSerializer, InfoCommentCreateSerializer, InfoLikeSerializer,
    InfoFavoriteSerializer, InfoViewLogSerializer
)
from apps.users.utils import get_client_ip


class InfoCategoryListCreateView(generics.ListCreateAPIView):
    """信息分类列表和创建"""
    queryset = InfoCategory.objects.filter(is_active=True)
    serializer_class = InfoCategorySerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    search_fields = ['name', 'description']
    ordering_fields = ['sort_order', 'created_at']
    ordering = ['sort_order', 'created_at']


class InfoCategoryDetailView(generics.RetrieveUpdateDestroyAPIView):
    """信息分类详情"""
    queryset = InfoCategory.objects.all()
    serializer_class = InfoCategorySerializer
    permission_classes = [permissions.IsAuthenticated]


class InfoTagListCreateView(generics.ListCreateAPIView):
    """信息标签列表和创建"""
    queryset = InfoTag.objects.all()
    serializer_class = InfoTagSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    search_fields = ['name', 'description']
    ordering_fields = ['use_count', 'created_at']
    ordering = ['-use_count', 'name']


class InfoPostListCreateView(generics.ListCreateAPIView):
    """信息发布列表和创建"""
    queryset = InfoPost.objects.filter(status='published')
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['post_type', 'category', 'priority', 'is_top', 'is_recommended']
    search_fields = ['title', 'content', 'summary', 'tags', 'location']
    ordering_fields = ['published_at', 'created_at', 'view_count', 'like_count']
    ordering = ['-is_top', '-published_at', '-created_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return InfoPostCreateSerializer
        return InfoPostListSerializer
    
    def get_queryset(self):
        queryset = super().get_queryset()
        
        # 非管理员只能看到已发布的信息
        if not self.request.user.is_staff:
            return queryset.filter(status='published')
        
        # 管理员可以看到所有信息
        return InfoPost.objects.all()
    
    def perform_create(self, serializer):
        serializer.save(author=self.request.user)


class InfoPostDetailView(generics.RetrieveUpdateDestroyAPIView):
    """信息发布详情"""
    queryset = InfoPost.objects.all()
    permission_classes = [permissions.IsAuthenticated]
    
    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return InfoPostCreateSerializer
        return InfoPostDetailSerializer
    
    def get_queryset(self):
        # 非管理员只能看到已发布的信息
        if not self.request.user.is_staff:
            return InfoPost.objects.filter(status='published')
        return super().get_queryset()
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        
        # 记录浏览日志
        InfoViewLog.objects.create(
            post=instance,
            user=request.user if request.user.is_authenticated else None,
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', '')
        )
        
        # 增加浏览次数
        InfoPost.objects.filter(id=instance.id).update(view_count=F('view_count') + 1)
        
        serializer = self.get_serializer(instance)
        return Response(serializer.data)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def publish_post(request, post_id):
    """发布信息"""
    try:
        post = InfoPost.objects.get(id=post_id, author=request.user)
        if post.status == 'published':
            return Response({'error': '信息已发布'}, status=status.HTTP_400_BAD_REQUEST)
        
        post.status = 'published'
        post.published_at = timezone.now()
        post.save()
        
        return Response({'message': '信息发布成功'})
    except InfoPost.DoesNotExist:
        return Response({'error': '信息不存在'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def like_post(request, post_id):
    """点赞信息"""
    try:
        post = InfoPost.objects.get(id=post_id)
        like, created = InfoLike.objects.get_or_create(post=post, user=request.user)
        
        if created:
            # 增加点赞数
            InfoPost.objects.filter(id=post_id).update(like_count=F('like_count') + 1)
            return Response({'message': '点赞成功', 'liked': True})
        else:
            # 取消点赞
            like.delete()
            InfoPost.objects.filter(id=post_id).update(like_count=F('like_count') - 1)
            return Response({'message': '取消点赞', 'liked': False})
    except InfoPost.DoesNotExist:
        return Response({'error': '信息不存在'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def favorite_post(request, post_id):
    """收藏信息"""
    try:
        post = InfoPost.objects.get(id=post_id)
        favorite, created = InfoFavorite.objects.get_or_create(post=post, user=request.user)
        
        if created:
            return Response({'message': '收藏成功', 'favorited': True})
        else:
            favorite.delete()
            return Response({'message': '取消收藏', 'favorited': False})
    except InfoPost.DoesNotExist:
        return Response({'error': '信息不存在'}, status=status.HTTP_404_NOT_FOUND)


class InfoCommentListCreateView(generics.ListCreateAPIView):
    """信息评论列表和创建"""
    queryset = InfoComment.objects.filter(is_approved=True, parent__isnull=True)
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['post']
    ordering_fields = ['created_at']
    ordering = ['-created_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return InfoCommentCreateSerializer
        return InfoCommentSerializer


class InfoCommentDetailView(generics.RetrieveUpdateDestroyAPIView):
    """信息评论详情"""
    queryset = InfoComment.objects.all()
    serializer_class = InfoCommentSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        # 非管理员只能看到已审核的评论
        if not self.request.user.is_staff:
            return InfoComment.objects.filter(is_approved=True)
        return super().get_queryset()


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def my_posts(request):
    """我的信息发布"""
    posts = InfoPost.objects.filter(author=request.user).order_by('-created_at')
    serializer = InfoPostListSerializer(posts, many=True, context={'request': request})
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def my_favorites(request):
    """我的收藏"""
    favorites = InfoFavorite.objects.filter(user=request.user).select_related('post').order_by('-created_at')
    posts = [favorite.post for favorite in favorites]
    serializer = InfoPostListSerializer(posts, many=True, context={'request': request})
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def hot_posts(request):
    """热门信息"""
    # 获取最近7天的热门信息
    week_ago = timezone.now() - timedelta(days=7)
    posts = InfoPost.objects.filter(
        status='published',
        published_at__gte=week_ago
    ).order_by('-view_count', '-like_count')[:20]
    
    serializer = InfoPostListSerializer(posts, many=True, context={'request': request})
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def recommended_posts(request):
    """推荐信息"""
    posts = InfoPost.objects.filter(
        status='published',
        is_recommended=True
    ).order_by('-published_at')[:20]
    
    serializer = InfoPostListSerializer(posts, many=True, context={'request': request})
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def search_posts(request):
    """搜索信息"""
    query = request.GET.get('q', '')
    post_type = request.GET.get('type', '')
    category_id = request.GET.get('category', '')
    location = request.GET.get('location', '')
    
    queryset = InfoPost.objects.filter(status='published')
    
    if query:
        queryset = queryset.filter(
            Q(title__icontains=query) |
            Q(content__icontains=query) |
            Q(summary__icontains=query) |
            Q(tags__icontains=query)
        )
    
    if post_type:
        queryset = queryset.filter(post_type=post_type)
    
    if category_id:
        queryset = queryset.filter(category_id=category_id)
    
    if location:
        queryset = queryset.filter(location__icontains=location)
    
    queryset = queryset.order_by('-published_at')
    
    serializer = InfoPostListSerializer(queryset, many=True, context={'request': request})
    return Response(serializer.data)
