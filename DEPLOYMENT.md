# 小柳AI助手 - 云端部署指南

## 🚀 Railway一键部署（推荐）

### 为什么选择Railway？
- ✅ 免费额度充足（$5/月，约500小时）
- ✅ 支持长连接，无冷启动
- ✅ 自动SSL证书
- ✅ GitHub集成，自动部署
- ✅ 配置简单，维护方便

### 部署步骤

#### 1. 准备工作
- GitHub账号
- Railway账号（可用GitHub登录）
- Claude API密钥

#### 2. 部署到Railway

**方式一：使用GitHub（推荐）**

1. **Fork此仓库**
   ```bash
   # 在GitHub上Fork此仓库到你的账号
   ```

2. **连接Railway**
   - 访问 https://railway.app
   - 点击 "Start a New Project"
   - 选择 "Deploy from GitHub repo"
   - 授权并选择你Fork的仓库

3. **自动部署**
   - Railway会自动检测配置文件
   - 自动安装依赖并启动服务
   - 等待部署完成（约2-3分钟）

**方式二：使用Railway CLI**

```bash
# 1. 安装Railway CLI
npm i -g @railway/cli

# 2. 登录Railway
railway login

# 3. 初始化项目
railway init

# 4. 部署
railway up
```

#### 3. 配置环境变量

在Railway Dashboard中：

1. 进入你的项目
2. 点击 "Variables" 标签
3. 添加以下变量：

```bash
CLAUDE_API_KEY=sk-ant-xxxxx  # 你的Claude API密钥
PORT=8000                      # 端口（Railway会自动设置）
```

#### 4. 获取部署URL

1. 在Railway Dashboard中，点击 "Settings"
2. 找到 "Domains" 部分
3. 点击 "Generate Domain"
4. 复制生成的URL（如：`xiaoliu-production.up.railway.app`）

#### 5. 测试部署

```bash
# 健康检查
curl https://your-app.up.railway.app/health

# 测试聊天
curl -X POST https://your-app.up.railway.app/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "你好小柳", "user_id": "test"}'
```

## 🔧 Vercel部署（备选方案）

### 适用场景
- 轻量级API调用
- 无需长连接
- 快速测试

### 部署步骤

1. **安装Vercel CLI**
   ```bash
   npm i -g vercel
   ```

2. **登录并部署**
   ```bash
   vercel login
   vercel
   ```

3. **配置环境变量**
   ```bash
   vercel env add CLAUDE_API_KEY
   ```

4. **重新部署**
   ```bash
   vercel --prod
   ```

## 📋 部署后配置

### 1. 更新安装脚本

编辑 `🚀 全自动安装.bat`，将你的部署URL添加到API列表：

```batch
set API1=https://your-app.up.railway.app/v1
set API2=https://xiaoliu-production.up.railway.app/v1
set API3=https://xiaoliu.vercel.app/v1
```

### 2. 配置自定义域名（可选）

**Railway配置：**
1. 在 Railway Dashboard → Settings → Domains
2. 点击 "Custom Domain"
3. 输入你的域名（如：api.xiaoliu.com）
4. 在域名DNS设置中添加CNAME记录

**DNS设置：**
```
类型: CNAME
名称: api
值: your-app.up.railway.app
```

### 3. 配置监控告警（可选）

在Railway Dashboard中：
1. 进入 "Metrics" 查看使用情况
2. 设置资源告警阈值
3. 配置邮件通知

## 🔍 故障排查

### 部署失败
```bash
# 查看构建日志
railway logs

# 检查环境变量
railway variables
```

### API调用失败
1. 检查CLAUDE_API_KEY是否正确
2. 确认API密钥有足够额度
3. 查看Railway日志排查错误

### 连接超时
- Railway: 检查健康检查路径 `/health`
- 确认服务正常运行
- 检查端口配置

## 📊 成本预估

### Railway免费额度
- $5/月免费额度
- 约500小时运行时间
- 100GB出站流量
- 1GB内存

**适合场景：**
- 个人使用：完全免费
- 小团队：免费额度足够
- 生产环境：需要付费升级

### Vercel免费额度
- 100GB带宽/月
- 无限次部署
- 自动SSL

**限制：**
- 函数执行时间10秒
- 有冷启动延迟

## 🎯 推荐配置

### 个人使用
- **平台**: Railway
- **配置**: 默认（512MB内存）
- **成本**: 免费

### 团队使用
- **平台**: Railway
- **配置**: 1GB内存
- **成本**: 约$5-10/月

### 生产环境
- **平台**: Railway Pro
- **配置**: 2GB内存，自动扩缩容
- **成本**: 约$20-50/月

## 📞 技术支持

遇到问题？
1. 查看 [Railway文档](https://docs.railway.app)
2. 检查项目日志
3. 提交Issue到GitHub

---

**部署完成后，使用 `🚀 全自动安装.bat` 一键连接到云端小柳！**

