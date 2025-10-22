#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
快速API测试脚本
"""

import requests
import json

BASE_URL = 'http://localhost:8000/api/v1'

def test_backend_connection():
    """测试后端连接"""
    print("=" * 60)
    print("测试后端服务连接...")
    print("=" * 60)
    
    try:
        response = requests.get(f"{BASE_URL.replace('/api/v1', '')}/swagger/", timeout=5)
        if response.status_code == 200:
            print("✓ 后端服务正常运行")
            print(f"  Swagger文档: {BASE_URL.replace('/api/v1', '')}/swagger/")
            return True
        else:
            print(f"✗ 后端响应异常: {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("✗ 无法连接到后端服务")
        print(f"  请确保后端服务正在运行: http://localhost:8000")
        return False
    except Exception as e:
        print(f"✗ 连接测试失败: {str(e)}")
        return False

def test_login():
    """测试登录"""
    print("\n" + "=" * 60)
    print("测试登录接口...")
    print("=" * 60)
    
    accounts = {
        'admin': {'username': 'admin', 'password': 'admin123'},
        'enterprise': {'username': 'enterprise', 'password': 'enterprise123'},
        'personal': {'username': 'user', 'password': 'user123'}
    }
    
    tokens = {}
    
    for role, credentials in accounts.items():
        try:
            response = requests.post(
                f"{BASE_URL}/auth/login/",
                json=credentials,
                headers={'Content-Type': 'application/json'},
                timeout=5
            )
            
            if response.status_code == 200:
                data = response.json()
                if 'access' in data:
                    tokens[role] = data['access']
                    print(f"✓ {role:12} 登录成功")
                    print(f"  用户: {data.get('user', {}).get('username', 'N/A')}")
                    print(f"  Token: {data['access'][:30]}...")
                else:
                    print(f"✗ {role:12} 登录失败: 响应缺少access token")
            else:
                print(f"✗ {role:12} 登录失败: HTTP {response.status_code}")
                print(f"  错误: {response.text[:100]}")
                
        except Exception as e:
            print(f"✗ {role:12} 登录异常: {str(e)}")
    
    return tokens

def test_endpoints(token):
    """测试常用端点"""
    print("\n" + "=" * 60)
    print("测试常用API端点...")
    print("=" * 60)
    
    endpoints = [
        ('GET', '/auth/profile/', '获取用户信息'),
        ('GET', '/auth/user-menus/', '获取用户菜单'),
        ('GET', '/dashboard/statistics/', '仪表板统计'),
        ('GET', '/enterprises/statistics/', '企业统计'),
        ('GET', '/enterprises/projects/', '企业项目列表'),
        ('GET', '/persons/statistics/', '个人统计'),
        ('GET', '/persons/projects/', '个人项目列表'),
        ('GET', '/persons/tasks/', '个人任务列表'),
        ('GET', '/info-plaza/posts/', '信息广场列表'),
        ('GET', '/resources/', '资源列表'),
    ]
    
    headers = {'Authorization': f'Bearer {token}'}
    
    success_count = 0
    fail_count = 0
    
    for method, endpoint, name in endpoints:
        try:
            response = requests.get(f"{BASE_URL}{endpoint}", headers=headers, timeout=5)
            
            if response.status_code == 200:
                print(f"✓ {name:20} - {method} {endpoint}")
                success_count += 1
            else:
                print(f"✗ {name:20} - HTTP {response.status_code}")
                fail_count += 1
                
        except Exception as e:
            print(f"✗ {name:20} - 异常: {str(e)[:50]}")
            fail_count += 1
    
    print(f"\n结果: {success_count}个成功, {fail_count}个失败")
    return success_count, fail_count

def main():
    print("\n")
    print("*" * 60)
    print("*" + " " * 15 + "前后端接口快速测试" + " " * 16 + "*")
    print("*" * 60)
    
    # 1. 测试后端连接
    if not test_backend_connection():
        print("\n请先启动后端服务:")
        print("  cd backend")
        print("  python manage.py runserver")
        return
    
    # 2. 测试登录
    tokens = test_login()
    
    if not tokens:
        print("\n所有账号登录失败，无法继续测试")
        return
    
    # 3. 使用admin token测试端点
    if 'admin' in tokens:
        test_endpoints(tokens['admin'])
    else:
        print("\n无法获取admin token，跳过端点测试")
    
    print("\n" + "=" * 60)
    print("测试完成!")
    print("=" * 60)
    print("\n详细测试请运行: python test_api_integration.py")
    print("浏览器测试请参考: 浏览器端接口测试指南.md")

if __name__ == '__main__':
    main()




