from django.urls import path
from . import views

urlpatterns = [
    # 个人用户信息管理
    path('', views.PersonListCreateView.as_view(), name='person_list_create'),
    path('<int:pk>/', views.PersonDetailView.as_view(), name='person_detail'),
    path('dashboard/', views.person_dashboard, name='person_dashboard'),
    path('statistics/', views.person_statistics, name='person_statistics'),
    
    # 个人项目管理
    path('projects/', views.PersonProjectListCreateView.as_view(), name='person_project_list_create'),
    path('projects/<int:pk>/', views.PersonProjectDetailView.as_view(), name='person_project_detail'),
    path('projects/<int:project_id>/progress/', views.update_project_progress, name='update_project_progress'),
    
    # 个人任务管理
    path('tasks/', views.PersonTaskListCreateView.as_view(), name='person_task_list_create'),
    path('tasks/<int:pk>/', views.PersonTaskDetailView.as_view(), name='person_task_detail'),
    path('tasks/<int:task_id>/complete/', views.complete_task, name='complete_task'),
    
    # 个人资质文件
    path('documents/', views.PersonDocumentListCreateView.as_view(), name='person_document_list_create'),
    path('documents/<int:pk>/', views.PersonDocumentDetailView.as_view(), name='person_document_detail'),
]
