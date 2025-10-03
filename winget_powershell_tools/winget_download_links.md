# winget (Windows包管理器) 官方下载地址

## 🔗 官方下载链接

### 方法一：Microsoft Store（推荐）
**App Installer (包含winget)**
- Microsoft Store链接：https://www.microsoft.com/store/productId/9NBLGGH4NNS1
- 直接链接：`ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1`

### 方法二：GitHub Releases（最新版本）
**winget-cli GitHub仓库**
- 最新版本：https://github.com/microsoft/winget-cli/releases/latest
- 下载文件：`Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle`

### 方法三：Microsoft官方页面
**Windows包管理器官方页面**
- 官方介绍：https://docs.microsoft.com/zh-cn/windows/package-manager/
- 下载页面：https://github.com/microsoft/winget-cli

## 📋 系统要求

- Windows 10 版本 1709 (16299) 或更高版本
- Windows 11（所有版本）
- 需要启用"应用安装程序"功能

## 🚀 安装方法

### 方法1：通过Microsoft Store安装
1. 打开Microsoft Store
2. 搜索"App Installer"或"应用安装程序"
3. 点击"获取"或"安装"
4. 安装完成后，winget将自动可用

### 方法2：手动下载安装
1. 访问：https://github.com/microsoft/winget-cli/releases/latest
2. 下载：`Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle`
3. 双击下载的文件进行安装
4. 或使用PowerShell命令：
   ```powershell
   Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
   ```

### 方法3：使用PowerShell脚本安装
```powershell
# 下载并安装winget
$url = "https://aka.ms/getwinget"
$output = "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
Invoke-WebRequest -Uri $url -OutFile $output
Add-AppxPackage $output
```

## ✅ 验证安装

安装完成后，在新的命令提示符或PowerShell窗口中运行：
```cmd
winget --version
```

如果显示版本号，说明安装成功！

## 🔧 常见问题解决

### 如果winget命令不被识别：
1. 重启计算机
2. 确保已安装"App Installer"
3. 检查PATH环境变量
4. 尝试使用完整路径：
   ```
   %LOCALAPPDATA%\Microsoft\WindowsApps\winget.exe
   ```

### 如果无法从Microsoft Store安装：
1. 检查Windows更新
2. 确保已登录Microsoft账户
3. 使用手动下载方法

## 📱 使用winget安装PowerShell 7

winget安装成功后，可以使用以下命令安装PowerShell 7：
```cmd
winget install Microsoft.PowerShell
```

