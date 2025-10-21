from django.contrib import admin
from .models import (
    Enterprise, EnterpriseDocument, Employee, 
    EnterpriseProject, EnterpriseStatistics
)


@admin.register(Enterprise)
class EnterpriseAdmin(admin.ModelAdmin):
    """企业信息管理"""
    list_display = [
        'name', 'short_name', 'enterprise_type', 'status', 
        'contact_person', 'contact_phone', 'is_active', 'created_at'
    ]
    list_filter = ['enterprise_type', 'status', 'is_active', 'created_at']
    search_fields = ['name', 'short_name', 'unified_social_credit_code', 'contact_person']
    ordering = ['-created_at']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(EnterpriseDocument)
class EnterpriseDocumentAdmin(admin.ModelAdmin):
    """企业资质文件管理"""
    list_display = [
        'enterprise', 'title', 'document_type', 'is_verified', 
        'verified_by', 'verified_at', 'created_at'
    ]
    list_filter = ['document_type', 'is_verified', 'created_at']
    search_fields = ['enterprise__name', 'title', 'description']
    ordering = ['-created_at']
    readonly_fields = ['verified_at', 'verified_by', 'created_at']


@admin.register(Employee)
class EmployeeAdmin(admin.ModelAdmin):
    """企业员工管理"""
    list_display = [
        'enterprise', 'user', 'employee_id', 'position', 
        'department', 'hire_date', 'is_active', 'created_at'
    ]
    list_filter = ['position', 'department', 'is_active', 'hire_date', 'created_at']
    search_fields = ['enterprise__name', 'user__username', 'employee_id']
    ordering = ['-created_at']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(EnterpriseProject)
class EnterpriseProjectAdmin(admin.ModelAdmin):
    """企业项目管理"""
    list_display = [
        'enterprise', 'name', 'client', 'status', 'progress',
        'start_date', 'end_date', 'created_at'
    ]
    list_filter = ['status', 'start_date', 'end_date', 'created_at']
    search_fields = ['enterprise__name', 'name', 'client', 'location']
    ordering = ['-created_at']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(EnterpriseStatistics)
class EnterpriseStatisticsAdmin(admin.ModelAdmin):
    """企业统计管理"""
    list_display = [
        'enterprise', 'total_projects', 'completed_projects',
        'total_employees', 'total_revenue', 'last_updated'
    ]
    list_filter = ['last_updated']
    search_fields = ['enterprise__name']
    ordering = ['-last_updated']
    readonly_fields = ['last_updated']
