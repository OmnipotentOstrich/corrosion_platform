from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import (
    SystemConfig, SystemLog, SystemStatistics, SystemNotification,
    SystemBackup, SystemMonitor
)

User = get_user_model()


class SystemConfigSerializer(serializers.ModelSerializer):
    """系统配置序列化器"""
    config_type_display = serializers.CharField(source='get_config_type_display', read_only=True)
    
    class Meta:
        model = SystemConfig
        fields = [
            'id', 'key', 'value', 'config_type', 'config_type_display',
            'description', 'is_encrypted', 'is_active', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class SystemLogSerializer(serializers.ModelSerializer):
    """系统日志序列化器"""
    level_display = serializers.CharField(source='get_level_display', read_only=True)
    log_type_display = serializers.CharField(source='get_log_type_display', read_only=True)
    user_name = serializers.CharField(source='user.username', read_only=True)
    
    class Meta:
        model = SystemLog
        fields = [
            'id', 'level', 'level_display', 'log_type', 'log_type_display',
            'module', 'message', 'user', 'user_name', 'ip_address',
            'user_agent', 'request_path', 'request_method', 'response_status',
            'execution_time', 'extra_data', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class SystemStatisticsSerializer(serializers.ModelSerializer):
    """系统统计序列化器"""
    stat_type_display = serializers.CharField(source='get_stat_type_display', read_only=True)
    
    class Meta:
        model = SystemStatistics
        fields = [
            'id', 'stat_type', 'stat_type_display', 'stat_date', 'stat_hour',
            'metric_name', 'metric_value', 'extra_data', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class SystemNotificationSerializer(serializers.ModelSerializer):
    """系统通知序列化器"""
    notification_type_display = serializers.CharField(source='get_notification_type_display', read_only=True)
    priority_display = serializers.CharField(source='get_priority_display', read_only=True)
    target_user_names = serializers.SerializerMethodField()
    
    class Meta:
        model = SystemNotification
        fields = [
            'id', 'title', 'content', 'notification_type', 'notification_type_display',
            'priority', 'priority_display', 'target_users', 'target_user_names',
            'is_global', 'is_read', 'is_active', 'expire_at', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def get_target_user_names(self, obj):
        return [user.username for user in obj.target_users.all()]


class SystemBackupSerializer(serializers.ModelSerializer):
    """系统备份序列化器"""
    backup_type_display = serializers.CharField(source='get_backup_type_display', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    created_by_name = serializers.CharField(source='created_by.username', read_only=True)
    file_size_display = serializers.SerializerMethodField()
    
    class Meta:
        model = SystemBackup
        fields = [
            'id', 'backup_type', 'backup_type_display', 'name', 'description',
            'file_path', 'file_size', 'file_size_display', 'status', 'status_display',
            'start_time', 'end_time', 'error_message', 'created_by', 'created_by_name',
            'created_at'
        ]
        read_only_fields = ['id', 'created_by', 'created_at']
    
    def get_file_size_display(self, obj):
        if obj.file_size:
            size = obj.file_size
            for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
                if size < 1024.0:
                    return f"{size:.1f} {unit}"
                size /= 1024.0
            return f"{size:.1f} PB"
        return None


class SystemMonitorSerializer(serializers.ModelSerializer):
    """系统监控序列化器"""
    monitor_type_display = serializers.CharField(source='get_monitor_type_display', read_only=True)
    
    class Meta:
        model = SystemMonitor
        fields = [
            'id', 'monitor_type', 'monitor_type_display', 'metric_name',
            'metric_value', 'threshold_warning', 'threshold_critical',
            'status', 'extra_data', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class DashboardStatisticsSerializer(serializers.Serializer):
    """仪表板统计序列化器"""
    total_users = serializers.IntegerField()
    total_enterprises = serializers.IntegerField()
    total_persons = serializers.IntegerField()
    total_info_posts = serializers.IntegerField()
    total_resources = serializers.IntegerField()
    active_users_today = serializers.IntegerField()
    new_users_today = serializers.IntegerField()
    new_posts_today = serializers.IntegerField()
    system_health = serializers.CharField()
    api_response_time = serializers.FloatField()
    database_connections = serializers.IntegerField()


class SystemHealthSerializer(serializers.Serializer):
    """系统健康状态序列化器"""
    status = serializers.CharField()
    cpu_usage = serializers.FloatField()
    memory_usage = serializers.FloatField()
    disk_usage = serializers.FloatField()
    database_status = serializers.CharField()
    api_status = serializers.CharField()
    last_check = serializers.DateTimeField()
