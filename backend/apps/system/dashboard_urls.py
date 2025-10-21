"""
Dashboard URL Configuration
仪表板相关的路由配置
"""
from django.urls import path
from .dashboard_views import (
    dashboard_statistics,
    dashboard_activities,
    dashboard_tasks,
    dashboard_notifications
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
]


