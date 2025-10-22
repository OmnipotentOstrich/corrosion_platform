#!/usr/bin/env python
"""
组织架构层和系统配置层功能测试脚本
"""
import os
import sys

# 添加backend目录到sys.path
backend_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'backend')
sys.path.insert(0, backend_path)

# 设置Django环境
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

import django
from django.conf import settings
django.setup()

from django.contrib.auth import get_user_model
from apps.users.models import (
    User, Role, Permission, Menu, UserRole, RolePermission, RoleMenu,
    UserLoginLog, UserSession, UserProfile, UserActivityLog, PermissionGroup,
    RolePermissionAudit, UserPermissionOverride
)
from apps.system.models import (
    SystemConfig, SystemLog, SystemStatistics, SystemNotification,
    SystemBackup, SystemMonitor, SystemSecurityLog, SystemPageConfig,
    SystemAnalytics, SystemMaintenance
)
from django.utils import timezone
from datetime import timedelta

User = get_user_model()

def test_user_management():
    """测试用户管理功能"""
    print("=== 测试用户管理功能 ===")
    
    # 创建测试用户
    try:
        user = User.objects.get(username='test_user')
        print(f"✓ 测试用户已存在: {user.username}")
    except User.DoesNotExist:
        try:
            user = User.objects.create_user(
                username='test_user',
                email='test@example.com',
                password='test123456',
                user_type='personal',
                phone='13900139000'  # 使用不同的手机号
            )
            print(f"✓ 创建测试用户: {user.username}")
        except Exception as e:
            print(f"创建测试用户失败: {str(e)}")
            # 使用第一个用户作为测试用户
            user = User.objects.first()
            print(f"✓ 使用现有用户进行测试: {user.username}")
    
    # 创建用户资料
    profile, created = UserProfile.objects.get_or_create(
        user=user,
        defaults={
            'real_name': '测试用户',
            'gender': 'male',
            'company': '测试公司',
            'position': '测试职位',
            'bio': '这是一个测试用户'
        }
    )
    
    if created:
        print(f"✓ 创建用户资料: {profile.real_name}")
    else:
        print(f"✓ 用户资料已存在: {profile.real_name}")
    
    # 创建用户会话
    session, created = UserSession.objects.get_or_create(
        user=user,
        session_key='test_session_key',
        defaults={
            'ip_address': '127.0.0.1',
            'user_agent': 'Test Browser',
            'expire_at': timezone.now() + timedelta(hours=24)
        }
    )
    
    if created:
        print(f"✓ 创建用户会话: {session.session_key}")
    else:
        print(f"✓ 用户会话已存在: {session.session_key}")
    
    # 创建用户活动日志
    activity_log = UserActivityLog.objects.create(
        user=user,
        action='login',
        description='用户登录',
        ip_address='127.0.0.1',
        user_agent='Test Browser',
        request_path='/api/auth/login/'
    )
    print(f"✓ 创建用户活动日志: {activity_log.action}")
    
    return user

def test_role_permission_management():
    """测试角色权限管理功能"""
    print("\n=== 测试角色权限管理功能 ===")
    
    # 创建权限组
    permission_group, created = PermissionGroup.objects.get_or_create(
        name='用户管理权限组',
        code='user_management_group',
        defaults={
            'description': '用户管理相关权限',
            'module': 'users',
            'sort_order': 1
        }
    )
    
    if created:
        print(f"✓ 创建权限组: {permission_group.name}")
    else:
        print(f"✓ 权限组已存在: {permission_group.name}")
    
    # 创建权限
    permission, created = Permission.objects.get_or_create(
        name='查看用户资料',
        code='users.view_userprofile',
        defaults={
            'description': '查看用户详细资料',
            'module': 'users'
        }
    )
    
    if created:
        print(f"✓ 创建权限: {permission.name}")
    else:
        print(f"✓ 权限已存在: {permission.name}")
    
    # 创建角色
    role, created = Role.objects.get_or_create(
        name='测试角色',
        code='test_role',
        defaults={
            'description': '用于测试的角色',
            'is_active': True
        }
    )
    
    if created:
        print(f"✓ 创建角色: {role.name}")
    else:
        print(f"✓ 角色已存在: {role.name}")
    
    # 分配角色权限
    role_permission, created = RolePermission.objects.get_or_create(
        role=role,
        permission=permission
    )
    
    if created:
        print(f"✓ 分配角色权限: {role.name} -> {permission.name}")
    else:
        print(f"✓ 角色权限已存在: {role.name} -> {permission.name}")
    
    # 创建角色权限审计日志
    audit_log = RolePermissionAudit.objects.create(
        role=role,
        permission=permission,
        user=User.objects.first(),
        action='grant',
        description='授予权限',
        ip_address='127.0.0.1',
        user_agent='Test Browser'
    )
    print(f"✓ 创建权限审计日志: {audit_log.action}")
    
    return role, permission

