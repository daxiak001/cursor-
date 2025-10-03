# Windows编码乱码问题快速修复参考

**AI助手专用 - 30秒解决方案**

## 🚨 快速识别

**乱码症状**: `✓` `✗` `→` 显示为 `�?` 或方块  
**路径问题**: 中文路径无法识别  
**脚本报错**: 编码相关的PowerShell错误

## ⚡ 立即修复模板

### PowerShell脚本头部（复制粘贴）
```powershell
# 必须放在脚本最开头
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
```

### 批处理文件头部（复制粘贴）
```batch
@echo off
chcp 65001 >nul 2>&1
```

### Unicode符号一键替换
```powershell
# 替换所有常见Unicode符号
$content = $content -replace '✓', '[OK]'
$content = $content -replace '✗', '[ERROR]'
$content = $content -replace '⚠', '[WARNING]'
$content = $content -replace '→', '->'
$content = $content -replace '←', '<-'
```

## 🛠️ 三步修复流程

### Step 1: 创建Universal版本
```powershell
# 为原文件创建_universal版本
$originalFile = "script.ps1"
$universalFile = "script_universal.ps1"
# 应用编码模板 + 符号替换
```

### Step 2: 快速测试
```powershell
# 测试脚本模板
Write-Host "Test: [OK] [ERROR] [WARNING]" -ForegroundColor Green
if (Test-Path "$env:USERPROFILE\Downloads") {
    Write-Host "Path test: SUCCESS" -ForegroundColor Green
}
```

### Step 3: 验证无交互
- 移除所有 `pause` 命令
- 移除 `start` 浏览器命令（如需要）
- 确保脚本能完全自动运行

## 📋 常用替换对照表

| 原始 | 替换为 | 用途 |
|------|--------|------|
| ✓ | [OK] | 成功 |
| ✗ | [ERROR] | 失败 |
| ⚠ | [WARNING] | 警告 |
| → | -> | 箭头 |
| 📁 | [DIR] | 目录 |
| 🔧 | [TOOL] | 工具 |

## ⚡ 一键修复脚本模板

```powershell
# 完整的编码修复脚本模板
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== Encoding Fix Tool ===" -ForegroundColor Green

# 获取所有脚本文件
$files = Get-ChildItem -Include "*.ps1","*.bat","*.cmd" -File

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # 应用所有替换
    $content = $content -replace '✓', '[OK]'
    $content = $content -replace '✗', '[ERROR]'
    $content = $content -replace '⚠', '[WARNING]'
    
    # 保存universal版本
    $newName = $file.BaseName + "_universal" + $file.Extension
    $content | Out-File -FilePath $newName -Encoding UTF8 -Force
    
    Write-Host "Created: $newName" -ForegroundColor Green
}
```

## 🎯 成功验证

运行这个测试确认修复成功：
```powershell
Write-Host "[OK] [ERROR] [WARNING] -> <- UP DOWN" -ForegroundColor Green
Write-Host "If you see clear text above, encoding is fixed!" -ForegroundColor Green
```

## 💡 关键要点

1. **编码设置必须在脚本开头**
2. **使用ASCII替代Unicode符号** 
3. **创建_universal版本而不是修改原文件**
4. **测试要无交互运行**
5. **使用环境变量构建路径**

---
**使用方法**: 复制相应模板，替换符号，测试验证 ✅
