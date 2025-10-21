from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import (
    User, Role, Permission, Menu, UserRole, 
    RolePermission, RoleMenu, UserLoginLog
)


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    """用户管理"""
    list_display = ['username', 'email', 'user_type', 'phone', 'is_verified', 'is_active', 'date_joined']
    list_filter = ['user_type', 'is_verified', 'is_active', 'is_staff', 'date_joined']
    search_fields = ['username', 'email', 'first_name', 'last_name', 'phone']
    ordering = ['-date_joined']
    
    fieldsets = BaseUserAdmin.fieldsets + (
        ('扩展信息', {'fields': ('user_type', 'phone', 'avatar', 'is_verified')}),
    )
    
    add_fieldsets = BaseUserAdmin.add_fieldsets + (
        ('扩展信息', {'fields': ('user_type', 'phone', 'email', 'first_name', 'last_name')}),
    )


@admin.register(Role)
class RoleAdmin(admin.ModelAdmin):
    """角色管理"""
    list_display = ['name', 'code', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['name', 'code', 'description']
    ordering = ['-created_at']


@admin.register(Permission)
class PermissionAdmin(admin.ModelAdmin):
    """权限管理"""
    list_display = ['name', 'code', 'module', 'is_active', 'created_at']
    list_filter = ['module', 'is_active', 'created_at']
    search_fields = ['name', 'code', 'description']
    ordering = ['module', 'created_at']


@admin.register(Menu)
class MenuAdmin(admin.ModelAdmin):
    """菜单管理"""
    list_display = ['name', 'code', 'url', 'parent', 'sort_order', 'is_active', 'created_at']
    list_filter = ['is_active', 'parent', 'created_at']
    search_fields = ['name', 'code', 'url']
    ordering = ['sort_order', 'created_at']


@admin.register(UserRole)
class UserRoleAdmin(admin.ModelAdmin):
    """用户角色关联管理"""
    list_display = ['user', 'role', 'created_at']
    list_filter = ['role', 'created_at']
    search_fields = ['user__username', 'role__name']
    ordering = ['-created_at']


@admin.register(RolePermission)
class RolePermissionAdmin(admin.ModelAdmin):
    """角色权限关联管理"""
    list_display = ['role', 'permission', 'created_at']
    list_filter = ['role', 'permission__module', 'created_at']
    search_fields = ['role__name', 'permission__name']
    ordering = ['-created_at']


@admin.register(RoleMenu)
class RoleMenuAdmin(admin.ModelAdmin):
    """角色菜单关联管理"""
    list_display = ['role', 'menu', 'created_at']
    list_filter = ['role', 'created_at']
    search_fields = ['role__name', 'menu__name']
    ordering = ['-created_at']


@admin.register(UserLoginLog)
class UserLoginLogAdmin(admin.ModelAdmin):
    """用户登录日志管理"""
    list_display = ['user', 'ip_address', 'login_time', 'is_success']
    list_filter = ['is_success', 'login_time']
    search_fields = ['user__username', 'ip_address']
    ordering = ['-login_time']
    readonly_fields = ['user', 'ip_address', 'user_agent', 'login_time', 'is_success']
