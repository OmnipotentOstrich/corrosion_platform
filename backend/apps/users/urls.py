from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from . import views

urlpatterns = [
    # 认证相关
    path('login/', views.CustomTokenObtainPairView.as_view(), name='login'),
    path('register/', views.register_view, name='register'),
    path('logout/', views.logout_view, name='logout'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # 用户相关
    path('profile/', views.user_profile, name='user_profile'),
    path('profile/update/', views.update_profile, name='update_profile'),
    path('change-password/', views.change_password, name='change_password'),
    path('users/', views.UserListCreateView.as_view(), name='user_list_create'),
    path('users/<int:pk>/', views.UserDetailView.as_view(), name='user_detail'),
    path('users/<int:user_id>/status/', views.update_user_status, name='update_user_status'),
    path('users/<int:user_id>/login-logs/', views.user_login_logs, name='user_login_logs'),
    path('user-menus/', views.user_menus, name='user_menus'),
    path('available-roles/', views.available_roles, name='available_roles'),
    
    # 角色管理
    path('roles/', views.RoleListCreateView.as_view(), name='role_list_create'),
    path('roles/<int:pk>/', views.RoleDetailView.as_view(), name='role_detail'),
    path('assign-role/', views.assign_user_role, name='assign_user_role'),
    path('remove-role/<int:user_id>/<int:role_id>/', views.remove_user_role, name='remove_user_role'),
    
    # 权限管理
    path('permissions/', views.PermissionListCreateView.as_view(), name='permission_list_create'),
    path('permissions/<int:pk>/', views.PermissionDetailView.as_view(), name='permission_detail'),
    path('available-permissions/', views.available_permissions, name='available_permissions'),
    path('assign-permission/', views.assign_role_permission, name='assign_role_permission'),
    path('remove-permission/<int:role_id>/<int:permission_id>/', views.remove_role_permission, name='remove_role_permission'),
    path('role-permissions/<int:role_id>/', views.role_permissions, name='role_permissions'),
    
    # 菜单管理
    path('menus/', views.MenuListCreateView.as_view(), name='menu_list_create'),
    path('menus/<int:pk>/', views.MenuDetailView.as_view(), name='menu_detail'),
    
    # 登录日志
    path('login-logs/', views.UserLoginLogListView.as_view(), name='login_logs'),
]
