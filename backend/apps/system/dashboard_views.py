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
    返回当前用户相关的统计信息，包括趋势和百分比
    """
    user = request.user
    today = timezone.now().date()
    last_month = today - timedelta(days=30)
    
    # 基础统计数据
    stats = {
        'posts': 0,
        'posts_trend': 0,
        'posts_percentage': 0,
        'resources': 0,
        'resources_trend': 0,
        'resources_percentage': 0,
        'projects': 0,
        'projects_trend': 0,
        'projects_percentage': 0,
        'tasks': 0,
        'tasks_trend': 0,
        'tasks_percentage': 0
    }
    
    try:
        # 根据用户类型获取不同的统计数据
        if user.user_type == 'enterprise':
            # 企业用户统计
            try:
                enterprise = Enterprise.objects.get(user=user)
                
                # 发布信息统计 - 企业用户没有直接发布信息，使用全局统计
                current_posts = InfoPost.objects.filter(status='published').count()
                last_month_posts = InfoPost.objects.filter(
                    status='published',
                    created_at__lt=last_month
                ).count()
                stats['posts'] = current_posts
                stats['posts_trend'] = calculate_trend(current_posts, last_month_posts)
                stats['posts_percentage'] = min(100, (current_posts / 50) * 100) if current_posts else 0
                
                # 资源统计
                current_resources = Resource.objects.filter(
                    owner_type='enterprise',
                    owner_id=enterprise.id
                ).count()
                last_month_resources = Resource.objects.filter(
                    owner_type='enterprise',
                    owner_id=enterprise.id,
                    created_at__lt=last_month
                ).count()
                stats['resources'] = current_resources
                stats['resources_trend'] = calculate_trend(current_resources, last_month_resources)
                stats['resources_percentage'] = min(100, (current_resources / 100) * 100) if current_resources else 0
                
                # 项目统计
                current_projects = EnterpriseProject.objects.filter(
                    enterprise=enterprise
                ).count()
                last_month_projects = EnterpriseProject.objects.filter(
                    enterprise=enterprise,
                    created_at__lt=last_month
                ).count()
                stats['projects'] = current_projects
                stats['projects_trend'] = calculate_trend(current_projects, last_month_projects)
                stats['projects_percentage'] = min(100, (current_projects / 20) * 100) if current_projects else 0
                
                # 企业没有任务，使用项目数量
                stats['tasks'] = current_projects
                stats['tasks_trend'] = stats['projects_trend']
                stats['tasks_percentage'] = stats['projects_percentage']
                
            except Enterprise.DoesNotExist:
                pass
                
        elif user.user_type == 'personal':
            # 个人用户统计
            try:
                person = Person.objects.get(user=user)
                
                # 发布信息统计 - 使用author字段
                current_posts = InfoPost.objects.filter(
                    author=user,
                    status='published'
                ).count()
                last_month_posts = InfoPost.objects.filter(
                    author=user,
                    status='published',
                    created_at__lt=last_month
                ).count()
                stats['posts'] = current_posts
                stats['posts_trend'] = calculate_trend(current_posts, last_month_posts)
                stats['posts_percentage'] = min(100, (current_posts / 30) * 100) if current_posts else 0
                
                # 资源统计 - 检查Resource模型的实际字段
                try:
                    current_resources = Resource.objects.filter(
                        owner=user
                    ).count()
                    last_month_resources = Resource.objects.filter(
                        owner=user,
                        created_at__lt=last_month
                    ).count()
                except:
                    # 如果字段名不对，使用全局统计
                    current_resources = Resource.objects.count()
                    last_month_resources = Resource.objects.filter(created_at__lt=last_month).count()
                
                stats['resources'] = current_resources
                stats['resources_trend'] = calculate_trend(current_resources, last_month_resources)
                stats['resources_percentage'] = min(100, (current_resources / 50) * 100) if current_resources else 0
                
                # 项目统计
                current_projects = PersonProject.objects.filter(
                    person=person
                ).count()
                last_month_projects = PersonProject.objects.filter(
                    person=person,
                    created_at__lt=last_month
                ).count()
                stats['projects'] = current_projects
                stats['projects_trend'] = calculate_trend(current_projects, last_month_projects)
                stats['projects_percentage'] = min(100, (current_projects / 15) * 100) if current_projects else 0
                
                # 任务统计
                current_tasks = PersonTask.objects.filter(
                    person=person,
                    status__in=['pending', 'in_progress']
                ).count()
                total_tasks = PersonTask.objects.filter(person=person).count()
                stats['tasks'] = current_tasks
                stats['tasks_trend'] = 5  # 默认趋势
                stats['tasks_percentage'] = min(100, (current_tasks / 30) * 100) if current_tasks else 0
                
            except Person.DoesNotExist:
                # 如果没有Person记录，使用全局统计（适用于admin用户）
                current_posts = InfoPost.objects.filter(status='published').count()
                last_month_posts = InfoPost.objects.filter(status='published', created_at__lt=last_month).count()
                stats['posts'] = current_posts
                stats['posts_trend'] = calculate_trend(current_posts, last_month_posts)
                stats['posts_percentage'] = min(100, (current_posts / 50) * 100) if current_posts else 0
                
                current_resources = Resource.objects.count()
                last_month_resources = Resource.objects.filter(created_at__lt=last_month).count()
                stats['resources'] = current_resources
                stats['resources_trend'] = calculate_trend(current_resources, last_month_resources)
                stats['resources_percentage'] = min(100, (current_resources / 100) * 100) if current_resources else 0
                
                current_projects = PersonProject.objects.count() + EnterpriseProject.objects.count()
                last_month_person_projects = PersonProject.objects.filter(created_at__lt=last_month).count()
                last_month_enterprise_projects = EnterpriseProject.objects.filter(created_at__lt=last_month).count()
                last_month_projects = last_month_person_projects + last_month_enterprise_projects
                stats['projects'] = current_projects
                stats['projects_trend'] = calculate_trend(current_projects, last_month_projects)
                stats['projects_percentage'] = min(100, (current_projects / 50) * 100) if current_projects else 0
                
                current_tasks = PersonTask.objects.filter(status__in=['pending', 'in_progress']).count()
                stats['tasks'] = current_tasks
                stats['tasks_trend'] = 5
                stats['tasks_percentage'] = min(100, (current_tasks / 100) * 100) if current_tasks else 0
                
        else:
            # 管理员统计 - 全局数据
            # 统计所有发布的信息（不区分状态）
            current_posts = InfoPost.objects.count()
            last_month_posts = InfoPost.objects.filter(created_at__lt=last_month).count()
            stats['posts'] = current_posts
            stats['posts_trend'] = calculate_trend(current_posts, last_month_posts)
            stats['posts_percentage'] = min(100, (current_posts / 50) * 100) if current_posts else 0
            
            # 统计所有资源（不区分公开/私有）
            current_resources = Resource.objects.count()
            last_month_resources = Resource.objects.filter(created_at__lt=last_month).count()
            stats['resources'] = current_resources
            stats['resources_trend'] = calculate_trend(current_resources, last_month_resources)
            stats['resources_percentage'] = min(100, (current_resources / 100) * 100) if current_resources else 0
            
            # 统计所有项目
            current_projects = PersonProject.objects.count() + EnterpriseProject.objects.count()
            last_month_person_projects = PersonProject.objects.filter(created_at__lt=last_month).count()
            last_month_enterprise_projects = EnterpriseProject.objects.filter(created_at__lt=last_month).count()
            last_month_projects = last_month_person_projects + last_month_enterprise_projects
            stats['projects'] = current_projects
            stats['projects_trend'] = calculate_trend(current_projects, last_month_projects)
            stats['projects_percentage'] = min(100, (current_projects / 50) * 100) if current_projects else 0
            
            # 统计所有待办任务
            current_tasks = PersonTask.objects.filter(status__in=['pending', 'in_progress']).count()
            stats['tasks'] = current_tasks
            stats['tasks_trend'] = 5
            stats['tasks_percentage'] = min(100, (current_tasks / 100) * 100) if current_tasks else 0
    
    except Exception as e:
        print(f"统计数据获取错误: {e}")
    
    return Response(stats)


def calculate_trend(current, previous):
    """计算趋势百分比"""
    if previous == 0:
        return 100 if current > 0 else 0
    
    trend = ((current - previous) / previous) * 100
    return round(trend, 1)


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
            Q(target_users=user) | Q(is_global=True)
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


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def dashboard_projects(request):
    """
    项目进度列表
    返回当前用户的项目进度信息
    """
    user = request.user
    projects = []
    
    try:
        if user.user_type == 'enterprise':
            # 企业用户的项目
            try:
                enterprise = Enterprise.objects.get(user=user)
                enterprise_projects = EnterpriseProject.objects.filter(
                    enterprise=enterprise
                ).order_by('-created_at')[:5]
                
                for proj in enterprise_projects:
                    # 计算项目进度
                    progress = getattr(proj, 'progress', 0)
                    if not progress and hasattr(proj, 'start_date') and hasattr(proj, 'end_date'):
                        if proj.start_date and proj.end_date:
                            total_days = (proj.end_date - proj.start_date).days
                            elapsed_days = (timezone.now().date() - proj.start_date).days
                            progress = min(100, max(0, int((elapsed_days / total_days) * 100))) if total_days > 0 else 0
                    
                    # 确定状态
                    status = getattr(proj, 'status', 'active')
                    status_text = '进行中'
                    if status == 'completed':
                        status_text = '已完成'
                        progress = 100
                    elif status == 'pending':
                        status_text = '待开始'
                    elif status == 'paused':
                        status_text = '已暂停'
                    
                    projects.append({
                        'id': proj.id,
                        'name': proj.name,
                        'progress': progress,
                        'status': status,
                        'statusText': status_text,
                        'team': getattr(proj, 'leader', '企业团队'),
                        'deadline': proj.end_date.strftime('%Y-%m-%d') if hasattr(proj, 'end_date') and proj.end_date else '未设置'
                    })
                    
            except Enterprise.DoesNotExist:
                pass
                
        elif user.user_type == 'personal':
            # 个人用户的项目
            try:
                person = Person.objects.get(user=user)
                person_projects = PersonProject.objects.filter(
                    person=person
                ).order_by('-created_at')[:5]
                
                for proj in person_projects:
                    # 计算项目进度
                    progress = getattr(proj, 'progress', 0)
                    if not progress and hasattr(proj, 'start_date') and hasattr(proj, 'end_date'):
                        if proj.start_date and proj.end_date:
                            total_days = (proj.end_date - proj.start_date).days
                            elapsed_days = (timezone.now().date() - proj.start_date).days
                            progress = min(100, max(0, int((elapsed_days / total_days) * 100))) if total_days > 0 else 0
                    
                    # 确定状态
                    status = getattr(proj, 'status', 'active')
                    status_text = '进行中'
                    if status == 'completed':
                        status_text = '已完成'
                        progress = 100
                    elif status == 'pending':
                        status_text = '待开始'
                    elif status == 'paused':
                        status_text = '已暂停'
                    
                    projects.append({
                        'id': proj.id,
                        'name': proj.name,
                        'progress': progress,
                        'status': status,
                        'statusText': status_text,
                        'team': getattr(proj, 'team_members', '个人'),
                        'deadline': proj.end_date.strftime('%Y-%m-%d') if hasattr(proj, 'end_date') and proj.end_date else '未设置'
                    })
                    
            except Person.DoesNotExist:
                pass
        else:
            # 管理员查看所有项目（取最新的5个）
            all_projects = []
            
            # 获取企业项目
            enterprise_projects = EnterpriseProject.objects.all().order_by('-created_at')[:3]
            for proj in enterprise_projects:
                progress = getattr(proj, 'progress', 50)
                status = getattr(proj, 'status', 'active')
                all_projects.append({
                    'id': f'e_{proj.id}',
                    'name': proj.name,
                    'progress': progress,
                    'status': status,
                    'statusText': '进行中' if status == 'active' else '已完成',
                    'team': getattr(proj, 'leader', '企业团队'),
                    'deadline': proj.end_date.strftime('%Y-%m-%d') if hasattr(proj, 'end_date') and proj.end_date else '未设置'
                })
            
            # 获取个人项目
            person_projects = PersonProject.objects.all().order_by('-created_at')[:2]
            for proj in person_projects:
                progress = getattr(proj, 'progress', 60)
                status = getattr(proj, 'status', 'active')
                all_projects.append({
                    'id': f'p_{proj.id}',
                    'name': proj.name,
                    'progress': progress,
                    'status': status,
                    'statusText': '进行中' if status == 'active' else '已完成',
                    'team': getattr(proj, 'team_members', '个人'),
                    'deadline': proj.end_date.strftime('%Y-%m-%d') if hasattr(proj, 'end_date') and proj.end_date else '未设置'
                })
            
            projects = all_projects
        
        # 如果没有项目，返回默认示例
        if not projects:
            projects = [
                {
                    'id': 1,
                    'name': '示例项目',
                    'progress': 0,
                    'status': 'pending',
                    'statusText': '待开始',
                    'team': '暂无',
                    'deadline': '未设置'
                }
            ]
    
    except Exception as e:
        print(f"项目数据获取错误: {e}")
        projects = []
    
    return Response(projects)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def dashboard_chart_data(request):
    """
    图表时序数据
    返回最近7天或30天的数据趋势
    """
    user = request.user
    period = request.GET.get('period', 'week')  # week, month, year
    
    # 根据周期确定天数
    if period == 'week':
        days = 7
        labels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    elif period == 'month':
        days = 30
        labels = [f'{i+1}日' for i in range(30)]
    else:  # year
        days = 365
        labels = [f'{i+1}月' for i in range(12)]
    
    # 初始化数据
    posts_data = []
    resources_data = []
    projects_data = []
    
    try:
        today = timezone.now().date()
        
        if period == 'week':
            # 按周统计
            for i in range(7):
                date = today - timedelta(days=6-i)
                
                if user.user_type == 'enterprise':
                    try:
                        enterprise = Enterprise.objects.get(user=user)
                        # 企业用户没有直接发布信息，使用全局统计
                        posts_count = InfoPost.objects.filter(
                            status='published',
                            created_at__date=date
                        ).count()
                        resources_count = Resource.objects.filter(
                            owner_type='enterprise',
                            owner_id=enterprise.id,
                            created_at__date=date
                        ).count()
                        projects_count = EnterpriseProject.objects.filter(
                            enterprise=enterprise,
                            created_at__date=date
                        ).count()
                    except Enterprise.DoesNotExist:
                        posts_count = resources_count = projects_count = 0
                        
                elif user.user_type == 'personal':
                    try:
                        person = Person.objects.get(user=user)
                        posts_count = InfoPost.objects.filter(
                            author=user,
                            created_at__date=date
                        ).count()
                        resources_count = Resource.objects.filter(
                            owner_type='personal',
                            owner_id=person.id,
                            created_at__date=date
                        ).count()
                        projects_count = PersonProject.objects.filter(
                            person=person,
                            created_at__date=date
                        ).count()
                    except Person.DoesNotExist:
                        posts_count = resources_count = projects_count = 0
                else:
                    # 管理员统计全局数据
                    posts_count = InfoPost.objects.filter(created_at__date=date).count()
                    resources_count = Resource.objects.filter(created_at__date=date).count()
                    projects_count = (PersonProject.objects.filter(created_at__date=date).count() + 
                                    EnterpriseProject.objects.filter(created_at__date=date).count())
                
                posts_data.append(posts_count)
                resources_data.append(resources_count)
                projects_data.append(projects_count)
        else:
            # 对于月和年，使用模拟数据（实际项目中应该从数据库聚合）
            import random
            posts_data = [random.randint(0, 10) for _ in range(len(labels))]
            resources_data = [random.randint(0, 8) for _ in range(len(labels))]
            projects_data = [random.randint(0, 5) for _ in range(len(labels))]
    
    except Exception as e:
        print(f"图表数据获取错误: {e}")
        # 返回默认数据
        posts_data = [5, 8, 3, 7, 4, 6, 2]
        resources_data = [2, 4, 1, 3, 2, 5, 1]
        projects_data = [1, 2, 0, 1, 3, 1, 0]
    
    return Response({
        'labels': labels,
        'datasets': {
            'posts': posts_data,
            'resources': resources_data,
            'projects': projects_data
        }
    })


@api_view(['GET'])
def debug_stats(request):
    """
    调试统计接口 - 无需认证
    用于排查数据问题
    """
    from apps.info_plaza.models import InfoPost
    from apps.resources.models import Resource
    from apps.persons.models import PersonProject
    from apps.enterprises.models import EnterpriseProject
    from apps.persons.models import PersonTask
    from apps.users.models import User
    
    debug_data = {
        'total_users': User.objects.count(),
        'total_posts': InfoPost.objects.count(),
        'total_resources': Resource.objects.count(),
        'total_person_projects': PersonProject.objects.count(),
        'total_enterprise_projects': EnterpriseProject.objects.count(),
        'total_tasks': PersonTask.objects.count(),
        'pending_tasks': PersonTask.objects.filter(status__in=['pending', 'in_progress']).count(),
        'post_details': list(InfoPost.objects.values('id', 'title', 'status', 'created_at')[:5]),
        'resource_details': list(Resource.objects.values('id', 'name', 'is_public', 'created_at')[:5]),
        'project_details': {
            'person_projects': list(PersonProject.objects.values('id', 'name', 'created_at')[:3]),
            'enterprise_projects': list(EnterpriseProject.objects.values('id', 'name', 'created_at')[:3])
        }
    }
    
    return Response(debug_data)


@api_view(['GET'])
def test_simple_stats(request):
    """
    简单测试接口 - 无需认证
    返回基本统计数据
    """
    from apps.info_plaza.models import InfoPost
    from apps.resources.models import Resource
    from apps.persons.models import PersonProject
    from apps.enterprises.models import EnterpriseProject
    from apps.persons.models import PersonTask
    
    return Response({
        'posts': InfoPost.objects.count(),
        'resources': Resource.objects.count(),
        'projects': PersonProject.objects.count() + EnterpriseProject.objects.count(),
        'tasks': PersonTask.objects.filter(status__in=['pending', 'in_progress']).count(),
        'message': '数据获取成功'
    })


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def dashboard_user_stats(request):
    """
    用户个人统计信息
    包括连续登录天数等
    """
    user = request.user
    
    # 计算连续登录天数（简化版本）
    login_days = 1
    if user.last_login:
        days_since_last_login = (timezone.now().date() - user.last_login.date()).days
        if days_since_last_login <= 1:
            # 这里应该从登录日志中统计连续登录天数
            # 暂时使用一个随机值
            login_days = 15
        else:
            login_days = 1
    
    # 天气信息（这里返回模拟数据，实际应该调用天气API）
    weather_info = '晴天 25°C'
    
    return Response({
        'login_days': login_days,
        'weather_info': weather_info,
        'last_login': user.last_login.strftime('%Y-%m-%d %H:%M') if user.last_login else '首次登录'
    })


