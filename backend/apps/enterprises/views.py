from rest_framework import generics, status, permissions, serializers
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.db.models import Q, Count, Sum
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.utils import timezone
from datetime import datetime, timedelta

from .models import (
    Enterprise, EnterpriseDocument, Employee, 
    EnterpriseProject, EnterpriseStatistics
)
from .serializers import (
    EnterpriseSerializer, EnterpriseCreateSerializer, EnterpriseDocumentSerializer,
    EmployeeSerializer, EmployeeCreateSerializer, EmployeeUpdateSerializer,
    EnterpriseProjectSerializer, EnterpriseStatisticsSerializer, EnterpriseDashboardSerializer
)
from apps.users.permissions import IsEnterpriseUser, IsEnterpriseAdmin


class EnterpriseListCreateView(generics.ListCreateAPIView):
    """企业列表和创建"""
    queryset = Enterprise.objects.all()
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['enterprise_type', 'status', 'is_active']
    search_fields = ['name', 'short_name', 'unified_social_credit_code', 'contact_person']
    ordering_fields = ['created_at', 'updated_at']
    ordering = ['-created_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return EnterpriseCreateSerializer
        return EnterpriseSerializer
    
    def get_queryset(self):
        # 非管理员只能看到自己的企业
        if not self.request.user.is_staff:
            return Enterprise.objects.filter(user=self.request.user)
        return super().get_queryset()


class EnterpriseDetailView(generics.RetrieveUpdateDestroyAPIView):
    """企业详情"""
    queryset = Enterprise.objects.all()
    serializer_class = EnterpriseSerializer
    permission_classes = [permissions.IsAuthenticated, IsEnterpriseUser]
    
    def get_queryset(self):
        # 非管理员只能看到自己的企业
        if not self.request.user.is_staff:
            return Enterprise.objects.filter(user=self.request.user)
        return super().get_queryset()


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated, IsEnterpriseUser])
def enterprise_dashboard(request):
    """企业仪表板数据"""
    try:
        enterprise = Enterprise.objects.get(user=request.user)
    except Enterprise.DoesNotExist:
        return Response({'error': '企业信息不存在'}, status=status.HTTP_404_NOT_FOUND)
    
    # 获取统计数据
    statistics = EnterpriseStatistics.objects.get(enterprise=enterprise)
    
    # 获取最近的项目
    recent_projects = EnterpriseProject.objects.filter(enterprise=enterprise).order_by('-created_at')[:5]
    
    # 获取员工数量
    employees_count = Employee.objects.filter(enterprise=enterprise, is_active=True).count()
    
    # 获取文档数量
    documents_count = EnterpriseDocument.objects.filter(enterprise=enterprise).count()
    pending_documents = EnterpriseDocument.objects.filter(enterprise=enterprise, is_verified=False).count()
    
    data = {
        'enterprise': enterprise,
        'statistics': statistics,
        'recent_projects': recent_projects,
        'employees_count': employees_count,
        'documents_count': documents_count,
        'pending_documents': pending_documents
    }
    
    serializer = EnterpriseDashboardSerializer(data)
    return Response(serializer.data)


class EnterpriseDocumentListCreateView(generics.ListCreateAPIView):
    """企业资质文件列表和创建"""
    queryset = EnterpriseDocument.objects.all()
    serializer_class = EnterpriseDocumentSerializer
    permission_classes = [permissions.IsAuthenticated, IsEnterpriseUser]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['document_type', 'is_verified']
    search_fields = ['title', 'description']
    ordering_fields = ['created_at']
    ordering = ['-created_at']
    
    def get_queryset(self):
        # 非管理员只能看到自己企业的文档
        if not self.request.user.is_staff:
            try:
                enterprise = Enterprise.objects.get(user=self.request.user)
            except Enterprise.DoesNotExist:
                return Response({'error': '用户没有对应的企业'}, status=status.HTTP_404_NOT_FOUND)
            return EnterpriseDocument.objects.filter(enterprise=enterprise)
        return super().get_queryset()
    
    def perform_create(self, serializer):
        if not self.request.user.is_staff:
            try:
                enterprise = Enterprise.objects.get(user=self.request.user)
            except Enterprise.DoesNotExist:
                return Response({'error': '用户没有对应的企业'}, status=status.HTTP_404_NOT_FOUND)
            serializer.save(enterprise=enterprise)
        else:
            serializer.save()


