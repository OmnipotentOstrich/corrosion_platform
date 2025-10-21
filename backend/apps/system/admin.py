from django.contrib import admin
from .models import (
    SystemConfig, SystemLog, SystemStatistics, SystemNotification,
    SystemBackup, SystemMonitor
)


@admin.register(SystemConfig)
class SystemConfigAdmin(admin.ModelAdmin):
    """系统配置管理"""
    list_display = ['key', 'config_type', 'is_active', 'created_at', 'updated_at']
    list_filter = ['config_type', 'is_active', 'created_at']
    search_fields = ['key', 'description']
    ordering = ['config_type', 'key']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(SystemLog)
class SystemLogAdmin(admin.ModelAdmin):
    """系统日志管理"""
    list_display = [
        'level', 'log_type', 'module', 'user', 'ip_address',
        'request_method', 'response_status', 'created_at'
    ]
    list_filter = ['level', 'log_type', 'module', 'request_method', 'response_status', 'created_at']
    search_fields = ['message', 'module', 'user__username', 'ip_address', 'request_path']
    ordering = ['-created_at']
    readonly_fields = ['created_at']


@admin.register(SystemStatistics)
class SystemStatisticsAdmin(admin.ModelAdmin):
    """系统统计管理"""
    list_display = [
        'stat_type', 'stat_date', 'stat_hour', 'metric_name',
        'metric_value', 'created_at'
    ]
    list_filter = ['stat_type', 'stat_date', 'stat_hour', 'created_at']
    search_fields = ['metric_name']
    ordering = ['-stat_date', '-stat_hour']
    readonly_fields = ['created_at']


@admin.register(SystemNotification)
class SystemNotificationAdmin(admin.ModelAdmin):
    """系统通知管理"""
    list_display = [
        'title', 'notification_type', 'priority', 'is_global',
        'is_read', 'is_active', 'expire_at', 'created_at'
    ]
    list_filter = ['notification_type', 'priority', 'is_global', 'is_read', 'is_active', 'created_at']
    search_fields = ['title', 'content']
    ordering = ['-priority', '-created_at']
    readonly_fields = ['created_at', 'updated_at']
    filter_horizontal = ['target_users']


@admin.register(SystemBackup)
class SystemBackupAdmin(admin.ModelAdmin):
    """系统备份管理"""
    list_display = [
        'name', 'backup_type', 'status', 'file_size',
        'start_time', 'end_time', 'created_by', 'created_at'
    ]
    list_filter = ['backup_type', 'status', 'created_at']
    search_fields = ['name', 'description', 'created_by__username']
    ordering = ['-created_at']
    readonly_fields = ['created_at']


@admin.register(SystemMonitor)
class SystemMonitorAdmin(admin.ModelAdmin):
    """系统监控管理"""
    list_display = [
        'monitor_type', 'metric_name', 'metric_value',
        'threshold_warning', 'threshold_critical', 'status', 'created_at'
    ]
    list_filter = ['monitor_type', 'status', 'created_at']
    search_fields = ['metric_name']
    ordering = ['-created_at']
    readonly_fields = ['created_at']
