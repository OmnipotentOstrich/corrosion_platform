from django.urls import path
from . import views

urlpatterns = [
    # 信息分类管理
    path('categories/', views.InfoCategoryListCreateView.as_view(), name='info_category_list_create'),
    path('categories/<int:pk>/', views.InfoCategoryDetailView.as_view(), name='info_category_detail'),
    
    # 信息标签管理
    path('tags/', views.InfoTagListCreateView.as_view(), name='info_tag_list_create'),
    
    # 信息发布管理
    path('posts/', views.InfoPostListCreateView.as_view(), name='info_post_list_create'),
    path('posts/<int:pk>/', views.InfoPostDetailView.as_view(), name='info_post_detail'),
    path('posts/<int:post_id>/publish/', views.publish_post, name='publish_post'),
    path('posts/<int:post_id>/like/', views.like_post, name='like_post'),
    path('posts/<int:post_id>/favorite/', views.favorite_post, name='favorite_post'),
    
    # 信息评论管理
    path('comments/', views.InfoCommentListCreateView.as_view(), name='info_comment_list_create'),
    path('comments/<int:pk>/', views.InfoCommentDetailView.as_view(), name='info_comment_detail'),
    
    # 个人相关
    path('my-posts/', views.my_posts, name='my_posts'),
    path('my-favorites/', views.my_favorites, name='my_favorites'),
    
    # 推荐和搜索
    path('hot-posts/', views.hot_posts, name='hot_posts'),
    path('recommended-posts/', views.recommended_posts, name='recommended_posts'),
    path('search/', views.search_posts, name='search_posts'),
]
