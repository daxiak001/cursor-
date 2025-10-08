# 小柳AI助手 - 客户端安装

## 📦 一键安装

### Windows用户

1. **下载安装脚本**
   - `🚀 全自动安装.bat` - 全自动安装
   - `✅ 验证安装.bat` - 验证安装

2. **运行安装**
   ```
   双击：🚀 全自动安装.bat
   ```

3. **等待完成**
   - 脚本会自动检测云端服务
   - 创建配置文件
   - 重启Cursor
   - 约30秒完成

### 验证安装

```
双击：✅ 验证安装.bat
```

## 🎯 使用说明

### 在Cursor中使用

安装完成后，在Cursor的AI对话框中输入：

#### 确认接入
```
你好小柳
小柳在吗
```

#### 快捷指令
```
生成文档     - 自动生成项目文档
分析代码     - 代码质量分析
配色        - 配色方案建议
并行开发     - 并行开发优化
优化性能     - 性能优化建议
写测试      - 生成测试用例
```

## 🔧 配置说明

### 配置文件位置
```
%USERPROFILE%\.cursorrc
```

### 配置内容
```json
{
  "xiaoliu": {
    "enabled": true,
    "apiUrl": "https://cursor-production.up.railway.app",
    "version": "6.2.0",
    "features": {
      "documentation": true,
      "codeAnalysis": true,
      "colorScheme": true,
      "parallelDev": true
    }
  }
}
```

### 手动修改API地址

编辑配置文件，修改 `apiUrl` 为你的部署地址：
- Railway: `https://your-app.up.railway.app`
- Vercel: `https://your-app.vercel.app`

## ⚠️ 常见问题

### 1. 安装失败
**原因**: 云端服务未部署

**解决**:
1. 查看 `../DEPLOYMENT.md` 部署云端服务
2. 或使用提供的默认API地址

### 2. 连接超时
**原因**: 网络问题或API未启动

**解决**:
1. 检查网络连接
2. 访问 API 地址检查服务状态
3. 运行 `✅ 验证安装.bat` 诊断

### 3. Cursor未重启
**原因**: Cursor安装路径不标准

**解决**:
1. 手动关闭Cursor
2. 手动重新启动Cursor
3. 配置已自动保存

### 4. 功能不响应
**原因**: 配置文件格式错误

**解决**:
1. 删除 `%USERPROFILE%\.cursorrc`
2. 重新运行安装脚本

## 📊 技术细节

### 自动检测逻辑

安装脚本会按顺序检测以下API：
1. `https://cursor-production.up.railway.app`
2. `https://xiaoliu-production.up.railway.app`
3. `https://cursor-.vercel.app`

找到第一个可用的API后，自动配置并使用。

### 验证测试

验证脚本会进行6项测试：
1. ✓ 配置文件存在
2. ✓ 配置内容正确
3. ✓ 健康检查通过
4. ✓ API根路径正常
5. ✓ 功能列表获取
6. ✓ 聊天接口测试

全部通过表示安装成功！

## 🚀 下一步

1. **部署云端服务**
   - 查看 `../DEPLOYMENT.md`
   - 一键部署到Railway

2. **自定义配置**
   - 修改API地址
   - 启用/禁用功能

3. **开始使用**
   - 在Cursor中输入"你好小柳"
   - 享受智能开发体验

## 📞 获取帮助

- 部署问题：查看 `DEPLOYMENT.md`
- 测试问题：查看 `本地测试指南.md`
- API文档：查看 `README.md`

---

**祝您使用愉快！**

