from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone


class User(AbstractUser):
    """自定义用户模型"""
    USER_TYPE_CHOICES = [
        ('enterprise', '企业用户'),
        ('personal', '个人用户'),
    ]
    
    user_type = models.CharField(
        max_length=20,
        choices=USER_TYPE_CHOICES,
        default='personal',
        verbose_name='用户类型'
    )
    phone = models.CharField(max_length=11, unique=True, verbose_name='手机号')
    avatar = models.ImageField(upload_to='avatars/', null=True, blank=True, verbose_name='头像')
    is_verified = models.BooleanField(default=False, verbose_name='是否认证')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'users'
        verbose_name = '用户'
        verbose_name_plural = '用户'
    
    def __str__(self):
        return f"{self.username} ({self.get_user_type_display()})"


class Role(models.Model):
    """角色模型"""
    name = models.CharField(max_length=50, unique=True, verbose_name='角色名称')
    code = models.CharField(max_length=50, unique=True, verbose_name='角色代码')
    description = models.TextField(blank=True, verbose_name='角色描述')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'roles'
        verbose_name = '角色'
        verbose_name_plural = '角色'
    
    def __str__(self):
        return self.name


class Permission(models.Model):
    """权限模型"""
    name = models.CharField(max_length=100, verbose_name='权限名称')
    code = models.CharField(max_length=100, unique=True, verbose_name='权限代码')
    description = models.TextField(blank=True, verbose_name='权限描述')
    module = models.CharField(max_length=50, verbose_name='所属模块')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'permissions'
        verbose_name = '权限'
        verbose_name_plural = '权限'
    
    def __str__(self):
        return f"{self.name} ({self.module})"


class Menu(models.Model):
    """菜单模型"""
    MENU_TYPE_CHOICES = [
        ('page', '页面'),
        ('module', '模块'),
        ('function', '功能'),
        ('api', 'API'),
        ('other', '其他'),
    ]
    
    name = models.CharField(max_length=50, verbose_name='菜单名称')
    code = models.CharField(max_length=50, unique=True, verbose_name='菜单代码')
    url = models.CharField(max_length=200, blank=True, verbose_name='菜单URL')
    icon = models.CharField(max_length=50, blank=True, verbose_name='菜单图标')
    menu_type = models.CharField(max_length=20, choices=MENU_TYPE_CHOICES, default='page', verbose_name='菜单类型')
    parent = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, verbose_name='父菜单')
    sort_order = models.IntegerField(default=0, verbose_name='排序')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    is_visible = models.BooleanField(default=True, verbose_name='是否可见')
    requires_permission = models.BooleanField(default=True, verbose_name='需要权限')
    description = models.TextField(blank=True, verbose_name='菜单描述')
    component_path = models.CharField(max_length=200, blank=True, verbose_name='组件路径')
    meta_data = models.JSONField(null=True, blank=True, verbose_name='元数据')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'menus'
        verbose_name = '菜单'
        verbose_name_plural = '菜单'
        ordering = ['sort_order', 'id']
    
    def __str__(self):
        return self.name


