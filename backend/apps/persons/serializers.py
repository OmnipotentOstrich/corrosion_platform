from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.utils import timezone
from .models import Person, PersonProject, PersonTask, PersonStatistics, PersonDocument

User = get_user_model()


class PersonSerializer(serializers.ModelSerializer):
    """个人用户信息序列化器"""
    gender_display = serializers.CharField(source='get_gender_display', read_only=True)
    education_display = serializers.CharField(source='get_education_display', read_only=True)
    username = serializers.CharField(source='user.username', read_only=True)
    email = serializers.EmailField(source='user.email', read_only=True)
    phone = serializers.CharField(source='user.phone', read_only=True)
    age = serializers.SerializerMethodField()
    
    class Meta:
        model = Person
        fields = [
            'id', 'user', 'username', 'email', 'phone', 'real_name', 'gender',
            'gender_display', 'birth_date', 'age', 'id_card', 'education',
            'education_display', 'profession', 'work_experience', 'skills',
            'address', 'emergency_contact', 'emergency_phone', 'bio',
            'is_verified', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'user', 'created_at', 'updated_at']
    
    def get_age(self, obj):
        if obj.birth_date:
            today = timezone.now().date()
            return today.year - obj.birth_date.year - ((today.month, today.day) < (obj.birth_date.month, obj.birth_date.day))
        return None


class PersonCreateSerializer(serializers.ModelSerializer):
    """个人用户创建序列化器"""
    username = serializers.CharField(write_only=True)
    email = serializers.EmailField(write_only=True)
    phone = serializers.CharField(write_only=True)
    password = serializers.CharField(write_only=True)
    
    class Meta:
        model = Person
        fields = [
            'username', 'email', 'phone', 'password', 'real_name', 'gender',
            'birth_date', 'id_card', 'education', 'profession', 'work_experience',
            'skills', 'address', 'emergency_contact', 'emergency_phone', 'bio'
        ]
    
    def create(self, validated_data):
        # 创建用户
        user_data = {
            'username': validated_data.pop('username'),
            'email': validated_data.pop('email'),
            'phone': validated_data.pop('phone'),
            'password': validated_data.pop('password'),
            'user_type': 'personal'
        }
        user = User.objects.create_user(**user_data)
        
        # 创建个人用户信息
        person = Person.objects.create(user=user, **validated_data)
        
        # 创建个人统计记录
        PersonStatistics.objects.create(person=person)
        
        return person


class PersonUpdateSerializer(serializers.ModelSerializer):
    """个人用户更新序列化器"""
    
    class Meta:
        model = Person
        fields = [
            'real_name', 'gender', 'birth_date', 'education', 'profession',
            'work_experience', 'skills', 'address', 'emergency_contact',
            'emergency_phone', 'bio'
        ]


class PersonProjectSerializer(serializers.ModelSerializer):
    """个人项目序列化器"""
    project_type_display = serializers.CharField(source='get_project_type_display', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    person_name = serializers.CharField(source='person.real_name', read_only=True)
    
    class Meta:
        model = PersonProject
        fields = [
            'id', 'person', 'person_name', 'name', 'project_type', 'project_type_display',
            'description', 'client', 'role', 'start_date', 'end_date', 'status',
            'status_display', 'progress', 'location', 'income', 'achievements',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'person', 'created_at', 'updated_at']


class PersonTaskSerializer(serializers.ModelSerializer):
    """个人任务序列化器"""
    priority_display = serializers.CharField(source='get_priority_display', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    person_name = serializers.CharField(source='person.real_name', read_only=True)
    project_name = serializers.CharField(source='project.name', read_only=True)
    
    class Meta:
        model = PersonTask
        fields = [
            'id', 'person', 'person_name', 'project', 'project_name', 'title',
            'description', 'priority', 'priority_display', 'status', 'status_display',
            'due_date', 'completed_at', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'person', 'created_at', 'updated_at']


class PersonStatisticsSerializer(serializers.ModelSerializer):
    """个人统计序列化器"""
    person_name = serializers.CharField(source='person.real_name', read_only=True)
    completion_rate = serializers.SerializerMethodField()
    task_completion_rate = serializers.SerializerMethodField()
    
    class Meta:
        model = PersonStatistics
        fields = [
            'id', 'person', 'person_name', 'total_projects', 'completed_projects',
            'total_tasks', 'completed_tasks', 'total_income', 'work_days',
            'completion_rate', 'task_completion_rate', 'last_updated'
        ]
        read_only_fields = ['id', 'person', 'last_updated']
    
    def get_completion_rate(self, obj):
        if obj.total_projects > 0:
            return round((obj.completed_projects / obj.total_projects) * 100, 2)
        return 0
    
    def get_task_completion_rate(self, obj):
        if obj.total_tasks > 0:
            return round((obj.completed_tasks / obj.total_tasks) * 100, 2)
        return 0


class PersonDocumentSerializer(serializers.ModelSerializer):
    """个人资质文件序列化器"""
    document_type_display = serializers.CharField(source='get_document_type_display', read_only=True)
    person_name = serializers.CharField(source='person.real_name', read_only=True)
    
    class Meta:
        model = PersonDocument
        fields = [
            'id', 'person', 'person_name', 'document_type', 'document_type_display',
            'title', 'file', 'description', 'is_public', 'created_at'
        ]
        read_only_fields = ['id', 'person', 'created_at']


class PersonDashboardSerializer(serializers.Serializer):
    """个人仪表板数据序列化器"""
    person = PersonSerializer(read_only=True)
    statistics = PersonStatisticsSerializer(read_only=True)
    recent_projects = PersonProjectSerializer(many=True, read_only=True)
    recent_tasks = PersonTaskSerializer(many=True, read_only=True)
    pending_tasks = serializers.IntegerField(read_only=True)
    overdue_tasks = serializers.IntegerField(read_only=True)
    documents_count = serializers.IntegerField(read_only=True)
