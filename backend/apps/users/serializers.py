from rest_framework import serializers
from django.contrib.auth import authenticate
from django.contrib.auth.password_validation import validate_password
from .models import User, Role, Permission, Menu, UserRole, RolePermission, RoleMenu, UserLoginLog


class UserSerializer(serializers.ModelSerializer):
    """用户序列化器"""
    user_type_display = serializers.CharField(source='get_user_type_display', read_only=True)
    roles = serializers.SerializerMethodField()
    
    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'first_name', 'last_name',
            'user_type', 'user_type_display', 'phone', 'avatar',
            'is_verified', 'is_active', 'date_joined', 'created_at',
            'updated_at', 'roles'
        ]
        read_only_fields = ['id', 'date_joined', 'created_at', 'updated_at']
    
    def get_roles(self, obj):
        """获取用户角色"""
        user_roles = UserRole.objects.filter(user=obj).select_related('role')
        return [{'id': ur.role.id, 'name': ur.role.name, 'code': ur.role.code} for ur in user_roles]


class UserCreateSerializer(serializers.ModelSerializer):
    """用户创建序列化器"""
    password = serializers.CharField(write_only=True, validators=[validate_password])
    password_confirm = serializers.CharField(write_only=True)
    
    class Meta:
        model = User
        fields = [
            'username', 'email', 'password', 'password_confirm',
            'first_name', 'last_name', 'user_type', 'phone'
        ]
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError("密码不匹配")
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password_confirm')
        password = validated_data.pop('password')
        user_type = validated_data.get('user_type', 'personal')
        
        # 创建用户
        user = User.objects.create_user(password=password, **validated_data)
        
        # 根据用户类型自动分配角色
        from .models import Role, UserRole
        
        try:
            # 根据用户类型选择角色
            if user_type == 'enterprise':
                # 企业用户默认分配企业管理员角色
                role = Role.objects.get(code='enterprise_admin')
            else:
                # 个人用户分配个人用户角色
                role = Role.objects.get(code='personal_user')
            
            # 创建用户角色关联
            UserRole.objects.create(user=user, role=role)
        except Role.DoesNotExist:
            # 如果角色不存在，记录错误但不影响用户创建
            import logging
            logger = logging.getLogger(__name__)
            logger.error(f"角色不存在，无法为用户 {user.username} 分配角色")
        
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
            'login_time', 'is_success'
        ]
        read_only_fields = ['id', 'login_time']
