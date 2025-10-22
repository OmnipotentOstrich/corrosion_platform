#!/usr/bin/env python
"""
为没有企业的企业用户自动创建企业
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

def create_enterprises_for_users():
    """为没有企业的企业用户创建企业"""
    print("开始为企业用户创建企业...")
    
    # 获取所有企业用户
    enterprise_users = User.objects.filter(user_type='enterprise')
    created_count = 0
    
    for user in enterprise_users:
        # 检查是否已有企业
        if Enterprise.objects.filter(user=user).exists():
            print(f"✓ {user.username} 已有关联企业，跳过")
            continue
        
        # 创建企业
        enterprise_name = f"{user.username}的企业"
        if user.first_name:
            enterprise_name = f"{user.first_name}的企业"
        
        enterprise = Enterprise.objects.create(
            user=user,
            name=enterprise_name,
            short_name=enterprise_name[:20],
            enterprise_type='other',
            unified_social_credit_code=f'USC{user.id:010d}',
            legal_representative=user.first_name or user.username,
            contact_person=user.first_name or user.username,
            contact_phone=user.phone or '未设置',
            contact_email=user.email,
            address='未设置',
            status='approved',
            is_active=True
        )
        
        print(f"✅ 为用户 {user.username} 创建企业: {enterprise.name}")
        created_count += 1
    
    print(f"\n完成！共为 {created_count} 个用户创建了企业")
    print(f"现在所有企业用户都有对应的企业了！")

if __name__ == '__main__':
    try:
        create_enterprises_for_users()
    except Exception as e:
        print(f"\n❌ 操作失败: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
