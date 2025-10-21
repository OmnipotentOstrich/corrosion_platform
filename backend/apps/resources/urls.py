from django.urls import path
from . import views

urlpatterns = [
    # 资源类型管理
    path('types/', views.ResourceTypeListCreateView.as_view(), name='resource_type_list_create'),
    path('types/<int:pk>/', views.ResourceTypeDetailView.as_view(), name='resource_type_detail'),
    
    # 资源管理
    path('', views.ResourceListCreateView.as_view(), name='resource_list_create'),
    path('<int:pk>/', views.ResourceDetailView.as_view(), name='resource_detail'),
    path('my-resources/', views.my_resources, name='my_resources'),
    path('available/', views.available_resources, name='available_resources'),
    path('rental/', views.rental_resources, name='rental_resources'),
    path('search/', views.search_resources, name='search_resources'),
    
    # 资源使用日志
    path('usage-logs/', views.ResourceUsageLogListCreateView.as_view(), name='resource_usage_log_list_create'),
    
    # 资源维护记录
    path('maintenances/', views.ResourceMaintenanceListCreateView.as_view(), name='resource_maintenance_list_create'),
    
    # 资源申请
    path('requests/', views.ResourceRequestListCreateView.as_view(), name='resource_request_list_create'),
    path('requests/<int:pk>/', views.ResourceRequestDetailView.as_view(), name='resource_request_detail'),
    path('requests/<int:request_id>/approve/', views.approve_request, name='approve_request'),
    path('my-requests/', views.my_requests, name='my_requests'),
    
    # 资源统计
    path('statistics/', views.resource_statistics, name='resource_statistics'),
]
