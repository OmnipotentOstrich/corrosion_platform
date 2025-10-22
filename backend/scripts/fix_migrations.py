#!/usr/bin/env python
"""
修复迁移历史脚本
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
from django.utils import timezone

def fix_migration_history():
    """修复迁移历史"""
    print("开始修复迁移历史...")
    
    with connection.cursor() as cursor:
        # 检查当前的迁移记录
        print("\n1. 检查当前的迁移记录...")
        cursor.execute("""
            SELECT app, name FROM django_migrations 
            WHERE app IN ('admin', 'auth', 'users')
            ORDER BY app, name
        """)
        migrations = cursor.fetchall()
        
        print(f"当前有 {len(migrations)} 个相关迁移记录:")
        for migration in migrations:
            print(f"  - {migration[0]}.{migration[1]}")
        
        # 检查是否有users的迁移记录
        print("\n2. 检查users应用的迁移记录...")
        cursor.execute("""
            SELECT COUNT(*) FROM django_migrations 
            WHERE app = 'users'
        """)
        users_count = cursor.fetchone()[0]
        
        if users_count == 0:
            print("   users应用没有迁移记录，正在添加...")
            cursor.execute("""
                INSERT INTO django_migrations (app, name, applied)
                VALUES ('users', '0001_initial', %s)
            """, [timezone.now()])
            print("   ✓ 已添加 users.0001_initial 迁移记录")
        else:
            print(f"   users应用已有 {users_count} 个迁移记录，无需添加")
        
        # 再次检查迁移记录
        print("\n3. 验证修复结果...")
        cursor.execute("""
            SELECT app, name FROM django_migrations 
            WHERE app = 'users'
            ORDER BY name
        """)
        users_migrations = cursor.fetchall()
        
        print("users应用的迁移记录:")
        for migration in users_migrations:
            print(f"  ✓ {migration[0]}.{migration[1]}")
        
        print("\n迁移历史修复完成！")
        print("\n下一步请运行:")
        print("  python manage.py makemigrations system")
        print("  python manage.py migrate")

if __name__ == '__main__':
    try:
        fix_migration_history()
    except Exception as e:
        print(f"\n❌ 修复失败: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
