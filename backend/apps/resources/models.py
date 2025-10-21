from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone

User = get_user_model()


class ResourceType(models.Model):
    """资源类型"""
    name = models.CharField(max_length=50, unique=True, verbose_name='类型名称')
    code = models.CharField(max_length=50, unique=True, verbose_name='类型代码')
    description = models.TextField(blank=True, verbose_name='类型描述')
    icon = models.CharField(max_length=50, blank=True, verbose_name='类型图标')
    sort_order = models.IntegerField(default=0, verbose_name='排序')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'resource_types'
        verbose_name = '资源类型'
        verbose_name_plural = '资源类型'
        ordering = ['sort_order', 'id']
    
    def __str__(self):
        return self.name


class Resource(models.Model):
    """资源信息"""
    RESOURCE_STATUS_CHOICES = [
        ('available', '可用'),
        ('in_use', '使用中'),
        ('maintenance', '维护中'),
        ('unavailable', '不可用'),
        ('retired', '已退役'),
    ]
    
    QUALITY_CHOICES = [
        ('excellent', '优秀'),
        ('good', '良好'),
        ('fair', '一般'),
        ('poor', '较差'),
    ]
    
    name = models.CharField(max_length=200, verbose_name='资源名称')
    resource_type = models.ForeignKey(ResourceType, on_delete=models.CASCADE, related_name='resources', verbose_name='资源类型')
    description = models.TextField(verbose_name='资源描述')
    specifications = models.TextField(blank=True, verbose_name='技术规格')
    manufacturer = models.CharField(max_length=200, blank=True, verbose_name='制造商')
    model = models.CharField(max_length=100, blank=True, verbose_name='型号')
    serial_number = models.CharField(max_length=100, blank=True, verbose_name='序列号')
    purchase_date = models.DateField(null=True, blank=True, verbose_name='采购日期')
    warranty_expiry = models.DateField(null=True, blank=True, verbose_name='保修到期')
    location = models.CharField(max_length=500, verbose_name='存放位置')
    status = models.CharField(max_length=20, choices=RESOURCE_STATUS_CHOICES, default='available', verbose_name='状态')
    quality = models.CharField(max_length=20, choices=QUALITY_CHOICES, default='good', verbose_name='质量等级')
    quantity = models.IntegerField(default=1, verbose_name='数量')
    unit_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, verbose_name='单价')
    total_value = models.DecimalField(max_digits=15, decimal_places=2, null=True, blank=True, verbose_name='总价值')
    owner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='owned_resources', verbose_name='所有者')
    contact_person = models.CharField(max_length=50, verbose_name='联系人')
    contact_phone = models.CharField(max_length=20, verbose_name='联系电话')
    contact_email = models.EmailField(blank=True, verbose_name='联系邮箱')
    is_public = models.BooleanField(default=True, verbose_name='是否公开')
    is_available_for_rent = models.BooleanField(default=False, verbose_name='是否可租赁')
    rental_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, verbose_name='租赁价格')
    rental_unit = models.CharField(max_length=20, blank=True, verbose_name='租赁单位')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'resources'
        verbose_name = '资源信息'
        verbose_name_plural = '资源信息'
        ordering = ['-created_at']
    
    def __str__(self):
        return self.name


class ResourceImage(models.Model):
    """资源图片"""
    resource = models.ForeignKey(Resource, on_delete=models.CASCADE, related_name='images', verbose_name='资源')
    image = models.ImageField(upload_to='resource_images/', verbose_name='图片')
    caption = models.CharField(max_length=200, blank=True, verbose_name='图片说明')
    sort_order = models.IntegerField(default=0, verbose_name='排序')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'resource_images'
        verbose_name = '资源图片'
        verbose_name_plural = '资源图片'
        ordering = ['sort_order', 'id']
    
    def __str__(self):
        return f"{self.resource.name} - 图片{self.sort_order}"


class ResourceUsageLog(models.Model):
    """资源使用日志"""
    USAGE_TYPE_CHOICES = [
        ('rental', '租赁'),
        ('borrow', '借用'),
        ('maintenance', '维护'),
        ('inspection', '检查'),
        ('other', '其他'),
    ]
    
    resource = models.ForeignKey(Resource, on_delete=models.CASCADE, related_name='usage_logs', verbose_name='资源')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='resource_usage_logs', verbose_name='使用者')
    usage_type = models.CharField(max_length=20, choices=USAGE_TYPE_CHOICES, verbose_name='使用类型')
    start_date = models.DateTimeField(verbose_name='开始时间')
    end_date = models.DateTimeField(null=True, blank=True, verbose_name='结束时间')
    purpose = models.TextField(verbose_name='使用目的')
    location = models.CharField(max_length=500, blank=True, verbose_name='使用地点')
    notes = models.TextField(blank=True, verbose_name='备注')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'resource_usage_logs'
        verbose_name = '资源使用日志'
        verbose_name_plural = '资源使用日志'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.resource.name} - {self.user.username}"


