from rest_framework import serializers
from django.contrib.auth import authenticate
from django.contrib.auth.password_validation import validate_password
from .models import (
    User, Role, Permission, Menu, UserRole, RolePermission, RoleMenu, UserLoginLog,
    UserSession, UserProfile, UserActivityLog, PermissionGroup, RolePermissionAudit,
    UserPermissionOverride
)


class UserSerializer(serializers.ModelSerializer):
    """用户序列化器"""
    user_type_display = serializers.CharField(source='get_user_type_display', read_only=True)
    roles = serializers.SerializerMethodField()
    status = serializers.SerializerMethodField()
    status_text = serializers.SerializerMethodField()
    role_text = serializers.SerializerMethodField()
    register_time = serializers.SerializerMethodField()
    last_login = serializers.SerializerMethodField()
    
    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'first_name', 'last_name',
            'user_type', 'user_type_display', 'phone', 'avatar',
            'is_verified', 'is_active', 'is_staff', 'is_superuser',
            'date_joined', 'created_at', 'updated_at', 'roles',
            'status', 'status_text', 'role_text', 'register_time', 'last_login'
        ]
        read_only_fields = ['id', 'date_joined', 'created_at', 'updated_at', 'is_staff', 'is_superuser']
    
    def get_roles(self, obj):
        """获取用户角色"""
        user_roles = UserRole.objects.filter(user=obj).select_related('role')
        return [{'id': ur.role.id, 'name': ur.role.name, 'code': ur.role.code} for ur in user_roles]
    
    def get_status(self, obj):
        """获取用户状态"""
        return 'active' if obj.is_active else 'banned'
    
    def get_status_text(self, obj):
        """获取用户状态文本"""
        return '活跃' if obj.is_active else '已禁用'
    
    def get_role_text(self, obj):
        """获取用户角色文本"""
        user_roles = UserRole.objects.filter(user=obj).select_related('role')
        if user_roles.exists():
            role = user_roles.first().role
            role_map = {
                'admin': '管理员',
                'enterprise_admin': '企业管理员',
                'enterprise_employee': '企业员工',
                'project_manager': '项目经理',
                'quality_supervisor': '质量监督员',
                'safety_manager': '安全管理员',
                'material_manager': '材料管理员',
                'personal_user': '个人用户',
                'technician': '技术员',
                'engineer': '工程师',
                'construction_worker': '建筑工人',
                'labor_worker': '劳务工人',
                'industry_consultant': '行业顾问',
                'industry_expert': '行业专家'
            }
            return role_map.get(role.code, role.name)
        return '普通用户'
    
    def get_register_time(self, obj):
        """获取注册时间"""
        return obj.date_joined.strftime('%Y-%m-%d %H:%M') if obj.date_joined else ''
    
    def get_last_login(self, obj):
        """获取最后登录时间"""
        return obj.last_login.strftime('%Y-%m-%d %H:%M') if obj.last_login else '从未登录'


class UserCreateSerializer(serializers.ModelSerializer):
    """用户创建序列化器"""
    password = serializers.CharField(write_only=True, validators=[validate_password])
    password_confirm = serializers.CharField(write_only=True)
    role_id = serializers.IntegerField(required=False, help_text='选择的角色ID')
    
    class Meta:
        model = User
        fields = [
            'username', 'email', 'password', 'password_confirm',
            'first_name', 'last_name', 'user_type', 'phone', 'role_id'
        ]
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError("密码不匹配")
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password_confirm')
        password = validated_data.pop('password')
        user_type = validated_data.get('user_type', 'personal')
        role_id = validated_data.pop('role_id', None)
        
        # 创建用户
        user = User.objects.create_user(password=password, **validated_data)
        
        # 分配角色
        from .models import UserRole
        
        if role_id:
            # 使用用户选择的角色
            try:
                role = Role.objects.get(id=role_id)
                UserRole.objects.create(user=user, role=role)
            except Role.DoesNotExist:
                # 如果角色不存在，记录错误但不影响用户创建
                import logging
                logger = logging.getLogger(__name__)
                logger.error(f"选择的角色ID {role_id} 不存在，无法为用户 {user.username} 分配角色")
        else:
            # 根据用户类型自动分配默认角色
            try:
                if user_type == 'enterprise':
                    # 企业用户默认分配企业管理员角色
                    default_role = Role.objects.get(code='enterprise_admin')
                else:
                    # 个人用户分配个人用户角色
                    default_role = Role.objects.get(code='personal_user')
                
                UserRole.objects.create(user=user, role=default_role)
            except Role.DoesNotExist:
                # 如果角色不存在，记录错误但不影响用户创建
                import logging
                logger = logging.getLogger(__name__)
                logger.error(f"默认角色不存在，无法为用户 {user.username} 分配角色")
        
        return user


