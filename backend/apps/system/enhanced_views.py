"""
增强的系统管理视图
提供更完整的系统配置层功能
"""
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
import json

from .models import (
    SystemConfig, SystemLog, SystemStatistics, SystemNotification,
    SystemBackup, SystemMonitor, SystemSecurityLog, SystemPageConfig,
    SystemAnalytics, SystemMaintenance
)
from .serializers import (
    SystemConfigSerializer, SystemLogSerializer, SystemStatisticsSerializer,
    SystemNotificationSerializer, SystemBackupSerializer, SystemMonitorSerializer,
    SystemSecurityLogSerializer, SystemPageConfigSerializer, SystemAnalyticsSerializer,
    SystemMaintenanceSerializer, DashboardStatisticsSerializer, SystemHealthSerializer
)
from apps.users.models import User
from apps.users.utils import get_client_ip


class SystemSecurityLogListView(generics.ListAPIView):
    """系统安全日志列表"""
    queryset = SystemSecurityLog.objects.all()
    serializer_class = SystemSecurityLogSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['security_type', 'risk_level', 'is_resolved', 'user']
    search_fields = ['description', 'ip_address']
    ordering_fields = ['created_at', 'risk_level']
    ordering = ['-created_at']


class SystemSecurityLogDetailView(generics.RetrieveUpdateDestroyAPIView):
    """系统安全日志详情"""
    queryset = SystemSecurityLog.objects.all()
    serializer_class = SystemSecurityLogSerializer
    permission_classes = [permissions.IsAuthenticated]


class SystemPageConfigListCreateView(generics.ListCreateAPIView):
    """系统页面配置列表和创建"""
    queryset = SystemPageConfig.objects.all()
    serializer_class = SystemPageConfigSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['page_type', 'is_active']
    search_fields = ['page_name', 'title', 'description']
    ordering_fields = ['page_name', 'created_at']
    ordering = ['page_name']


class SystemPageConfigDetailView(generics.RetrieveUpdateDestroyAPIView):
    """系统页面配置详情"""
    queryset = SystemPageConfig.objects.all()
    serializer_class = SystemPageConfigSerializer
    permission_classes = [permissions.IsAuthenticated]


class SystemAnalyticsListView(generics.ListAPIView):
    """系统数据分析列表"""
    queryset = SystemAnalytics.objects.all()
    serializer_class = SystemAnalyticsSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['analytics_type', 'metric_name']
    search_fields = ['metric_name']
    ordering_fields = ['analysis_date', 'created_at']
    ordering = ['-analysis_date', '-created_at']


class SystemMaintenanceListCreateView(generics.ListCreateAPIView):
    """系统维护列表和创建"""
    queryset = SystemMaintenance.objects.all()
    serializer_class = SystemMaintenanceSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['maintenance_type', 'status', 'created_by']
    search_fields = ['title', 'description']
    ordering_fields = ['scheduled_start', 'created_at']
    ordering = ['-scheduled_start']
    
    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)


