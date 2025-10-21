from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone

User = get_user_model()


class SystemConfig(models.Model):
    """系统配置"""
    CONFIG_TYPE_CHOICES = [
        ('basic', '基础配置'),
        ('email', '邮件配置'),
        ('sms', '短信配置'),
        ('storage', '存储配置'),
        ('security', '安全配置'),
        ('business', '业务配置'),
        ('other', '其他配置'),
    ]
    
    key = models.CharField(max_length=100, unique=True, verbose_name='配置键')
    value = models.TextField(verbose_name='配置值')
    config_type = models.CharField(max_length=20, choices=CONFIG_TYPE_CHOICES, verbose_name='配置类型')
    description = models.TextField(blank=True, verbose_name='配置描述')
    is_encrypted = models.BooleanField(default=False, verbose_name='是否加密')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'system_configs'
        verbose_name = '系统配置'
        verbose_name_plural = '系统配置'
        ordering = ['config_type', 'key']
    
    def __str__(self):
        return f"{self.key} ({self.get_config_type_display()})"


class SystemLog(models.Model):
    """系统日志"""
    LOG_LEVEL_CHOICES = [
        ('DEBUG', '调试'),
        ('INFO', '信息'),
        ('WARNING', '警告'),
        ('ERROR', '错误'),
        ('CRITICAL', '严重'),
    ]
    
    LOG_TYPE_CHOICES = [
        ('system', '系统日志'),
        ('user', '用户操作'),
        ('api', 'API访问'),
        ('database', '数据库操作'),
        ('security', '安全日志'),
        ('business', '业务日志'),
    ]
    
    level = models.CharField(max_length=10, choices=LOG_LEVEL_CHOICES, verbose_name='日志级别')
    log_type = models.CharField(max_length=20, choices=LOG_TYPE_CHOICES, verbose_name='日志类型')
    module = models.CharField(max_length=100, verbose_name='模块')
    message = models.TextField(verbose_name='日志消息')
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='system_logs', verbose_name='用户')
    ip_address = models.GenericIPAddressField(null=True, blank=True, verbose_name='IP地址')
    user_agent = models.TextField(blank=True, verbose_name='用户代理')
    request_path = models.CharField(max_length=500, blank=True, verbose_name='请求路径')
    request_method = models.CharField(max_length=10, blank=True, verbose_name='请求方法')
    response_status = models.IntegerField(null=True, blank=True, verbose_name='响应状态')
    execution_time = models.FloatField(null=True, blank=True, verbose_name='执行时间(秒)')
    extra_data = models.JSONField(null=True, blank=True, verbose_name='额外数据')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'system_logs'
        verbose_name = '系统日志'
        verbose_name_plural = '系统日志'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['level', 'created_at']),
            models.Index(fields=['log_type', 'created_at']),
            models.Index(fields=['user', 'created_at']),
            models.Index(fields=['module', 'created_at']),
        ]
    
    def __str__(self):
        return f"{self.level} - {self.module} - {self.message[:50]}"


class SystemStatistics(models.Model):
    """系统统计"""
    STAT_TYPE_CHOICES = [
        ('user', '用户统计'),
        ('enterprise', '企业统计'),
        ('person', '个人统计'),
        ('info_post', '信息发布统计'),
        ('resource', '资源统计'),
        ('api', 'API统计'),
        ('system', '系统统计'),
    ]
    
    stat_type = models.CharField(max_length=20, choices=STAT_TYPE_CHOICES, verbose_name='统计类型')
    stat_date = models.DateField(verbose_name='统计日期')
    stat_hour = models.IntegerField(null=True, blank=True, verbose_name='统计小时')
    metric_name = models.CharField(max_length=100, verbose_name='指标名称')
    metric_value = models.DecimalField(max_digits=15, decimal_places=2, verbose_name='指标值')
    extra_data = models.JSONField(null=True, blank=True, verbose_name='额外数据')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'system_statistics'
        verbose_name = '系统统计'
        verbose_name_plural = '系统统计'
        ordering = ['-stat_date', '-stat_hour']
        unique_together = ['stat_type', 'stat_date', 'stat_hour', 'metric_name']
        indexes = [
            models.Index(fields=['stat_type', 'stat_date']),
            models.Index(fields=['metric_name', 'stat_date']),
        ]
    
    def __str__(self):
        return f"{self.get_stat_type_display()} - {self.metric_name} - {self.stat_date}"


