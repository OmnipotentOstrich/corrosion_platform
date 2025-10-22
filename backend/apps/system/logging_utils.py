"""
系统日志工具函数
提供便捷的日志记录方法
"""
from .models import SystemLog


def log_info(module, message, user=None, **kwargs):
    """记录信息级别日志"""
    return create_log('INFO', 'system', module, message, user, **kwargs)


def log_warning(module, message, user=None, **kwargs):
    """记录警告级别日志"""
    return create_log('WARNING', 'system', module, message, user, **kwargs)


def log_error(module, message, user=None, **kwargs):
    """记录错误级别日志"""
    return create_log('ERROR', 'system', module, message, user, **kwargs)


def log_debug(module, message, user=None, **kwargs):
    """记录调试级别日志"""
    return create_log('DEBUG', 'system', module, message, user, **kwargs)


def log_user_action(module, message, user, action_type='user', **kwargs):
    """记录用户操作日志"""
    return create_log('INFO', action_type, module, message, user, **kwargs)


def log_security(module, message, user=None, risk_level='INFO', **kwargs):
    """记录安全日志"""
    level_map = {
        'INFO': 'INFO',
        'WARNING': 'WARNING',
        'ERROR': 'ERROR',
        'CRITICAL': 'CRITICAL'
    }
    level = level_map.get(risk_level, 'WARNING')
    return create_log(level, 'security', module, message, user, **kwargs)


def log_business(module, message, user=None, **kwargs):
    """记录业务日志"""
    return create_log('INFO', 'business', module, message, user, **kwargs)


def log_api_call(module, message, user=None, **kwargs):
    """记录API调用日志"""
    return create_log('INFO', 'api', module, message, user, **kwargs)


def log_database_operation(module, message, user=None, **kwargs):
    """记录数据库操作日志"""
    return create_log('INFO', 'database', module, message, user, **kwargs)


def create_log(level, log_type, module, message, user=None, **kwargs):
    """创建日志记录"""
    try:
        log = SystemLog.objects.create(
            level=level,
            log_type=log_type,
            module=module,
            message=message,
            user=user,
            ip_address=kwargs.get('ip_address'),
            user_agent=kwargs.get('user_agent', ''),
            request_path=kwargs.get('request_path', ''),
            request_method=kwargs.get('request_method', ''),
            response_status=kwargs.get('response_status'),
            execution_time=kwargs.get('execution_time'),
            extra_data=kwargs.get('extra_data')
        )
        return log
    except Exception as e:
        print(f"创建日志失败: {e}")
        return None


# 装饰器：自动记录函数执行日志
def log_function_call(module, log_type='system', level='INFO'):
    """装饰器：自动记录函数调用"""
    def decorator(func):
        def wrapper(*args, **kwargs):
            import time
            start_time = time.time()
            
            try:
                result = func(*args, **kwargs)
                execution_time = time.time() - start_time
                
                # 记录成功日志
                create_log(
                    level=level,
                    log_type=log_type,
                    module=module,
                    message=f"函数 {func.__name__} 执行成功",
                    execution_time=execution_time
                )
                
                return result
            except Exception as e:
                execution_time = time.time() - start_time
                
                # 记录错误日志
                create_log(
                    level='ERROR',
                    log_type=log_type,
                    module=module,
                    message=f"函数 {func.__name__} 执行失败: {str(e)}",
                    execution_time=execution_time,
                    extra_data={'error': str(e)}
                )
                
                raise
        
        return wrapper
    return decorator


# 示例使用
if __name__ == '__main__':
    # 基本日志记录
    log_info('test', '这是一条测试信息')
    log_warning('test', '这是一条警告信息')
    log_error('test', '这是一条错误信息')
    
    # 用户操作日志
    # log_user_action('user_module', '用户登录', user=some_user)
    
    # 安全日志
    log_security('auth', '检测到异常登录尝试', risk_level='WARNING')
    
    # 业务日志
    log_business('order', '订单创建成功', extra_data={'order_id': 12345})

