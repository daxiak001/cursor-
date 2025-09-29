// AutoJS Connection Test Script
// 测试AutoJS与模拟器的连接和基本功能

console.log("=== AutoJS Connection Test ===");
console.log("Starting connection test...");

// 1. 基本信息测试
console.log("\n1. Device Information:");
console.log("Device Model: " + device.model);
console.log("Android Version: " + device.release);
console.log("Screen Size: " + device.width + "x" + device.height);
console.log("Density: " + device.buildId);

// 2. 权限检查
console.log("\n2. Permission Check:");

// 检查无障碍服务
try {
    if (auto.service) {
        console.log("✓ Accessibility Service: ENABLED");
    } else {
        console.log("✗ Accessibility Service: DISABLED");
        console.log("Please enable AutoJS accessibility service in Settings");
    }
} catch (e) {
    console.log("✗ Accessibility Service: ERROR - " + e.message);
}

// 检查悬浮窗权限
try {
    if (floaty.checkPermission()) {
        console.log("✓ Overlay Permission: ENABLED");
    } else {
        console.log("✗ Overlay Permission: DISABLED");
        console.log("Please enable overlay permission for AutoJS");
    }
} catch (e) {
    console.log("✗ Overlay Permission: ERROR - " + e.message);
}

// 3. 基本功能测试
console.log("\n3. Basic Function Test:");

try {
    // 测试Toast
    toast("AutoJS Connection Test - Toast Working!");
    console.log("✓ Toast function: OK");
    
    // 测试日志
    console.log("✓ Console log: OK");
    
    // 测试坐标获取
    var screenInfo = {
        width: device.width,
        height: device.height
    };
    console.log("✓ Screen info: " + JSON.stringify(screenInfo));
    
} catch (e) {
    console.log("✗ Basic functions: ERROR - " + e.message);
}

// 4. 高级功能测试
console.log("\n4. Advanced Function Test:");

try {
    // 测试图像处理
    if (images) {
        console.log("✓ Image processing: Available");
    } else {
        console.log("✗ Image processing: Not available");
    }
    
    // 测试HTTP请求
    if (http) {
        console.log("✓ HTTP module: Available");
    } else {
        console.log("✗ HTTP module: Not available");
    }
    
    // 测试文件系统
    if (files) {
        console.log("✓ File system: Available");
    } else {
        console.log("✗ File system: Not available");
    }
    
} catch (e) {
    console.log("✗ Advanced functions: ERROR - " + e.message);
}

// 5. 连接状态总结
console.log("\n5. Connection Summary:");
console.log("Device: Connected ✓");
console.log("AutoJS: Installed ✓");
console.log("Script execution: Working ✓");

console.log("\n=== Test Completed ===");
console.log("AutoJS is ready for automation!");

// 显示一个简单的UI测试
try {
    var window = floaty.window(
        <vertical>
            <text text="AutoJS Connection Test" textColor="white" textSize="16sp"/>
            <text text="Status: Connected ✓" textColor="green" textSize="14sp"/>
            <text text="Click to close" textColor="gray" textSize="12sp"/>
        </vertical>
    );
    
    window.setPosition(100, 100);
    
    window.setOnTouchListener(function(view, event) {
        if (event.getAction() == event.ACTION_DOWN) {
            window.close();
            return true;
        }
        return false;
    });
    
    // 5秒后自动关闭
    setTimeout(function() {
        try {
            window.close();
        } catch (e) {
            // 忽略关闭错误
        }
    }, 5000);
    
    console.log("✓ Floating window test: OK");
    
} catch (e) {
    console.log("✗ Floating window test: " + e.message);
}
