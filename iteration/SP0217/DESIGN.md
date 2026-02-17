# SP0217 设计文档：复合搜索插件

## 架构设计

### 系统架构

```
┌─────────────────────────────────────────────────────────────────────┐
│                          用户层                                      │
│  ┌──────────────────┐  ┌──────────────────┐                       │
│  │   浏览器(Web UI)  │  │   OpenClaw CLI   │                       │
│  │   :18443         │  │                  │                       │
│  └────────┬─────────┘  └────────┬─────────┘                       │
└───────────┼─────────────────────┼─────────────────────────────────┘
            │                     │
            ▼                     ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      OpenClaw Gateway                                │
│                    (ws://0.0.0.0:18789)                              │
│                                                                      │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                     Agent 层                                   │  │
│  │  ┌───────────────────────────────────────────────────────────┐│  │
│  │  │                    Model Provider                          ││  │
│  │  │              bailian/qwen3-max                            ││  │
│  │  └───────────────────────────────────────────────────────────┘│  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                      │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                   Plugins 层                                   │  │
│  │  ┌───────────────────────────────────────────────────────────┐│  │
│  │  │              Composite Search Plugin                        ││  │
│  │  │  ┌─────────────┐ ┌─────────────┐ ┌──────────────────────┐ ││  │
│  │  │  │   Baidu     │ │   Gaode     │ │       Brave          │ ││  │
│  │  │  │  (通用搜索)  │ │  (POI/路线)  │ │    (海外搜索)         │ ││  │
│  │  │  └─────────────┘ └─────────────┘ └──────────────────────┘ ││  │
│  │  └───────────────────────────────────────────────────────────┘│  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
            │                     │                      │
            ▼                     ▼                      ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│  百度搜索 API    │  │  高德地图 API     │  │  Brave Search    │
└──────────────────┘  └──────────────────┘  └──────────────────┘
```

## 核心模块设计

### 1. 复合搜索插件 (Composite Search)

#### 1.1 插件架构

```javascript
// openclaw.plugin.json
{
  "name": "composite_search",
  "version": "1.0.0",
  "entry": "index.js",
  "tools": [
    {
      "name": "composite_search",
      "description": "多源聚合搜索工具",
      "parameters": {
        "type": "object",
        "properties": {
          "query": {
            "type": "string",
            "description": "搜索关键词"
          },
          "source": {
            "type": "string",
            "enum": ["baidu", "gaode", "brave", "all"],
            "default": "all"
          }
        },
        "required": ["query"]
      }
    }
  ]
}
```

#### 1.2 搜索源策略

| 搜索源 | 适用场景 | API |
|--------|----------|-----|
| Baidu | 通用中文搜索 | 百度搜索资源平台 API |
| Gaode | 地理位置、POI、路线 | 高德地图 Web API |
| Brave | 海外内容、英文搜索 | Brave Search API |

#### 1.3 Query Router 规则

```javascript
const routingRules = {
  gaode: ['附近', '地址', '怎么去', '路线', '导航', 'POI', '地图', '餐厅', '酒店'],
  brave: ['英文', 'github', 'stackoverflow', '国外', 'international'],
  baidu: ['default']
};
```

### 2. 插件加载配置

```json
{
  "plugins": {
    "enabled": true,
    "load": {
      "paths": ["/data/composite-search"]
    },
    "entries": {
      "composite-search": {
        "enabled": true
      }
    }
  }
}
```

### 3. 工具禁用配置

```json
{
  "tools": {
    "deny": ["web_search"]
  }
}
```

## 数据流

```
用户请求搜索
     │
     ▼
Agent 识别需要搜索
     │
     ▼
调用 composite_search 工具
     │
     ▼
Query Router 分析查询意图
     │
     ▼
选择搜索源 (Baidu/Gaode/Brave)
     │
     ▼
并行调用多个 API
     │
     ▼
结果合并 & 格式化
     │
     ▼
返回结构化数据给 Agent
     │
     ▼
Agent 整合搜索结果生成回复
```

## 环境变量

```bash
# Search APIs
BAIDU_API_KEY=***
GAODE_API_KEY=***
BRAVE_API_KEY=***
```

## 部署步骤

1. 同步 composite-search 代码到服务器 `/data/composite-search/`
2. 配置 openclaw.json 添加 plugins 配置
3. 复制插件到容器 `/app/composite-search/`
4. 安装依赖 `npm install`
5. 重启 OpenClaw Gateway

## 验证方法

```bash
# 测试搜索
curl -X POST https://175.178.157.123.nip.io:18443/api/v1/tools/composite_search \
  -H "Authorization: Bearer 9fdea33381da4fe1acb517121ab8c473" \
  -d '{"query": "杭州西湖"}'

# 查看日志
docker logs openclaw-deploy-openclaw-gateway-1 | grep composite_search
```
