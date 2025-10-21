from django.urls import path
from . import views

urlpatterns = [
    # 企业信息管理
    path('', views.EnterpriseListCreateView.as_view(), name='enterprise_list_create'),
    path('<int:pk>/', views.EnterpriseDetailView.as_view(), name='enterprise_detail'),
    path('dashboard/', views.enterprise_dashboard, name='enterprise_dashboard'),
    path('statistics/', views.enterprise_statistics, name='enterprise_statistics'),
    
    # 企业资质文件
    path('documents/', views.EnterpriseDocumentListCreateView.as_view(), name='enterprise_document_list_create'),
    path('documents/<int:pk>/', views.EnterpriseDocumentDetailView.as_view(), name='enterprise_document_detail'),
    path('documents/<int:document_id>/verify/', views.verify_document, name='verify_document'),
    
    # 企业员工管理
    path('employees/', views.EmployeeListCreateView.as_view(), name='employee_list_create'),
    path('employees/<int:pk>/', views.EmployeeDetailView.as_view(), name='employee_detail'),
    
    # 企业项目管理
    path('projects/', views.EnterpriseProjectListCreateView.as_view(), name='enterprise_project_list_create'),
    path('projects/<int:pk>/', views.EnterpriseProjectDetailView.as_view(), name='enterprise_project_detail'),
    path('projects/<int:project_id>/progress/', views.update_project_progress, name='update_project_progress'),
]
