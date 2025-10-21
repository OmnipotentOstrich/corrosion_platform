#!/usr/bin/env python
"""
为已存在的用户分配角色
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from apps.users.models import User, Role, UserRole

def assign_roles():
    """为没有角色的用户分配默认角色"""
    print("=" * 60)
    print("为现有用户分配角色")
    print("=" * 60)
    
    # 获取所有用户
    users = User.objects.all()
    print(f"\n共有 {users.count()} 个用户")
    
    assigned_count = 0
    skipped_count = 0
    
    for user in users:
        # 检查用户是否已有角色
        has_role = UserRole.objects.filter(user=user).exists()
        
        if has_role:
            roles = UserRole.objects.filter(user=user).select_related('role')
            role_names = ', '.join([ur.role.name for ur in roles])
            print(f"\n✓ {user.username} 已有角色: {role_names}")
            skipped_count += 1
        else:
            # 根据用户类型分配角色
            try:
                if user.user_type == 'enterprise':
                    role = Role.objects.get(code='enterprise_admin')
                elif user.user_type == 'personal':
                    role = Role.objects.get(code='personal_user')
                else:
                    # 对于其他类型或管理员，跳过
                    if user.is_staff or user.is_superuser:
                        role = Role.objects.get(code='admin')
                    else:
                        role = Role.objects.get(code='personal_user')
                
                UserRole.objects.create(user=user, role=role)
                print(f"\n→ 为 {user.username} ({user.get_user_type_display()}) 分配角色: {role.name}")
                assigned_count += 1
            except Role.DoesNotExist as e:
                print(f"\n✗ 无法为 {user.username} 分配角色: 角色不存在")
    
    print("\n" + "=" * 60)
    print(f"完成！共分配 {assigned_count} 个角色，跳过 {skipped_count} 个已有角色的用户")
    print("=" * 60)

if __name__ == "__main__":
    assign_roles()


