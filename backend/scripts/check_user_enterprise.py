#!/usr/bin/env python
"""
检查用户是否有对应的企业
"""
import os
import sys

# 添加项目路径到sys.path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# 设置Django环境
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

import django
django.setup()

from apps.users.models import User
from apps.enterprises.models import Enterprise

def check_user_enterprise():
    """检查用户和企业的关联"""
    print("检查用户和企业的关联关系...")
    
    # 获取所有企业用户
    enterprise_users = User.objects.filter(user_type='enterprise')
    print(f"\n找到 {enterprise_users.count()} 个企业用户")
    
    for user in enterprise_users:
        print(f"\n用户: {user.username} (ID: {user.id})")
        print(f"  邮箱: {user.email}")
        print(f"  类型: {user.user_type}")
        
        # 检查是否有对应的企业
        try:
            enterprise = Enterprise.objects.get(user=user)
            print(f"  ✅ 关联企业: {enterprise.name} (ID: {enterprise.id})")
        except Enterprise.DoesNotExist:
            print(f"  ❌ 没有关联的企业！")
            print(f"  建议: 需要为该用户创建企业")
    
    # 检查所有企业
    print(f"\n\n所有企业列表:")
    enterprises = Enterprise.objects.all()
    print(f"找到 {enterprises.count()} 个企业")
    
    for enterprise in enterprises:
        print(f"\n企业: {enterprise.name} (ID: {enterprise.id})")
        if enterprise.user:
            print(f"  关联用户: {enterprise.user.username}")
        else:
            print(f"  ❌ 没有关联用户")

if __name__ == '__main__':
    try:
        check_user_enterprise()
    except Exception as e:
        print(f"\n❌ 检查失败: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)