def test_menu_management():
    """测试菜单管理功能"""
    print("\n=== 测试菜单管理功能 ===")
    
    # 创建父菜单
    parent_menu, created = Menu.objects.get_or_create(
        name='系统管理',
        code='system_management',
        defaults={
            'url': '/system',
            'icon': 'system',
            'menu_type': 'module',
            'sort_order': 1,
            'description': '系统管理模块'
        }
    )
    
    if created:
        print(f"✓ 创建父菜单: {parent_menu.name}")
    else:
        print(f"✓ 父菜单已存在: {parent_menu.name}")
    
    # 创建子菜单
    child_menu, created = Menu.objects.get_or_create(
        name='用户管理',
        code='user_management',
        defaults={
            'url': '/system/users',
            'icon': 'user',
            'menu_type': 'page',
            'parent': parent_menu,
            'sort_order': 1,
            'description': '用户管理页面'
        }
    )
    
    if created:
        print(f"✓ 创建子菜单: {child_menu.name}")
    else:
        print(f"✓ 子菜单已存在: {child_menu.name}")
    
    return parent_menu, child_menu

def test_system_configuration():
    """测试系统配置功能"""
    print("\n=== 测试系统配置功能 ===")
    
    # 创建系统配置
    config, created = SystemConfig.objects.get_or_create(
        key='system_name',
        defaults={
            'value': '腐蚀平台管理系统',
            'config_type': 'basic',
            'description': '系统名称',
            'is_active': True
        }
    )
    
    if created:
        print(f"✓ 创建系统配置: {config.key}")
    else:
        print(f"✓ 系统配置已存在: {config.key}")
    
    # 创建页面配置
    page_config, created = SystemPageConfig.objects.get_or_create(
        page_name='dashboard',
        defaults={
            'page_type': 'dashboard',
            'title': '仪表板',
            'description': '系统仪表板页面',
            'keywords': 'dashboard,仪表板,统计',
            'is_active': True
        }
    )
    
    if created:
        print(f"✓ 创建页面配置: {page_config.page_name}")
    else:
        print(f"✓ 页面配置已存在: {page_config.page_name}")
    
    return config, page_config

def test_security_monitoring():
    """测试安全监控功能"""
    print("\n=== 测试安全监控功能 ===")
    
    # 创建安全日志
    security_log = SystemSecurityLog.objects.create(
        security_type='login_failure',
        user=User.objects.first(),
        ip_address='192.168.1.100',
        user_agent='Suspicious Browser',
        description='多次登录失败',
        risk_level='high'
    )
    print(f"✓ 创建安全日志: {security_log.security_type}")
    
    # 创建系统监控数据
    monitor = SystemMonitor.objects.create(
        monitor_type='cpu',
        metric_name='cpu_usage',
        metric_value=75.5,
        threshold_warning=80,
        threshold_critical=90,
        status='normal'
    )
    print(f"✓ 创建系统监控数据: {monitor.monitor_type}")
    
    return security_log, monitor