class ResourceMaintenance(models.Model):
    """资源维护记录"""
    MAINTENANCE_TYPE_CHOICES = [
        ('preventive', '预防性维护'),
        ('corrective', '纠正性维护'),
        ('emergency', '紧急维护'),
        ('upgrade', '升级改造'),
    ]
    
    resource = models.ForeignKey(Resource, on_delete=models.CASCADE, related_name='maintenances', verbose_name='资源')
    maintenance_type = models.CharField(max_length=20, choices=MAINTENANCE_TYPE_CHOICES, verbose_name='维护类型')
    title = models.CharField(max_length=200, verbose_name='维护标题')
    description = models.TextField(verbose_name='维护描述')
    start_date = models.DateTimeField(verbose_name='开始时间')
    end_date = models.DateTimeField(null=True, blank=True, verbose_name='结束时间')
    cost = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, verbose_name='维护费用')
    technician = models.CharField(max_length=100, blank=True, verbose_name='维护人员')
    notes = models.TextField(blank=True, verbose_name='维护备注')
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='created_maintenances', verbose_name='创建人')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'resource_maintenances'
        verbose_name = '资源维护记录'
        verbose_name_plural = '资源维护记录'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.resource.name} - {self.title}"


class ResourceRequest(models.Model):
    """资源申请"""
    REQUEST_STATUS_CHOICES = [
        ('pending', '待审核'),
        ('approved', '已批准'),
        ('rejected', '已拒绝'),
        ('completed', '已完成'),
        ('cancelled', '已取消'),
    ]
    
    REQUEST_TYPE_CHOICES = [
        ('rental', '租赁申请'),
        ('borrow', '借用申请'),
        ('purchase', '采购申请'),
        ('other', '其他申请'),
    ]
    
    resource = models.ForeignKey(Resource, on_delete=models.CASCADE, related_name='requests', verbose_name='资源')
    requester = models.ForeignKey(User, on_delete=models.CASCADE, related_name='resource_requests', verbose_name='申请人')
    request_type = models.CharField(max_length=20, choices=REQUEST_TYPE_CHOICES, verbose_name='申请类型')
    title = models.CharField(max_length=200, verbose_name='申请标题')
    description = models.TextField(verbose_name='申请描述')
    start_date = models.DateTimeField(verbose_name='开始时间')
    end_date = models.DateTimeField(verbose_name='结束时间')
    quantity = models.IntegerField(default=1, verbose_name='申请数量')
    purpose = models.TextField(verbose_name='使用目的')
    status = models.CharField(max_length=20, choices=REQUEST_STATUS_CHOICES, default='pending', verbose_name='申请状态')
    approved_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='approved_requests', verbose_name='审批人')
    approved_at = models.DateTimeField(null=True, blank=True, verbose_name='审批时间')
    approval_notes = models.TextField(blank=True, verbose_name='审批备注')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'resource_requests'
        verbose_name = '资源申请'
        verbose_name_plural = '资源申请'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.resource.name} - {self.requester.username}"


class ResourceStatistics(models.Model):
    """资源统计"""
    resource_type = models.ForeignKey(ResourceType, on_delete=models.CASCADE, related_name='statistics', verbose_name='资源类型')
    total_count = models.IntegerField(default=0, verbose_name='总数量')
    available_count = models.IntegerField(default=0, verbose_name='可用数量')
    in_use_count = models.IntegerField(default=0, verbose_name='使用中数量')
    maintenance_count = models.IntegerField(default=0, verbose_name='维护中数量')
    total_value = models.DecimalField(max_digits=15, decimal_places=2, default=0, verbose_name='总价值')
    utilization_rate = models.DecimalField(max_digits=5, decimal_places=2, default=0, verbose_name='利用率')
    last_updated = models.DateTimeField(auto_now=True, verbose_name='最后更新时间')
    
    class Meta:
        db_table = 'resource_statistics'
        verbose_name = '资源统计'
        verbose_name_plural = '资源统计'
    
    def __str__(self):
        return f"{self.resource_type.name} - 统计数据"
