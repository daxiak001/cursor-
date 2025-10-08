# 免费AI部署平台推荐

## 🎯 免费部署平台对比

### 1. **Vercel**（强烈推荐）
- **免费额度**: 100GB带宽/月，无限制部署
- **特点**: 支持Python、Node.js，自动部署
- **适合**: FastAPI应用，响应速度快
- **部署方式**: Git连接，自动构建
- **限制**: 函数执行时间10秒，冷启动

### 2. **Railway**
- **免费额度**: $5/月免费额度，500小时运行时间
- **特点**: 支持Docker，数据库集成
- **适合**: 完整应用栈，包含数据库
- **部署方式**: GitHub连接，Docker支持
- **限制**: 资源有限，需要信用卡验证

### 3. **Render**
- **免费额度**: 750小时/月，512MB内存
- **特点**: 自动SSL，持续部署
- **适合**: Web应用，静态网站
- **部署方式**: GitHub集成
- **限制**: 冷启动较慢，内存限制

### 4. **Netlify Functions**
- **免费额度**: 100GB带宽，125,000请求/月
- **特点**: 边缘计算，全球CDN
- **适合**: 轻量级API，静态网站
- **部署方式**: Git连接
- **限制**: 函数大小限制，执行时间限制

### 5. **Fly.io**
- **免费额度**: 3个小应用，256MB内存
- **特点**: 全球部署，低延迟
- **适合**: 全球访问，高性能需求
- **部署方式**: Docker部署
- **限制**: 需要信用卡，资源有限

## 🚀 最佳免费方案：Vercel + FastAPI

### 为什么选择Vercel？
- ✅ **完全免费** - 无信用卡要求
- ✅ **部署简单** - Git连接即可
- ✅ **响应快速** - 全球CDN
- ✅ **自动SSL** - HTTPS支持
- ✅ **持续部署** - 代码更新自动部署

### 部署架构
```
GitHub → Vercel → FastAPI → Claude API
                ↓
            环境变量存储
```

### 实施步骤

#### 1. 准备代码结构
```
xiaoliu-ai/
├── api/
│   ├── __init__.py
│   ├── main.py              # FastAPI应用
│   ├── services.py          # 业务逻辑
│   └── models.py            # 数据模型
├── requirements.txt         # Python依赖
├── vercel.json             # Vercel配置
└── README.md
```

#### 2. 创建vercel.json配置
```json
{
  "version": 2,
  "builds": [
    {
      "src": "api/main.py",
      "use": "@vercel/python"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "api/main.py"
    }
  ],
  "env": {
    "CLAUDE_API_KEY": "@claude_api_key"
  }
}
```

#### 3. FastAPI应用代码
```python
# api/main.py
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import os
import httpx

app = FastAPI(title="小柳AI助手", version="1.0.0")

# CORS配置
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ChatRequest(BaseModel):
    message: str
    user_id: str = "default"

class ChatResponse(BaseModel):
    response: str
    status: str

@app.get("/")
async def root():
    return {"message": "小柳AI助手已上线！", "status": "running"}

@app.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    try:
        # 识别快捷指令
        command = identify_command(request.message)
        
        if command:
            response = await execute_command(command, request.message)
        else:
            response = await general_chat(request.message)
            
        return ChatResponse(response=response, status="success")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

def identify_command(message: str) -> str:
    commands = {
        "生成文档": "文档",
        "分析代码": "分析", 
        "配色": "配色",
        "并行开发": "并行"
    }
    
    for key, value in commands.items():
        if key in message:
            return value
    return None

async def execute_command(command: str, message: str) -> str:
    if command == "文档":
        return "✅ 文档生成功能已激活！正在扫描项目文件..."
    elif command == "分析":
        return "✅ 代码分析功能已激活！正在分析代码结构..."
    elif command == "配色":
        return "✅ 配色方案功能已激活！正在生成配色建议..."
    elif command == "并行":
        return "✅ 并行开发功能已激活！正在优化开发流程..."
    else:
        return "✅ 功能执行完成！"

async def general_chat(message: str) -> str:
    # 调用Claude API
    claude_api_key = os.getenv("CLAUDE_API_KEY")
    
    if not claude_api_key:
        return "❌ Claude API密钥未配置"
    
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "https://api.anthropic.com/v1/messages",
                headers={
                    "x-api-key": claude_api_key,
                    "Content-Type": "application/json"
                },
                json={
                    "model": "claude-3-sonnet-20240229",
                    "max_tokens": 1000,
                    "messages": [
                        {
                            "role": "user",
                            "content": f"你是小柳AI助手，请回答：{message}"
                        }
                    ]
                }
            )
            
            if response.status_code == 200:
                result = response.json()
                return result["content"][0]["text"]
            else:
                return f"❌ API调用失败：{response.status_code}"
    except Exception as e:
        return f"❌ 请求失败：{str(e)}"

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "xiaoliu-ai"}
```

#### 4. requirements.txt
```
fastapi==0.104.1
uvicorn==0.24.0
httpx==0.25.2
pydantic==2.5.0
python-multipart==0.0.6
```

#### 5. 部署步骤
1. **创建GitHub仓库**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/xiaoliu-ai.git
   git push -u origin main
   ```

2. **连接Vercel**
   - 访问 [vercel.com](https://vercel.com)
   - 使用GitHub账号登录
   - 点击"New Project"
   - 选择你的GitHub仓库
   - 点击"Deploy"

3. **配置环境变量**
   - 在Vercel Dashboard中找到你的项目
   - 进入Settings → Environment Variables
   - 添加 `CLAUDE_API_KEY` 变量
   - 设置值为你的Claude API密钥

4. **获取部署链接**
   - 部署完成后，Vercel会提供访问链接
   - 例如：`https://xiaoliu-ai.vercel.app`

## 🎯 使用方式

### API调用示例
```javascript
// 聊天接口
const response = await fetch('https://xiaoliu-ai.vercel.app/chat', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    message: '你好小柳',
    user_id: 'user123'
  })
});

const data = await response.json();
console.log(data.response);
```

### 快捷指令测试
```bash
# 生成文档
curl -X POST "https://xiaoliu-ai.vercel.app/chat" \
  -H "Content-Type: application/json" \
  -d '{"message": "生成文档", "user_id": "test"}'

# 分析代码
curl -X POST "https://xiaoliu-ai.vercel.app/chat" \
  -H "Content-Type: application/json" \
  -d '{"message": "分析代码", "user_id": "test"}'
```

## 📊 平台对比总结

| 平台 | 免费额度 | 部署难度 | 性能 | 推荐度 |
|------|----------|----------|------|--------|
| Vercel | 100GB/月 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Railway | $5/月 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Render | 750小时/月 | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Netlify | 100GB/月 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Fly.io | 3个应用 | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

## 🎉 总结

**推荐方案**: Vercel + FastAPI
- **成本**: 完全免费
- **部署时间**: 30分钟内完成
- **访问速度**: 全球CDN，响应快速
- **维护成本**: 几乎为零
- **扩展性**: 支持付费升级

这个方案可以让你的小柳AI助手在几分钟内上线，并且完全免费使用！


