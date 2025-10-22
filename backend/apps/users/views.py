from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth import login
from django.db.models import Q
from django.utils import timezone
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter

from .models import User, Role, Permission, Menu, UserRole, RolePermission, RoleMenu, UserLoginLog
from .serializers import (
    UserSerializer, UserCreateSerializer, UserUpdateSerializer,
    ChangePasswordSerializer, LoginSerializer, RoleSerializer,
    PermissionSerializer, MenuSerializer, UserLoginLogSerializer
)
from .permissions import IsAdminOrReadOnly, IsOwnerOrAdmin
from .utils import get_client_ip


class CustomTokenObtainPairView(TokenObtainPairView):
    """自定义JWT登录视图"""
    
    def post(self, request, *args, **kwargs):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        
        # 记录登录日志
        UserLoginLog.objects.create(
            user=user,
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', ''),
            is_success=True
        )
        
        # 生成JWT token
        refresh = RefreshToken.for_user(user)
        return Response({
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': UserSerializer(user).data
        })


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def register_view(request):
    """用户注册视图"""
    serializer = UserCreateSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        # 记录注册日志
        UserLoginLog.objects.create(
            user=user,
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', ''),
            is_success=True
        )
        return Response({
            'message': '注册成功',
            'user': UserSerializer(user).data
        }, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def logout_view(request):
    """登出视图"""
    # JWT是无状态的，实际的token失效由前端删除token完成
    # 这里只是返回成功响应，让前端清除本地存储的token
    # 如果需要token黑名单功能，需要安装并配置 rest_framework_simplejwt.token_blacklist
    return Response({'message': '登出成功'}, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def user_profile(request):
    """获取当前用户信息"""
    serializer = UserSerializer(request.user)
    return Response(serializer.data)


@api_view(['PUT'])
@permission_classes([permissions.IsAuthenticated])
def update_profile(request):
    """更新当前用户信息"""
    serializer = UserUpdateSerializer(request.user, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def change_password(request):
    """修改密码"""
    serializer = ChangePasswordSerializer(data=request.data, context={'request': request})
    if serializer.is_valid():
        user = request.user
        user.set_password(serializer.validated_data['new_password'])
        user.save()
        return Response({'message': '密码修改成功'})
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserListCreateView(generics.ListCreateAPIView):
    """用户列表和创建"""
    queryset = User.objects.all()
    permission_classes = [permissions.IsAuthenticated, IsAdminOrReadOnly]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['user_type', 'is_active', 'is_verified']
    search_fields = ['username', 'email', 'first_name', 'last_name', 'phone']
    ordering_fields = ['created_at', 'updated_at', 'date_joined']
    ordering = ['-created_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return UserCreateSerializer
        return UserSerializer


class UserDetailView(generics.RetrieveUpdateDestroyAPIView):
    """用户详情"""
    queryset = User.objects.all()
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrAdmin]
    
    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return UserUpdateSerializer
        return UserSerializer


class RoleListCreateView(generics.ListCreateAPIView):
    """角色列表和创建"""
    queryset = Role.objects.all()
    serializer_class = RoleSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrReadOnly]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['is_active']
    search_fields = ['name', 'code', 'description']
    ordering_fields = ['created_at', 'updated_at']
    ordering = ['-created_at']


class RoleDetailView(generics.RetrieveUpdateDestroyAPIView):
    """角色详情"""
    queryset = Role.objects.all()
    serializer_class = RoleSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrReadOnly]


class PermissionListCreateView(generics.ListCreateAPIView):
    """权限列表和创建"""
    queryset = Permission.objects.all()
    serializer_class = PermissionSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrReadOnly]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['module', 'is_active']
    search_fields = ['name', 'code', 'description']
    ordering_fields = ['created_at']
    ordering = ['module', 'created_at']


class PermissionDetailView(generics.RetrieveUpdateDestroyAPIView):
    """权限详情"""
    queryset = Permission.objects.all()
    serializer_class = PermissionSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrReadOnly]


class MenuListCreateView(generics.ListCreateAPIView):
    """菜单列表和创建"""
    queryset = Menu.objects.filter(parent__isnull=True)
    serializer_class = MenuSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrReadOnly]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['is_active']
    search_fields = ['name', 'code']
    ordering_fields = ['sort_order', 'created_at']
    ordering = ['sort_order', 'created_at']


class MenuDetailView(generics.RetrieveUpdateDestroyAPIView):
    """菜单详情"""
    queryset = Menu.objects.all()
    serializer_class = MenuSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrReadOnly]


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def user_menus(request):
    """获取当前用户菜单"""
    user = request.user
    user_roles = UserRole.objects.filter(user=user).values_list('role', flat=True)
    role_menus = RoleMenu.objects.filter(role__in=user_roles).values_list('menu', flat=True)
    menus = Menu.objects.filter(id__in=role_menus, is_active=True).order_by('sort_order')
    
    # 构建菜单树
    menu_tree = []
    for menu in menus:
        if not menu.parent:
            menu_data = MenuSerializer(menu).data
            menu_tree.append(menu_data)
    
    return Response(menu_tree)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def assign_user_role(request):
    """分配用户角色"""
    user_id = request.data.get('user_id')
    role_id = request.data.get('role_id')
    
    if not user_id or not role_id:
        return Response({'error': '用户ID和角色ID不能为空'}, status=status.HTTP_400_BAD_REQUEST)
    
    try:
        user = User.objects.get(id=user_id)
        role = Role.objects.get(id=role_id)
        
        user_role, created = UserRole.objects.get_or_create(user=user, role=role)
        if created:
            return Response({'message': '角色分配成功'})
        else:
            return Response({'message': '用户已拥有该角色'})
    except User.DoesNotExist:
        return Response({'error': '用户不存在'}, status=status.HTTP_404_NOT_FOUND)
    except Role.DoesNotExist:
        return Response({'error': '角色不存在'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['DELETE'])
@permission_classes([permissions.IsAuthenticated])
def remove_user_role(request, user_id, role_id):
    """移除用户角色"""
    try:
        user_role = UserRole.objects.get(user_id=user_id, role_id=role_id)
        user_role.delete()
        return Response({'message': '角色移除成功'})
    except UserRole.DoesNotExist:
        return Response({'error': '用户角色关系不存在'}, status=status.HTTP_404_NOT_FOUND)


class UserLoginLogListView(generics.ListAPIView):
    """用户登录日志列表"""
    queryset = UserLoginLog.objects.all()
    serializer_class = UserLoginLogSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrReadOnly]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['is_success', 'user']
    search_fields = ['user__username', 'ip_address']
    ordering_fields = ['login_time']
    ordering = ['-login_time']
