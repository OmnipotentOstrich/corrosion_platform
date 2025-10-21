from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.db.models import Q, Count, Sum, Avg
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.utils import timezone
from datetime import datetime, timedelta
import psutil
import os

from .models import (
    SystemConfig, SystemLog, SystemStatistics, SystemNotification,
    SystemBackup, SystemMonitor
)
from .serializers import (
    SystemConfigSerializer, SystemLogSerializer, SystemStatisticsSerializer,
    SystemNotificationSerializer, SystemBackupSerializer, SystemMonitorSerializer,
    DashboardStatisticsSerializer, SystemHealthSerializer
)
from apps.users.models import User
from apps.enterprises.models import Enterprise
from apps.persons.models import Person
from apps.info_plaza.models import InfoPost
from apps.resources.models import Resource


class SystemConfigListCreateView(generics.ListCreateAPIView):
    """系统配置列表和创建"""
    queryset = SystemConfig.objects.all()
    serializer_class = SystemConfigSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['config_type', 'is_active']
    search_fields = ['key', 'description']
    ordering_fields = ['key', 'created_at']
    ordering = ['config_type', 'key']


class SystemConfigDetailView(generics.RetrieveUpdateDestroyAPIView):
    """系统配置详情"""
    queryset = SystemConfig.objects.all()
    serializer_class = SystemConfigSerializer
    permission_classes = [permissions.IsAuthenticated]


class SystemLogListView(generics.ListAPIView):
    """系统日志列表"""
    queryset = SystemLog.objects.all()
    serializer_class = SystemLogSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['level', 'log_type', 'user', 'module']
    search_fields = ['message', 'module', 'request_path']
    ordering_fields = ['created_at', 'level']
    ordering = ['-created_at']


class SystemStatisticsListView(generics.ListAPIView):
    """系统统计列表"""
    queryset = SystemStatistics.objects.all()
    serializer_class = SystemStatisticsSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['stat_type', 'metric_name']
    search_fields = ['metric_name']
    ordering_fields = ['stat_date', 'stat_hour', 'created_at']
    ordering = ['-stat_date', '-stat_hour']


class SystemNotificationListCreateView(generics.ListCreateAPIView):
    """系统通知列表和创建"""
    queryset = SystemNotification.objects.all()
    serializer_class = SystemNotificationSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['notification_type', 'priority', 'is_read', 'is_active']
    search_fields = ['title', 'content']
    ordering_fields = ['priority', 'created_at']
    ordering = ['-priority', '-created_at']


class SystemNotificationDetailView(generics.RetrieveUpdateDestroyAPIView):
    """系统通知详情"""
    queryset = SystemNotification.objects.all()
    serializer_class = SystemNotificationSerializer
    permission_classes = [permissions.IsAuthenticated]


class SystemBackupListCreateView(generics.ListCreateAPIView):
    """系统备份列表和创建"""
    queryset = SystemBackup.objects.all()
    serializer_class = SystemBackupSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['backup_type', 'status', 'created_by']
    search_fields = ['name', 'description']
    ordering_fields = ['created_at', 'start_time', 'end_time']
    ordering = ['-created_at']
    
    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)


class SystemBackupDetailView(generics.RetrieveUpdateDestroyAPIView):
    """系统备份详情"""
    queryset = SystemBackup.objects.all()
    serializer_class = SystemBackupSerializer
    permission_classes = [permissions.IsAuthenticated]


