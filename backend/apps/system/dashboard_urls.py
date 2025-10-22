"""
Dashboard URL Configuration
仪表板相关的路由配置
"""
from django.urls import path
from .dashboard_views import (
    dashboard_statistics,
    dashboard_activities,
    dashboard_tasks,
    dashboard_notifications,
    dashboard_projects,
    dashboard_chart_data,
    dashboard_user_stats,
    debug_stats,
    test_simple_stats
)

urlpatterns = [
    # 仪表板统计数据
    path('statistics/', dashboard_statistics, name='dashboard_statistics'),
    
    # 最近活动
    path('activities/', dashboard_activities, name='dashboard_activities'),
    
    # 待办任务
    path('tasks/', dashboard_tasks, name='dashboard_tasks'),
    
    # 系统通知
    path('notifications/', dashboard_notifications, name='dashboard_notifications'),
    
    # 项目进度列表
    path('projects/', dashboard_projects, name='dashboard_projects'),
    
    # 图表时序数据
    path('chart-data/', dashboard_chart_data, name='dashboard_chart_data'),
    
    # 用户个人统计
    path('user-stats/', dashboard_user_stats, name='dashboard_user_stats'),
    
    # 调试接口（无需认证）
    path('debug-stats/', debug_stats, name='debug_stats'),
    path('test-simple-stats/', test_simple_stats, name='test_simple_stats'),
]