class SystemMaintenanceDetailView(generics.RetrieveUpdateDestroyAPIView):
    """系统维护详情"""
    queryset = SystemMaintenance.objects.all()
    serializer_class = SystemMaintenanceSerializer
    permission_classes = [permissions.IsAuthenticated]


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def security_dashboard(request):
    """安全监控仪表板"""
    today = timezone.now().date()
    last_7_days = today - timedelta(days=7)
    last_30_days = today - timedelta(days=30)
    
    # 安全事件统计
    total_security_events = SystemSecurityLog.objects.count()
    unresolved_events = SystemSecurityLog.objects.filter(is_resolved=False).count()
    critical_events = SystemSecurityLog.objects.filter(risk_level='critical', is_resolved=False).count()
    high_events = SystemSecurityLog.objects.filter(risk_level='high', is_resolved=False).count()
    
    # 最近7天安全事件趋势
    security_trend = []
    for i in range(7):
        date = today - timedelta(days=i)
        count = SystemSecurityLog.objects.filter(created_at__date=date).count()
        security_trend.append({
            'date': date.strftime('%Y-%m-%d'),
            'count': count
        })
    
    # 安全事件类型分布
    security_type_stats = SystemSecurityLog.objects.values('security_type').annotate(
        count=Count('id')
    ).order_by('-count')
    
    # 风险等级分布
    risk_level_stats = SystemSecurityLog.objects.values('risk_level').annotate(
        count=Count('id')
    ).order_by('-count')
    
    # 最近的安全事件
    recent_events = SystemSecurityLog.objects.filter(
        created_at__gte=last_7_days
    ).order_by('-created_at')[:10]
    
    return Response({
        'summary': {
            'total_events': total_security_events,
            'unresolved_events': unresolved_events,
            'critical_events': critical_events,
            'high_events': high_events
        },
        'trend': security_trend,
        'type_stats': list(security_type_stats),
        'risk_stats': list(risk_level_stats),
        'recent_events': SystemSecurityLogSerializer(recent_events, many=True).data
    })


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def resolve_security_event(request, event_id):
    """解决安全事件"""
    try:
        event = SystemSecurityLog.objects.get(id=event_id)
        event.is_resolved = True
        event.resolved_by = request.user
        event.resolved_at = timezone.now()
        event.save()
        
        return Response({'message': '安全事件已标记为已解决'})
    except SystemSecurityLog.DoesNotExist:
        return Response({'error': '安全事件不存在'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def analytics_dashboard(request):
    """数据分析仪表板"""
    today = timezone.now().date()
    last_30_days = today - timedelta(days=30)
    
    # 用户行为分析
    user_behavior_stats = SystemAnalytics.objects.filter(
        analytics_type='user_behavior',
        analysis_date__gte=last_30_days
    ).values('metric_name').annotate(
        avg_value=Avg('metric_value'),
        total_value=Sum('metric_value')
    ).order_by('-total_value')
    
    # 页面访问分析
    page_view_stats = SystemAnalytics.objects.filter(
        analytics_type='page_views',
        analysis_date__gte=last_30_days
    ).values('metric_name').annotate(
        total_views=Sum('metric_value')
    ).order_by('-total_views')
    
    # API使用分析
    api_usage_stats = SystemAnalytics.objects.filter(
        analytics_type='api_usage',
        analysis_date__gte=last_30_days
    ).values('metric_name').annotate(
        total_calls=Sum('metric_value'),
        avg_response_time=Avg('metric_value')
    ).order_by('-total_calls')
    
    # 性能分析
    performance_stats = SystemAnalytics.objects.filter(
        analytics_type='performance',
        analysis_date__gte=last_30_days
    ).values('metric_name').annotate(
        avg_value=Avg('metric_value')
    ).order_by('-avg_value')
    
    return Response({
        'user_behavior': list(user_behavior_stats),
        'page_views': list(page_view_stats),
        'api_usage': list(api_usage_stats),
        'performance': list(performance_stats)
    })


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def create_analytics_data(request):
    """创建分析数据"""
    analytics_type = request.data.get('analytics_type')
    metric_name = request.data.get('metric_name')
    metric_value = request.data.get('metric_value')
    dimension_data = request.data.get('dimension_data', {})
    time_period = request.data.get('time_period', 'daily')
    
    if not all([analytics_type, metric_name, metric_value]):
        return Response({'error': '缺少必要参数'}, status=status.HTTP_400_BAD_REQUEST)
    
    analytics = SystemAnalytics.objects.create(
        analytics_type=analytics_type,
        metric_name=metric_name,
        metric_value=metric_value,
        dimension_data=dimension_data,
        time_period=time_period,
        analysis_date=timezone.now().date()
    )
    
    serializer = SystemAnalyticsSerializer(analytics)
    return Response(serializer.data, status=status.HTTP_201_CREATED)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def maintenance_schedule(request):
    """维护计划"""
    today = timezone.now().date()
    upcoming_maintenance = SystemMaintenance.objects.filter(
        scheduled_start__date__gte=today,
        status__in=['planned', 'in_progress']
    ).order_by('scheduled_start')
    
    recent_maintenance = SystemMaintenance.objects.filter(
        scheduled_start__date__lt=today
    ).order_by('-scheduled_start')[:10]
    
    return Response({
        'upcoming': SystemMaintenanceSerializer(upcoming_maintenance, many=True).data,
        'recent': SystemMaintenanceSerializer(recent_maintenance, many=True).data
    })


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def start_maintenance(request, maintenance_id):
    """开始维护"""
    try:
        maintenance = SystemMaintenance.objects.get(id=maintenance_id)
        if maintenance.status != 'planned':
            return Response({'error': '只能开始计划中的维护'}, status=status.HTTP_400_BAD_REQUEST)
        
        maintenance.status = 'in_progress'
        maintenance.actual_start = timezone.now()
        maintenance.save()
        
        return Response({'message': '维护已开始'})
    except SystemMaintenance.DoesNotExist:
        return Response({'error': '维护记录不存在'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def complete_maintenance(request, maintenance_id):
    """完成维护"""
    try:
        maintenance = SystemMaintenance.objects.get(id=maintenance_id)
        if maintenance.status != 'in_progress':
            return Response({'error': '只能完成进行中的维护'}, status=status.HTTP_400_BAD_REQUEST)
        
        maintenance.status = 'completed'
        maintenance.actual_end = timezone.now()
        maintenance.save()
        
        return Response({'message': '维护已完成'})
    except SystemMaintenance.DoesNotExist:
        return Response({'error': '维护记录不存在'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def system_performance(request):
    """系统性能监控"""
    try:
        # CPU使用率
        cpu_usage = psutil.cpu_percent(interval=1)
        
        # 内存使用率
        memory = psutil.virtual_memory()
        memory_usage = memory.percent
        
        # 磁盘使用率
        disk = psutil.disk_usage('/')
        disk_usage = (disk.used / disk.total) * 100
        
        # 网络统计
        network = psutil.net_io_counters()
        
        # 系统负载
        load_avg = os.getloadavg() if hasattr(os, 'getloadavg') else [0, 0, 0]
        
        # 数据库连接数（模拟）
        database_connections = 25
        
        # API响应时间（模拟）
        api_response_time = 150.5
        
        # 系统状态评估
        status = "healthy"
        if cpu_usage > 80 or memory_usage > 80 or disk_usage > 80:
            status = "warning"
        if cpu_usage > 90 or memory_usage > 90 or disk_usage > 90:
            status = "critical"
        
        # 记录监控数据
        SystemMonitor.objects.create(
            monitor_type='cpu',
            metric_name='cpu_usage',
            metric_value=cpu_usage,
            threshold_warning=80,
            threshold_critical=90,
            status=status
        )
        
        SystemMonitor.objects.create(
            monitor_type='memory',
            metric_name='memory_usage',
            metric_value=memory_usage,
            threshold_warning=80,
            threshold_critical=90,
            status=status
        )
        
        SystemMonitor.objects.create(
            monitor_type='disk',
            metric_name='disk_usage',
            metric_value=disk_usage,
            threshold_warning=80,
            threshold_critical=90,
            status=status
        )
        
        return Response({
            'status': status,
            'cpu_usage': cpu_usage,
            'memory_usage': memory_usage,
            'disk_usage': disk_usage,
            'network': {
                'bytes_sent': network.bytes_sent,
                'bytes_recv': network.bytes_recv,
                'packets_sent': network.packets_sent,
                'packets_recv': network.packets_recv
            },
            'load_avg': load_avg,
            'database_connections': database_connections,
            'api_response_time': api_response_time,
            'last_check': timezone.now()
        })
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def backup_status(request):
    """备份状态"""
    recent_backups = SystemBackup.objects.filter(
        created_at__gte=timezone.now() - timedelta(days=7)
    ).order_by('-created_at')
    
    backup_stats = {
        'total_backups': SystemBackup.objects.count(),
        'successful_backups': SystemBackup.objects.filter(status='completed').count(),
        'failed_backups': SystemBackup.objects.filter(status='failed').count(),
        'pending_backups': SystemBackup.objects.filter(status='pending').count(),
        'running_backups': SystemBackup.objects.filter(status='running').count()
    }
    
    return Response({
        'stats': backup_stats,
        'recent_backups': SystemBackupSerializer(recent_backups, many=True).data
    })


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def create_scheduled_backup(request):
    """创建定时备份"""
    backup_type = request.data.get('backup_type', 'database')
    name = request.data.get('name', f'backup_{timezone.now().strftime("%Y%m%d_%H%M%S")}')
    description = request.data.get('description', '')
    schedule_time = request.data.get('schedule_time')
    
    backup = SystemBackup.objects.create(
        backup_type=backup_type,
        name=name,
        description=description,
        status='pending',
        created_by=request.user
    )
    
    # 这里应该集成定时任务系统（如Celery）
    # 为了演示，我们直接设置为完成状态
    backup.status = 'completed'
    backup.start_time = timezone.now()
    backup.end_time = timezone.now()
    backup.file_path = f'/backups/{name}.sql'
    backup.file_size = 1024 * 1024  # 1MB
    backup.save()
    
    serializer = SystemBackupSerializer(backup)
    return Response(serializer.data, status=status.HTTP_201_CREATED)





