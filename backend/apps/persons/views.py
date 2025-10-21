from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.db.models import Q, Count
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.utils import timezone
from datetime import datetime, timedelta

from .models import Person, PersonProject, PersonTask, PersonStatistics, PersonDocument
from .serializers import (
    PersonSerializer, PersonCreateSerializer, PersonUpdateSerializer,
    PersonProjectSerializer, PersonTaskSerializer, PersonStatisticsSerializer,
    PersonDocumentSerializer, PersonDashboardSerializer
)
from apps.users.permissions import IsPersonalUser


class PersonListCreateView(generics.ListCreateAPIView):
    """个人用户列表和创建"""
    queryset = Person.objects.all()
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['gender', 'education', 'profession', 'is_verified']
    search_fields = ['real_name', 'profession', 'skills', 'user__username']
    ordering_fields = ['created_at', 'updated_at', 'work_experience']
    ordering = ['-created_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return PersonCreateSerializer
        return PersonSerializer
    
    def get_queryset(self):
        # 非管理员只能看到自己的信息
        if not self.request.user.is_staff:
            return Person.objects.filter(user=self.request.user)
        return super().get_queryset()


class PersonDetailView(generics.RetrieveUpdateDestroyAPIView):
    """个人用户详情"""
    queryset = Person.objects.all()
    permission_classes = [permissions.IsAuthenticated, IsPersonalUser]
    
    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return PersonUpdateSerializer
        return PersonSerializer
    
    def get_queryset(self):
        # 非管理员只能看到自己的信息
        if not self.request.user.is_staff:
            return Person.objects.filter(user=self.request.user)
        return super().get_queryset()


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated, IsPersonalUser])
def person_dashboard(request):
    """个人仪表板数据"""
    try:
        person = Person.objects.get(user=request.user)
    except Person.DoesNotExist:
        return Response({'error': '个人用户信息不存在'}, status=status.HTTP_404_NOT_FOUND)
    
    # 获取统计数据
    statistics = PersonStatistics.objects.get(person=person)
    
    # 获取最近的项目
    recent_projects = PersonProject.objects.filter(person=person).order_by('-created_at')[:5]
    
    # 获取最近的任务
    recent_tasks = PersonTask.objects.filter(person=person).order_by('-created_at')[:5]
    
    # 获取待处理任务数量
    pending_tasks = PersonTask.objects.filter(person=person, status='pending').count()
    
    # 获取逾期任务数量
    overdue_tasks = PersonTask.objects.filter(
        person=person, 
        status__in=['pending', 'in_progress'],
        due_date__lt=timezone.now()
    ).count()
    
    # 获取文档数量
    documents_count = PersonDocument.objects.filter(person=person).count()
    
    data = {
        'person': person,
        'statistics': statistics,
        'recent_projects': recent_projects,
        'recent_tasks': recent_tasks,
        'pending_tasks': pending_tasks,
        'overdue_tasks': overdue_tasks,
        'documents_count': documents_count
    }
    
    serializer = PersonDashboardSerializer(data)
    return Response(serializer.data)


class PersonProjectListCreateView(generics.ListCreateAPIView):
    """个人项目列表和创建"""
    queryset = PersonProject.objects.all()
    serializer_class = PersonProjectSerializer
    permission_classes = [permissions.IsAuthenticated, IsPersonalUser]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['project_type', 'status']
    search_fields = ['name', 'description', 'client', 'role', 'location']
    ordering_fields = ['start_date', 'end_date', 'created_at']
    ordering = ['-created_at']
    
    def get_queryset(self):
        # 非管理员只能看到自己的项目
        if not self.request.user.is_staff:
            person = Person.objects.get(user=self.request.user)
            return PersonProject.objects.filter(person=person)
        return super().get_queryset()
    
    def perform_create(self, serializer):
        if not self.request.user.is_staff:
            person = Person.objects.get(user=self.request.user)
            serializer.save(person=person)
        else:
            serializer.save()


class PersonProjectDetailView(generics.RetrieveUpdateDestroyAPIView):
    """个人项目详情"""
    queryset = PersonProject.objects.all()
    serializer_class = PersonProjectSerializer
    permission_classes = [permissions.IsAuthenticated, IsPersonalUser]
    
    def get_queryset(self):
        # 非管理员只能看到自己的项目
        if not self.request.user.is_staff:
            person = Person.objects.get(user=self.request.user)
            return PersonProject.objects.filter(person=person)
        return super().get_queryset()


