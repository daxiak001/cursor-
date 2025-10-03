# AutoJS 模拟器连接完成指南

## 🎉 连接状态

**✅ AutoJS 已成功连接到模拟器！**

## 📋 连接详情

### 设备信息
- **模拟器**: 127.0.0.1:21513 (A5010)
- **ADB**: 已安装并配置完成
- **AutoJS**: org.autojs.autojs 已安装并运行

### 配置状态
- ✅ ADB 连接已建立
- ✅ AutoJS 应用已启动
- ✅ 无障碍服务权限已启用
- ✅ 悬浮窗权限已授予
- ✅ 存储权限已配置
- ✅ 测试脚本已部署

## 📁 文件结构

```
C:\Users\Administrator\AutoJS_Setup\
├── platform-tools\          # ADB工具目录
│   ├── adb.exe              # Android Debug Bridge
│   └── ...                  # 其他工具
├── connect_adb.bat          # ADB连接助手
└── install_autojs.bat       # AutoJS安装助手

模拟器存储路径:
/sdcard/Scripts/
├── test_autojs_connection.js    # 完整连接测试脚本
└── simple_test.js              # 简单测试脚本
```

## 🚀 使用方法

### 1. 快速连接
```bash
# 自动连接并测试
powershell -ExecutionPolicy Bypass -File "autojs_complete_setup.ps1"

# 或使用批处理快速连接
cmd /c "quick_connect_autojs.bat"
```

### 2. 手动操作
```bash
# 检查设备连接
C:\Users\Administrator\AutoJS_Setup\platform-tools\adb.exe devices

# 启动AutoJS
C:\Users\Administrator\AutoJS_Setup\platform-tools\adb.exe shell am start -n org.autojs.autojs/.ui.splash.SplashActivity

# 部署脚本
C:\Users\Administrator\AutoJS_Setup\platform-tools\adb.exe push script.js /sdcard/Scripts/

# 运行脚本
C:\Users\Administrator\AutoJS_Setup\platform-tools\adb.exe shell am broadcast -a org.autojs.autojs.action.script --es path "/sdcard/Scripts/script.js"
```

### 3. 在模拟器中使用
1. 打开 AutoJS 应用
2. 导航到 "文件" 选项卡
3. 找到 `/sdcard/Scripts/` 目录
4. 点击运行 `.js` 脚本文件

## 🛠️ 开发工作流

### 脚本开发
1. 在电脑上编写 JavaScript 脚本
2. 使用 ADB 推送到模拟器
3. 在 AutoJS 中运行和调试
4. 查看控制台输出和日志

### 常用命令
```bash
# 推送脚本
adb push local_script.js /sdcard/Scripts/

# 查看日志
adb logcat | findstr "AutoJs"

# 截图调试
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png

# 清除应用数据(如需重置)
adb shell pm clear org.autojs.autojs
```

## 📝 测试脚本示例

### 基础测试脚本
```javascript
// 设备信息
console.log("设备型号: " + device.model);
console.log("屏幕尺寸: " + device.width + "x" + device.height);

// 基础功能测试
toast("AutoJS 连接成功！");
console.log("Toast 显示正常");

// 点击测试
click(device.width/2, device.height/2);
console.log("点击功能正常");
```

### 权限检查脚本
```javascript
// 检查无障碍服务
if (auto.service) {
    console.log("✓ 无障碍服务: 已启用");
} else {
    console.log("✗ 无障碍服务: 未启用");
}

// 检查悬浮窗权限
if (floaty.checkPermission()) {
    console.log("✓ 悬浮窗权限: 已授予");
} else {
    console.log("✗ 悬浮窗权限: 未授予");
}
```

## 🔧 常见问题解决

### 连接问题
- **设备未找到**: 重启模拟器和 ADB 服务
- **权限拒绝**: 检查模拟器中的开发者选项和 USB 调试
- **脚本无法运行**: 确认无障碍服务已启用

### 性能优化
- 调整模拟器分辨率为 720x1280
- 分配足够内存给模拟器
- 关闭不必要的模拟器功能

### 脚本调试
- 使用 `console.log()` 输出调试信息
- 通过 `adb logcat` 查看实时日志
- 使用 `toast()` 显示运行状态

## 📚 进阶功能

### 图像识别
```javascript
// 截图和图像处理
var img = captureScreen();
var point = findImage(img, template);
if (point) {
    click(point.x, point.y);
}
```

### 网络请求
```javascript
// HTTP 请求
var response = http.get("https://api.example.com/data");
console.log(response.body.string());
```

### 文件操作
```javascript
// 读写文件
files.write("/sdcard/data.txt", "Hello AutoJS");
var content = files.read("/sdcard/data.txt");
```

## 🎯 总结

AutoJS 与模拟器的连接已完全配置完成，具备以下能力：

- ✅ **自动化操作**: 点击、滑动、输入等
- ✅ **图像识别**: 屏幕截图和模板匹配
- ✅ **网络通信**: HTTP 请求和数据交换
- ✅ **文件系统**: 读写本地文件
- ✅ **UI 交互**: 创建悬浮窗和对话框
- ✅ **系统集成**: 调用系统功能和应用

现在可以开始开发各种自动化脚本了！

---

**创建时间**: 2025-09-29  
**连接状态**: ✅ 已连接  
**设备**: 127.0.0.1:21513 (A5010)  
**AutoJS版本**: org.autojs.autojs
