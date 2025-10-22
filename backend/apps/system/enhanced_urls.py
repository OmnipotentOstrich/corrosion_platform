"""
增强的系统管理URL配置
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views
from . import enhanced_views

# 创建路由器
router = DefaultRouter()

# 注册视图集
router.register(r'configs', views.SystemConfigListCreateView, basename='system-configs')
router.register(r'logs', views.SystemLogListView, basename='system-logs')
router.register(r'statistics', views.SystemStatisticsListView, basename='system-statistics')
router.register(r'notifications', views.SystemNotificationListCreateView, basename='system-notifications')
router.register(r'backups', views.SystemBackupListCreateView, basename='system-backups')
router.register(r'monitors', views.SystemMonitorListView, basename='system-monitors')

# 安全相关URL
security_urls = [
    path('security-logs/', enhanced_views.SystemSecurityLogListView.as_view(), name='security-logs-list'),
    path('security-logs/<int:pk>/', enhanced_views.SystemSecurityLogDetailView.as_view(), name='security-logs-detail'),
    path('security-dashboard/', enhanced_views.security_dashboard, name='security-dashboard'),
    path('security-events/<int:event_id>/resolve/', enhanced_views.resolve_security_event, name='resolve-security-event'),
]

# 页面配置URL
page_config_urls = [
    path('page-configs/', enhanced_views.SystemPageConfigListCreateView.as_view(), name='page-configs-list'),
    path('page-configs/<int:pk>/', enhanced_views.SystemPageConfigDetailView.as_view(), name='page-configs-detail'),
]

# 数据分析URL
analytics_urls = [
    path('analytics/', enhanced_views.SystemAnalyticsListView.as_view(), name='analytics-list'),
    path('analytics-dashboard/', enhanced_views.analytics_dashboard, name='analytics-dashboard'),
    path('analytics-data/', enhanced_views.create_analytics_data, name='create-analytics-data'),
]

# 系统维护URL
maintenance_urls = [
    path('maintenance/', enhanced_views.SystemMaintenanceListCreateView.as_view(), name='maintenance-list'),
    path('maintenance/<int:pk>/', enhanced_views.SystemMaintenanceDetailView.as_view(), name='maintenance-detail'),
    path('maintenance-schedule/', enhanced_views.maintenance_schedule, name='maintenance-schedule'),
    path('maintenance/<int:maintenance_id>/start/', enhanced_views.start_maintenance, name='start-maintenance'),
    path('maintenance/<int:maintenance_id>/complete/', enhanced_views.complete_maintenance, name='complete-maintenance'),
]

# 系统监控URL
monitoring_urls = [
    path('performance/', enhanced_views.system_performance, name='system-performance'),
    path('backup-status/', enhanced_views.backup_status, name='backup-status'),
    path('scheduled-backup/', enhanced_views.create_scheduled_backup, name='create-scheduled-backup'),
]

# 基础系统URL
basic_urls = [
    path('dashboard-statistics/', views.dashboard_statistics, name='dashboard-statistics'),
    path('system-health/', views.system_health, name='system-health'),
    path('user-statistics/', views.user_statistics, name='user-statistics'),
    path('content-statistics/', views.content_statistics, name='content-statistics'),
    path('logs-summary/', views.system_logs_summary, name='system-logs-summary'),
    path('create-backup/', views.create_backup, name='create-backup'),
]

# 组合所有URL
urlpatterns = [
    # 基础系统管理
    path('', include(basic_urls)),
    
    # 安全监控
    path('security/', include(security_urls)),
    
    # 页面配置
    path('pages/', include(page_config_urls)),
    
    # 数据分析
    path('analytics/', include(analytics_urls)),
    
    # 系统维护
    path('maintenance/', include(maintenance_urls)),
    
    # 系统监控
    path('monitoring/', include(monitoring_urls)),
    
    # 路由器URL
    path('', include(router.urls)),
]