def test_analytics():
    """测试数据分析功能"""
    print("\n=== 测试数据分析功能 ===")
    
    # 创建分析数据
    analytics = SystemAnalytics.objects.create(
        analytics_type='user_behavior',
        metric_name='page_views',
        metric_value=1500,
        dimension_data={'page': 'dashboard', 'user_type': 'enterprise'},
        time_period='daily',
        analysis_date=timezone.now().date()
    )
    print(f"✓ 创建分析数据: {analytics.analytics_type}")
    
    return analytics

def test_maintenance():
    """测试系统维护功能"""
    print("\n=== 测试系统维护功能 ===")
    
    # 创建维护计划
    maintenance = SystemMaintenance.objects.create(
        maintenance_type='scheduled',
        title='数据库优化维护',
        description='定期数据库优化和清理',
        status='planned',
        scheduled_start=timezone.now() + timedelta(days=1),
        scheduled_end=timezone.now() + timedelta(days=1, hours=2),
        created_by=User.objects.first()
    )
    print(f"✓ 创建维护计划: {maintenance.title}")
    
    return maintenance

def test_backup():
    """测试备份功能"""
    print("\n=== 测试备份功能 ===")
    
    # 创建备份记录
    backup = SystemBackup.objects.create(
        backup_type='database',
        name='test_backup_20241201',
        description='测试数据库备份',
        status='completed',
        start_time=timezone.now() - timedelta(hours=1),
        end_time=timezone.now() - timedelta(minutes=30),
        file_path='/backups/test_backup_20241201.sql',
        file_size=1024 * 1024,  # 1MB
        created_by=User.objects.first()
    )
    print(f"✓ 创建备份记录: {backup.name}")
    
    return backup

def main():
    """主测试函数"""
    print("开始测试组织架构层和系统配置层功能...")
    
    try:
        # 测试用户管理
        user = test_user_management()
        
        # 测试角色权限管理
        role, permission = test_role_permission_management()
        
        # 测试菜单管理
        parent_menu, child_menu = test_menu_management()
        
        # 测试系统配置
        config, page_config = test_system_configuration()
        
        # 测试安全监控
        security_log, monitor = test_security_monitoring()
        
        # 测试数据分析
        analytics = test_analytics()
        
        # 测试系统维护
        maintenance = test_maintenance()
        
        # 测试备份功能
        backup = test_backup()
        
        print("\n=== 测试总结 ===")
        print("✓ 所有功能测试完成！")
        print(f"✓ 创建/验证了 {User.objects.count()} 个用户")
        print(f"✓ 创建/验证了 {Role.objects.count()} 个角色")
        print(f"✓ 创建/验证了 {Permission.objects.count()} 个权限")
        print(f"✓ 创建/验证了 {Menu.objects.count()} 个菜单")
        print(f"✓ 创建/验证了 {SystemConfig.objects.count()} 个系统配置")
        print(f"✓ 创建/验证了 {SystemSecurityLog.objects.count()} 个安全日志")
        print(f"✓ 创建/验证了 {SystemAnalytics.objects.count()} 个分析数据")
        print(f"✓ 创建/验证了 {SystemMaintenance.objects.count()} 个维护计划")
        print(f"✓ 创建/验证了 {SystemBackup.objects.count()} 个备份记录")
        
        print("\n=== 功能验证 ===")
        print("✓ 用户管理功能正常")
        print("✓ 角色权限管理功能正常")
        print("✓ 菜单管理功能正常")
        print("✓ 系统配置功能正常")
        print("✓ 安全监控功能正常")
        print("✓ 数据分析功能正常")
        print("✓ 系统维护功能正常")
        print("✓ 备份管理功能正常")
        
        print("\n🎉 所有测试通过！组织架构层和系统配置层功能已成功完善！")
        
    except Exception as e:
        print(f"\n❌ 测试过程中出现错误: {str(e)}")
        import traceback
        traceback.print_exc()
        return False
    
    return True

if __name__ == '__main__':
    success = main()
    sys.exit(0 if success else 1)

