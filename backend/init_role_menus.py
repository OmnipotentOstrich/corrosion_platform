#!/usr/bin/env python
"""
初始化角色和菜单关联
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from apps.users.models import Role, Menu, RoleMenu

# 角色菜单配置
ROLE_MENUS = {
    'personal_user': [
        'dashboard',
        'personal',
        'personal_info',
        'personal_projects',
        'personal_tasks',
        'info_plaza',
        'info_browse',
        'resources',
        'resource_browse',
    ],
    'enterprise_admin': [
        'dashboard',
        'enterprise',
        'enterprise_info',
        'enterprise_projects',
        'enterprise_employees',
        'info_plaza',
        'info_browse',
        'info_publish',
        'resources',
        'resource_browse',
        'resource_add',
    ],
    'enterprise_employee': [
        'dashboard',
        'enterprise',
        'enterprise_info',
        'enterprise_projects',
        'info_plaza',
        'info_browse',
        'resources',
        'resource_browse',
    ],
}

def init_role_menus():
    """初始化角色菜单关联"""
    print("=" * 60)
    print("开始初始化角色菜单关联")
    print("=" * 60)
    
    for role_code, menu_codes in ROLE_MENUS.items():
        try:
            role = Role.objects.get(code=role_code)
            print(f"\n处理角色: {role.name} ({role_code})")
            
            # 清除现有的菜单关联
            deleted_count = RoleMenu.objects.filter(role=role).delete()[0]
            if deleted_count > 0:
                print(f"  - 清除了 {deleted_count} 个旧的菜单关联")
            
            # 添加新的菜单关联
            added_count = 0
            for menu_code in menu_codes:
                try:
                    menu = Menu.objects.get(code=menu_code)
                    RoleMenu.objects.create(role=role, menu=menu)
                    added_count += 1
                    print(f"  ✓ 添加菜单: {menu.name}")
                except Menu.DoesNotExist:
                    print(f"  ✗ 菜单不存在: {menu_code}")
            
            print(f"  → 共添加 {added_count} 个菜单")
            
        except Role.DoesNotExist:
            print(f"\n✗ 角色不存在: {role_code}")
    
    print("\n" + "=" * 60)
    print("角色菜单初始化完成")
    print("=" * 60)
    
    # 显示结果
    print("\n最终结果：")
    for role in Role.objects.all():
        menu_count = RoleMenu.objects.filter(role=role).count()
        status = "✓" if menu_count > 0 else "✗"
        print(f"  {status} {role.name}: {menu_count}个菜单")

if __name__ == "__main__":
    init_role_menus()


