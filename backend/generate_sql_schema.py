#!/usr/bin/env python
"""
生成数据库SQL schema文件
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
from datetime import datetime

def generate_sql_schema():
    """生成SQL schema"""
    print("开始生成数据库SQL schema...")
    
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    output_file = f'../database_schema_{timestamp}.sql'
    
    with connection.cursor() as cursor:
        # 获取所有表
        cursor.execute("SHOW TABLES")
        tables = [table[0] for table in cursor.fetchall()]
        
        print(f"\n找到 {len(tables)} 个表")
        
        sql_content = []
        sql_content.append("-- ========================================")
        sql_content.append("-- 防腐保温智能数字平台 v2.0 数据库结构")
        sql_content.append(f"-- 生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        sql_content.append("-- 数据库: corrosion_platform")
        sql_content.append("-- ========================================\n")
        
        sql_content.append("SET NAMES utf8mb4;")
        sql_content.append("SET FOREIGN_KEY_CHECKS = 0;\n")
        
        # 为每个表生成CREATE TABLE语句
        for table_name in sorted(tables):
            print(f"  导出表: {table_name}")
            
            # 获取CREATE TABLE语句
            cursor.execute(f"SHOW CREATE TABLE `{table_name}`")
            create_table = cursor.fetchone()[1]
            
            sql_content.append(f"-- ----------------------------")
            sql_content.append(f"-- Table structure for {table_name}")
            sql_content.append(f"-- ----------------------------")
            sql_content.append(f"DROP TABLE IF EXISTS `{table_name}`;")
            sql_content.append(create_table + ";")
            sql_content.append("")
        
        sql_content.append("\nSET FOREIGN_KEY_CHECKS = 1;")
        
        # 写入文件
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write('\n'.join(sql_content))
        
        print(f"\n✓ 数据库结构已导出到: {output_file}")
        print(f"✓ 总共导出 {len(tables)} 个表")
        
        # 生成表列表
        print(f"\n表列表:")
        for i, table in enumerate(sorted(tables), 1):
            print(f"  {i}. {table}")
        
        return output_file

if __name__ == '__main__':
    try:
        output_file = generate_sql_schema()
        print(f"\n🎉 数据库结构导出成功！")
        print(f"文件位置: {os.path.abspath(output_file)}")
    except Exception as e:
        print(f"\n❌ 导出失败: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