class UserRole(models.Model):
    """用户角色关联"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='用户')
    role = models.ForeignKey(Role, on_delete=models.CASCADE, verbose_name='角色')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'user_roles'
        verbose_name = '用户角色'
        verbose_name_plural = '用户角色'
        unique_together = ['user', 'role']
    
    def __str__(self):
        return f"{self.user.username} - {self.role.name}"


class RolePermission(models.Model):
    """角色权限关联"""
    role = models.ForeignKey(Role, on_delete=models.CASCADE, verbose_name='角色')
    permission = models.ForeignKey(Permission, on_delete=models.CASCADE, verbose_name='权限')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'role_permissions'
        verbose_name = '角色权限'
        verbose_name_plural = '角色权限'
        unique_together = ['role', 'permission']
    
    def __str__(self):
        return f"{self.role.name} - {self.permission.name}"




class UserLoginLog(models.Model):
    """用户登录日志"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='用户')
    ip_address = models.GenericIPAddressField(verbose_name='IP地址')
    user_agent = models.TextField(verbose_name='用户代理')
    login_time = models.DateTimeField(auto_now_add=True, verbose_name='登录时间')
    logout_time = models.DateTimeField(null=True, blank=True, verbose_name='登出时间')
    is_success = models.BooleanField(default=True, verbose_name='是否成功')
    failure_reason = models.CharField(max_length=200, blank=True, verbose_name='失败原因')
    location = models.CharField(max_length=100, blank=True, verbose_name='登录地点')
    device_type = models.CharField(max_length=50, blank=True, verbose_name='设备类型')
    
    class Meta:
        db_table = 'user_login_logs'
        verbose_name = '用户登录日志'
        verbose_name_plural = '用户登录日志'
        ordering = ['-login_time']
    
    def __str__(self):
        return f"{self.user.username} - {self.login_time}"


class UserSession(models.Model):
    """用户会话管理"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='用户')
    session_key = models.CharField(max_length=100, unique=True, verbose_name='会话密钥')
    ip_address = models.GenericIPAddressField(verbose_name='IP地址')
    user_agent = models.TextField(verbose_name='用户代理')
    login_time = models.DateTimeField(auto_now_add=True, verbose_name='登录时间')
    last_activity = models.DateTimeField(auto_now=True, verbose_name='最后活动时间')
    is_active = models.BooleanField(default=True, verbose_name='是否活跃')
    expire_at = models.DateTimeField(verbose_name='过期时间')
    
    class Meta:
        db_table = 'user_sessions'
        verbose_name = '用户会话'
        verbose_name_plural = '用户会话'
        ordering = ['-last_activity']
    
    def __str__(self):
        return f"{self.user.username} - {self.session_key}"


class UserProfile(models.Model):
    """用户扩展信息"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, verbose_name='用户')
    real_name = models.CharField(max_length=50, blank=True, verbose_name='真实姓名')
    id_card = models.CharField(max_length=18, blank=True, verbose_name='身份证号')
    gender = models.CharField(max_length=10, choices=[('male', '男'), ('female', '女')], blank=True, verbose_name='性别')
    birthday = models.DateField(null=True, blank=True, verbose_name='生日')
    address = models.TextField(blank=True, verbose_name='地址')
    company = models.CharField(max_length=200, blank=True, verbose_name='公司')
    position = models.CharField(max_length=100, blank=True, verbose_name='职位')
    bio = models.TextField(blank=True, verbose_name='个人简介')
    website = models.URLField(blank=True, verbose_name='个人网站')
    social_media = models.JSONField(null=True, blank=True, verbose_name='社交媒体')
    preferences = models.JSONField(null=True, blank=True, verbose_name='偏好设置')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'user_profiles'
        verbose_name = '用户资料'
        verbose_name_plural = '用户资料'
    
    def __str__(self):
        return f"{self.user.username} - 个人资料"


class RoleMenu(models.Model):
    """角色菜单关联"""
    role = models.ForeignKey(Role, on_delete=models.CASCADE, verbose_name='角色')
    menu = models.ForeignKey(Menu, on_delete=models.CASCADE, verbose_name='菜单')
    can_view = models.BooleanField(default=True, verbose_name='可查看')
    can_create = models.BooleanField(default=False, verbose_name='可创建')
    can_update = models.BooleanField(default=False, verbose_name='可更新')
    can_delete = models.BooleanField(default=False, verbose_name='可删除')
    can_export = models.BooleanField(default=False, verbose_name='可导出')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'role_menus'
        verbose_name = '角色菜单'
        verbose_name_plural = '角色菜单'
        unique_together = ['role', 'menu']
    
    def __str__(self):
        return f"{self.role.name} - {self.menu.name}"


