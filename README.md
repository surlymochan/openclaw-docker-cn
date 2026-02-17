# OpenClaw CN

一行命令部署 OpenClaw，支持复合搜索插件（高德地图 + 百度AI搜索）。

```bash
./deploy-openclaw-cn.sh <你的服务器IP>
```

[English Version](README_EN.md)

---

## 核心特性

| 特性 | 说明 |
|------|------|
| 🚀 **一键部署** | 单命令完成完整部署，无需手动配置 |
| 🔥 **qwen3-max 模型** | 内置通义千问 Qwen3 Max 模型（80k 上下文）|
| 🇨🇳 **国内优化** | NPM 镜像加速，解决网络问题 |
| 🔒 **公网 HTTPS** | Caddy 自动 HTTPS，支持公网 Web 访问 |
| 🔍 **复合搜索** | 百度 AI 智能搜索 + 高德地图 POI 搜索 |

---

## 一步启动

```bash
# 部署 OpenClaw
./deploy-openclaw-cn.sh <你的服务器IP>
```

脚本自动完成：
- 拉取 OpenClaw 源码 → 构建 Docker 镜像 → 启动服务
- 配置 qwen3-max 模型 → 启用复合搜索插件
- 设置 HTTPS 反向代理 → 生成安全 Token

访问 `https://<IP>.nip.io:18443`，开始使用！

---

## 复合搜索功能

### 功能特点
- **百度 AI 搜索**: 通用中文搜索，AI 智能总结
- **高德地图搜索**: POI、地址、路线、出行信息
- **智能路由**: 自动根据查询内容选择最佳搜索引擎
- **禁用内置搜索**: 避免重复功能和 token 浪费

### 使用方法
在 OpenClaw Chat 中使用：
```
/search 杭州西湖
/search 人工智能最新发展  
/search 北京三里屯美食推荐
```

### 配置搜索 API Keys
在项目根目录下创建 `search.env` 文件：
```bash
GAODE_API_KEY=your-gaode-key
BAIDU_API_KEY=your-baidu-api-key
```

然后重新部署即可启用搜索功能。

---

## 常见问题

**Token 在哪？**
```bash
ssh root@<IP> "cat /data/openclaw-deploy/.env | grep TOKEN"
```

**怎么重启？**
```bash
ssh root@<IP> "cd /data/openclaw-deploy && docker compose restart"
```

**怎么看日志？**
```bash
ssh root@<IP> "docker logs openclaw-deploy-openclaw-gateway-1 -f"
```

---

## 进阶配置

### 启用模型对话

在项目根目录下创建 `llm.env` 文件：

```bash
BAILIAN_API_KEY=your-key
```

重新部署。

### 本地源码调试

```bash
./deploy-openclaw.sh <IP> /path/to/openclaw
```

---

## 默认配置

- **AI 模型**: qwen3-max (80k 上下文，8192 输出)
- **公网访问**: HTTPS 18443 端口 (Caddy 自动证书)
- **搜索功能**: 复合搜索插件 (百度 AI + 高德地图)

---

## 声明

社区工具，与 OpenClaw 官方无关。