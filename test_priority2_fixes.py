#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
优先级2修复功能测试脚本
测试资源管理和信息发布功能
"""

import requests
import json

BASE_URL = 'http://localhost:8000/api/v1'

class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

def print_header(text):
    print(f"\n{Colors.BOLD}{Colors.BLUE}{'='*60}{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.BLUE}{text.center(60)}{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.BLUE}{'='*60}{Colors.RESET}\n")

def print_test(name, success, details=""):
    icon = f"{Colors.GREEN}✓{Colors.RESET}" if success else f"{Colors.RED}✗{Colors.RESET}"
    print(f"{icon} {name}")
    if details:
        print(f"  {details}")

def test_login():
    """测试登录并获取token"""
    print_header("步骤1: 登录获取Token")
    
    try:
        response = requests.post(
            f"{BASE_URL}/auth/login/",
            json={'username': 'admin', 'password': 'admin123'},
            timeout=5
        )
        
        if response.status_code == 200:
            data = response.json()
            token = data.get('access')
            print_test("管理员登录", True, f"Token: {token[:30]}...")
            return token
        else:
            print_test("管理员登录", False, f"状态码: {response.status_code}")
            return None
    except Exception as e:
        print_test("管理员登录", False, str(e))
        return None

def test_resources_api(token):
    """测试资源管理API"""
    print_header("步骤2: 测试资源管理API")
    
    headers = {'Authorization': f'Bearer {token}'}
    
    # 测试1: 获取资源列表
    try:
        response = requests.get(f"{BASE_URL}/resources/", headers=headers, timeout=5)
        if response.status_code == 200:
            data = response.json()
            count = len(data.get('results', data) if isinstance(data, dict) else data)
            print_test("获取资源列表", True, f"返回 {count} 个资源")
        else:
            print_test("获取资源列表", False, f"状态码: {response.status_code}")
    except Exception as e:
        print_test("获取资源列表", False, str(e))
    
    # 测试2: 带搜索参数的请求
    try:
        response = requests.get(
            f"{BASE_URL}/resources/",
            headers=headers,
            params={'search': '测试'},
            timeout=5
        )
        if response.status_code == 200:
            print_test("资源搜索功能", True, "搜索参数正确传递")
        else:
            print_test("资源搜索功能", False, f"状态码: {response.status_code}")
    except Exception as e:
        print_test("资源搜索功能", False, str(e))
    
    # 测试3: 带类型筛选的请求
    try:
        response = requests.get(
            f"{BASE_URL}/resources/",
            headers=headers,
            params={'resource_type': 'document'},
            timeout=5
        )
        if response.status_code == 200:
            print_test("资源类型筛选", True, "类型筛选参数正确传递")
        else:
            print_test("资源类型筛选", False, f"状态码: {response.status_code}")
    except Exception as e:
        print_test("资源类型筛选", False, str(e))

def test_info_plaza_api(token):
    """测试信息广场API"""
    print_header("步骤3: 测试信息广场API")
    
    headers = {'Authorization': f'Bearer {token}', 'Content-Type': 'application/json'}
    
    # 测试1: 获取分类列表
    try:
        response = requests.get(f"{BASE_URL}/info-plaza/categories/", headers=headers, timeout=5)
        if response.status_code == 200:
            data = response.json()
            count = len(data.get('results', data) if isinstance(data, dict) else data)
            print_test("获取分类列表", True, f"返回 {count} 个分类")
        else:
            print_test("获取分类列表", False, f"状态码: {response.status_code}")
    except Exception as e:
        print_test("获取分类列表", False, str(e))
    
    # 测试2: 获取标签列表
    try:
        response = requests.get(f"{BASE_URL}/info-plaza/tags/", headers=headers, timeout=5)
        if response.status_code == 200:
            data = response.json()
            count = len(data.get('results', data) if isinstance(data, dict) else data)
            print_test("获取标签列表", True, f"返回 {count} 个标签")
        else:
            print_test("获取标签列表", False, f"状态码: {response.status_code}")
    except Exception as e:
        print_test("获取标签列表", False, str(e))
    
    # 测试3: 发布信息（创建测试信息）
    try:
        test_post = {
            'title': '测试信息 - API测试',
            'post_type': 'technology',
            'content': '这是一个自动化测试发布的信息',
            'summary': '测试摘要',
        }
        
        response = requests.post(
            f"{BASE_URL}/info-plaza/posts/",
            headers=headers,
            json=test_post,
            timeout=5
        )
        
        if response.status_code in [200, 201]:
            data = response.json()
            post_id = data.get('id')
            print_test("发布信息", True, f"成功创建信息 ID: {post_id}")
            return post_id
        else:
            error_msg = response.text[:100]
            print_test("发布信息", False, f"状态码: {response.status_code}, 错误: {error_msg}")
            return None
    except Exception as e:
        print_test("发布信息", False, str(e))
        return None

def test_frontend_pages():
    """测试前端页面是否可访问"""
    print_header("步骤4: 测试前端页面")
    
    frontend_url = 'http://localhost:5173'
    
    pages = [
        ('/dashboard/resources', '资源管理页面'),
        ('/dashboard/info-plaza/publish', '信息发布页面'),
    ]
    
    for path, name in pages:
        try:
            response = requests.get(f"{frontend_url}{path}", timeout=5)
            if response.status_code == 200:
                print_test(name, True, f"页面可访问")
            else:
                print_test(name, False, f"状态码: {response.status_code}")
        except Exception as e:
            print_test(name, False, "前端服务未运行")

def generate_manual_test_instructions():
    """生成手动测试说明"""
    print_header("手动测试步骤")
    
    print(f"{Colors.YELLOW}1. 测试资源管理页面:{Colors.RESET}")
    print("   a. 访问: http://localhost:5173/dashboard/resources")
    print("   b. 打开开发者工具 (F12) -> Network标签")
    print("   c. 观察是否有请求: GET /api/v1/resources/")
    print("   d. 测试搜索功能")
    print("   e. 测试类型筛选")
    print("   f. 测试分类筛选\n")
    
    print(f"{Colors.YELLOW}2. 测试信息发布页面:{Colors.RESET}")
    print("   a. 访问: http://localhost:5173/dashboard/info-plaza/publish")
    print("   b. 打开开发者工具 (F12) -> Network标签")
    print("   c. 观察是否有请求:")
    print("      - GET /api/v1/info-plaza/categories/")
    print("      - GET /api/v1/info-plaza/tags/")
    print("   d. 填写表单:")
    print("      - 标题: 测试信息")
    print("      - 类型: 技术文章")
    print("      - 内容: 测试内容")
    print("   e. 点击发布")
    print("   f. 观察是否有请求: POST /api/v1/info-plaza/posts/")
    print("   g. 检查是否跳转到信息广场\n")

def main():
    print(f"\n{Colors.BOLD}{'*'*60}{Colors.RESET}")
    print(f"{Colors.BOLD}{'*':<10}{'优先级2功能测试':^40}{'*':>10}{Colors.RESET}")
    print(f"{Colors.BOLD}{'*'*60}{Colors.RESET}\n")
    
    print("测试内容:")
    print("  1. 资源管理API对接")
    print("  2. 信息发布API对接")
    print("  3. 前端页面可访问性\n")
    
    # 检查后端服务
    try:
        response = requests.get(f"{BASE_URL.replace('/api/v1', '')}/swagger/", timeout=2)
        if response.status_code != 200:
            raise Exception()
    except:
        print(f"{Colors.RED}错误: 后端服务未运行{Colors.RESET}")
        print("请先启动后端服务:")
        print("  cd backend")
        print("  python manage.py runserver\n")
        generate_manual_test_instructions()
        return
    
    # 测试登录
    token = test_login()
    if not token:
        print(f"\n{Colors.RED}无法获取token，测试终止{Colors.RESET}")
        return
    
    # 测试资源管理API
    test_resources_api(token)
    
    # 测试信息广场API
    test_info_plaza_api(token)
    
    # 测试前端页面
    test_frontend_pages()
    
    # 显示手动测试说明
    generate_manual_test_instructions()
    
    print_header("测试完成")
    print(f"{Colors.GREEN}所有自动化测试已完成!{Colors.RESET}")
    print(f"{Colors.YELLOW}请按照上述手动测试步骤在浏览器中验证前端功能{Colors.RESET}\n")

if __name__ == '__main__':
    main()



