def get_client_ip(request):
    """获取客户端IP地址"""
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip


def has_permission(user, permission_code):
    """检查用户是否有指定权限"""
    from .models import UserRole, RolePermission
    
    user_roles = UserRole.objects.filter(user=user)
    for user_role in user_roles:
        role_permissions = RolePermission.objects.filter(role=user_role.role)
        for role_permission in role_permissions:
            if role_permission.permission.code == permission_code:
                return True
    return False


def get_user_permissions(user):
    """获取用户所有权限"""
    from .models import UserRole, RolePermission
    
    permissions = []
    user_roles = UserRole.objects.filter(user=user)
    for user_role in user_roles:
        role_permissions = RolePermission.objects.filter(role=user_role.role)
        for role_permission in role_permissions:
            permissions.append({
                'id': role_permission.permission.id,
                'name': role_permission.permission.name,
                'code': role_permission.permission.code,
                'module': role_permission.permission.module
            })
    return permissions


def get_user_menus(user):
    """获取用户菜单"""
    from .models import UserRole, RoleMenu, Menu
    
    menus = []
    user_roles = UserRole.objects.filter(user=user)
    for user_role in user_roles:
        role_menus = RoleMenu.objects.filter(role=user_role.role)
        for role_menu in role_menus:
            if role_menu.menu.is_active:
                menus.append(role_menu.menu)
    
    # 去重并排序
    unique_menus = list(set(menus))
    unique_menus.sort(key=lambda x: (x.sort_order, x.id))
    return unique_menus
