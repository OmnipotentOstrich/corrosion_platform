#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
前后端接口集成测试脚本
用于验证所有前端调用的后端API是否正常工作
"""

import requests
import json
import sys
from datetime import datetime
from typing import Dict, List, Tuple

# 配置
BASE_URL = 'http://localhost:8000/api/v1'
FRONTEND_URL = 'http://localhost:5173'

# 测试账号
TEST_ACCOUNTS = {
    'admin': {'username': 'admin', 'password': 'admin123'},
    'enterprise': {'username': 'enterprise', 'password': 'enterprise123'},
    'personal': {'username': 'user', 'password': 'user123'}
}

class Colors:
    """终端颜色"""
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

class APITester:
    """API测试器"""
    
    def __init__(self):
        self.results = []
        self.tokens = {}
        self.session = requests.Session()
        
    def print_header(self, text: str):
        """打印标题"""
        print(f"\n{Colors.BOLD}{Colors.BLUE}{'='*80}{Colors.RESET}")
        print(f"{Colors.BOLD}{Colors.BLUE}{text.center(80)}{Colors.RESET}")
        print(f"{Colors.BOLD}{Colors.BLUE}{'='*80}{Colors.RESET}\n")
        
    def print_section(self, text: str):
        """打印章节"""
        print(f"\n{Colors.BOLD}{Colors.YELLOW}{'-'*80}{Colors.RESET}")
        print(f"{Colors.BOLD}{Colors.YELLOW}{text}{Colors.RESET}")
        print(f"{Colors.BOLD}{Colors.YELLOW}{'-'*80}{Colors.RESET}")
        
    def print_test(self, name: str, status: bool, details: str = ""):
        """打印测试结果"""
        status_icon = f"{Colors.GREEN}✓{Colors.RESET}" if status else f"{Colors.RED}✗{Colors.RESET}"
        print(f"{status_icon} {name}")
        if details:
            print(f"  {details}")
            
    def test_endpoint(self, method: str, endpoint: str, name: str, 
                     token: str = None, data: Dict = None, 
                     expected_status: int = 200) -> bool:
        """测试单个端点"""
        url = f"{BASE_URL}{endpoint}"
        headers = {}
        
        if token:
            headers['Authorization'] = f'Bearer {token}'
            
        try:
            if method == 'GET':
                response = self.session.get(url, headers=headers)
            elif method == 'POST':
                headers['Content-Type'] = 'application/json'
                response = self.session.post(url, headers=headers, json=data)
            elif method == 'PUT':
                headers['Content-Type'] = 'application/json'
                response = self.session.put(url, headers=headers, json=data)
            elif method == 'PATCH':
                headers['Content-Type'] = 'application/json'
                response = self.session.patch(url, headers=headers, json=data)
            elif method == 'DELETE':
                response = self.session.delete(url, headers=headers)
            else:
                self.print_test(name, False, f"不支持的HTTP方法: {method}")
                return False
                
            success = response.status_code == expected_status
            
            if success:
                self.print_test(name, True, 
                    f"{Colors.GREEN}[{response.status_code}] {method} {endpoint}{Colors.RESET}")
                self.results.append({
                    'name': name,
                    'status': 'PASS',
                    'method': method,
                    'endpoint': endpoint,
                    'status_code': response.status_code
                })
                return True
            else:
                error_msg = ""
                try:
                    error_data = response.json()
                    error_msg = json.dumps(error_data, indent=2, ensure_ascii=False)
                except:
                    error_msg = response.text[:200]
                    
                self.print_test(name, False, 
                    f"{Colors.RED}[{response.status_code}] {method} {endpoint}\n  错误: {error_msg}{Colors.RESET}")
                self.results.append({
                    'name': name,
                    'status': 'FAIL',
                    'method': method,
                    'endpoint': endpoint,
                    'status_code': response.status_code,
                    'error': error_msg
                })
                return False
                
        except requests.exceptions.ConnectionError:
            self.print_test(name, False, 
                f"{Colors.RED}连接失败: 无法连接到 {url}\n  请确保后端服务正在运行{Colors.RESET}")
            self.results.append({
                'name': name,
                'status': 'ERROR',
                'method': method,
                'endpoint': endpoint,
                'error': '连接失败'
            })
            return False
        except Exception as e:
            self.print_test(name, False, 
                f"{Colors.RED}异常: {str(e)}{Colors.RESET}")
            self.results.append({
                'name': name,
                'status': 'ERROR',
                'method': method,
                'endpoint': endpoint,
                'error': str(e)
            })
            return False
            
    def test_auth_module(self):
        """测试认证模块"""
        self.print_section("1. 认证模块测试")
        
        # 1.1 登录测试
        print("\n1.1 登录测试")
        for role, credentials in TEST_ACCOUNTS.items():
            response = self.session.post(
                f"{BASE_URL}/auth/login/",
                json=credentials,
                headers={'Content-Type': 'application/json'}
            )
            
            if response.status_code == 200:
                data = response.json()
                if 'access' in data:
                    self.tokens[role] = data['access']
                    self.print_test(
                        f"登录 - {role}",
                        True,
                        f"成功获取token: {data['access'][:20]}..."
                    )
                else:
                    self.print_test(f"登录 - {role}", False, "响应中缺少access token")
            else:
                self.print_test(
                    f"登录 - {role}",
                    False,
                    f"状态码: {response.status_code}, 响应: {response.text[:100]}"
                )
        
        # 使用管理员token进行后续测试
        admin_token = self.tokens.get('admin')
        
        if not admin_token:
            print(f"\n{Colors.RED}警告: 无法获取管理员token，部分测试将被跳过{Colors.RESET}")
            return
            
        # 1.2 获取用户信息
        print("\n1.2 用户信息测试")
        self.test_endpoint('GET', '/auth/profile/', '获取用户信息', admin_token)
        
        # 1.3 获取用户菜单
        print("\n1.3 用户菜单测试")
        self.test_endpoint('GET', '/auth/user-menus/', '获取用户菜单', admin_token)
        
        # 1.4 用户列表
        print("\n1.4 用户管理测试")
        self.test_endpoint('GET', '/auth/users/', '获取用户列表', admin_token)
        
        # 1.5 角色列表
        print("\n1.5 角色管理测试")
        self.test_endpoint('GET', '/auth/roles/', '获取角色列表', admin_token)
        
    def test_dashboard_module(self):
        """测试仪表板模块"""
        self.print_section("2. 仪表板模块测试")
        
        admin_token = self.tokens.get('admin')
        if not admin_token:
            print(f"{Colors.YELLOW}跳过: 需要管理员token{Colors.RESET}")
            return
            
        self.test_endpoint('GET', '/dashboard/statistics/', '仪表板统计', admin_token)
        self.test_endpoint('GET', '/dashboard/activities/', '最近活动', admin_token)
        self.test_endpoint('GET', '/dashboard/tasks/', '待办任务', admin_token)
        self.test_endpoint('GET', '/dashboard/notifications/', '系统通知', admin_token)
        
    def test_enterprise_module(self):
        """测试企业模块"""
        self.print_section("3. 企业模块测试")
        
        enterprise_token = self.tokens.get('enterprise') or self.tokens.get('admin')
        if not enterprise_token:
            print(f"{Colors.YELLOW}跳过: 需要企业用户或管理员token{Colors.RESET}")
            return
            
        print("\n3.1 企业信息测试")
        self.test_endpoint('GET', '/enterprises/', '获取企业列表', enterprise_token)
        self.test_endpoint('GET', '/enterprises/statistics/', '企业统计', enterprise_token)
        
        print("\n3.2 企业项目测试")
        self.test_endpoint('GET', '/enterprises/projects/', '获取项目列表', enterprise_token)
        
        print("\n3.3 企业员工测试")
        self.test_endpoint('GET', '/enterprises/employees/', '获取员工列表', enterprise_token)
        
    def test_personal_module(self):
        """测试个人模块"""
        self.print_section("4. 个人模块测试")
        
        personal_token = self.tokens.get('personal') or self.tokens.get('admin')
        if not personal_token:
            print(f"{Colors.YELLOW}跳过: 需要个人用户或管理员token{Colors.RESET}")
            return
            
        print("\n4.1 个人信息测试")
        self.test_endpoint('GET', '/persons/statistics/', '个人统计', personal_token)
        
        print("\n4.2 个人项目测试")
        self.test_endpoint('GET', '/persons/projects/', '获取个人项目', personal_token)
        
        print("\n4.3 个人任务测试")
        self.test_endpoint('GET', '/persons/tasks/', '获取个人任务', personal_token)
        
    def test_info_plaza_module(self):
        """测试信息广场模块"""
        self.print_section("5. 信息广场模块测试")
        
        token = self.tokens.get('admin')
        if not token:
            print(f"{Colors.YELLOW}跳过: 需要token{Colors.RESET}")
            return
            
        print("\n5.1 信息列表测试")
        self.test_endpoint('GET', '/info-plaza/posts/', '获取信息列表', token)
        self.test_endpoint('GET', '/info-plaza/categories/', '获取分类列表', token)
        self.test_endpoint('GET', '/info-plaza/tags/', '获取标签列表', token)
        
        print("\n5.2 个人信息测试")
        self.test_endpoint('GET', '/info-plaza/my-posts/', '我的发布', token)
        self.test_endpoint('GET', '/info-plaza/my-favorites/', '我的收藏', token)
        self.test_endpoint('GET', '/info-plaza/hot-posts/', '热门信息', token)
        
    def test_resources_module(self):
        """测试资源管理模块"""
        self.print_section("6. 资源管理模块测试")
        
        token = self.tokens.get('admin')
        if not token:
            print(f"{Colors.YELLOW}跳过: 需要token{Colors.RESET}")
            return
            
        print("\n6.1 资源列表测试")
        self.test_endpoint('GET', '/resources/', '获取资源列表', token)
        self.test_endpoint('GET', '/resources/types/', '获取资源类型', token)
        
        print("\n6.2 资源查询测试")
        self.test_endpoint('GET', '/resources/my-resources/', '我的资源', token)
        self.test_endpoint('GET', '/resources/available/', '可用资源', token)
        
        print("\n6.3 资源申请测试")
        self.test_endpoint('GET', '/resources/requests/', '资源申请列表', token)
        self.test_endpoint('GET', '/resources/my-requests/', '我的申请', token)
        
    def test_system_module(self):
        """测试系统管理模块"""
        self.print_section("7. 系统管理模块测试")
        
        admin_token = self.tokens.get('admin')
        if not admin_token:
            print(f"{Colors.YELLOW}跳过: 需要管理员token{Colors.RESET}")
            return
            
        print("\n7.1 系统配置测试")
        self.test_endpoint('GET', '/system/configs/', '系统配置', admin_token)
        
        print("\n7.2 系统日志测试")
        self.test_endpoint('GET', '/system/logs/', '系统日志', admin_token)
        self.test_endpoint('GET', '/system/logs/summary/', '日志摘要', admin_token)
        
        print("\n7.3 系统统计测试")
        self.test_endpoint('GET', '/system/statistics/', '系统统计', admin_token)
        self.test_endpoint('GET', '/system/statistics/dashboard/', '仪表板统计', admin_token)
        
        print("\n7.4 系统监控测试")
        self.test_endpoint('GET', '/system/health/', '健康检查', admin_token)
        
    def generate_report(self):
        """生成测试报告"""
        self.print_header("测试报告")
        
        total = len(self.results)
        passed = len([r for r in self.results if r['status'] == 'PASS'])
        failed = len([r for r in self.results if r['status'] == 'FAIL'])
        errors = len([r for r in self.results if r['status'] == 'ERROR'])
        
        print(f"总测试数: {total}")
        print(f"{Colors.GREEN}通过: {passed}{Colors.RESET}")
        print(f"{Colors.RED}失败: {failed}{Colors.RESET}")
        print(f"{Colors.YELLOW}错误: {errors}{Colors.RESET}")
        
        if total > 0:
            success_rate = (passed / total) * 100
            print(f"\n成功率: {Colors.GREEN if success_rate >= 80 else Colors.RED}{success_rate:.2f}%{Colors.RESET}")
            
        # 详细失败列表
        if failed > 0 or errors > 0:
            print(f"\n{Colors.BOLD}失败的测试:{Colors.RESET}")
            for result in self.results:
                if result['status'] in ['FAIL', 'ERROR']:
                    print(f"\n{Colors.RED}✗ {result['name']}{Colors.RESET}")
                    print(f"  方法: {result['method']}")
                    print(f"  端点: {result['endpoint']}")
                    if 'status_code' in result:
                        print(f"  状态码: {result['status_code']}")
                    if 'error' in result:
                        print(f"  错误: {result['error'][:200]}")
                        
        # 保存报告到文件
        report_file = f"test_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_file, 'w', encoding='utf-8') as f:
            json.dump({
                'timestamp': datetime.now().isoformat(),
                'summary': {
                    'total': total,
                    'passed': passed,
                    'failed': failed,
                    'errors': errors,
                    'success_rate': success_rate if total > 0 else 0
                },
                'results': self.results
            }, f, indent=2, ensure_ascii=False)
            
        print(f"\n{Colors.GREEN}详细报告已保存到: {report_file}{Colors.RESET}")
        
    def run_all_tests(self):
        """运行所有测试"""
        self.print_header("前后端API集成测试")
        
        print(f"后端服务: {BASE_URL}")
        print(f"前端服务: {FRONTEND_URL}")
        print(f"测试时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        
        try:
            # 1. 认证模块
            self.test_auth_module()
            
            # 2. 仪表板模块
            self.test_dashboard_module()
            
            # 3. 企业模块
            self.test_enterprise_module()
            
            # 4. 个人模块
            self.test_personal_module()
            
            # 5. 信息广场模块
            self.test_info_plaza_module()
            
            # 6. 资源管理模块
            self.test_resources_module()
            
            # 7. 系统管理模块
            self.test_system_module()
            
        except KeyboardInterrupt:
            print(f"\n\n{Colors.YELLOW}测试被用户中断{Colors.RESET}")
        except Exception as e:
            print(f"\n\n{Colors.RED}测试过程中发生异常: {str(e)}{Colors.RESET}")
            import traceback
            traceback.print_exc()
        finally:
            # 生成报告
            self.generate_report()

def main():
    """主函数"""
    tester = APITester()
    tester.run_all_tests()

if __name__ == '__main__':
    main()