class UserUpdateSerializer(serializers.ModelSerializer):
    """用户更新序列化器"""
    
    class Meta:
        model = User
        fields = [
            'email', 'first_name', 'last_name', 'phone', 'avatar'
        ]


class ChangePasswordSerializer(serializers.Serializer):
    """修改密码序列化器"""
    old_password = serializers.CharField(required=True)
    new_password = serializers.CharField(required=True, validators=[validate_password])
    new_password_confirm = serializers.CharField(required=True)
    
    def validate_old_password(self, value):
        user = self.context['request'].user
        if not user.check_password(value):
            raise serializers.ValidationError("原密码错误")
        return value
    
    def validate(self, attrs):
        if attrs['new_password'] != attrs['new_password_confirm']:
            raise serializers.ValidationError("新密码不匹配")
        return attrs


class LoginSerializer(serializers.Serializer):
    """登录序列化器"""
    username = serializers.CharField()
    password = serializers.CharField()
    
    def validate(self, attrs):
        username = attrs.get('username')
        password = attrs.get('password')
        
        if username and password:
            user = authenticate(username=username, password=password)
            if not user:
                raise serializers.ValidationError("用户名或密码错误")
            if not user.is_active:
                raise serializers.ValidationError("用户账户已被禁用")
            attrs['user'] = user
        else:
            raise serializers.ValidationError("用户名和密码不能为空")
        
        return attrs


class RoleUpdateSerializer(serializers.ModelSerializer):
    """角色更新序列化器"""
    permission_ids = serializers.ListField(
        child=serializers.IntegerField(),
        write_only=True,
        required=False,
        help_text='权限ID列表'
    )
    
    class Meta:
        model = Role
        fields = [
            'name', 'code', 'description', 'is_active', 'permission_ids'
        ]
    
    def update(self, instance, validated_data):
        permission_ids = validated_data.pop('permission_ids', None)
        
        # 更新角色基本信息
        instance = super().update(instance, validated_data)
        
        # 更新角色权限
        if permission_ids is not None:
            # 清除现有权限
            RolePermission.objects.filter(role=instance).delete()
            
            # 添加新权限
            for permission_id in permission_ids:
                try:
                    permission = Permission.objects.get(id=permission_id)
                    RolePermission.objects.create(role=instance, permission=permission)
                except Permission.DoesNotExist:
                    # 权限不存在，记录错误但不影响更新
                    import logging
                    logger = logging.getLogger(__name__)
                    logger.error(f"权限ID {permission_id} 不存在，无法分配给角色 {instance.name}")
        
        return instance


