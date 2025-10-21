from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import (
    ResourceType, Resource, ResourceImage, ResourceUsageLog,
    ResourceMaintenance, ResourceRequest, ResourceStatistics
)

User = get_user_model()


class ResourceTypeSerializer(serializers.ModelSerializer):
    """资源类型序列化器"""
    
    class Meta:
        model = ResourceType
        fields = [
            'id', 'name', 'code', 'description', 'icon',
            'sort_order', 'is_active', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class ResourceImageSerializer(serializers.ModelSerializer):
    """资源图片序列化器"""
    
    class Meta:
        model = ResourceImage
        fields = [
            'id', 'resource', 'image', 'caption', 'sort_order', 'created_at'
        ]
        read_only_fields = ['id', 'resource', 'created_at']


class ResourceListSerializer(serializers.ModelSerializer):
    """资源列表序列化器"""
    resource_type_name = serializers.CharField(source='resource_type.name', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    quality_display = serializers.CharField(source='get_quality_display', read_only=True)
    owner_name = serializers.CharField(source='owner.username', read_only=True)
    first_image = serializers.SerializerMethodField()
    
    class Meta:
        model = Resource
        fields = [
            'id', 'name', 'resource_type', 'resource_type_name', 'description',
            'specifications', 'manufacturer', 'model', 'serial_number',
            'purchase_date', 'warranty_expiry', 'location', 'status',
            'status_display', 'quality', 'quality_display', 'quantity',
            'unit_price', 'total_value', 'owner', 'owner_name',
            'contact_person', 'contact_phone', 'contact_email',
            'is_public', 'is_available_for_rent', 'rental_price',
            'rental_unit', 'created_at', 'updated_at', 'first_image'
        ]
        read_only_fields = [
            'id', 'owner', 'created_at', 'updated_at'
        ]
    
    def get_first_image(self, obj):
        first_image = obj.images.first()
        if first_image:
            return ResourceImageSerializer(first_image).data
        return None


class ResourceDetailSerializer(serializers.ModelSerializer):
    """资源详情序列化器"""
    resource_type_name = serializers.CharField(source='resource_type.name', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    quality_display = serializers.CharField(source='get_quality_display', read_only=True)
    owner_name = serializers.CharField(source='owner.username', read_only=True)
    images = ResourceImageSerializer(many=True, read_only=True)
    
    class Meta:
        model = Resource
        fields = [
            'id', 'name', 'resource_type', 'resource_type_name', 'description',
            'specifications', 'manufacturer', 'model', 'serial_number',
            'purchase_date', 'warranty_expiry', 'location', 'status',
            'status_display', 'quality', 'quality_display', 'quantity',
            'unit_price', 'total_value', 'owner', 'owner_name',
            'contact_person', 'contact_phone', 'contact_email',
            'is_public', 'is_available_for_rent', 'rental_price',
            'rental_unit', 'created_at', 'updated_at', 'images'
        ]
        read_only_fields = [
            'id', 'owner', 'created_at', 'updated_at'
        ]


class ResourceCreateSerializer(serializers.ModelSerializer):
    """资源创建序列化器"""
    images = ResourceImageSerializer(many=True, required=False)
    
    class Meta:
        model = Resource
        fields = [
            'name', 'resource_type', 'description', 'specifications',
            'manufacturer', 'model', 'serial_number', 'purchase_date',
            'warranty_expiry', 'location', 'status', 'quality',
            'quantity', 'unit_price', 'total_value', 'contact_person',
            'contact_phone', 'contact_email', 'is_public',
            'is_available_for_rent', 'rental_price', 'rental_unit', 'images'
        ]
    
    def create(self, validated_data):
        images_data = validated_data.pop('images', [])
        resource = Resource.objects.create(**validated_data)
        
        for image_data in images_data:
            ResourceImage.objects.create(resource=resource, **image_data)
        
        return resource


class ResourceUsageLogSerializer(serializers.ModelSerializer):
    """资源使用日志序列化器"""
    usage_type_display = serializers.CharField(source='get_usage_type_display', read_only=True)
    user_name = serializers.CharField(source='user.username', read_only=True)
    resource_name = serializers.CharField(source='resource.name', read_only=True)
    
    class Meta:
        model = ResourceUsageLog
        fields = [
            'id', 'resource', 'resource_name', 'user', 'user_name',
            'usage_type', 'usage_type_display', 'start_date', 'end_date',
            'purpose', 'location', 'notes', 'created_at'
        ]
        read_only_fields = ['id', 'user', 'created_at']


class ResourceMaintenanceSerializer(serializers.ModelSerializer):
    """资源维护记录序列化器"""
    maintenance_type_display = serializers.CharField(source='get_maintenance_type_display', read_only=True)
    resource_name = serializers.CharField(source='resource.name', read_only=True)
    created_by_name = serializers.CharField(source='created_by.username', read_only=True)
    
    class Meta:
        model = ResourceMaintenance
        fields = [
            'id', 'resource', 'resource_name', 'maintenance_type',
            'maintenance_type_display', 'title', 'description',
            'start_date', 'end_date', 'cost', 'technician', 'notes',
            'created_by', 'created_by_name', 'created_at'
        ]
        read_only_fields = ['id', 'created_by', 'created_at']


class ResourceRequestSerializer(serializers.ModelSerializer):
    """资源申请序列化器"""
    request_type_display = serializers.CharField(source='get_request_type_display', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    resource_name = serializers.CharField(source='resource.name', read_only=True)
    requester_name = serializers.CharField(source='requester.username', read_only=True)
    approved_by_name = serializers.CharField(source='approved_by.username', read_only=True)
    
    class Meta:
        model = ResourceRequest
        fields = [
            'id', 'resource', 'resource_name', 'requester', 'requester_name',
            'request_type', 'request_type_display', 'title', 'description',
            'start_date', 'end_date', 'quantity', 'purpose', 'status',
            'status_display', 'approved_by', 'approved_by_name',
            'approved_at', 'approval_notes', 'created_at', 'updated_at'
        ]
        read_only_fields = [
            'id', 'requester', 'approved_by', 'approved_at',
            'created_at', 'updated_at'
        ]


class ResourceRequestCreateSerializer(serializers.ModelSerializer):
    """资源申请创建序列化器"""
    
    class Meta:
        model = ResourceRequest
        fields = [
            'resource', 'request_type', 'title', 'description',
            'start_date', 'end_date', 'quantity', 'purpose'
        ]
    
    def create(self, validated_data):
        validated_data['requester'] = self.context['request'].user
        return super().create(validated_data)


class ResourceStatisticsSerializer(serializers.ModelSerializer):
    """资源统计序列化器"""
    resource_type_name = serializers.CharField(source='resource_type.name', read_only=True)
    
    class Meta:
        model = ResourceStatistics
        fields = [
            'id', 'resource_type', 'resource_type_name', 'total_count',
            'available_count', 'in_use_count', 'maintenance_count',
            'total_value', 'utilization_rate', 'last_updated'
        ]
        read_only_fields = ['id', 'last_updated']
