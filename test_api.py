#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
小柳AI助手 - API测试脚本
测试所有API接口和快捷指令
"""

import requests
import json
import sys
from typing import Dict, Any
from colorama import init, Fore, Style

# 初始化colorama
init(autoreset=True)

# API基础URL（部署后替换）
API_URLS = [
    "https://cursor-production.up.railway.app",
    "https://xiaoliu-production.up.railway.app",
    "http://localhost:8000"  # 本地测试
]

def print_success(message: str):
    """打印成功消息"""
    print(f"{Fore.GREEN}✓{Style.RESET_ALL} {message}")

def print_error(message: str):
    """打印错误消息"""
    print(f"{Fore.RED}✗{Style.RESET_ALL} {message}")

def print_info(message: str):
    """打印信息消息"""
    print(f"{Fore.CYAN}ℹ{Style.RESET_ALL} {message}")

def test_health_check(base_url: str) -> bool:
    """测试健康检查接口"""
    try:
        response = requests.get(f"{base_url}/health", timeout=10)
        if response.status_code == 200:
            data = response.json()
            if data.get("status") == "healthy":
                print_success(f"健康检查通过: {base_url}")
                return True
        print_error(f"健康检查失败: {base_url}")
        return False
    except Exception as e:
        print_error(f"连接失败: {base_url} - {str(e)}")
        return False

def test_root_endpoint(base_url: str) -> bool:
    """测试根路径"""
    try:
        response = requests.get(f"{base_url}/", timeout=10)
        if response.status_code == 200:
            data = response.json()
            print_success(f"根路径访问成功")
            print_info(f"服务信息: {data.get('message')}")
            return True
        return False
    except Exception as e:
        print_error(f"根路径测试失败: {str(e)}")
        return False

def test_features_endpoint(base_url: str) -> bool:
    """测试功能列表接口"""
    try:
        response = requests.get(f"{base_url}/features", timeout=10)
        if response.status_code == 200:
            data = response.json()
            print_success(f"功能列表获取成功")
            print_info(f"可用功能数: {len(data.get('features', []))}")
            return True
        return False
    except Exception as e:
        print_error(f"功能列表测试失败: {str(e)}")
        return False

def test_chat_endpoint(base_url: str, message: str, expected_keyword: str = None) -> bool:
    """测试聊天接口"""
    try:
        payload = {
            "message": message,
            "user_id": "test_user"
        }
        response = requests.post(
            f"{base_url}/chat",
            json=payload,
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        
        if response.status_code == 200:
            data = response.json()
            if data.get("status") == "success":
                response_text = data.get("response", "")
                print_success(f"聊天测试成功: {message}")
                print_info(f"响应: {response_text[:100]}...")
                
                if expected_keyword and expected_keyword in response_text:
                    print_success(f"响应包含预期关键词: {expected_keyword}")
                    return True
                elif not expected_keyword:
                    return True
                else:
                    print_error(f"响应未包含预期关键词: {expected_keyword}")
                    return False
        
        print_error(f"聊天测试失败: {response.status_code}")
        return False
        
    except Exception as e:
        print_error(f"聊天接口测试失败: {str(e)}")
        return False

def run_all_tests(base_url: str):
    """运行所有测试"""
    print(f"\n{Fore.YELLOW}{'='*60}{Style.RESET_ALL}")
    print(f"{Fore.YELLOW}开始测试: {base_url}{Style.RESET_ALL}")
    print(f"{Fore.YELLOW}{'='*60}{Style.RESET_ALL}\n")
    
    results = []
    
    # 1. 健康检查
    print_info("测试1: 健康检查")
    results.append(test_health_check(base_url))
    print()
    
    # 2. 根路径
    print_info("测试2: 根路径")
    results.append(test_root_endpoint(base_url))
    print()
    
    # 3. 功能列表
    print_info("测试3: 功能列表")
    results.append(test_features_endpoint(base_url))
    print()
    
    # 4. 快捷指令测试
    test_cases = [
        ("你好小柳", "小柳"),
        ("小柳状态", "运行正常"),
        ("生成文档", "文档生成"),
        ("分析代码", "代码分析"),
        ("配色", "配色"),
        ("并行开发", "并行开发"),
    ]
    
    for i, (message, keyword) in enumerate(test_cases, 4):
        print_info(f"测试{i}: 快捷指令 - {message}")
        results.append(test_chat_endpoint(base_url, message, keyword))
        print()
    
    # 统计结果
    passed = sum(results)
    total = len(results)
    
    print(f"\n{Fore.YELLOW}{'='*60}{Style.RESET_ALL}")
    if passed == total:
        print(f"{Fore.GREEN}✓✓✓ 所有测试通过！({passed}/{total}){Style.RESET_ALL}")
    else:
        print(f"{Fore.RED}部分测试失败 ({passed}/{total}){Style.RESET_ALL}")
    print(f"{Fore.YELLOW}{'='*60}{Style.RESET_ALL}\n")
    
    return passed == total

def find_available_api():
    """查找可用的API"""
    print(f"{Fore.CYAN}正在检测可用的API...{Style.RESET_ALL}\n")
    
    for url in API_URLS:
        print_info(f"尝试连接: {url}")
        if test_health_check(url):
            return url
        print()
    
    return None

def main():
    """主函数"""
    print(f"\n{Fore.CYAN}{'='*60}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}小柳AI助手 - API测试工具{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{'='*60}{Style.RESET_ALL}\n")
    
    # 查找可用API
    api_url = find_available_api()
    
    if not api_url:
        print_error("未找到可用的API服务")
        print_info("请确保：")
        print("  1. 已部署到Railway/Vercel")
        print("  2. 服务正常运行")
        print("  3. 或在本地启动服务: uvicorn api.main:app")
        sys.exit(1)
    
    # 运行测试
    success = run_all_tests(api_url)
    
    if success:
        print_success("API测试完成，所有功能正常！")
        sys.exit(0)
    else:
        print_error("部分测试失败，请检查日志")
        sys.exit(1)

if __name__ == "__main__":
    main()

