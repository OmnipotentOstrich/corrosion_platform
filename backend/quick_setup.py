#!/usr/bin/env python
"""
一键快速初始化脚本
包含：数据库迁移、初始化角色菜单、创建测试用户
"""
import os
import sys
import django
import subprocess

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

def run_command(command, description):
    """运行命令并显示结果"""
    print("\n" + "="*60)
    print(f"执行: {description}")
    print("="*60)
    
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    
    if result.returncode == 0:
        print(f"✓ {description} 成功")
        if result.stdout:
            print(result.stdout)
    else:
        print(f"✗ {description} 失败")
        if result.stderr:
            print(result.stderr)
        return False
    
    return True

def quick_setup():
    """快速初始化"""
    print("\n" + "="*60)
    print("防腐保温智能数字平台 - 快速初始化")
    print("="*60)
    
    # 检查是否在正确的目录
    if not os.path.exists('manage.py'):
        print("✗ 错误：请在backend目录下运行此脚本")
        sys.exit(1)
    
    # 1. 数据库迁移
    print("\n【步骤 1/3】数据库迁移")
    if not run_command('python manage.py migrate', '数据库迁移'):
        print("✗ 数据库迁移失败，请检查数据库配置")
        return False
    
    # 2. 初始化角色和菜单
    print("\n【步骤 2/3】初始化角色和菜单")
    try:
        from init_database import main as init_db
        init_db()
    except Exception as e:
        print(f"✗ 初始化角色和菜单失败: {e}")
        return False
    
    # 3. 创建测试用户
    print("\n【步骤 3/3】创建测试用户")
    try:
        from create_test_users import create_test_users
        create_test_users()
    except Exception as e:
        print(f"✗ 创建测试用户失败: {e}")
        return False
    
    print("\n" + "="*60)
    print("✓ 初始化完成！")
    print("="*60)
    print("\n测试账号：")
    print("  管理员:   admin / admin123")
    print("  企业用户: enterprise / enterprise123")
    print("  个人用户: user / user123")
    print("\n启动服务：")
    print("  python manage.py runserver")
    print("\n访问地址：")
    print("  前端: http://localhost:5173")
    print("  后端: http://localhost:8000")
    print("  API文档: http://localhost:8000/swagger/")
    print("="*60)
    
    return True

if __name__ == "__main__":
    success = quick_setup()
    sys.exit(0 if success else 1)


