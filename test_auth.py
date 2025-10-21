#!/usr/bin/env python
"""
测试认证API的脚本
"""
import requests
import json

# 后端API基础URL
BASE_URL = "http://localhost:8000/api/v1/auth"

def test_register():
    """测试用户注册"""
    print("测试用户注册...")
    
    register_data = {
        "username": "testuser",
        "email": "test@example.com",
        "phone": "13800138001",
        "first_name": "测试",
        "last_name": "用户",
        "user_type": "personal",
        "password": "test123456",
        "password_confirm": "test123456"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/register/", json=register_data)
        print(f"注册响应状态码: {response.status_code}")
        print(f"注册响应内容: {response.text}")
        
        if response.status_code == 201:
            print("✅ 注册成功")
            return True
        else:
            print("❌ 注册失败")
            return False
    except Exception as e:
        print(f"❌ 注册请求异常: {e}")
        return False

def test_login():
    """测试用户登录"""
    print("\n测试用户登录...")
    
    login_data = {
        "username": "testuser",
        "password": "test123456"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/login/", json=login_data)
        print(f"登录响应状态码: {response.status_code}")
        print(f"登录响应内容: {response.text}")
        
        if response.status_code == 200:
            print("✅ 登录成功")
            data = response.json()
            return data.get('access')
        else:
            print("❌ 登录失败")
            return None
    except Exception as e:
        print(f"❌ 登录请求异常: {e}")
        return None

def test_profile(access_token):
    """测试获取用户信息"""
    if not access_token:
        print("❌ 没有访问令牌，跳过用户信息测试")
        return
    
    print("\n测试获取用户信息...")
    
    headers = {
        "Authorization": f"Bearer {access_token}"
    }
    
    try:
        response = requests.get(f"{BASE_URL}/profile/", headers=headers)
        print(f"用户信息响应状态码: {response.status_code}")
        print(f"用户信息响应内容: {response.text}")
        
        if response.status_code == 200:
            print("✅ 获取用户信息成功")
        else:
            print("❌ 获取用户信息失败")
    except Exception as e:
        print(f"❌ 获取用户信息请求异常: {e}")

def test_admin_login():
    """测试管理员登录"""
    print("\n测试管理员登录...")
    
    login_data = {
        "username": "admin",
        "password": "admin123"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/login/", json=login_data)
        print(f"管理员登录响应状态码: {response.status_code}")
        print(f"管理员登录响应内容: {response.text}")
        
        if response.status_code == 200:
            print("✅ 管理员登录成功")
            return response.json().get('access')
        else:
            print("❌ 管理员登录失败")
            return None
    except Exception as e:
        print(f"❌ 管理员登录请求异常: {e}")
        return None

if __name__ == "__main__":
    print("开始测试认证API...")
    print("=" * 50)
    
    # 测试注册
    register_success = test_register()
    
    # 测试登录
    access_token = test_login()
    
    # 测试获取用户信息
    test_profile(access_token)
    
    # 测试管理员登录
    admin_token = test_admin_login()
    
    print("\n" + "=" * 50)
    print("测试完成")
