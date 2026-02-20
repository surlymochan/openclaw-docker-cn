# OpenClaw 国内版

[![CI](https://github.com/surlymochan/openclaw-cn/actions/workflows/ci.yml/badge.svg)](https://github.com/surlymochan/openclaw-cn/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2026.2.19-blue.svg)](spec/README.md)

一行命令部署 OpenClaw，支持 Qwen3-Max、复合搜索（百度+高德）、飞书机器人；部署时自动备份与恢复 Agent workspace，升级不丢记忆。

```bash
# 必填：目标服务器 IP（环境变量或下方命令前设置）
export SERVER_IP=你的服务器IP
./deploy.sh all
```

**前置要求**：本机需 **bash**、**ssh**、**rsync**；目标机需 **Docker**、**docker compose** 且可被 SSH 访问。未设置 `SERVER_IP` 时脚本会提示并退出。

---

## 核心特性

| 特性 | 说明 |
|------|------|
| 🚀 **一键部署** | 单命令完成同步、配置、重启，无需手动改配置 |
| 🔥 **Qwen3-Max** | 内置通义千问 Qwen3 Max（80k 上下文，8k 输出）|
| 🇨🇳 **国内可用** | 阿里百炼 + 百度/高德搜索，无需海外网络 |
| 🔒 **公网 HTTPS** | Caddy 自动 HTTPS，访问 `https://<IP>.nip.io:18443` |
| 🔍 **复合搜索** | 百度 AI 智能搜索 + 高德地图 POI，Chat 内 `/search` 即用 |
| 📦 **Workspace 备份** | 每次部署前自动备份、部署后自动恢复，升级不丢对话与记忆 |

---

## 一步启动

### 1. 准备密钥（可选但推荐）

在**本机**建一个目录放密钥文件（如 `./keys`），并设置环境变量：

```bash
export KEYS_DIR=./keys   # 或任意路径
# 目录内放以下文件（至少 llm.env 才能对话）：
#   llm.env      → BAILIAN_API_KEY=xxx     （阿里百炼，必填才能对话）
#   feishu.env   → FEISHU_APP_ID、FEISHU_APP_SECRET 等（飞书机器人）
#   search.env   → GAODE_API_KEY、BAIDU_API_KEY     （复合搜索）
```

### 2. 执行部署

```bash
export SERVER_IP=你的服务器IP          # 必填
export SERVER_USER=root                 # 可选，默认 root
./deploy.sh all
```

脚本会自动：同步代码 → 写配置 → 重启服务 → **部署前备份 workspace、部署后恢复**。  
完成后访问：**https://\<你的服务器IP\>.nip.io:18443**

### 3. 仅备份 / 仅恢复（可选）

```bash
./deploy.sh workspace-backup   # 只备份当前服务器上的 workspace
./deploy.sh workspace-restore  # 只从已有备份恢复，不部署
```

---

## 部署命令速查

| 命令 | 说明 |
|------|------|
| `./deploy.sh all` | **全部部署**（推荐）：同步 + 配置 + 重启 + 自动备份与恢复 workspace |
| `./deploy.sh workspace-backup` | 仅备份 workspace |
| `./deploy.sh workspace-restore` | 仅恢复 workspace |

也可直接运行：`bash scripts/deploy-from-src.sh`、`bash scripts/workspace-backup.sh`、`bash scripts/workspace-restore.sh`。

---

## 复合搜索

### 功能

- **百度 AI 搜索**：通用中文搜索、AI 总结
- **高德地图**：POI、地址、路线
- **智能路由**：按查询内容自动选搜索引擎  
- 在 Chat 里输入 **`/search 杭州西湖`**、**`/search 北京三里屯美食`** 即可使用。

### 配置搜索 Key

在 `KEYS_DIR` 指向的目录下创建 `search.env`：

```bash
GAODE_API_KEY=your-gaode-key
BAIDU_API_KEY=your-baidu-api-key
```

重新执行 `./deploy.sh all` 后生效。

---

## 常见问题

**Token 在哪？**  
```bash
ssh root@<IP> "grep OPENCLAW_GATEWAY_TOKEN /data/openclaw-deploy/.env"
```

**怎么重启？**  
```bash
ssh root@<IP> "cd /data/openclaw-deploy && docker compose restart"
```

**怎么看日志？**  
```bash
ssh root@<IP> "docker logs openclaw-deploy-openclaw-gateway-1 -f"
```

**首次部署没有备份？**  
正常，脚本会跳过恢复；之后每次部署都会先备份再恢复。

---

## 进阶配置

- **只用对话、不用飞书/搜索**：只配置 `llm.env`（`BAILIAN_API_KEY`）即可。
- **密钥目录**：通过环境变量 `KEYS_DIR` 指定；不设则使用项目上级的 `keys/openclaw-cn`（若存在）。
- **跳过备份/恢复**：`SKIP_WORKSPACE_BACKUP=1` 或 `SKIP_WORKSPACE_RESTORE=1`。  
更多变量见 [spec/README.md](spec/README.md)。

---

## 默认配置

| 项目 | 说明 |
|------|------|
| 模型 | qwen3-max（80k 上下文，8192 输出）|
| 访问 | HTTPS 18443 端口，`https://<IP>.nip.io:18443` |
| 搜索 | 复合搜索插件（百度 AI + 高德地图）|
| Workspace | 服务器路径默认 `/root/.openclaw/workspace`，备份文件默认 `/data/openclaw-deploy/workspace-backup.tar` |

---

## 目录与文档

```
openclaw-cn/
├── deploy.sh           # 部署入口
├── scripts/            # deploy-from-src.sh、workspace-backup.sh、workspace-restore.sh
├── src/                # 部署用代码与配置（bigclaw、docker-compose 等）
└── spec/               # 版本说明、PRD、DESIGN、TEST
```

- **当前版本**：[spec/README.md](spec/README.md)  
- 产品需求与技术约定：spec/ 下 PRD.md、DESIGN.md、TEST.md  
- 版本变更：[CHANGELOG.md](CHANGELOG.md)

---

## 上游与致谢

本项目为 **OpenClaw** 的国内一键部署与定制，在 [OpenClaw](https://github.com/openclaw/openclaw) 基础上增加：Qwen3-Max、复合搜索（百度+高德）、飞书接入、workspace 备份与恢复等。感谢上游社区。

---

## 许可证与参与

- 本项目采用 [MIT 许可证](LICENSE)。
- 参与贡献见 [CONTRIBUTING.md](CONTRIBUTING.md)；安全相关问题见 [SECURITY.md](SECURITY.md)。
