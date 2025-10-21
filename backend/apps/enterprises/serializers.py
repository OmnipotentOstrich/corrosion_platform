from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import (
    Enterprise, EnterpriseDocument, Employee, 
    EnterpriseProject, EnterpriseStatistics
)

User = get_user_model()


class EnterpriseSerializer(serializers.ModelSerializer):
    """企业信息序列化器"""
    enterprise_type_display = serializers.CharField(source='get_enterprise_type_display', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    username = serializers.CharField(source='user.username', read_only=True)
    email = serializers.EmailField(source='user.email', read_only=True)
    phone = serializers.CharField(source='user.phone', read_only=True)
    
    class Meta:
        model = Enterprise
        fields = [
            'id', 'user', 'username', 'email', 'phone', 'name', 'short_name',
            'enterprise_type', 'enterprise_type_display', 'unified_social_credit_code',
            'legal_representative', 'registered_capital', 'establishment_date',
            'business_scope', 'address', 'contact_person', 'contact_phone',
            'contact_email', 'website', 'description', 'status', 'status_display',
            'is_active', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'user', 'created_at', 'updated_at']


class EnterpriseCreateSerializer(serializers.ModelSerializer):
    """企业创建序列化器"""
    username = serializers.CharField(write_only=True)
    email = serializers.EmailField(write_only=True)
    phone = serializers.CharField(write_only=True)
    password = serializers.CharField(write_only=True)
    
    class Meta:
        model = Enterprise
        fields = [
            'username', 'email', 'phone', 'password', 'name', 'short_name',
            'enterprise_type', 'unified_social_credit_code', 'legal_representative',
            'registered_capital', 'establishment_date', 'business_scope',
            'address', 'contact_person', 'contact_phone', 'contact_email',
            'website', 'description'
        ]
    
    def create(self, validated_data):
        # 创建用户
        user_data = {
            'username': validated_data.pop('username'),
            'email': validated_data.pop('email'),
            'phone': validated_data.pop('phone'),
            'password': validated_data.pop('password'),
            'user_type': 'enterprise'
        }
        user = User.objects.create_user(**user_data)
        
        # 创建企业
        enterprise = Enterprise.objects.create(user=user, **validated_data)
        
        # 创建企业统计记录
        EnterpriseStatistics.objects.create(enterprise=enterprise)
        
        return enterprise


class EnterpriseDocumentSerializer(serializers.ModelSerializer):
    """企业资质文件序列化器"""
    document_type_display = serializers.CharField(source='get_document_type_display', read_only=True)
    verified_by_username = serializers.CharField(source='verified_by.username', read_only=True)
    
    class Meta:
        model = EnterpriseDocument
        fields = [
            'id', 'enterprise', 'document_type', 'document_type_display',
            'title', 'file', 'description', 'is_verified', 'verified_at',
            'verified_by', 'verified_by_username', 'created_at'
        ]
        read_only_fields = ['id', 'enterprise', 'verified_at', 'verified_by', 'created_at']


class EmployeeSerializer(serializers.ModelSerializer):
    """企业员工序列化器"""
    position_display = serializers.CharField(source='get_position_display', read_only=True)
    username = serializers.CharField(source='user.username', read_only=True)
    email = serializers.EmailField(source='user.email', read_only=True)
    phone = serializers.CharField(source='user.phone', read_only=True)
    first_name = serializers.CharField(source='user.first_name', read_only=True)
    last_name = serializers.CharField(source='user.last_name', read_only=True)
    
    class Meta:
        model = Employee
        fields = [
            'id', 'enterprise', 'user', 'username', 'email', 'phone',
            'first_name', 'last_name', 'employee_id', 'position',
            'position_display', 'department', 'hire_date', 'salary',
            'is_active', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'enterprise', 'user', 'created_at', 'updated_at']


class EmployeeCreateSerializer(serializers.ModelSerializer):
    """员工创建序列化器"""
    username = serializers.CharField(write_only=True)
    email = serializers.EmailField(write_only=True)
    phone = serializers.CharField(write_only=True)
    password = serializers.CharField(write_only=True)
    first_name = serializers.CharField(write_only=True, required=False)
    last_name = serializers.CharField(write_only=True, required=False)
    
    class Meta:
        model = Employee
        fields = [
            'username', 'email', 'phone', 'password', 'first_name', 'last_name',
            'employee_id', 'position', 'department', 'hire_date', 'salary'
        ]
    
    def create(self, validated_data):
        enterprise = self.context['enterprise']
        
        # 创建用户
        user_data = {
            'username': validated_data.pop('username'),
            'email': validated_data.pop('email'),
            'phone': validated_data.pop('phone'),
            'password': validated_data.pop('password'),
            'user_type': 'enterprise',
            'first_name': validated_data.pop('first_name', ''),
            'last_name': validated_data.pop('last_name', '')
        }
        user = User.objects.create_user(**user_data)
        
        # 创建员工
        employee = Employee.objects.create(enterprise=enterprise, user=user, **validated_data)
        
        return employee


class EnterpriseProjectSerializer(serializers.ModelSerializer):
    """企业项目序列化器"""
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    enterprise_name = serializers.CharField(source='enterprise.name', read_only=True)
    
    class Meta:
        model = EnterpriseProject
        fields = [
            'id', 'enterprise', 'enterprise_name', 'name', 'description',
            'client', 'contract_amount', 'start_date', 'end_date',
            'status', 'status_display', 'progress', 'location',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'enterprise', 'created_at', 'updated_at']


class EnterpriseStatisticsSerializer(serializers.ModelSerializer):
    """企业统计序列化器"""
    enterprise_name = serializers.CharField(source='enterprise.name', read_only=True)
    
    class Meta:
        model = EnterpriseStatistics
        fields = [
            'id', 'enterprise', 'enterprise_name', 'total_projects',
            'completed_projects', 'total_employees', 'total_revenue',
            'total_contracts', 'last_updated'
        ]
        read_only_fields = ['id', 'enterprise', 'last_updated']


class EnterpriseDashboardSerializer(serializers.Serializer):
    """企业仪表板数据序列化器"""
    enterprise = EnterpriseSerializer(read_only=True)
    statistics = EnterpriseStatisticsSerializer(read_only=True)
    recent_projects = EnterpriseProjectSerializer(many=True, read_only=True)
    employees_count = serializers.IntegerField(read_only=True)
    documents_count = serializers.IntegerField(read_only=True)
    pending_documents = serializers.IntegerField(read_only=True)
