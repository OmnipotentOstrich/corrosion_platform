"""
系统日志中间件
自动记录所有API请求和响应
"""
import time
import json
from django.utils import timezone
from .models import SystemLog


def get_client_ip(request):
    """获取客户端IP地址"""
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip


class SystemLogMiddleware:
    """系统日志中间件 - 记录所有API请求"""
    
    def __init__(self, get_response):
        self.get_response = get_response
        # 不需要记录日志的路径
        self.exclude_paths = [
            '/static/',
            '/media/',
            '/admin/jsi18n/',
            '/favicon.ico',
        ]
        # 只记录这些方法的请求
        self.log_methods = ['POST', 'PUT', 'PATCH', 'DELETE']
    
    def __call__(self, request):
        # 记录请求开始时间
        start_time = time.time()
        
        # 执行请求
        response = self.get_response(request)
        
        # 计算执行时间
        execution_time = time.time() - start_time
        
        # 判断是否需要记录日志
        if self.should_log(request, response):
            self.log_request(request, response, execution_time)
        
        return response
    
    def should_log(self, request, response):
        """判断是否应该记录日志"""
        path = request.path
        
        # 排除静态文件等路径
        for exclude_path in self.exclude_paths:
            if path.startswith(exclude_path):
                return False
        
        # 只记录API请求
        if not path.startswith('/api/'):
            return False
        
        # 记录所有POST/PUT/PATCH/DELETE请求
        if request.method in self.log_methods:
            return True
        
        # 记录所有失败的请求（4xx, 5xx）
        if response.status_code >= 400:
            return True
        
        return False
    
    def log_request(self, request, response, execution_time):
        """记录请求日志"""
        try:
            # 确定日志级别
            status_code = response.status_code
            if status_code >= 500:
                level = 'ERROR'
            elif status_code >= 400:
                level = 'WARNING'
            else:
                level = 'INFO'
            
            # 确定日志类型
            log_type = 'api'
            if 'login' in request.path or 'logout' in request.path:
                log_type = 'security'
            elif request.user.is_authenticated:
                log_type = 'user'
            
            # 确定模块
            module = self.get_module_from_path(request.path)
            
            # 构建日志消息
            message = f"{request.method} {request.path} - {status_code}"
            
            # 获取用户
            user = request.user if request.user.is_authenticated else None
            
            # 获取额外数据
            extra_data = {}
            if request.method in ['POST', 'PUT', 'PATCH']:
                try:
                    # 尝试获取请求体（避免记录敏感信息）
                    if hasattr(request, 'data'):
                        extra_data['request_data'] = self.sanitize_data(dict(request.data))
                except:
                    pass
            
            # 创建日志记录
            SystemLog.objects.create(
                level=level,
                log_type=log_type,
                module=module,
                message=message,
                user=user,
                ip_address=get_client_ip(request),
                user_agent=request.META.get('HTTP_USER_AGENT', '')[:500],
                request_path=request.path,
                request_method=request.method,
                response_status=status_code,
                execution_time=execution_time,
                extra_data=extra_data if extra_data else None
            )
        except Exception as e:
            # 日志记录失败不应该影响正常请求
            print(f"日志记录失败: {e}")
    
    def get_module_from_path(self, path):
        """从请求路径中提取模块名"""
        parts = path.split('/')
        if len(parts) >= 4:  # /api/v1/module/
            return parts[3]
        return 'unknown'
    
    def sanitize_data(self, data):
        """清理敏感数据（密码等）"""
        sensitive_fields = ['password', 'token', 'secret', 'key']
        sanitized = {}
        
        for key, value in data.items():
            if any(field in key.lower() for field in sensitive_fields):
                sanitized[key] = '***HIDDEN***'
            else:
                sanitized[key] = value
        
        return sanitized


class PerformanceLogMiddleware:
    """性能日志中间件 - 记录慢请求"""
    
    def __init__(self, get_response):
        self.get_response = get_response
        self.slow_request_threshold = 2.0  # 超过2秒视为慢请求
    
    def __call__(self, request):
        start_time = time.time()
        response = self.get_response(request)
        execution_time = time.time() - start_time
        
        # 记录慢请求
        if execution_time > self.slow_request_threshold and request.path.startswith('/api/'):
            try:
                SystemLog.objects.create(
                    level='WARNING',
                    log_type='system',
                    module='performance',
                    message=f"慢请求: {request.method} {request.path} - {execution_time:.2f}秒",
                    user=request.user if request.user.is_authenticated else None,
                    ip_address=get_client_ip(request),
                    request_path=request.path,
                    request_method=request.method,
                    response_status=response.status_code,
                    execution_time=execution_time
                )
            except Exception as e:
                print(f"性能日志记录失败: {e}")
        
        return response

