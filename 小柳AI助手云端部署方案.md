# 小柳AI助手云端部署方案

## 📋 系统架构分析

### 当前系统特点
- **推理引擎**: Claude API
- **工具集**: 完整功能模块在 D:\xiaoliu
- **功能模块**: 文档生成、代码分析、配色设计、并行开发等
- **工作模式**: 主动执行、自动保存、智能选择

### 部署需求
- **高可用性**: 7x24小时服务
- **跨平台访问**: 随时随地可用
- **数据安全**: 保护用户数据和隐私
- **成本控制**: 合理的资源使用

## 🚀 推荐部署方案

### 方案一：容器化部署（推荐）

#### 技术栈
- **容器**: Docker + Docker Compose
- **Web框架**: FastAPI + Uvicorn
- **数据库**: SQLite/PostgreSQL
- **缓存**: Redis
- **反向代理**: Nginx

#### 架构设计
```
用户请求 → Nginx → FastAPI → Claude API → 工具集 → 响应
                ↓
            数据库/缓存
```

#### 优势
- ✅ 环境一致性
- ✅ 快速部署和扩展
- ✅ 资源隔离
- ✅ 易于维护

### 方案二：云原生部署

#### 技术栈
- **容器编排**: Kubernetes
- **服务网格**: Istio
- **监控**: Prometheus + Grafana
- **日志**: ELK Stack

#### 优势
- ✅ 高可用性
- ✅ 自动扩缩容
- ✅ 服务发现
- ✅ 完善监控

### 方案三：Serverless部署

#### 技术栈
- **函数计算**: AWS Lambda / 阿里云函数计算
- **API网关**: AWS API Gateway / 阿里云API网关
- **存储**: S3 / OSS

#### 优势
- ✅ 按需付费
- ✅ 自动扩缩容
- ✅ 无需服务器管理
- ✅ 快速部署

## 🏗️ 详细实施方案

### 阶段一：基础环境搭建

#### 1. 云服务器选择
**推荐配置**:
- **CPU**: 2-4核
- **内存**: 4-8GB
- **存储**: 50-100GB SSD
- **网络**: 5Mbps以上带宽

**推荐平台**:
1. **阿里云ECS** - 国内访问速度快
2. **腾讯云CVM** - 性价比高
3. **AWS EC2** - 全球覆盖
4. **华为云ECS** - 企业级服务

#### 2. 系统环境
```bash
# Ubuntu 20.04 LTS 或 CentOS 8
# 安装Docker和Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# 安装Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 阶段二：应用容器化

#### 1. 项目结构
```
xiaoliu-ai/
├── app/
│   ├── main.py              # FastAPI主应用
│   ├── models/              # 数据模型
│   ├── services/            # 业务逻辑
│   ├── tools/               # 工具集
│   └── utils/               # 工具函数
├── docker/
│   ├── Dockerfile           # 应用镜像
│   └── docker-compose.yml   # 服务编排
├── nginx/
│   └── nginx.conf           # 反向代理配置
├── requirements.txt         # Python依赖
└── README.md               # 部署说明
```

#### 2. Dockerfile
```dockerfile
FROM python:3.9-slim

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY app/ .

# 暴露端口
EXPOSE 8000

# 启动命令
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

#### 3. docker-compose.yml
```yaml
version: '3.8'

services:
  xiaoliu-ai:
    build: .
    ports:
      - "8000:8000"
    environment:
      - CLAUDE_API_KEY=${CLAUDE_API_KEY}
      - REDIS_URL=redis://redis:6379
    depends_on:
      - redis
    volumes:
      - ./data:/app/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - xiaoliu-ai
    restart: unless-stopped

volumes:
  redis_data:
```

### 阶段三：应用开发

#### 1. FastAPI主应用
```python
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn

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

@app.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    try:
        # 调用小柳AI助手逻辑
        response = await process_message(request.message, request.user_id)
        return ChatResponse(response=response, status="success")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "xiaoliu-ai"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

#### 2. 核心服务逻辑
```python
import asyncio
from typing import Dict, Any
import httpx
import json

class XiaoliuAIService:
    def __init__(self, claude_api_key: str):
        self.claude_api_key = claude_api_key
        self.base_url = "https://api.anthropic.com/v1/messages"
        
    async def process_message(self, message: str, user_id: str) -> str:
        # 识别快捷指令
        command = self._identify_command(message)
        
        if command:
            return await self._execute_command(command, message, user_id)
        else:
            return await self._general_chat(message, user_id)
    
    def _identify_command(self, message: str) -> str:
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
    
    async def _execute_command(self, command: str, message: str, user_id: str) -> str:
        # 根据命令类型执行相应功能
        if command == "文档":
            return await self._generate_document(message)
        elif command == "分析":
            return await self._analyze_code(message)
        elif command == "配色":
            return await self._generate_color_scheme(message)
        elif command == "并行":
            return await self._parallel_development(message)
        
    async def _general_chat(self, message: str, user_id: str) -> str:
        # 调用Claude API进行对话
        async with httpx.AsyncClient() as client:
            response = await client.post(
                self.base_url,
                headers={
                    "x-api-key": self.claude_api_key,
                    "Content-Type": "application/json"
                },
                json={
                    "model": "claude-3-sonnet-20240229",
                    "max_tokens": 1000,
                    "messages": [
                        {
                            "role": "user",
                            "content": message
                        }
                    ]
                }
            )
            
            if response.status_code == 200:
                result = response.json()
                return result["content"][0]["text"]
            else:
                raise Exception(f"Claude API error: {response.status_code}")