class EnterpriseDocumentDetailView(generics.RetrieveUpdateDestroyAPIView):
    """企业资质文件详情"""
    queryset = EnterpriseDocument.objects.all()
    serializer_class = EnterpriseDocumentSerializer
    permission_classes = [permissions.IsAuthenticated, IsEnterpriseUser]
    
    def get_queryset(self):
        # 非管理员只能看到自己企业的文档
        if not self.request.user.is_staff:
            try:
                enterprise = Enterprise.objects.get(user=self.request.user)
            except Enterprise.DoesNotExist:
                return Response({'error': '用户没有对应的企业'}, status=status.HTTP_404_NOT_FOUND)
            return EnterpriseDocument.objects.filter(enterprise=enterprise)
        return super().get_queryset()


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated, IsEnterpriseAdmin])
def verify_document(request, document_id):
    """验证企业资质文件"""
    try:
        document = EnterpriseDocument.objects.get(id=document_id)
        document.is_verified = True
        document.verified_at = timezone.now()
        document.verified_by = request.user
        document.save()
        return Response({'message': '文档验证成功'})
    except EnterpriseDocument.DoesNotExist:
        return Response({'error': '文档不存在'}, status=status.HTTP_404_NOT_FOUND)


class EmployeeListCreateView(generics.ListCreateAPIView):
    """企业员工列表和创建"""
    queryset = Employee.objects.all()
    permission_classes = [permissions.IsAuthenticated, IsEnterpriseUser]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['position', 'department', 'is_active']
    search_fields = ['user__username', 'user__first_name', 'user__last_name', 'employee_id']
    ordering_fields = ['hire_date', 'created_at']
    ordering = ['-created_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return EmployeeCreateSerializer
        return EmployeeSerializer
    
    def get_queryset(self):
        # 非管理员只能看到自己企业的员工
        if not self.request.user.is_staff:
            try:
                enterprise = Enterprise.objects.get(user=self.request.user)
                return Employee.objects.filter(enterprise=enterprise)
            except Enterprise.DoesNotExist:
                # 如果用户没有对应的企业，返回空查询集
                return Employee.objects.none()
        return super().get_queryset()
    
    def get_serializer_context(self):
        context = super().get_serializer_context()
        if not self.request.user.is_staff:
            try:
                context['enterprise'] = Enterprise.objects.get(user=self.request.user)
            except Enterprise.DoesNotExist:
                # 如果用户没有对应的企业，不设置enterprise上下文
                pass
        return context


class EmployeeDetailView(generics.RetrieveUpdateDestroyAPIView):
    """企业员工详情"""
    queryset = Employee.objects.all()
    serializer_class = EmployeeSerializer
    permission_classes = [permissions.IsAuthenticated, IsEnterpriseUser]
    
    def get_serializer_class(self):
        # 更新操作使用EmployeeUpdateSerializer
        if self.request.method in ['PUT', 'PATCH']:
            return EmployeeUpdateSerializer
        return EmployeeSerializer
    
    def get_queryset(self):
        # 非管理员只能看到自己企业的员工
        if not self.request.user.is_staff:
            try:
                enterprise = Enterprise.objects.get(user=self.request.user)
                return Employee.objects.filter(enterprise=enterprise)
            except Enterprise.DoesNotExist:
                # 如果用户没有对应的企业，返回空查询集
                return Employee.objects.none()
        return super().get_queryset()


class EnterpriseProjectListCreateView(generics.ListCreateAPIView):
    """企业项目列表和创建"""
    queryset = EnterpriseProject.objects.all()
    serializer_class = EnterpriseProjectSerializer
    permission_classes = [permissions.IsAuthenticated, IsEnterpriseUser]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['status']
    search_fields = ['name', 'description', 'client', 'location']
    ordering_fields = ['start_date', 'end_date', 'created_at']
    ordering = ['-created_at']
    
    def get_queryset(self):
        # 非管理员只能看到自己企业的项目
        if not self.request.user.is_staff:
            try:
                enterprise = Enterprise.objects.get(user=self.request.user)
                return EnterpriseProject.objects.filter(enterprise=enterprise)
            except Enterprise.DoesNotExist:
                # 如果企业不存在，返回空查询集
                return EnterpriseProject.objects.none()
        return super().get_queryset()
    
    def perform_create(self, serializer):
        if not self.request.user.is_staff:
            try:
                enterprise = Enterprise.objects.get(user=self.request.user)
                serializer.save(enterprise=enterprise)
            except Enterprise.DoesNotExist:
                raise serializers.ValidationError('企业信息不存在')
        else:
            serializer.save()


class EnterpriseProjectDetailView(generics.RetrieveUpdateDestroyAPIView):
    """企业项目详情"""
    queryset = EnterpriseProject.objects.all()
    serializer_class = EnterpriseProjectSerializer
    permission_classes = [permissions.IsAuthenticated, IsEnterpriseUser]
    
    def get_queryset(self):
        # 非管理员只能看到自己企业的项目
        if not self.request.user.is_staff:
            try:
                enterprise = Enterprise.objects.get(user=self.request.user)
            except Enterprise.DoesNotExist:
                return Response({'error': '用户没有对应的企业'}, status=status.HTTP_404_NOT_FOUND)
            return EnterpriseProject.objects.filter(enterprise=enterprise)
        return super().get_queryset()


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated, IsEnterpriseUser])
def enterprise_statistics(request):
    """企业统计数据"""
    try:
        # 如果是管理员，返回所有企业的汇总统计
        if request.user.is_staff:
            total_projects = EnterpriseProject.objects.count()
            completed_projects = EnterpriseProject.objects.filter(status='completed').count()
            ongoing_projects = EnterpriseProject.objects.filter(status='in_progress').count()
            total_employees = Employee.objects.filter(is_active=True).count()
            total_revenue = EnterpriseProject.objects.filter(
                contract_amount__isnull=False
            ).aggregate(total=Sum('contract_amount'))['total'] or 0
            
            data = {
                'total_projects': total_projects,
                'ongoing_projects': ongoing_projects,
                'completed_projects': completed_projects,
                'total_employees': total_employees,
                'total_revenue': str(total_revenue),
                'total_contracts': total_projects,
            }
            return Response(data)
        
        # 企业用户返回自己的统计
        enterprise = Enterprise.objects.get(user=request.user)
        
        # 如果统计数据不存在，创建默认的
        statistics, created = EnterpriseStatistics.objects.get_or_create(
            enterprise=enterprise,
            defaults={
                'total_projects': EnterpriseProject.objects.filter(enterprise=enterprise).count(),
                'completed_projects': EnterpriseProject.objects.filter(enterprise=enterprise, status='completed').count(),
                'total_employees': Employee.objects.filter(enterprise=enterprise, is_active=True).count(),
                'total_revenue': 0,
                'total_contracts': 0,
            }
        )
        
        serializer = EnterpriseStatisticsSerializer(statistics)
        return Response(serializer.data)
    except Enterprise.DoesNotExist:
        # 如果企业不存在，返回空统计
        return Response({
            'total_projects': 0,
            'ongoing_projects': 0,
            'completed_projects': 0,
            'total_employees': 0,
            'total_revenue': '0',
            'total_contracts': 0,
        })


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated, IsEnterpriseUser])
def update_project_progress(request, project_id):
    """更新项目进度"""
    try:
        project = EnterpriseProject.objects.get(id=project_id)
        progress = request.data.get('progress', 0)
        
        if not isinstance(progress, int) or progress < 0 or progress > 100:
            return Response({'error': '进度值必须在0-100之间'}, status=status.HTTP_400_BAD_REQUEST)
        
        project.progress = progress
        if progress == 100:
            project.status = 'completed'
            project.end_date = timezone.now().date()
        elif progress > 0 and project.status == 'planning':
            project.status = 'in_progress'
        
        project.save()
        
        # 更新企业统计
        enterprise = project.enterprise
        statistics = EnterpriseStatistics.objects.get(enterprise=enterprise)
        statistics.completed_projects = EnterpriseProject.objects.filter(
            enterprise=enterprise, status='completed'
        ).count()
        statistics.save()
        
        return Response({'message': '项目进度更新成功'})
    except EnterpriseProject.DoesNotExist:
        return Response({'error': '项目不存在'}, status=status.HTTP_404_NOT_FOUND)
