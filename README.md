# OpenClaw Docker CN (一键部署包)

[English](./README_EN.md)

**本项目旨在为国内用户提供一个简单、稳定、一键式的 OpenClaw 部署方案。**

## 核心特性

*   🚀 **一键部署**: 自动拉取源码、注入国内源、构建镜像、启动服务。
*   🇨🇳 **国内优化**: 内置 NPM 淘宝镜像配置，解决构建时的网络问题。
*   🔒 **HTTPS 直连**: 集成 Caddy 反向代理，自动伪装 Origin，无需 SSH 隧道即可访问 Web UI。
*   🤖 **Qwen3-Max 模型**: 默认配置阿里百炼 qwen3-max 模型（80k context）。
*   🛠 **运维增强**: 镜像内预装常用工具 (`vim`, `curl` 等) 及 `openclaw` CLI 别名。

## 快速开始

### 1. 准备工作

*   一台安装了 Docker 和 SSH 的 Linux 服务器（如腾讯云、阿里云）。
*   本地机器（Mac/Linux）安装了 `rsync` 和 `git`。
*   阿里百炼 API Key（可选，用于模型对话功能）。

### 2. 配置密钥（可选）

创建密钥文件 `../../private/keys/openclaw-docker-cn/llm.env`：

```bash
# 阿里百炼 API Key
BAILIAN_API_KEY=your-api-key-here
```

### 3. 执行部署

在本地执行部署脚本，传入服务器 IP：

```bash
./deploy-openclaw.sh <服务器IP>
# 例如: ./deploy-openclaw.sh 1.2.3.4
```

脚本会自动完成以下操作：
1.  从 GitHub 拉取 OpenClaw 最新源码。
2.  注入定制的 Dockerfile（配置国内源）。
3.  同步到服务器并构建镜像。
4.  生成 openclaw.json 配置（qwen3-max 模型）。
5.  启动 OpenClaw Gateway 和 Caddy。

### 4. 使用本地源码（可选）

如果你需要使用本地源码进行调试，可以传递本地源码路径：

```bash
./deploy-openclaw.sh <服务器IP> <本地源码路径>
# 例如: ./deploy-openclaw.sh 1.2.3.4 /path/to/openclaw
```

### 5. 访问与配对

部署成功后，脚本会输出访问地址。

1.  打开浏览器访问：`https://<服务器IP>.nip.io:18443`
    *   *注意：由于使用自签名证书，浏览器会提示不安全，请点击"继续前往" (Proceed)。*
2.  如果页面提示 **"Pairing Required"** 或要求输入 Token：
    *   查看服务器上的 Token：`ssh root@<IP> "cat /data/openclaw-deploy/.env | grep TOKEN"`
    *   在 Web UI 的 Overview 页面输入 Token 完成配对
3.  页面将自动刷新并连接成功。

## 模型配置

默认配置 **qwen3-max** 模型：

```json
{
  "models": {
    "providers": {
      "bailian": {
        "baseUrl": "https://dashscope.aliyuncs.com/compatible-mode/v1",
        "apiKey": "your-api-key",
        "models": [{
          "id": "qwen3-max",
          "name": "Qwen3 Max",
          "contextWindow": 80000,
          "maxTokens": 8192
        }]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "bailian/qwen3-max"
      }
    }
  }
}
```

## 常用运维命令

**进入容器控制台**:
```bash
ssh root@<IP> "docker exec -it openclaw-deploy-openclaw-gateway-1 /bin/bash"
# 在容器内可以使用:
openclaw status
openclaw devices list
```

**查看日志**:
```bash
ssh root@<IP> "docker logs openclaw-deploy-openclaw-gateway-1 -f --tail 100"
```

**重启服务**:
```bash
ssh root@<IP> "cd /data/openclaw-deploy && docker compose restart"
```

**查看 Token**:
```bash
ssh root@<IP> "cat /data/openclaw-deploy/.env | grep TOKEN"
```

## 目录说明

*   `deploy-openclaw.sh`: 部署主脚本。
*   `approve-device.sh`: 设备配对脚本。
*   `Dockerfile`: 定制构建文件（构建时注入）。
*   `docker-compose.yml`: 服务编排。
*   `Caddyfile`: 反向代理配置。

## 声明

本项目与 OpenClaw 官方无关，仅作为社区部署工具。
