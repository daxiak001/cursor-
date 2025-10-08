# 🚀 一键部署小柳AI助手到Railway

## 方式一：一键部署按钮（最简单）

点击下面的按钮，一键部署到Railway：

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template?template=https://github.com/daxiak001/cursor-)

## 方式二：手动部署

### 步骤1：访问Railway

打开浏览器，访问：https://railway.app

### 步骤2：使用GitHub登录

点击 "Login with GitHub" 并授权

### 步骤3：创建新项目

1. 点击 "New Project"
2. 选择 "Deploy from GitHub repo"
3. 搜索并选择 `daxiak001/cursor-`
4. 点击 "Deploy Now"

### 步骤4：配置环境变量

在Railway Dashboard中：

1. 点击你的项目
2. 进入 "Variables" 标签
3. 添加环境变量：
   ```
   CLAUDE_API_KEY=你的Claude_API密钥
   ```
4. 点击 "Add" 保存

### 步骤5：等待部署完成

- 部署通常需要2-3分钟
- 在 "Deployments" 标签查看进度
- 看到 "Success" 表示部署成功

### 步骤6：获取访问URL

1. 在项目页面，点击 "Settings"
2. 找到 "Domains" 部分
3. 点击 "Generate Domain"
4. 复制生成的URL，例如：
   ```
   https://cursor-production.up.railway.app
   ```

### 步骤7：测试API

打开浏览器或使用curl测试：

```bash
# 健康检查
curl https://你的URL/health

# 测试聊天
curl -X POST https://你的URL/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "你好小柳", "user_id": "test"}'
```

## 🎉 部署成功！

现在您可以：

1. **使用全自动安装脚本**
   - 编辑 `🚀 全自动安装.bat`
   - 将你的Railway URL添加到API列表
   - 运行脚本自动配置客户端

2. **直接调用API**
   - 使用获取的URL直接调用
   - 支持所有快捷指令

3. **自定义域名（可选）**
   - 在Railway中配置自定义域名
   - 提升专业度和易记性

## 📊 监控和管理

在Railway Dashboard中：

- **Metrics**: 查看CPU、内存、网络使用情况
- **Logs**: 实时查看应用日志
- **Deployments**: 查看部署历史
- **Variables**: 管理环境变量

## 💰 费用说明

- **免费额度**: $5/月，约500小时运行时间
- **个人使用**: 完全免费
- **升级选项**: 需要更多资源时可升级

## ⚠️ 常见问题

### Q: 部署失败怎么办？
A: 查看 "Logs" 标签的错误信息，通常是环境变量配置问题

### Q: 如何更新代码？
A: 推送到GitHub，Railway会自动重新部署

### Q: Claude API密钥在哪获取？
A: 访问 https://console.anthropic.com 获取

### Q: 可以使用免费的Claude API吗？
A: 需要有效的Claude API密钥，可申请免费试用

---

**需要帮助？** 查看 [DEPLOYMENT.md](./DEPLOYMENT.md) 获取详细文档

