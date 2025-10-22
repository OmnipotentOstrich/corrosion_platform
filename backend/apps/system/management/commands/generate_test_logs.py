"""
生成测试日志数据
用于演示系统日志功能
"""
from django.core.management.base import BaseCommand
from django.utils import timezone
from datetime import timedelta
import random
from apps.system.models import SystemLog
from apps.users.models import User


class Command(BaseCommand):
    help = '生成测试系统日志数据'

    def add_arguments(self, parser):
        parser.add_argument(
            '--count',
            type=int,
            default=50,
            help='生成的日志数量'
        )

    def handle(self, *args, **options):
        count = options['count']
        
        self.stdout.write(self.style.WARNING(f'开始生成 {count} 条测试日志...'))
        
        # 获取一些用户
        users = list(User.objects.all()[:5])
        if not users:
            self.stdout.write(self.style.ERROR('没有找到用户，请先创建用户'))
            return
        
        # 日志模板
        log_templates = [
            {
                'level': 'INFO',
                'log_type': 'user',
                'module': 'auth',
                'message': '用户登录成功',
                'request_path': '/api/v1/auth/login/',
                'request_method': 'POST',
                'response_status': 200,
            },
            {
                'level': 'INFO',
                'log_type': 'user',
                'module': 'auth',
                'message': '用户登出',
                'request_path': '/api/v1/auth/logout/',
                'request_method': 'POST',
                'response_status': 200,
            },
            {
                'level': 'INFO',
                'log_type': 'user',
                'module': 'enterprises',
                'message': '创建企业项目',
                'request_path': '/api/v1/enterprises/projects/',
                'request_method': 'POST',
                'response_status': 201,
            },
            {
                'level': 'INFO',
                'log_type': 'user',
                'module': 'enterprises',
                'message': '更新企业信息',
                'request_path': '/api/v1/enterprises/1/',
                'request_method': 'PUT',
                'response_status': 200,
            },
            {
                'level': 'INFO',
                'log_type': 'user',
                'module': 'persons',
                'message': '创建个人任务',
                'request_path': '/api/v1/persons/tasks/',
                'request_method': 'POST',
                'response_status': 201,
            },
            {
                'level': 'INFO',
                'log_type': 'api',
                'module': 'info_plaza',
                'message': '发布信息',
                'request_path': '/api/v1/info-plaza/posts/',
                'request_method': 'POST',
                'response_status': 201,
            },
            {
                'level': 'INFO',
                'log_type': 'api',
                'module': 'resources',
                'message': '上传资源',
                'request_path': '/api/v1/resources/',
                'request_method': 'POST',
                'response_status': 201,
            },
            {
                'level': 'WARNING',
                'log_type': 'security',
                'module': 'auth',
                'message': '登录尝试失败 - 密码错误',
                'request_path': '/api/v1/auth/login/',
                'request_method': 'POST',
                'response_status': 401,
            },
            {
                'level': 'WARNING',
                'log_type': 'api',
                'module': 'system',
                'message': '权限不足',
                'request_path': '/api/v1/system/configs/',
                'request_method': 'POST',
                'response_status': 403,
            },
            {
                'level': 'ERROR',
                'log_type': 'api',
                'module': 'resources',
                'message': '资源不存在',
                'request_path': '/api/v1/resources/999/',
                'request_method': 'GET',
                'response_status': 404,
            },
            {
                'level': 'ERROR',
                'log_type': 'system',
                'module': 'database',
                'message': '数据库连接超时',
                'request_path': '/api/v1/dashboard/statistics/',
                'request_method': 'GET',
                'response_status': 500,
            },
            {
                'level': 'WARNING',
                'log_type': 'system',
                'module': 'performance',
                'message': '慢请求: GET /api/v1/info-plaza/posts/ - 2.34秒',
                'request_path': '/api/v1/info-plaza/posts/',
                'request_method': 'GET',
                'response_status': 200,
            },
        ]
        
        # 生成日志
        created_count = 0
        for i in range(count):
            template = random.choice(log_templates)
            user = random.choice(users) if random.random() > 0.3 else None
            
            # 随机生成过去7天内的时间
            days_ago = random.randint(0, 7)
            hours_ago = random.randint(0, 23)
            minutes_ago = random.randint(0, 59)
            created_at = timezone.now() - timedelta(
                days=days_ago,
                hours=hours_ago,
                minutes=minutes_ago
            )
            
            try:
                log = SystemLog.objects.create(
                    level=template['level'],
                    log_type=template['log_type'],
                    module=template['module'],
                    message=template['message'],
                    user=user,
                    ip_address=f"192.168.1.{random.randint(1, 255)}",
                    user_agent=random.choice([
                        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
                        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
                    ]),
                    request_path=template['request_path'],
                    request_method=template['request_method'],
                    response_status=template['response_status'],
                    execution_time=random.uniform(0.01, 3.0),
                )
                # 手动设置创建时间
                log.created_at = created_at
                log.save(update_fields=['created_at'])
                
                created_count += 1
                
            except Exception as e:
                self.stdout.write(self.style.ERROR(f'创建日志失败: {e}'))
        
        self.stdout.write(self.style.SUCCESS(f'✓ 成功生成 {created_count} 条测试日志'))
        
        # 显示统计
        total = SystemLog.objects.count()
        info_count = SystemLog.objects.filter(level='INFO').count()
        warning_count = SystemLog.objects.filter(level='WARNING').count()
        error_count = SystemLog.objects.filter(level='ERROR').count()
        
        self.stdout.write(self.style.SUCCESS(f'\n日志统计:'))
        self.stdout.write(f'  总计: {total}')
        self.stdout.write(f'  信息: {info_count}')
        self.stdout.write(f'  警告: {warning_count}')
        self.stdout.write(f'  错误: {error_count}')