```

### 阶段四：部署和配置

#### 1. 环境变量配置
```bash
# .env文件
CLAUDE_API_KEY=your_claude_api_key_here
REDIS_URL=redis://localhost:6379
DATABASE_URL=sqlite:///./xiaoliu_ai.db
LOG_LEVEL=INFO
```

#### 2. Nginx配置
```nginx
events {
    worker_connections 1024;
}

http {
    upstream xiaoliu_ai {
        server xiaoliu-ai:8000;
    }

    server {
        listen 80;
        server_name your-domain.com;

        location / {
            proxy_pass http://xiaoliu_ai;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /health {
            proxy_pass http://xiaoliu_ai/health;
        }
    }
}
```

#### 3. 部署脚本
```bash
#!/bin/bash
# deploy.sh

echo "开始部署小柳AI助手..."

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "Docker未安装，请先安装Docker"
    exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose未安装，请先安装Docker Compose"
    exit 1
fi

# 创建必要的目录
mkdir -p data logs ssl

# 复制环境变量文件
if [ ! -f .env ]; then
    cp .env.example .env
    echo "请编辑.env文件，配置必要的环境变量"
    exit 1
fi

# 构建和启动服务
docker-compose up -d --build

# 等待服务启动
sleep 10

# 检查服务状态
docker-compose ps

echo "部署完成！"
echo "服务地址: http://your-domain.com"
echo "健康检查: http://your-domain.com/health"
```

## 🔧 运维和监控

### 1. 日志管理
```yaml
# 在docker-compose.yml中添加日志配置
services:
  xiaoliu-ai:
    # ... 其他配置
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### 2. 监控配置
```python
# 添加Prometheus监控
from prometheus_client import Counter, Histogram, generate_latest
import time

REQUEST_COUNT = Counter('requests_total', 'Total requests', ['method', 'endpoint'])
REQUEST_DURATION = Histogram('request_duration_seconds', 'Request duration')

@app.middleware("http")
async def monitor_requests(request, call_next):
    start_time = time.time()
    
    response = await call_next(request)
    
    duration = time.time() - start_time
    REQUEST_COUNT.labels(method=request.method, endpoint=request.url.path).inc()
    REQUEST_DURATION.observe(duration)
    
    return response

@app.get("/metrics")
async def metrics():
    return generate_latest()
```

### 3. 备份策略
```bash
#!/bin/bash
# backup.sh

# 备份数据库
docker-compose exec xiaoliu-ai python -c "
import sqlite3
import shutil
shutil.copy('/app/data/xiaoliu_ai.db', '/app/backup/xiaoliu_ai_$(date +%Y%m%d_%H%M%S).db')
"

# 备份配置文件
tar -czf backup_$(date +%Y%m%d_%H%M%S).tar.gz .env docker-compose.yml nginx/
```

## 💰 成本估算

### 方案一：容器化部署
- **云服务器**: 200-500元/月
- **域名**: 50-100元/年
- **SSL证书**: 免费（Let's Encrypt）
- **总成本**: 约250-600元/月

### 方案二：云原生部署
- **Kubernetes集群**: 500-1000元/月
- **负载均衡**: 100-200元/月
- **监控服务**: 100-300元/月
- **总成本**: 约700-1500元/月

### 方案三：Serverless部署
- **函数调用**: 按使用量计费
- **API网关**: 按请求数计费
- **存储**: 按使用量计费
- **总成本**: 约50-200元/月（轻量使用）

## 🎯 推荐实施路径

### 第一阶段：MVP部署（1-2周）
1. 选择方案一（容器化部署）
2. 使用阿里云ECS
3. 实现基础聊天功能
4. 配置域名和SSL

### 第二阶段：功能完善（2-3周）
1. 集成所有工具集功能
2. 添加用户管理
3. 实现数据持久化
4. 优化性能和稳定性

### 第三阶段：生产优化（1-2周）
1. 添加监控和日志
2. 实现自动备份
3. 配置负载均衡
4. 性能调优

## 📞 技术支持

### 部署支持
- 提供完整的部署脚本
- 详细的配置文档
- 故障排除指南

### 运维支持
- 监控告警配置
- 自动备份方案
- 性能优化建议

### 定制开发
- 功能扩展
- 界面定制
- 集成其他服务

---

**总结**: 推荐使用容器化部署方案，成本适中，部署简单，维护方便。可以根据实际需求选择合适的云平台和配置。
