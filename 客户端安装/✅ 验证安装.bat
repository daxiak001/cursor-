@echo off
chcp 65001 >nul
title 小柳智能开发助手 - 安装验证

color 0B
cls

echo ========================================
echo    小柳智能开发助手 - 安装验证
echo ========================================
echo.

:: 读取配置文件中的API地址
set CLOUD_API=
if exist "%USERPROFILE%\.cursorrc" (
    for /f "tokens=2 delims=:," %%a in ('findstr /C:"apiUrl" "%USERPROFILE%\.cursorrc"') do (
        set CLOUD_API=%%a
        set CLOUD_API=!CLOUD_API:"=!
        set CLOUD_API=!CLOUD_API: =!
    )
)

if "%CLOUD_API%"=="" (
    set CLOUD_API=https://cursor-production.up.railway.app
)

echo 正在验证安装...
echo API地址：%CLOUD_API%
echo.

set TOTAL_TESTS=0
set PASSED_TESTS=0

:: 测试1：配置文件
echo [测试1/6] 配置文件检查
set /a TOTAL_TESTS+=1
if exist "%USERPROFILE%\.cursorrc" (
    echo [✓] 配置文件存在
    set /a PASSED_TESTS+=1
) else (
    echo [✗] 配置文件不存在
)
echo.

:: 测试2：配置内容
echo [测试2/6] 配置内容检查
set /a TOTAL_TESTS+=1
findstr /C:"xiaoliu" "%USERPROFILE%\.cursorrc" >nul 2>&1
if %errorlevel%==0 (
    echo [✓] 配置内容正确
    set /a PASSED_TESTS+=1
) else (
    echo [✗] 配置内容错误
)
echo.

:: 测试3：健康检查
echo [测试3/6] 健康检查
set /a TOTAL_TESTS+=1
curl -s -m 5 "%CLOUD_API%/health" 2>nul | findstr "healthy" >nul
if %errorlevel%==0 (
    echo [✓] 健康检查通过
    set /a PASSED_TESTS+=1
) else (
    echo [✗] 健康检查失败
)
echo.

:: 测试4：API根路径
echo [测试4/6] API根路径
set /a TOTAL_TESTS+=1
curl -s -m 5 "%CLOUD_API%/" 2>nul | findstr "小柳" >nul
if %errorlevel%==0 (
    echo [✓] API根路径正常
    set /a PASSED_TESTS+=1
) else (
    echo [✗] API根路径异常
)
echo.

:: 测试5：功能列表
echo [测试5/6] 功能列表
set /a TOTAL_TESTS+=1
curl -s -m 5 "%CLOUD_API%/features" 2>nul | findstr "features" >nul
if %errorlevel%==0 (
    echo [✓] 功能列表获取成功
    set /a PASSED_TESTS+=1
) else (
    echo [✗] 功能列表获取失败
)
echo.

:: 测试6：聊天接口
echo [测试6/6] 聊天接口测试
set /a TOTAL_TESTS+=1
curl -s -m 10 -X POST "%CLOUD_API%/chat" ^
  -H "Content-Type: application/json" ^
  -d "{\"message\":\"你好小柳\",\"user_id\":\"test\"}" 2>nul | findstr "小柳" >nul
if %errorlevel%==0 (
    echo [✓] 聊天接口正常
    set /a PASSED_TESTS+=1
) else (
    echo [✗] 聊天接口异常
)
echo.

:: 显示结果
echo ========================================
echo    验证结果
echo ========================================
echo.
echo 通过测试：%PASSED_TESTS%/%TOTAL_TESTS%
echo.

if %PASSED_TESTS%==%TOTAL_TESTS% (
    color 0A
    echo ✓✓✓ 完美！所有测试通过 ✓✓✓
    echo.
    echo 小柳AI助手已成功安装并正常运行！
    echo.
    echo 快速开始：
    echo   1. 打开Cursor
    echo   2. 输入："你好小柳"
    echo   3. 享受智能开发体验！
) else if %PASSED_TESTS% geq 3 (
    color 0E
    echo ⚠ 部分功能可用
    echo.
    echo 建议：
    echo   - 检查网络连接
    echo   - 确认云端服务已部署
    echo   - 查看 DEPLOYMENT.md 获取帮助
) else (
    color 0C
    echo ✗ 安装可能存在问题
    echo.
    echo 解决方案：
    echo   1. 检查是否已部署到Railway/Vercel
    echo   2. 确认API地址正确
    echo   3. 重新运行安装脚本
    echo   4. 查看部署文档 DEPLOYMENT.md
)

echo.
echo 详细信息：
echo   配置文件：%USERPROFILE%\.cursorrc
echo   API地址：%CLOUD_API%
echo.
echo 按任意键退出...
pause >nul

