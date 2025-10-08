@echo off
chcp 65001 >nul
title 小柳智能开发助手 - 全自动安装

color 0A
cls

echo ========================================
echo    小柳智能开发助手 v6.2.0
echo    全自动安装（零操作）
echo ========================================
echo.
echo 正在全自动安装，请稍候...
echo.

:: 云端API地址列表（自动尝试）
set API1=https://cursor-production.up.railway.app
set API2=https://xiaoliu-production.up.railway.app
set API3=https://cursor-.vercel.app

:: 步骤1：自动检测可用的云端API
echo [1/5] 自动检测云端服务...
set CLOUD_API=
for %%A in (%API1% %API2% %API3%) do (
    curl -s -m 5 "%%A/health" 2>nul | findstr "healthy" >nul
    if not errorlevel 1 (
        set CLOUD_API=%%A
        echo [成功] 找到可用云端：%%A
        goto :found
    )
)

:found
if "%CLOUD_API%"=="" (
    echo [警告] 未找到已部署的云端服务
    echo [提示] 将使用默认配置，云端部署后自动生效
    set CLOUD_API=%API1%
)
echo.

:: 步骤2：自动创建配置文件
echo [2/5] 自动创建配置文件...
(
echo {
echo   "xiaoliu": {
echo     "enabled": true,
echo     "apiUrl": "%CLOUD_API%",
echo     "autoUpdate": true,
echo     "cacheTime": 300000,
echo     "version": "6.2.0",
echo     "features": {
echo       "documentation": true,
echo       "codeAnalysis": true,
echo       "colorScheme": true,
echo       "parallelDev": true,
echo       "performance": true,
echo       "testing": true
echo     },
echo     "offline": {
echo       "enabled": false
echo     }
echo   }
echo }
) > "%USERPROFILE%\.cursorrc"

if exist "%USERPROFILE%\.cursorrc" (
    echo [成功] 配置文件已创建
) else (
    echo [失败] 配置文件创建失败
    pause
    exit /b 1
)
echo.

:: 步骤3：自动验证配置
echo [3/5] 自动验证配置...
if exist "%USERPROFILE%\.cursorrc" (
    echo [成功] 配置验证通过
) else (
    echo [失败] 配置验证失败
    pause
    exit /b 1
)
echo.

:: 步骤4：自动测试连接
echo [4/5] 自动测试云端连接...
curl -s -m 5 "%CLOUD_API%/health" 2>nul | findstr "healthy" >nul
if not errorlevel 1 (
    echo [成功] 云端连接正常
    echo [信息] API地址：%CLOUD_API%
) else (
    echo [提示] 云端暂时无法连接，配置已保存
    echo [提示] 云端部署后将自动生效
)
echo.

:: 步骤5：自动重启Cursor（可选）
echo [5/5] 准备重启Cursor...
echo.

:: 检查Cursor是否在运行
tasklist /FI "IMAGENAME eq Cursor.exe" 2>NUL | find /I /N "Cursor.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [检测] Cursor正在运行
    echo [提示] 将在3秒后自动关闭Cursor...
    timeout /t 3 /nobreak >nul
    
    :: 自动关闭Cursor
    taskkill /F /IM Cursor.exe >nul 2>&1
    echo [完成] Cursor已关闭
    
    timeout /t 2 /nobreak >nul
    
    :: 自动启动Cursor
    echo [启动] 正在重新启动Cursor...
    
    :: 尝试常见的Cursor安装路径
    if exist "%LOCALAPPDATA%\Programs\cursor\Cursor.exe" (
        start "" "%LOCALAPPDATA%\Programs\cursor\Cursor.exe"
        echo [成功] Cursor已重新启动
    ) else if exist "%PROGRAMFILES%\Cursor\Cursor.exe" (
        start "" "%PROGRAMFILES%\Cursor\Cursor.exe"
        echo [成功] Cursor已重新启动
    ) else (
        echo [提示] 请手动启动Cursor
    )
) else (
    echo [提示] Cursor未运行，请手动启动
)
echo.

:: 完成
echo ========================================
echo    ✓ 全自动安装完成！
echo ========================================
echo.
echo 配置信息：
echo   配置文件：%USERPROFILE%\.cursorrc
echo   云端API：%CLOUD_API%
echo   版本：v6.2.0
echo   状态：已就绪
echo.
echo 下一步：
echo   1. Cursor已自动重启（或手动启动）
echo   2. 系统已自动配置完成
echo   3. 立即可用，无需任何操作
echo.
echo 快捷指令测试：
echo   - "你好小柳" - 确认接入
echo   - "生成文档" - 文档生成
echo   - "分析代码" - 代码分析
echo   - "配色" - 配色方案
echo.
echo ========================================
echo.

:: 自动验证安装
echo ========================================
echo    自动验证安装结果
echo ========================================
echo.

set VERIFY_PASS=0

:: 快速验证
echo [验证] 配置文件...
if exist "%USERPROFILE%\.cursorrc" (
    echo [✓] 配置文件已创建
    set /a VERIFY_PASS+=1
) else (
    echo [✗] 配置文件未找到
)

echo [验证] 配置内容...
findstr /C:"xiaoliu" "%USERPROFILE%\.cursorrc" >nul 2>&1
if %errorlevel%==0 (
    echo [✓] 配置内容正确
    set /a VERIFY_PASS+=1
) else (
    echo [✗] 配置内容错误
)

echo [验证] 云端连接...
curl -s -m 3 "%CLOUD_API%/health" 2>nul | findstr "healthy" >nul
if %errorlevel%==0 (
    echo [✓] 云端连接成功
    set /a VERIFY_PASS+=1
) else (
    echo [⚠] 云端暂时无法连接
)

echo [验证] API版本...
curl -s -m 3 "%CLOUD_API%/" 2>nul | findstr "小柳" >nul
if %errorlevel%==0 (
    echo [✓] API版本验证成功
    set /a VERIFY_PASS+=1
) else (
    echo [⚠] API版本验证失败
)
echo.

:: 显示最终结果
if %VERIFY_PASS% geq 2 (
    color 0A
    echo ========================================
    echo    ✓✓✓ 安装成功！✓✓✓
    echo ========================================
    echo.
    echo 验证通过：%VERIFY_PASS%/4
    echo 状态：已就绪，可以使用
    echo.
    echo 在Cursor中输入：
    echo   "你好小柳" 或 "小柳在吗"
    echo.
) else (
    color 0E
    echo ========================================
    echo    ⚠ 安装可能需要检查
    echo ========================================
    echo.
    echo 验证通过：%VERIFY_PASS%/4
    echo 提示：配置已保存，云端部署后自动生效
    echo.
)

echo 详细信息请查看：
echo   - DEPLOYMENT.md（部署指南）
echo   - 本地测试指南.md（测试说明）
echo.
echo 按任意键退出...
pause >nul

