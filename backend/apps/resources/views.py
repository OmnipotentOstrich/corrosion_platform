from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.db.models import Q, Count, Sum, F
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.utils import timezone
from datetime import datetime, timedelta

from .models import (
    ResourceType, Resource, ResourceImage, ResourceUsageLog,
    ResourceMaintenance, ResourceRequest, ResourceStatistics
)
from .serializers import (
    ResourceTypeSerializer, ResourceListSerializer, ResourceDetailSerializer,
    ResourceCreateSerializer, ResourceImageSerializer, ResourceUsageLogSerializer,
    ResourceMaintenanceSerializer, ResourceRequestSerializer, ResourceRequestCreateSerializer,
    ResourceStatisticsSerializer
)


class ResourceTypeListCreateView(generics.ListCreateAPIView):
    """资源类型列表和创建"""
    queryset = ResourceType.objects.filter(is_active=True)
    serializer_class = ResourceTypeSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    search_fields = ['name', 'description']
    ordering_fields = ['sort_order', 'created_at']
    ordering = ['sort_order', 'created_at']


class ResourceTypeDetailView(generics.RetrieveUpdateDestroyAPIView):
    """资源类型详情"""
    queryset = ResourceType.objects.all()
    serializer_class = ResourceTypeSerializer
    permission_classes = [permissions.IsAuthenticated]


class ResourceListCreateView(generics.ListCreateAPIView):
    """资源列表和创建"""
    queryset = Resource.objects.filter(is_public=True)
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['resource_type', 'status', 'quality', 'is_available_for_rent', 'owner']
    search_fields = ['name', 'description', 'manufacturer', 'model', 'location']
    ordering_fields = ['created_at', 'updated_at', 'purchase_date', 'unit_price']
    ordering = ['-created_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return ResourceCreateSerializer
        return ResourceListSerializer
    
    def get_queryset(self):
        # 非管理员只能看到公开的资源
        if not self.request.user.is_staff:
            return Resource.objects.filter(is_public=True)
        return super().get_queryset()
    
    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)


class ResourceDetailView(generics.RetrieveUpdateDestroyAPIView):
    """资源详情"""
    queryset = Resource.objects.all()
    permission_classes = [permissions.IsAuthenticated]
    
    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return ResourceCreateSerializer
        return ResourceDetailSerializer
    
    def get_queryset(self):
        # 非管理员只能看到公开的资源
        if not self.request.user.is_staff:
            return Resource.objects.filter(is_public=True)
        return super().get_queryset()


class ResourceUsageLogListCreateView(generics.ListCreateAPIView):
    """资源使用日志列表和创建"""
    queryset = ResourceUsageLog.objects.all()
    serializer_class = ResourceUsageLogSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['resource', 'user', 'usage_type']
    search_fields = ['purpose', 'location', 'notes']
    ordering_fields = ['start_date', 'end_date', 'created_at']
    ordering = ['-created_at']
    
    def get_queryset(self):
        # 非管理员只能看到自己的使用记录
        if not self.request.user.is_staff:
            return ResourceUsageLog.objects.filter(user=self.request.user)
        return super().get_queryset()
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class ResourceMaintenanceListCreateView(generics.ListCreateAPIView):
    """资源维护记录列表和创建"""
    queryset = ResourceMaintenance.objects.all()
    serializer_class = ResourceMaintenanceSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['resource', 'maintenance_type', 'created_by']
    search_fields = ['title', 'description', 'technician', 'notes']
    ordering_fields = ['start_date', 'end_date', 'created_at']
    ordering = ['-created_at']
    
    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)


class ResourceRequestListCreateView(generics.ListCreateAPIView):
    """资源申请列表和创建"""
    queryset = ResourceRequest.objects.all()
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['resource', 'requester', 'request_type', 'status']
    search_fields = ['title', 'description', 'purpose']
    ordering_fields = ['start_date', 'end_date', 'created_at']
    ordering = ['-created_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return ResourceRequestCreateSerializer
        return ResourceRequestSerializer
    
    def get_queryset(self):
        # 非管理员只能看到自己的申请
        if not self.request.user.is_staff:
            return ResourceRequest.objects.filter(requester=self.request.user)
        return super().get_queryset()
    
    def perform_create(self, serializer):
        serializer.save(requester=self.request.user)


class ResourceRequestDetailView(generics.RetrieveUpdateDestroyAPIView):
    """资源申请详情"""
    queryset = ResourceRequest.objects.all()
    serializer_class = ResourceRequestSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        # 非管理员只能看到自己的申请
        if not self.request.user.is_staff:
            return ResourceRequest.objects.filter(requester=self.request.user)
        return super().get_queryset()


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def approve_request(request, request_id):
    """审批资源申请"""
    try:
        resource_request = ResourceRequest.objects.get(id=request_id)
        approval_notes = request.data.get('approval_notes', '')
        action = request.data.get('action', 'approve')  # approve or reject
        
        if action == 'approve':
            resource_request.status = 'approved'
        else:
            resource_request.status = 'rejected'
        
        resource_request.approved_by = request.user
        resource_request.approved_at = timezone.now()
        resource_request.approval_notes = approval_notes
        resource_request.save()
        
        return Response({'message': f'申请{action == "approve" and "批准" or "拒绝"}成功'})
    except ResourceRequest.DoesNotExist:
        return Response({'error': '申请不存在'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def my_resources(request):
    """我的资源"""
    resources = Resource.objects.filter(owner=request.user).order_by('-created_at')
    serializer = ResourceListSerializer(resources, many=True)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def my_requests(request):
    """我的申请"""
    requests = ResourceRequest.objects.filter(requester=request.user).order_by('-created_at')
    serializer = ResourceRequestSerializer(requests, many=True)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def resource_statistics(request):
    """资源统计"""
    statistics = ResourceStatistics.objects.all()
    serializer = ResourceStatisticsSerializer(statistics, many=True)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def search_resources(request):
    """搜索资源"""
    query = request.GET.get('q', '')
    resource_type_id = request.GET.get('type', '')
    status = request.GET.get('status', '')
    location = request.GET.get('location', '')
    min_price = request.GET.get('min_price', '')
    max_price = request.GET.get('max_price', '')
    
    queryset = Resource.objects.filter(is_public=True)
    
    if query:
        queryset = queryset.filter(
            Q(name__icontains=query) |
            Q(description__icontains=query) |
            Q(manufacturer__icontains=query) |
            Q(model__icontains=query) |
            Q(specifications__icontains=query)
        )
    
    if resource_type_id:
        queryset = queryset.filter(resource_type_id=resource_type_id)
    
    if status:
        queryset = queryset.filter(status=status)
    
    if location:
        queryset = queryset.filter(location__icontains=location)
    
    if min_price:
        queryset = queryset.filter(unit_price__gte=min_price)
    
    if max_price:
        queryset = queryset.filter(unit_price__lte=max_price)
    
    queryset = queryset.order_by('-created_at')
    
    serializer = ResourceListSerializer(queryset, many=True)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def available_resources(request):
    """可用资源"""
    resources = Resource.objects.filter(
        is_public=True,
        status='available'
    ).order_by('-created_at')
    
    serializer = ResourceListSerializer(resources, many=True)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def rental_resources(request):
    """可租赁资源"""
    resources = Resource.objects.filter(
        is_public=True,
        is_available_for_rent=True,
        status='available'
    ).order_by('rental_price')
    
    serializer = ResourceListSerializer(resources, many=True)
    return Response(serializer.data)
