#!/usr/bin/env python
"""
初始化数据库：创建角色、权限、菜单、角色菜单关联
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from apps.users.models import Role, Permission, Menu, RoleMenu
from apps.info_plaza.models import InfoCategory
from apps.resources.models import ResourceType
from apps.system.models import SystemConfig

def init_roles():
    """初始化角色"""
    print("\n" + "="*60)
    print("初始化角色")
    print("="*60)
    
    roles_data = [
        {
            'name': '系统管理员',
            'code': 'admin',
            'description': '系统管理员，拥有所有权限',
            'is_active': True
        },
        {
            'name': '企业管理员',
            'code': 'enterprise_admin',
            'description': '企业管理员，管理企业相关功能',
            'is_active': True
        },
        {
            'name': '企业员工',
            'code': 'enterprise_employee',
            'description': '企业员工，使用企业功能',
            'is_active': True
        },
        {
            'name': '个人用户',
            'code': 'personal_user',
            'description': '个人用户，使用个人功能',
            'is_active': True
        },
    ]
    
    created_count = 0
    for role_data in roles_data:
        role, created = Role.objects.get_or_create(
            code=role_data['code'],
            defaults=role_data
        )
        if created:
            print(f"✓ 创建角色: {role.name}")
            created_count += 1
        else:
            print(f"  角色已存在: {role.name}")
    
    print(f"\n完成！创建 {created_count} 个角色")
    return Role.objects.all().count()

def init_menus():
    """初始化菜单"""
    print("\n" + "="*60)
    print("初始化菜单")
    print("="*60)
    
    # 一级菜单
    menus_data = [
        {
            'name': '仪表板',
            'code': 'dashboard',
            'url': '/dashboard',
            'icon': 'Odometer',
            'parent': None,
            'sort_order': 1,
            'is_active': True
        },
        {
            'name': '企业中心',
            'code': 'enterprise',
            'url': '/dashboard/enterprise',
            'icon': 'OfficeBuilding',
            'parent': None,
            'sort_order': 2,
            'is_active': True
        },
        {
            'name': '个人中心',
            'code': 'personal',
            'url': '/dashboard/personal',
            'icon': 'User',
            'parent': None,
            'sort_order': 3,
            'is_active': True
        },
        {
            'name': '信息广场',
            'code': 'info_plaza',
            'url': '/dashboard/info-plaza',
            'icon': 'ChatDotSquare',
            'parent': None,
            'sort_order': 4,
            'is_active': True
        },
        {
            'name': '资源管理',
            'code': 'resources',
            'url': '/dashboard/resources',
            'icon': 'Box',
            'parent': None,
            'sort_order': 5,
            'is_active': True
        },
        {
            'name': '系统管理',
            'code': 'system',
            'url': '/dashboard/system',
            'icon': 'Setting',
            'parent': None,
            'sort_order': 6,
            'is_active': True
        },
    ]
    
    created_count = 0
    menu_map = {}  # 用于存储菜单对象，方便后续创建子菜单
    
    # 创建一级菜单
    for menu_data in menus_data:
        menu, created = Menu.objects.get_or_create(
            code=menu_data['code'],
            defaults=menu_data
        )
        menu_map[menu_data['code']] = menu
        if created:
            print(f"✓ 创建一级菜单: {menu.name}")
            created_count += 1
        else:
            print(f"  菜单已存在: {menu.name}")
    
    # 二级菜单
    sub_menus_data = [
        # 企业中心子菜单
        {
            'name': '企业信息',
            'code': 'enterprise_info',
            'url': '/dashboard/enterprise',
            'icon': 'OfficeBuilding',
            'parent_code': 'enterprise',
            'sort_order': 1,
            'is_active': True
        },
        {
            'name': '项目管理',
            'code': 'enterprise_projects',
            'url': '/dashboard/enterprise/projects',
            'icon': 'Folder',
            'parent_code': 'enterprise',
            'sort_order': 2,
            'is_active': True
        },
        {
            'name': '员工管理',
            'code': 'enterprise_employees',
            'url': '/dashboard/enterprise/employees',
            'icon': 'UserFilled',
            'parent_code': 'enterprise',
            'sort_order': 3,
            'is_active': True
        },
        # 个人中心子菜单
        {
            'name': '个人信息',
            'code': 'personal_info',
            'url': '/dashboard/personal',
            'icon': 'User',
            'parent_code': 'personal',
            'sort_order': 1,
            'is_active': True
        },
        {
            'name': '我的项目',
            'code': 'personal_projects',
            'url': '/dashboard/personal/projects',
            'icon': 'Folder',
            'parent_code': 'personal',
            'sort_order': 2,
            'is_active': True
        },
        {
            'name': '我的任务',
            'code': 'personal_tasks',
            'url': '/dashboard/personal/tasks',
            'icon': 'List',
            'parent_code': 'personal',
            'sort_order': 3,
            'is_active': True
        },
        # 信息广场子菜单
        {
            'name': '信息浏览',
            'code': 'info_browse',
            'url': '/dashboard/info-plaza',
            'icon': 'ChatDotSquare',
            'parent_code': 'info_plaza',
            'sort_order': 1,
            'is_active': True
        },
        {
            'name': '发布信息',
            'code': 'info_publish',
            'url': '/dashboard/info-plaza/publish',
            'icon': 'Edit',
            'parent_code': 'info_plaza',
            'sort_order': 2,
            'is_active': True
        },
        # 资源管理子菜单
        {
            'name': '资源浏览',
            'code': 'resource_browse',
            'url': '/dashboard/resources',
            'icon': 'Box',
            'parent_code': 'resources',
            'sort_order': 1,
            'is_active': True
        },
        {
            'name': '添加资源',
            'code': 'resource_add',
            'url': '/dashboard/resources/add',
            'icon': 'Plus',
            'parent_code': 'resources',
            'sort_order': 2,
            'is_active': True
        },
        # 系统管理子菜单
        {
            'name': '用户管理',
            'code': 'system_users',
            'url': '/dashboard/system/users',
            'icon': 'User',
            'parent_code': 'system',
            'sort_order': 1,
            'is_active': True
        },
        {
            'name': '角色管理',
            'code': 'system_roles',
            'url': '/dashboard/system/roles',
            'icon': 'UserFilled',
            'parent_code': 'system',
            'sort_order': 2,
            'is_active': True
        },
        {
            'name': '系统日志',
            'code': 'system_logs',
            'url': '/dashboard/system/logs',
            'icon': 'Document',
            'parent_code': 'system',
            'sort_order': 3,
            'is_active': True
        },
    ]
    
    # 创建二级菜单
    for menu_data in sub_menus_data:
        parent_code = menu_data.pop('parent_code')
        parent_menu = menu_map.get(parent_code)
        
        if parent_menu:
            menu_data['parent'] = parent_menu
            menu, created = Menu.objects.get_or_create(
                code=menu_data['code'],
                defaults=menu_data
            )
            if created:
                print(f"  ✓ 创建子菜单: {parent_menu.name} -> {menu.name}")
                created_count += 1
            else:
                print(f"    子菜单已存在: {menu.name}")
        else:
            print(f"  ✗ 父菜单不存在: {parent_code}")
    
    print(f"\n完成！创建 {created_count} 个菜单")
    return Menu.objects.all().count()

def init_role_menus():
    """初始化角色菜单关联"""
    print("\n" + "="*60)
    print("初始化角色菜单关联")
    print("="*60)
    
    # 角色菜单配置
    role_menus_config = {
        'admin': [
            'dashboard', 'enterprise', 'enterprise_info', 'enterprise_projects', 
            'enterprise_employees', 'personal', 'personal_info', 'personal_projects', 
            'personal_tasks', 'info_plaza', 'info_browse', 'info_publish', 
            'resources', 'resource_browse', 'resource_add', 'system', 
            'system_users', 'system_roles', 'system_logs'
        ],
        'enterprise_admin': [
            'dashboard', 'enterprise', 'enterprise_info', 'enterprise_projects', 
            'enterprise_employees', 'info_plaza', 'info_browse', 'info_publish', 
            'resources', 'resource_browse', 'resource_add'
        ],
        'enterprise_employee': [
            'dashboard', 'enterprise', 'enterprise_info', 'enterprise_projects', 
            'info_plaza', 'info_browse', 'resources', 'resource_browse'
        ],
        'personal_user': [
            'dashboard', 'personal', 'personal_info', 'personal_projects', 
            'personal_tasks', 'info_plaza', 'info_browse', 'resources', 
            'resource_browse'
        ],
    }
    
    created_count = 0
    
    for role_code, menu_codes in role_menus_config.items():
        try:
            role = Role.objects.get(code=role_code)
            print(f"\n处理角色: {role.name}")
            
            # 清除现有关联
            RoleMenu.objects.filter(role=role).delete()
            
            for menu_code in menu_codes:
                try:
                    menu = Menu.objects.get(code=menu_code)
                    RoleMenu.objects.create(role=role, menu=menu)
                    created_count += 1
                except Menu.DoesNotExist:
                    print(f"  ✗ 菜单不存在: {menu_code}")
            
            print(f"  ✓ 分配 {len(menu_codes)} 个菜单")
            
        except Role.DoesNotExist:
            print(f"✗ 角色不存在: {role_code}")
    
    print(f"\n完成！创建 {created_count} 个角色菜单关联")
    return created_count

def main():
    """主函数"""
    print("\n" + "="*60)
    print("开始初始化数据库")
    print("="*60)
    
    # 初始化角色
    roles_count = init_roles()
    
    # 初始化菜单
    menus_count = init_menus()
    
    # 初始化角色菜单关联
    role_menus_count = init_role_menus()
    
    print("\n" + "="*60)
    print("数据库初始化完成")
    print("="*60)
    print(f"角色总数: {roles_count}")
    print(f"菜单总数: {menus_count}")
    print(f"角色菜单关联数: {role_menus_count}")
    print("="*60)

if __name__ == "__main__":
    main()


