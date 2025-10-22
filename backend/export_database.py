#!/usr/bin/env python
"""
导出数据库结构和数据的脚本
"""
import os
import sys
import subprocess
from datetime import datetime

# 添加项目路径到sys.path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# 设置Django环境
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

import django
django.setup()

from django.conf import settings

def export_database():
    """导出数据库"""
    print("开始导出数据库...")
    
    # 获取数据库配置
    db_config = settings.DATABASES['default']
    db_name = db_config['NAME']
    db_user = db_config['USER']
    db_password = db_config['PASSWORD']
    db_host = db_config['HOST']
    db_port = db_config['PORT']
    
    # 生成文件名
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    
    # 导出数据库结构
    schema_file = f'../database_schema_{timestamp}.sql'
    print(f"\n1. 导出数据库结构到: {schema_file}")
    
    schema_cmd = f'mysqldump -h {db_host} -P {db_port} -u {db_user} -p{db_password} --no-data {db_name} > {schema_file}'
    
    # 导出完整数据库（结构+数据）
    full_file = f'../database_full_{timestamp}.sql'
    print(f"2. 导出完整数据库到: {full_file}")
    
    full_cmd = f'mysqldump -h {db_host} -P {db_port} -u {db_user} -p{db_password} {db_name} > {full_file}'
    
    # 导出仅结构（无数据）
    structure_file = f'../database_structure_only_{timestamp}.sql'
    print(f"3. 导出数据库结构（仅表结构）到: {structure_file}")
    
    structure_cmd = f'mysqldump -h {db_host} -P {db_port} -u {db_user} -p{db_password} --no-data --skip-add-drop-table {db_name} > {structure_file}'
    
    print("\n正在导出，请稍候...")
    print(f"\n数据库信息:")
    print(f"  数据库名: {db_name}")
    print(f"  主机: {db_host}:{db_port}")
    print(f"  用户: {db_user}")
    
    print("\n如果您安装了mysqldump，请手动运行以下命令:")
    print(f"\n1. 导出数据库结构:")
    print(f"   {schema_cmd}")
    print(f"\n2. 导出完整数据库:")
    print(f"   {full_cmd}")
    print(f"\n3. 导出仅结构:")
    print(f"   {structure_cmd}")
    
    print("\n或者使用数据库管理工具（如Navicat、phpMyAdmin）进行导出")

if __name__ == '__main__':
    try:
        export_database()
    except Exception as e:
        print(f"\n❌ 导出失败: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)




