@echo off
chcp 65001 >nul
title 删除旧版小柳系统

color 0E
cls

echo ========================================
echo    删除旧版小柳系统
echo ========================================
echo.
echo 将要删除以下目录：
echo.
echo   1. D:\xiaoliu
echo   2. D:\小柳系统-便携部署包v6.1.1
echo   3. D:\小柳v6.0-完整测试包_20251006_202249
echo.
echo ⚠️ 警告：此操作不可恢复！
echo.
echo 请确认：
echo   - 已备份重要数据
echo   - 已部署云端版本
echo   - 确定要删除旧系统
echo.
set /p confirm="输入 YES 确认删除，其他键取消: "

if /i "%confirm%" NEQ "YES" (
    echo.
    echo [取消] 操作已取消
    pause
    exit /b 0
)

echo.
echo [开始] 删除旧系统...
echo.

:: 删除 D:\xiaoliu
if exist "D:\xiaoliu" (
    echo [删除] D:\xiaoliu...
    rd /s /q "D:\xiaoliu" 2>nul
    if not exist "D:\xiaoliu" (
        echo [✓] D:\xiaoliu 已删除
    ) else (
        echo [✗] D:\xiaoliu 删除失败（可能有文件被占用）
    )
) else (
    echo [跳过] D:\xiaoliu 不存在
)
echo.

:: 删除便携部署包
if exist "D:\小柳系统-便携部署包v6.1.1" (
    echo [删除] D:\小柳系统-便携部署包v6.1.1...
    rd /s /q "D:\小柳系统-便携部署包v6.1.1" 2>nul
    if not exist "D:\小柳系统-便携部署包v6.1.1" (
        echo [✓] D:\小柳系统-便携部署包v6.1.1 已删除
    ) else (
        echo [✗] D:\小柳系统-便携部署包v6.1.1 删除失败
    )
) else (
    echo [跳过] D:\小柳系统-便携部署包v6.1.1 不存在
)
echo.

:: 删除测试包
if exist "D:\小柳v6.0-完整测试包_20251006_202249" (
    echo [删除] D:\小柳v6.0-完整测试包_20251006_202249...
    rd /s /q "D:\小柳v6.0-完整测试包_20251006_202249" 2>nul
    if not exist "D:\小柳v6.0-完整测试包_20251006_202249" (
        echo [✓] D:\小柳v6.0-完整测试包_20251006_202249 已删除
    ) else (
        echo [✗] D:\小柳v6.0-完整测试包_20251006_202249 删除失败
    )
) else (
    echo [跳过] D:\小柳v6.0-完整测试包_20251006_202249 不存在
)
echo.

:: 删除ZIP文件
if exist "D:\小柳系统-便携部署包v6.1.1.zip" (
    echo [删除] D:\小柳系统-便携部署包v6.1.1.zip...
    del /f /q "D:\小柳系统-便携部署包v6.1.1.zip" 2>nul
    if not exist "D:\小柳系统-便携部署包v6.1.1.zip" (
        echo [✓] ZIP文件已删除
    )
)

if exist "D:\小柳v6.0-完整测试包_20251006_202249.zip" (
    echo [删除] D:\小柳v6.0-完整测试包_20251006_202249.zip...
    del /f /q "D:\小柳v6.0-完整测试包_20251006_202249.zip" 2>nul
    if not exist "D:\小柳v6.0-完整测试包_20251006_202249.zip" (
        echo [✓] ZIP文件已删除
    )
)
echo.

:: 完成
color 0A
echo ========================================
echo    ✓ 旧系统删除完成！
echo ========================================
echo.
echo 现在您使用的是：
echo   ✅ 云端版小柳 - 随时随地访问
echo   📍 项目位置：D:\项目开发文档\问答
echo.
echo 下一步：
echo   1. 部署到Railway（查看：一键部署到Railway.md）
echo   2. 使用客户端安装脚本连接云端
echo   3. 在Cursor中输入"你好小柳"开始使用
echo.
echo 按任意键退出...
pause >nul

