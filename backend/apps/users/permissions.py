from rest_framework import permissions


class IsAdminOrReadOnly(permissions.BasePermission):
    """
    管理员可以读写，其他用户只能读
    """
    
    def has_permission(self, request, view):
        if request.method in permissions.SAFE_METHODS:
            return True
        return request.user and request.user.is_staff


class IsOwnerOrAdmin(permissions.BasePermission):
    """
    只有对象所有者或管理员可以访问
    """
    
    def has_object_permission(self, request, view, obj):
        if request.user.is_staff:
            return True
        return obj == request.user


class IsEnterpriseAdmin(permissions.BasePermission):
    """
    企业管理员权限
    """
    
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        # 检查用户是否是企业用户且是管理员
        from .models import UserRole
        from apps.enterprises.models import Enterprise
        
        if request.user.user_type != 'enterprise':
            return False
        
        # 检查是否是企业管理员角色
        user_roles = UserRole.objects.filter(user=request.user)
        for user_role in user_roles:
            if user_role.role.code == 'enterprise_admin':
                return True
        
        return False


class IsPersonalUser(permissions.BasePermission):
    """
    个人用户权限
    """
    
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        return request.user.user_type == 'personal'


class IsEnterpriseUser(permissions.BasePermission):
    """
    企业用户权限
    """
    
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        return request.user.user_type == 'enterprise'
