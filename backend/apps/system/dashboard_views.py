"""
Dashboard API Views
为前端仪表板提供统一的数据接口
"""
from rest_framework import permissions, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.utils import timezone
from datetime import timedelta
from django.db.models import Count, Q

from apps.users.models import User
from apps.enterprises.models import Enterprise, EnterpriseProject
from apps.persons.models import Person, PersonTask, PersonProject
from apps.info_plaza.models import InfoPost
from apps.resources.models import Resource
from apps.system.models import SystemNotification, SystemLog


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def dashboard_statistics(request):
    """
    仪表板统计数据
    返回当前用户相关的统计信息
    """
    user = request.user
    
    # 基础统计数据
    stats = {
        'posts': 0,
        'resources': 0,
        'projects': 0,
        'tasks': 0
    }
    
    try:
        # 根据用户类型获取不同的统计数据
        if user.user_type == 'enterprise':
            # 企业用户统计
            try:
                enterprise = Enterprise.objects.get(user=user)
                stats['posts'] = InfoPost.objects.filter(
                    publisher_type='enterprise',
                    publisher_id=enterprise.id,
                    status='published'
                ).count()
                stats['resources'] = Resource.objects.filter(
                    owner_type='enterprise',
                    owner_id=enterprise.id
                ).count()
                stats['projects'] = EnterpriseProject.objects.filter(
                    enterprise=enterprise
                ).count()
                # 企业没有任务，使用项目数量
                stats['tasks'] = stats['projects']
            except Enterprise.DoesNotExist:
                pass
                
        elif user.user_type == 'personal':
            # 个人用户统计
            try:
                person = Person.objects.get(user=user)
                stats['posts'] = InfoPost.objects.filter(
                    publisher_type='personal',
                    publisher_id=person.id,
                    status='published'
                ).count()
                stats['resources'] = Resource.objects.filter(
                    owner_type='personal',
                    owner_id=person.id
                ).count()
                stats['projects'] = PersonProject.objects.filter(
                    person=person
                ).count()
                stats['tasks'] = PersonTask.objects.filter(
                    person=person,
                    status__in=['pending', 'in_progress']
                ).count()
            except Person.DoesNotExist:
                pass
                
        else:
            # 管理员统计 - 全局数据
            stats['posts'] = InfoPost.objects.filter(status='published').count()
            stats['resources'] = Resource.objects.filter(is_public=True).count()
            stats['projects'] = PersonProject.objects.count() + EnterpriseProject.objects.count()
            stats['tasks'] = PersonTask.objects.filter(status__in=['pending', 'in_progress']).count()
    
    except Exception as e:
        print(f"统计数据获取错误: {e}")
    
    return Response(stats)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def dashboard_activities(request):
    """
    最近活动列表
    返回用户最近的活动记录
    """
    user = request.user
    activities = []
    
    try:
        # 获取最近的系统日志作为活动记录
        recent_logs = SystemLog.objects.filter(
            user=user
        ).order_by('-created_at')[:10]
        
        for log in recent_logs:
            activity_type = 'info'
            icon = 'Edit'
            
            # 根据日志类型设置图标
            if 'login' in log.action.lower():
                activity_type = 'success'
                icon = 'Check'
            elif 'create' in log.action.lower() or 'add' in log.action.lower():
                activity_type = 'resource'
                icon = 'Plus'
            elif 'project' in log.action.lower():
                activity_type = 'project'
                icon = 'Folder'
            
            activities.append({
                'id': log.id,
                'type': activity_type,
                'icon': icon,
                'title': log.action,
                'description': log.description or '',
                'time': format_time_ago(log.created_at)
            })
        
        # 如果没有日志记录，返回默认活动
        if not activities:
            activities = [
                {
                    'id': 1,
                    'type': 'info',
                    'icon': 'Edit',
                    'title': '欢迎使用系统',
                    'description': '开始创建您的第一个项目吧',
                    'time': '刚刚'
                }
            ]
    
    except Exception as e:
        print(f"活动数据获取错误: {e}")
        activities = [
            {
                'id': 1,
                'type': 'info',
                'icon': 'Edit',
                'title': '暂无活动记录',
                'description': '您的活动将显示在这里',
                'time': '刚刚'
            }
        ]
    
    return Response(activities)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def dashboard_tasks(request):
    """
    待办任务列表
    返回当前用户的待办任务
    """
    user = request.user
    tasks = []
    
    try:
        # 只有个人用户才有任务
        if user.user_type == 'personal':
            try:
                person = Person.objects.get(user=user)
                person_tasks = PersonTask.objects.filter(
                    person=person,
                    status__in=['pending', 'in_progress']
                ).order_by('-priority', 'due_date')[:10]
                
                priority_map = {
                    'high': '高',
                    'medium': '中',
                    'low': '低'
                }
                
                for task in person_tasks:
                    tasks.append({
                        'id': task.id,
                        'title': task.title,
                        'priority': priority_map.get(task.priority, '中'),
                        'dueDate': format_due_date(task.due_date) if task.due_date else '无截止日期',
                        'completed': False
                    })
            except Person.DoesNotExist:
                pass
        
        # 如果没有任务，返回默认任务
        if not tasks:
            tasks = [
                {
                    'id': 1,
                    'title': '欢迎使用系统',
                    'priority': '低',
                    'dueDate': '今天',
                    'completed': False
                }
            ]
    
    except Exception as e:
        print(f"任务数据获取错误: {e}")
        tasks = [
            {
                'id': 1,
                'title': '加载失败',
                'priority': '低',
                'dueDate': '今天',
                'completed': False
            }
        ]
    
    return Response(tasks)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def dashboard_notifications(request):
    """
    系统通知列表
    返回当前用户的未读通知
    """
    user = request.user
    notifications = []
    
    try:
        # 获取系统通知
        system_notifications = SystemNotification.objects.filter(
            Q(target_user=user) | Q(target_user__isnull=True)
        ).filter(
            is_active=True
        ).order_by('-created_at')[:10]
        
        for notif in system_notifications:
            notif_type = 'info'
            icon = 'Bell'
            
            # 根据通知类型设置样式
            if notif.notification_type == 'warning':
                notif_type = 'warning'
                icon = 'Warning'
            elif notif.notification_type == 'error':
                notif_type = 'error'
                icon = 'Close'
            elif notif.notification_type == 'success':
                notif_type = 'success'
                icon = 'Check'
            
            notifications.append({
                'id': notif.id,
                'type': notif_type,
                'icon': icon,
                'title': notif.title,
                'content': notif.content,
                'time': format_time_ago(notif.created_at)
            })
        
        # 如果没有通知，返回默认通知
        if not notifications:
            notifications = [
                {
                    'id': 1,
                    'type': 'info',
                    'icon': 'Bell',
                    'title': '欢迎',
                    'content': '欢迎使用防腐保温智能数字平台',
                    'time': '刚刚'
                }
            ]
    
    except Exception as e:
        print(f"通知数据获取错误: {e}")
        notifications = [
            {
                'id': 1,
                'type': 'info',
                'icon': 'Bell',
                'title': '系统消息',
                'content': '暂无新通知',
                'time': '刚刚'
            }
        ]
    
    return Response(notifications)


def format_time_ago(dt):
    """格式化时间为"xx前"的格式"""
    if not dt:
        return '未知'
    
    now = timezone.now()
    diff = now - dt
    
    if diff.days > 7:
        return dt.strftime('%Y-%m-%d')
    elif diff.days > 0:
        return f'{diff.days}天前'
    elif diff.seconds >= 3600:
        hours = diff.seconds // 3600
        return f'{hours}小时前'
    elif diff.seconds >= 60:
        minutes = diff.seconds // 60
        return f'{minutes}分钟前'
    else:
        return '刚刚'


def format_due_date(dt):
    """格式化截止日期"""
    if not dt:
        return '无截止日期'
    
    today = timezone.now().date()
    
    if hasattr(dt, 'date'):
        due_date = dt.date()
    else:
        due_date = dt
    
    diff = (due_date - today).days
    
    if diff < 0:
        return f'已逾期{abs(diff)}天'
    elif diff == 0:
        return '今天'
    elif diff == 1:
        return '明天'
    elif diff <= 7:
        return f'{diff}天后'
    else:
        return due_date.strftime('%Y-%m-%d')