class SystemNotification(models.Model):
    """系统通知"""
    NOTIFICATION_TYPE_CHOICES = [
        ('system', '系统通知'),
        ('user', '用户通知'),
        ('enterprise', '企业通知'),
        ('info_post', '信息通知'),
        ('resource', '资源通知'),
        ('security', '安全通知'),
    ]
    
    PRIORITY_CHOICES = [
        ('low', '低'),
        ('medium', '中'),
        ('high', '高'),
        ('urgent', '紧急'),
    ]
    
    title = models.CharField(max_length=200, verbose_name='通知标题')
    content = models.TextField(verbose_name='通知内容')
    notification_type = models.CharField(max_length=20, choices=NOTIFICATION_TYPE_CHOICES, verbose_name='通知类型')
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES, default='medium', verbose_name='优先级')
    target_users = models.ManyToManyField(User, blank=True, related_name='notifications', verbose_name='目标用户')
    is_global = models.BooleanField(default=False, verbose_name='是否全局通知')
    is_read = models.BooleanField(default=False, verbose_name='是否已读')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    expire_at = models.DateTimeField(null=True, blank=True, verbose_name='过期时间')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'system_notifications'
        verbose_name = '系统通知'
        verbose_name_plural = '系统通知'
        ordering = ['-priority', '-created_at']
    
    def __str__(self):
        return self.title


class SystemBackup(models.Model):
    """系统备份"""
    BACKUP_TYPE_CHOICES = [
        ('database', '数据库备份'),
        ('files', '文件备份'),
        ('full', '完整备份'),
    ]
    
    STATUS_CHOICES = [
        ('pending', '待执行'),
        ('running', '执行中'),
        ('completed', '已完成'),
        ('failed', '失败'),
    ]
    
    backup_type = models.CharField(max_length=20, choices=BACKUP_TYPE_CHOICES, verbose_name='备份类型')
    name = models.CharField(max_length=200, verbose_name='备份名称')
    description = models.TextField(blank=True, verbose_name='备份描述')
    file_path = models.CharField(max_length=500, blank=True, verbose_name='文件路径')
    file_size = models.BigIntegerField(null=True, blank=True, verbose_name='文件大小(字节)')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending', verbose_name='状态')
    start_time = models.DateTimeField(null=True, blank=True, verbose_name='开始时间')
    end_time = models.DateTimeField(null=True, blank=True, verbose_name='结束时间')
    error_message = models.TextField(blank=True, verbose_name='错误信息')
    created_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='created_backups', verbose_name='创建人')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'system_backups'
        verbose_name = '系统备份'
        verbose_name_plural = '系统备份'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.name} ({self.get_backup_type_display()})"


class SystemMonitor(models.Model):
    """系统监控"""
    MONITOR_TYPE_CHOICES = [
        ('cpu', 'CPU使用率'),
        ('memory', '内存使用率'),
        ('disk', '磁盘使用率'),
        ('network', '网络流量'),
        ('database', '数据库连接'),
        ('api', 'API响应时间'),
    ]
    
    monitor_type = models.CharField(max_length=20, choices=MONITOR_TYPE_CHOICES, verbose_name='监控类型')
    metric_name = models.CharField(max_length=100, verbose_name='指标名称')
    metric_value = models.FloatField(verbose_name='指标值')
    threshold_warning = models.FloatField(null=True, blank=True, verbose_name='警告阈值')
    threshold_critical = models.FloatField(null=True, blank=True, verbose_name='严重阈值')
    status = models.CharField(max_length=20, default='normal', verbose_name='状态')
    extra_data = models.JSONField(null=True, blank=True, verbose_name='额外数据')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'system_monitors'
        verbose_name = '系统监控'
        verbose_name_plural = '系统监控'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['monitor_type', 'created_at']),
            models.Index(fields=['status', 'created_at']),
        ]
    
    def __str__(self):
        return f"{self.get_monitor_type_display()} - {self.metric_name} - {self.metric_value}"
