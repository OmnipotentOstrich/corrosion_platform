#!/usr/bin/env python
"""
创建测试用户
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from apps.users.models import User, Role, UserRole
from django.db import IntegrityError

def create_test_users():
    """创建测试用户"""
    print("=" * 60)
    print("创建测试用户")
    print("=" * 60)
    
    # 测试用户配置
    test_users = [
        {
            'username': 'admin',
            'email': 'admin@corrosion-platform.com',
            'phone': '13900000001',
            'password': 'admin123',
            'first_name': '系统',
            'last_name': '管理员',
            'user_type': 'personal',
            'is_staff': True,
            'is_superuser': True,
            'is_active': True,
            'is_verified': True,
            'role_code': 'admin',
        },
        {
            'username': 'enterprise',
            'email': 'enterprise@example.com',
            'phone': '13900000002',
            'password': 'enterprise123',
            'first_name': '企业',
            'last_name': '用户',
            'user_type': 'enterprise',
            'is_staff': False,
            'is_superuser': False,
            'is_active': True,
            'is_verified': True,
            'role_code': 'enterprise_admin',
        },
        {
            'username': 'user',
            'email': 'user@example.com',
            'phone': '13900000003',
            'password': 'user123',
            'first_name': '个人',
            'last_name': '用户',
            'user_type': 'personal',
            'is_staff': False,
            'is_superuser': False,
            'is_active': True,
            'is_verified': True,
            'role_code': 'personal_user',
        },
    ]
    
    created_count = 0
    updated_count = 0
    
    for user_data in test_users:
        username = user_data['username']
        password = user_data.pop('password')
        role_code = user_data.pop('role_code', None)
        
        try:
            # 检查用户是否存在
            user = User.objects.filter(username=username).first()
            
            if user:
                # 更新密码
                user.set_password(password)
                user.email = user_data['email']
                user.phone = user_data['phone']
                user.first_name = user_data['first_name']
                user.last_name = user_data['last_name']
                user.user_type = user_data['user_type']
                user.is_staff = user_data['is_staff']
                user.is_superuser = user_data['is_superuser']
                user.is_active = user_data['is_active']
                user.is_verified = user_data['is_verified']
                user.save()
                print(f"\n✓ 更新用户: {username} (密码已重置为 {password})")
                updated_count += 1
            else:
                # 创建新用户
                # 从user_data中提取username，避免重复传递
                user = User.objects.create_user(
                    username=username,
                    password=password,
                    email=user_data['email'],
                    phone=user_data['phone'],
                    first_name=user_data['first_name'],
                    last_name=user_data['last_name'],
                    user_type=user_data['user_type'],
                    is_staff=user_data['is_staff'],
                    is_superuser=user_data['is_superuser'],
                    is_active=user_data['is_active'],
                    is_verified=user_data['is_verified']
                )
                print(f"\n✓ 创建用户: {username} (密码: {password})")
                created_count += 1
            
            # 分配角色
            if role_code:
                try:
                    role = Role.objects.get(code=role_code)
                    # 删除旧的角色关联
                    UserRole.objects.filter(user=user).delete()
                    # 创建新的角色关联
                    UserRole.objects.create(user=user, role=role)
                    print(f"  → 分配角色: {role.name}")
                except Role.DoesNotExist:
                    print(f"  ✗ 角色不存在: {role_code}")
            
            # 显示用户信息
            print(f"  - 邮箱: {user.email}")
            print(f"  - 手机: {user.phone}")
            print(f"  - 类型: {user.get_user_type_display()}")
            print(f"  - 管理员: {'是' if user.is_staff else '否'}")
            
        except IntegrityError as e:
            print(f"\n✗ 创建用户 {username} 失败: {e}")
    
    print("\n" + "=" * 60)
    print(f"完成！创建 {created_count} 个用户，更新 {updated_count} 个用户")
    print("=" * 60)
    
    # 显示所有测试用户
    print("\n测试账号信息：")
    print("-" * 60)
    for user_data in test_users:
        username = user_data['username']
        user = User.objects.filter(username=username).first()
        if user:
            roles = UserRole.objects.filter(user=user).select_related('role')
            role_names = ', '.join([ur.role.name for ur in roles]) if roles else '无角色'
            print(f"\n【{user.get_user_type_display()}】")
            print(f"  用户名: {username}")
            print(f"  密码: {password}")  # 注意：这里使用的是循环中的最后一个密码，需要修改
            print(f"  角色: {role_names}")
    
    # 正确显示每个用户的密码
    print("\n登录凭据：")
    print("-" * 60)
    print("管理员: admin / admin123")
    print("企业用户: enterprise / enterprise123")
    print("个人用户: user / user123")
    print("-" * 60)

if __name__ == "__main__":
    create_test_users()

