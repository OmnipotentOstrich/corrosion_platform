from django.contrib import admin
from .models import Person, PersonProject, PersonTask, PersonStatistics, PersonDocument


@admin.register(Person)
class PersonAdmin(admin.ModelAdmin):
    """个人用户信息管理"""
    list_display = [
        'real_name', 'user', 'gender', 'education', 'profession',
        'work_experience', 'is_verified', 'created_at'
    ]
    list_filter = ['gender', 'education', 'profession', 'is_verified', 'created_at']
    search_fields = ['real_name', 'user__username', 'profession', 'skills']
    ordering = ['-created_at']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(PersonProject)
class PersonProjectAdmin(admin.ModelAdmin):
    """个人项目管理"""
    list_display = [
        'person', 'name', 'project_type', 'client', 'status', 'progress',
        'start_date', 'end_date', 'created_at'
    ]
    list_filter = ['project_type', 'status', 'start_date', 'end_date', 'created_at']
    search_fields = ['person__real_name', 'name', 'client', 'role', 'location']
    ordering = ['-created_at']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(PersonTask)
class PersonTaskAdmin(admin.ModelAdmin):
    """个人任务管理"""
    list_display = [
        'person', 'title', 'priority', 'status', 'due_date',
        'completed_at', 'created_at'
    ]
    list_filter = ['priority', 'status', 'due_date', 'created_at']
    search_fields = ['person__real_name', 'title', 'description']
    ordering = ['-created_at']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(PersonStatistics)
class PersonStatisticsAdmin(admin.ModelAdmin):
    """个人统计管理"""
    list_display = [
        'person', 'total_projects', 'completed_projects', 'total_tasks',
        'completed_tasks', 'total_income', 'work_days', 'last_updated'
    ]
    list_filter = ['last_updated']
    search_fields = ['person__real_name']
    ordering = ['-last_updated']
    readonly_fields = ['last_updated']


@admin.register(PersonDocument)
class PersonDocumentAdmin(admin.ModelAdmin):
    """个人资质文件管理"""
    list_display = [
        'person', 'title', 'document_type', 'is_public', 'created_at'
    ]
    list_filter = ['document_type', 'is_public', 'created_at']
    search_fields = ['person__real_name', 'title', 'description']
    ordering = ['-created_at']
    readonly_fields = ['created_at']
