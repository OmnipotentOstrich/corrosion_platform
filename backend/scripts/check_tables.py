#!/usr/bin/env python
"""
检查数据库表脚本
"""
import os
import sys

# 添加项目路径到sys.path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# 设置Django环境
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

import django
django.setup()

from django.db import connection

def check_tables():
    """检查数据库表"""
    with connection.cursor() as cursor:
        # 检查所有表
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        
        print(f"数据库中的所有表 (共{len(tables)}个):")
        for table in tables:
            print(f"  - {table[0]}")
        
        # 检查users相关的表
        print("\nusers应用相关的表:")
        users_tables = [t[0] for t in tables if 'user' in t[0].lower()]
        for table in users_tables:
            print(f"  - {table}")
        
        # 检查system相关的表
        print("\nsystem应用相关的表:")
        system_tables = [t[0] for t in tables if 'system' in t[0].lower()]
        for table in system_tables:
            print(f"  - {table}")

if __name__ == '__main__':
    try:
        check_tables()
    except Exception as e:
        print(f"\n❌ 检查失败: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