class SystemMonitorListView(generics.ListAPIView):
    """系统监控列表"""
    queryset = SystemMonitor.objects.all()
    serializer_class = SystemMonitorSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['monitor_type', 'status']
    search_fields = ['metric_name']
    ordering_fields = ['created_at', 'metric_value']
    ordering = ['-created_at']


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def dashboard_statistics(request):
    """仪表板统计数据"""
    today = timezone.now().date()
    
    # 基础统计
    total_users = User.objects.count()
    total_enterprises = Enterprise.objects.count()
    total_persons = Person.objects.count()
    total_info_posts = InfoPost.objects.filter(status='published').count()
    total_resources = Resource.objects.filter(is_public=True).count()
    
    # 今日统计
    active_users_today = User.objects.filter(
        last_login__date=today
    ).count()
    
    new_users_today = User.objects.filter(
        date_joined__date=today
    ).count()
    
    new_posts_today = InfoPost.objects.filter(
        published_at__date=today
    ).count()
    
    # 系统健康状态
    system_health = "healthy"
    
    # API响应时间（模拟）
    api_response_time = 150.5
    
    # 数据库连接数（模拟）
    database_connections = 25
    
    data = {
        'total_users': total_users,
        'total_enterprises': total_enterprises,
        'total_persons': total_persons,
        'total_info_posts': total_info_posts,
        'total_resources': total_resources,
        'active_users_today': active_users_today,
        'new_users_today': new_users_today,
        'new_posts_today': new_posts_today,
        'system_health': system_health,
        'api_response_time': api_response_time,
        'database_connections': database_connections
    }
    
    serializer = DashboardStatisticsSerializer(data)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def system_health(request):
    """系统健康状态"""
    try:
        # CPU使用率
        cpu_usage = psutil.cpu_percent(interval=1)
        
        # 内存使用率
        memory = psutil.virtual_memory()
        memory_usage = memory.percent
        
        # 磁盘使用率
        disk = psutil.disk_usage('/')
        disk_usage = (disk.used / disk.total) * 100
        
        # 数据库状态（模拟）
        database_status = "healthy"
        
        # API状态（模拟）
        api_status = "healthy"
        
        # 系统状态
        status = "healthy"
        if cpu_usage > 80 or memory_usage > 80 or disk_usage > 80:
            status = "warning"
        if cpu_usage > 90 or memory_usage > 90 or disk_usage > 90:
            status = "critical"
        
        data = {
            'status': status,
            'cpu_usage': cpu_usage,
            'memory_usage': memory_usage,
            'disk_usage': disk_usage,
            'database_status': database_status,
            'api_status': api_status,
            'last_check': timezone.now()
        }
        
        serializer = SystemHealthSerializer(data)
        return Response(serializer.data)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def user_statistics(request):
    """用户统计"""
    # 用户类型统计
    enterprise_users = User.objects.filter(user_type='enterprise').count()
    personal_users = User.objects.filter(user_type='personal').count()
    
    # 用户活跃度统计（最近30天）
    thirty_days_ago = timezone.now() - timedelta(days=30)
    active_users = User.objects.filter(last_login__gte=thirty_days_ago).count()
    
    # 用户注册趋势（最近7天）
    registration_trend = []
    for i in range(7):
        date = timezone.now().date() - timedelta(days=i)
        count = User.objects.filter(date_joined__date=date).count()
        registration_trend.append({
            'date': date.strftime('%Y-%m-%d'),
            'count': count
        })
    
    return Response({
        'enterprise_users': enterprise_users,
        'personal_users': personal_users,
        'active_users': active_users,
        'registration_trend': registration_trend
    })


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def content_statistics(request):
    """内容统计"""
    # 信息发布统计
    total_posts = InfoPost.objects.count()
    published_posts = InfoPost.objects.filter(status='published').count()
    pending_posts = InfoPost.objects.filter(status='pending').count()
    
    # 信息类型统计
    post_type_stats = InfoPost.objects.values('post_type').annotate(
        count=Count('id')
    ).order_by('-count')
    
    # 资源统计
    total_resources = Resource.objects.count()
    available_resources = Resource.objects.filter(status='available').count()
    rental_resources = Resource.objects.filter(is_available_for_rent=True).count()
    
    # 资源类型统计
    resource_type_stats = Resource.objects.values('resource_type__name').annotate(
        count=Count('id')
    ).order_by('-count')
    
    return Response({
        'posts': {
            'total': total_posts,
            'published': published_posts,
            'pending': pending_posts,
            'type_stats': list(post_type_stats)
        },
        'resources': {
            'total': total_resources,
            'available': available_resources,
            'rental': rental_resources,
            'type_stats': list(resource_type_stats)
        }
    })


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def system_logs_summary(request):
    """系统日志摘要"""
    # 最近24小时的日志统计
    twenty_four_hours_ago = timezone.now() - timedelta(hours=24)
    
    # 按级别统计
    level_stats = SystemLog.objects.filter(
        created_at__gte=twenty_four_hours_ago
    ).values('level').annotate(count=Count('id')).order_by('-count')
    
    # 按类型统计
    type_stats = SystemLog.objects.filter(
        created_at__gte=twenty_four_hours_ago
    ).values('log_type').annotate(count=Count('id')).order_by('-count')
    
    # 错误日志
    error_logs = SystemLog.objects.filter(
        level__in=['ERROR', 'CRITICAL'],
        created_at__gte=twenty_four_hours_ago
    ).order_by('-created_at')[:10]
    
    return Response({
        'level_stats': list(level_stats),
        'type_stats': list(type_stats),
        'error_logs': SystemLogSerializer(error_logs, many=True).data
    })


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def create_backup(request):
    """创建系统备份"""
    backup_type = request.data.get('backup_type', 'database')
    name = request.data.get('name', f'backup_{timezone.now().strftime("%Y%m%d_%H%M%S")}')
    description = request.data.get('description', '')
    
    backup = SystemBackup.objects.create(
        backup_type=backup_type,
        name=name,
        description=description,
        status='pending',
        created_by=request.user
    )
    
    # 这里应该启动实际的备份任务
    # 为了演示，我们直接设置为完成状态
    backup.status = 'completed'
    backup.start_time = timezone.now()
    backup.end_time = timezone.now()
    backup.file_path = f'/backups/{name}.sql'
    backup.file_size = 1024 * 1024  # 1MB
    backup.save()
    
    serializer = SystemBackupSerializer(backup)
    return Response(serializer.data, status=status.HTTP_201_CREATED)