class PermissionGroup(models.Model):
    """权限组"""
    name = models.CharField(max_length=100, unique=True, verbose_name='权限组名称')
    code = models.CharField(max_length=100, unique=True, verbose_name='权限组代码')
    description = models.TextField(blank=True, verbose_name='权限组描述')
    module = models.CharField(max_length=50, verbose_name='所属模块')
    sort_order = models.IntegerField(default=0, verbose_name='排序')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'permission_groups'
        verbose_name = '权限组'
        verbose_name_plural = '权限组'
        ordering = ['sort_order', 'name']
    
    def __str__(self):
        return self.name


class RolePermissionAudit(models.Model):
    """角色权限审计日志"""
    ACTION_CHOICES = [
        ('grant', '授予权限'),
        ('revoke', '撤销权限'),
        ('create_role', '创建角色'),
        ('update_role', '更新角色'),
        ('delete_role', '删除角色'),
        ('assign_role', '分配角色'),
        ('remove_role', '移除角色'),
    ]
    
    role = models.ForeignKey(Role, on_delete=models.CASCADE, verbose_name='角色')
    permission = models.ForeignKey(Permission, on_delete=models.CASCADE, null=True, blank=True, verbose_name='权限')
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='操作用户')
    action = models.CharField(max_length=20, choices=ACTION_CHOICES, verbose_name='操作类型')
    description = models.TextField(verbose_name='操作描述')
    ip_address = models.GenericIPAddressField(verbose_name='IP地址')
    user_agent = models.TextField(verbose_name='用户代理')
    extra_data = models.JSONField(null=True, blank=True, verbose_name='额外数据')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'role_permission_audits'
        verbose_name = '角色权限审计'
        verbose_name_plural = '角色权限审计'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['role', 'created_at']),
            models.Index(fields=['user', 'created_at']),
            models.Index(fields=['action', 'created_at']),
        ]
    
    def __str__(self):
        return f"{self.role.name} - {self.get_action_display()} - {self.created_at}"


class UserActivityLog(models.Model):
    """用户活动日志"""
    ACTION_CHOICES = [
        ('login', '登录'),
        ('logout', '登出'),
        ('register', '注册'),
        ('update_profile', '更新资料'),
        ('change_password', '修改密码'),
        ('view_page', '浏览页面'),
        ('create_post', '发布信息'),
        ('update_post', '更新信息'),
        ('delete_post', '删除信息'),
        ('upload_file', '上传文件'),
        ('download_file', '下载文件'),
        ('search', '搜索'),
        ('other', '其他'),
    ]
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='用户')
    action = models.CharField(max_length=50, choices=ACTION_CHOICES, verbose_name='操作类型')
    description = models.CharField(max_length=200, verbose_name='操作描述')
    ip_address = models.GenericIPAddressField(verbose_name='IP地址')
    user_agent = models.TextField(verbose_name='用户代理')
    request_path = models.CharField(max_length=500, blank=True, verbose_name='请求路径')
    extra_data = models.JSONField(null=True, blank=True, verbose_name='额外数据')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'user_activity_logs'
        verbose_name = '用户活动日志'
        verbose_name_plural = '用户活动日志'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['user', 'created_at']),
            models.Index(fields=['action', 'created_at']),
        ]
    
    def __str__(self):
        return f"{self.user.username} - {self.get_action_display()} - {self.created_at}"


class UserPermissionOverride(models.Model):
    """用户权限覆盖"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='用户')
    permission = models.ForeignKey(Permission, on_delete=models.CASCADE, verbose_name='权限')
    is_granted = models.BooleanField(default=True, verbose_name='是否授予')
    reason = models.TextField(verbose_name='原因')
    granted_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='granted_overrides', verbose_name='授予人')
    expire_at = models.DateTimeField(null=True, blank=True, verbose_name='过期时间')
    is_active = models.BooleanField(default=True, verbose_name='是否有效')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'user_permission_overrides'
        verbose_name = '用户权限覆盖'
        verbose_name_plural = '用户权限覆盖'
        unique_together = ['user', 'permission']
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.user.username} - {self.permission.name} - {'授予' if self.is_granted else '拒绝'}"
