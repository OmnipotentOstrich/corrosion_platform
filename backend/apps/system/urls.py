from django.urls import path
from . import views

urlpatterns = [
    # 系统配置
    path('configs/', views.SystemConfigListCreateView.as_view(), name='system_config_list_create'),
    path('configs/<int:pk>/', views.SystemConfigDetailView.as_view(), name='system_config_detail'),
    
    # 系统日志
    path('logs/', views.SystemLogListView.as_view(), name='system_log_list'),
    path('logs/summary/', views.system_logs_summary, name='system_logs_summary'),
    
    # 系统统计
    path('statistics/', views.SystemStatisticsListView.as_view(), name='system_statistics_list'),
    path('statistics/dashboard/', views.dashboard_statistics, name='dashboard_statistics'),
    path('statistics/users/', views.user_statistics, name='user_statistics'),
    path('statistics/content/', views.content_statistics, name='content_statistics'),
    
    # 系统通知
    path('notifications/', views.SystemNotificationListCreateView.as_view(), name='system_notification_list_create'),
    path('notifications/<int:pk>/', views.SystemNotificationDetailView.as_view(), name='system_notification_detail'),
    
    # 系统备份
    path('backups/', views.SystemBackupListCreateView.as_view(), name='system_backup_list_create'),
    path('backups/<int:pk>/', views.SystemBackupDetailView.as_view(), name='system_backup_detail'),
    path('backups/create/', views.create_backup, name='create_backup'),
    
    # 系统监控
    path('monitors/', views.SystemMonitorListView.as_view(), name='system_monitor_list'),
    path('health/', views.system_health, name='system_health'),
]
