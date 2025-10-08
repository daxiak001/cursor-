# 小柳AI助手

基于Claude API的智能助手，支持多种快捷指令和功能。

## 功能特性

- 🚀 快捷指令识别
- 📝 文档生成
- 🔍 代码分析  
- 🎨 配色方案
- ⚡ 并行开发
- 🛠️ 性能优化
- 🧪 测试生成

## 🚀 快速部署

### 方式一：Railway部署（推荐 - 稳定可靠）

1. **一键部署**
   - 访问 [Railway.app](https://railway.app)
   - 使用GitHub登录
   - 点击 "New Project" → "Deploy from GitHub repo"
   - 选择此仓库

2. **配置环境变量**
   - 在 Railway Dashboard 中添加：
   - `CLAUDE_API_KEY` = 你的Claude API密钥

3. **获取部署URL**
   - 部署完成后，Railway会自动分配URL
   - 例如：`https://xiaoliu-production.up.railway.app`

### 方式二：Vercel部署（快速）

1. Fork 此仓库
2. 在 Vercel 中导入项目
3. 配置环境变量 `CLAUDE_API_KEY`
4. 部署完成

## API 使用

### 聊天接口
```bash
POST /chat
{
  "message": "你好小柳",
  "user_id": "user123"
}
```

### 健康检查
```bash
GET /health
```

### 功能列表
```bash
GET /features
```

## 快捷指令

- `你好小柳` / `小柳你好` / `hi小柳` - 确认接入
- `小柳在吗` / `小柳状态` - 查看状态
- `生成文档` / `写文档` / `@文档` - 文档生成
- `分析代码` / `代码分析` / `@分析` - 代码分析
- `配色` / `配色方案` / `@配色` - 配色方案
- `并行开发` / `@并行` - 并行开发
- `优化性能` / `@优化` - 性能优化
- `写测试` / `@测试` - 测试生成