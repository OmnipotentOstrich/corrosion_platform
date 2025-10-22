#!/usr/bin/env python
"""
调试数据脚本
直接查询数据库数据
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from apps.info_plaza.models import InfoPost
from apps.resources.models import Resource
from apps.persons.models import PersonProject
from apps.enterprises.models import EnterpriseProject
from apps.persons.models import PersonTask
from apps.users.models import User

def check_data():
    print("="*60)
    print("数据库数据检查")
    print("="*60)
    
    # 用户数据
    total_users = User.objects.count()
    print(f"总用户数: {total_users}")
    
    # 信息帖子数据
    total_posts = InfoPost.objects.count()
    print(f"总信息数: {total_posts}")
    if total_posts > 0:
        posts = InfoPost.objects.all()[:3]
        for post in posts:
            print(f"  - {post.title} (状态: {post.status})")
    
    # 资源数据
    total_resources = Resource.objects.count()
    print(f"总资源数: {total_resources}")
    if total_resources > 0:
        resources = Resource.objects.all()[:3]
        for resource in resources:
            print(f"  - {resource.name} (公开: {resource.is_public})")
    
    # 项目数据
    total_person_projects = PersonProject.objects.count()
    total_enterprise_projects = EnterpriseProject.objects.count()
    print(f"个人项目数: {total_person_projects}")
    print(f"企业项目数: {total_enterprise_projects}")
    print(f"总项目数: {total_person_projects + total_enterprise_projects}")
    
    if total_person_projects > 0:
        person_projects = PersonProject.objects.all()[:3]
        for project in person_projects:
            print(f"  - 个人项目: {project.name}")
    
    if total_enterprise_projects > 0:
        enterprise_projects = EnterpriseProject.objects.all()[:3]
        for project in enterprise_projects:
            print(f"  - 企业项目: {project.name}")
    
    # 任务数据
    total_tasks = PersonTask.objects.count()
    pending_tasks = PersonTask.objects.filter(status__in=['pending', 'in_progress']).count()
    print(f"总任务数: {total_tasks}")
    print(f"待办任务数: {pending_tasks}")
    
    if total_tasks > 0:
        tasks = PersonTask.objects.all()[:3]
        for task in tasks:
            print(f"  - {task.title} (状态: {task.status})")
    
    print("="*60)
    print("数据检查完成")

if __name__ == "__main__":
    check_data()