class PersonTaskListCreateView(generics.ListCreateAPIView):
    """个人任务列表和创建"""
    queryset = PersonTask.objects.all()
    serializer_class = PersonTaskSerializer
    permission_classes = [permissions.IsAuthenticated, IsPersonalUser]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['status', 'priority', 'project']
    search_fields = ['title', 'description']
    ordering_fields = ['due_date', 'created_at', 'priority']
    ordering = ['-created_at']
    
    def get_queryset(self):
        # 非管理员只能看到自己的任务
        if not self.request.user.is_staff:
            person = Person.objects.get(user=self.request.user)
            return PersonTask.objects.filter(person=person)
        return super().get_queryset()
    
    def perform_create(self, serializer):
        if not self.request.user.is_staff:
            person = Person.objects.get(user=self.request.user)
            serializer.save(person=person)
        else:
            serializer.save()


class PersonTaskDetailView(generics.RetrieveUpdateDestroyAPIView):
    """个人任务详情"""
    queryset = PersonTask.objects.all()
    serializer_class = PersonTaskSerializer
    permission_classes = [permissions.IsAuthenticated, IsPersonalUser]
    
    def get_queryset(self):
        # 非管理员只能看到自己的任务
        if not self.request.user.is_staff:
            person = Person.objects.get(user=self.request.user)
            return PersonTask.objects.filter(person=person)
        return super().get_queryset()


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated, IsPersonalUser])
def complete_task(request, task_id):
    """完成任务"""
    try:
        person = Person.objects.get(user=request.user)
        task = PersonTask.objects.get(id=task_id, person=person)
        
        if task.status == 'completed':
            return Response({'error': '任务已完成'}, status=status.HTTP_400_BAD_REQUEST)
        
        task.status = 'completed'
        task.completed_at = timezone.now()
        task.save()
        
        # 更新个人统计
        statistics = PersonStatistics.objects.get(person=person)
        statistics.completed_tasks = PersonTask.objects.filter(person=person, status='completed').count()
        statistics.save()
        
        return Response({'message': '任务完成成功'})
    except Person.DoesNotExist:
        return Response({'error': '个人用户信息不存在'}, status=status.HTTP_404_NOT_FOUND)
    except PersonTask.DoesNotExist:
        return Response({'error': '任务不存在'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated, IsPersonalUser])
def update_project_progress(request, project_id):
    """更新项目进度"""
    try:
        person = Person.objects.get(user=request.user)
        project = PersonProject.objects.get(id=project_id, person=person)
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
        
        # 更新个人统计
        statistics = PersonStatistics.objects.get(person=person)
        statistics.completed_projects = PersonProject.objects.filter(
            person=person, status='completed'
        ).count()
        statistics.save()
        
        return Response({'message': '项目进度更新成功'})
    except Person.DoesNotExist:
        return Response({'error': '个人用户信息不存在'}, status=status.HTTP_404_NOT_FOUND)
    except PersonProject.DoesNotExist:
        return Response({'error': '项目不存在'}, status=status.HTTP_404_NOT_FOUND)


class PersonDocumentListCreateView(generics.ListCreateAPIView):
    """个人资质文件列表和创建"""
    queryset = PersonDocument.objects.all()
    serializer_class = PersonDocumentSerializer
    permission_classes = [permissions.IsAuthenticated, IsPersonalUser]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['document_type', 'is_public']
    search_fields = ['title', 'description']
    ordering_fields = ['created_at']
    ordering = ['-created_at']
    
    def get_queryset(self):
        # 非管理员只能看到自己的文档
        if not self.request.user.is_staff:
            person = Person.objects.get(user=self.request.user)
            return PersonDocument.objects.filter(person=person)
        return super().get_queryset()
    
    def perform_create(self, serializer):
        if not self.request.user.is_staff:
            person = Person.objects.get(user=self.request.user)
            serializer.save(person=person)
        else:
            serializer.save()


class PersonDocumentDetailView(generics.RetrieveUpdateDestroyAPIView):
    """个人资质文件详情"""
    queryset = PersonDocument.objects.all()
    serializer_class = PersonDocumentSerializer
    permission_classes = [permissions.IsAuthenticated, IsPersonalUser]
    
    def get_queryset(self):
        # 非管理员只能看到自己的文档
        if not self.request.user.is_staff:
            person = Person.objects.get(user=self.request.user)
            return PersonDocument.objects.filter(person=person)
        return super().get_queryset()


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated, IsPersonalUser])
def person_statistics(request):
    """个人统计数据"""
    try:
        person = Person.objects.get(user=request.user)
        statistics = PersonStatistics.objects.get(person=person)
        serializer = PersonStatisticsSerializer(statistics)
        return Response(serializer.data)
    except Person.DoesNotExist:
        return Response({'error': '个人用户信息不存在'}, status=status.HTTP_404_NOT_FOUND)
    except PersonStatistics.DoesNotExist:
        return Response({'error': '统计数据不存在'}, status=status.HTTP_404_NOT_FOUND)
