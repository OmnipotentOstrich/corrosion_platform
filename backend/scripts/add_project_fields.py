#!/usr/bin/env python
"""
为enterprise_projects表添加新字段
"""
import os
import sys

# 添加项目路径到sys.path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# 设置Django环境
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

import django
django.setup()

from django.db import connection

def add_project_fields():
    """添加项目表的新字段"""
    print("开始为enterprise_projects表添加新字段...")
    
    with connection.cursor() as cursor:
        # 添加 project_code 字段
        try:
            cursor.execute("ALTER TABLE `enterprise_projects` ADD COLUMN `project_code` varchar(50) NOT NULL DEFAULT ''")
            print("✓ 添加 project_code 字段")
        except Exception as e:
            print(f"⚠ project_code: {str(e)[:80]}")
        
        # 添加 project_type 字段
        try:
            cursor.execute("ALTER TABLE `enterprise_projects` ADD COLUMN `project_type` varchar(20) NOT NULL DEFAULT 'other'")
            print("✓ 添加 project_type 字段")
        except Exception as e:
            print(f"⚠ project_type: {str(e)[:80]}")
        
        # 添加 manager 字段
        try:
            cursor.execute("ALTER TABLE `enterprise_projects` ADD COLUMN `manager` varchar(100) NOT NULL DEFAULT ''")
            print("✓ 添加 manager 字段")
        except Exception as e:
            print(f"⚠ manager: {str(e)[:80]}")
        
        # 添加 budget 字段
        try:
            cursor.execute("ALTER TABLE `enterprise_projects` ADD COLUMN `budget` decimal(15,2) DEFAULT NULL")
            print("✓ 添加 budget 字段")
        except Exception as e:
            print(f"⚠ budget: {str(e)[:80]}")
        
        # 添加 contact_phone 字段
        try:
            cursor.execute("ALTER TABLE `enterprise_projects` ADD COLUMN `contact_phone` varchar(20) NOT NULL DEFAULT ''")
            print("✓ 添加 contact_phone 字段")
        except Exception as e:
            print(f"⚠ contact_phone: {str(e)[:80]}")
        
        # 添加 notes 字段
        try:
            cursor.execute("ALTER TABLE `enterprise_projects` ADD COLUMN `notes` longtext")
            print("✓ 添加 notes 字段")
        except Exception as e:
            print(f"⚠ notes: {str(e)[:80]}")
        
        # 修改 status 字段的CHOICES
        print("\n注意: status字段的选项值已更新，请确保数据一致性")
        print("  旧值: planning, in_progress, suspended")
        print("  新值: pending, active, paused")
        
        # 更新现有数据的status值
        try:
            cursor.execute("UPDATE `enterprise_projects` SET `status` = 'pending' WHERE `status` = 'planning'")
            print("✓ 更新 planning → pending")
        except Exception as e:
            print(f"⚠ 更新status: {str(e)[:80]}")
        
        try:
            cursor.execute("UPDATE `enterprise_projects` SET `status` = 'active' WHERE `status` = 'in_progress'")
            print("✓ 更新 in_progress → active")
        except Exception as e:
            print(f"⚠ 更新status: {str(e)[:80]}")
        
        try:
            cursor.execute("UPDATE `enterprise_projects` SET `status` = 'paused' WHERE `status` = 'suspended'")
            print("✓ 更新 suspended → paused")
        except Exception as e:
            print(f"⚠ 更新status: {str(e)[:80]}")
    
    print("\n所有字段添加完成！")

if __name__ == '__main__':
    try:
        add_project_fields()
    except Exception as e:
        print(f"\n❌ 操作失败: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

