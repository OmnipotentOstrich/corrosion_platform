#!/usr/bin/env python
"""
修复menus表的description字段
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

def fix_menus_table():
    """修复menus表"""
    print("修复menus表...")
    
    with connection.cursor() as cursor:
        # 添加 description 字段
        try:
            cursor.execute("ALTER TABLE `menus` ADD COLUMN `description` longtext")
            print("✓ 添加 description 字段成功")
        except Exception as e:
            print(f"⚠ description: {str(e)[:80]}")
    
    print("修复完成！")

if __name__ == '__main__':
    try:
        fix_menus_table()
    except Exception as e:
        print(f"\n❌ 操作失败: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
