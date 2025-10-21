from django.contrib import admin
from .models import (
    ResourceType, Resource, ResourceImage, ResourceUsageLog,
    ResourceMaintenance, ResourceRequest, ResourceStatistics
)


@admin.register(ResourceType)
class ResourceTypeAdmin(admin.ModelAdmin):
    """资源类型管理"""
    list_display = ['name', 'code', 'sort_order', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['name', 'code', 'description']
    ordering = ['sort_order', 'created_at']


@admin.register(Resource)
class ResourceAdmin(admin.ModelAdmin):
    """资源管理"""
    list_display = [
        'name', 'resource_type', 'manufacturer', 'model', 'status',
        'quality', 'quantity', 'location', 'owner', 'is_public',
        'is_available_for_rent', 'created_at'
    ]
    list_filter = ['resource_type', 'status', 'quality', 'is_public', 'is_available_for_rent', 'created_at']
    search_fields = ['name', 'manufacturer', 'model', 'serial_number', 'location', 'owner__username']
    ordering = ['-created_at']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(ResourceImage)
class ResourceImageAdmin(admin.ModelAdmin):
    """资源图片管理"""
    list_display = ['resource', 'caption', 'sort_order', 'created_at']
    list_filter = ['created_at']
    search_fields = ['resource__name', 'caption']
    ordering = ['resource', 'sort_order']


@admin.register(ResourceUsageLog)
class ResourceUsageLogAdmin(admin.ModelAdmin):
    """资源使用日志管理"""
    list_display = [
        'resource', 'user', 'usage_type', 'start_date', 'end_date', 'created_at'
    ]
    list_filter = ['usage_type', 'start_date', 'end_date', 'created_at']
    search_fields = ['resource__name', 'user__username', 'purpose', 'location']
    ordering = ['-created_at']
    readonly_fields = ['created_at']


@admin.register(ResourceMaintenance)
class ResourceMaintenanceAdmin(admin.ModelAdmin):
    """资源维护记录管理"""
    list_display = [
        'resource', 'maintenance_type', 'title', 'start_date',
        'end_date', 'cost', 'technician', 'created_by', 'created_at'
    ]
    list_filter = ['maintenance_type', 'start_date', 'end_date', 'created_at']
    search_fields = ['resource__name', 'title', 'technician', 'created_by__username']
    ordering = ['-created_at']
    readonly_fields = ['created_at']


@admin.register(ResourceRequest)
class ResourceRequestAdmin(admin.ModelAdmin):
    """资源申请管理"""
    list_display = [
        'resource', 'requester', 'request_type', 'title', 'status',
        'start_date', 'end_date', 'approved_by', 'approved_at', 'created_at'
    ]
    list_filter = ['request_type', 'status', 'start_date', 'end_date', 'created_at']
    search_fields = ['resource__name', 'requester__username', 'title', 'purpose']
    ordering = ['-created_at']
    readonly_fields = ['approved_at', 'created_at', 'updated_at']


@admin.register(ResourceStatistics)
class ResourceStatisticsAdmin(admin.ModelAdmin):
    """资源统计管理"""
    list_display = [
        'resource_type', 'total_count', 'available_count', 'in_use_count',
        'maintenance_count', 'total_value', 'utilization_rate', 'last_updated'
    ]
    list_filter = ['last_updated']
    search_fields = ['resource_type__name']
    ordering = ['-last_updated']
    readonly_fields = ['last_updated']
