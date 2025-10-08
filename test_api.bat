@echo off
chcp 65001 >nul
title 小柳AI助手 - API测试

color 0B
cls

echo ========================================
echo    小柳AI助手 - API测试工具
echo ========================================
echo.

:: 检查Python是否安装
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到Python
    echo [提示] 请先安装Python 3.7+
    pause
    exit /b 1
)

:: 安装依赖
echo [1/3] 检查依赖...
pip show requests >nul 2>&1
if errorlevel 1 (
    echo [安装] 安装requests...
    pip install requests colorama -q
)

pip show colorama >nul 2>&1
if errorlevel 1 (
    echo [安装] 安装colorama...
    pip install colorama -q
)
echo.

:: 运行测试
echo [2/3] 开始API测试...
echo.
python test_api.py

:: 保存结果
set TEST_RESULT=%errorlevel%
echo.

:: 显示结果
echo [3/3] 测试完成
echo.

if %TEST_RESULT%==0 (
    color 0A
    echo ========================================
    echo    ✓ 测试通过！API运行正常
    echo ========================================
) else (
    color 0C
    echo ========================================
    echo    ✗ 测试失败，请查看错误信息
    echo ========================================
)

echo.
echo 按任意键退出...
pause >nul