class RoleSerializer(serializers.ModelSerializer):
    """角色序列化器"""
    permissions = serializers.SerializerMethodField()
    menus = serializers.SerializerMethodField()
    user_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Role
        fields = [
            'id', 'name', 'code', 'description', 'is_active',
            'created_at', 'updated_at', 'permissions', 'menus', 'user_count'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def get_permissions(self, obj):
        """获取角色权限"""
        role_permissions = RolePermission.objects.filter(role=obj).select_related('permission')
        return [{'id': rp.permission.id, 'name': rp.permission.name, 'code': rp.permission.code} for rp in role_permissions]
    
    def get_menus(self, obj):
        """获取角色菜单"""
        role_menus = RoleMenu.objects.filter(role=obj).select_related('menu')
        return [{'id': rm.menu.id, 'name': rm.menu.name, 'code': rm.menu.code} for rm in role_menus]
    
    def get_user_count(self, obj):
        """获取角色用户数量"""
        return UserRole.objects.filter(role=obj).count()


class PermissionSerializer(serializers.ModelSerializer):
    """权限序列化器"""
    
    class Meta:
        model = Permission
        fields = [
            'id', 'name', 'code', 'description', 'module',
            'is_active', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class MenuSerializer(serializers.ModelSerializer):
    """菜单序列化器"""
    children = serializers.SerializerMethodField()
    
    class Meta:
        model = Menu
        fields = [
            'id', 'name', 'code', 'url', 'icon', 'parent',
            'sort_order', 'is_active', 'created_at', 'children'
        ]
        read_only_fields = ['id', 'created_at']
    
    def get_children(self, obj):
        """获取子菜单"""
        children = Menu.objects.filter(parent=obj, is_active=True).order_by('sort_order')
        return MenuSerializer(children, many=True).data


class UserLoginLogSerializer(serializers.ModelSerializer):
    """用户登录日志序列化器"""
    username = serializers.CharField(source='user.username', read_only=True)
    
    class Meta:
        model = UserLoginLog
        fields = [
            'id', 'username', 'ip_address', 'user_agent',
            'login_time', 'logout_time', 'is_success', 'failure_reason',
            'location', 'device_type'
        ]
        read_only_fields = ['id', 'login_time']


class UserProfileSerializer(serializers.ModelSerializer):
    """用户资料序列化器"""
    
    class Meta:
        model = UserProfile
        fields = [
            'real_name', 'id_card', 'gender', 'birthday', 'address',
            'company', 'position', 'bio', 'website', 'social_media',
            'preferences', 'created_at', 'updated_at'
        ]
        read_only_fields = ['created_at', 'updated_at']


class UserSessionSerializer(serializers.ModelSerializer):
    """用户会话序列化器"""
    user_name = serializers.CharField(source='user.username', read_only=True)
    
    class Meta:
        model = UserSession
        fields = [
            'id', 'user', 'user_name', 'session_key', 'ip_address',
            'user_agent', 'login_time', 'last_activity', 'is_active',
            'expire_at'
        ]
        read_only_fields = ['id', 'user', 'login_time', 'last_activity']


class UserActivityLogSerializer(serializers.ModelSerializer):
    """用户活动日志序列化器"""
    action_display = serializers.CharField(source='get_action_display', read_only=True)
    user_name = serializers.CharField(source='user.username', read_only=True)
    
    class Meta:
        model = UserActivityLog
        fields = [
            'id', 'user', 'user_name', 'action', 'action_display',
            'description', 'ip_address', 'user_agent', 'request_path',
            'extra_data', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class PermissionGroupSerializer(serializers.ModelSerializer):
    """权限组序列化器"""
    
    class Meta:
        model = PermissionGroup
        fields = [
            'id', 'name', 'code', 'description', 'module',
            'sort_order', 'is_active', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class RolePermissionAuditSerializer(serializers.ModelSerializer):
    """角色权限审计序列化器"""
    action_display = serializers.CharField(source='get_action_display', read_only=True)
    role_name = serializers.CharField(source='role.name', read_only=True)
    permission_name = serializers.CharField(source='permission.name', read_only=True)
    user_name = serializers.CharField(source='user.username', read_only=True)
    
    class Meta:
        model = RolePermissionAudit
        fields = [
            'id', 'role', 'role_name', 'permission', 'permission_name',
            'user', 'user_name', 'action', 'action_display', 'description',
            'ip_address', 'user_agent', 'extra_data', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class UserPermissionOverrideSerializer(serializers.ModelSerializer):
    """用户权限覆盖序列化器"""
    user_name = serializers.CharField(source='user.username', read_only=True)
    permission_name = serializers.CharField(source='permission.name', read_only=True)
    granted_by_name = serializers.CharField(source='granted_by.username', read_only=True)
    
    class Meta:
        model = UserPermissionOverride
        fields = [
            'id', 'user', 'user_name', 'permission', 'permission_name',
            'is_granted', 'reason', 'granted_by', 'granted_by_name',
            'expire_at', 'is_active', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class EnhancedRoleMenuSerializer(serializers.ModelSerializer):
    """增强的角色菜单序列化器"""
    role_name = serializers.CharField(source='role.name', read_only=True)
    menu_name = serializers.CharField(source='menu.name', read_only=True)
    
    class Meta:
        model = RoleMenu
        fields = [
            'id', 'role', 'role_name', 'menu', 'menu_name',
            'can_view', 'can_create', 'can_update', 'can_delete',
            'can_export', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']
