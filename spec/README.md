# OpenClaw 基础工具链（私有项目）— 规格与说明

**当前发布版本**：`v2026.2.19`（对应 iteration 合并到 src+spec 后的发布版本）

**版本说明**：迭代完成后将结果合并到 `src/`（代码与配置）与 `spec/`（本目录，说明与报告）；`deploy all` 部署的即此版本。

---

## 项目概述

本项目通过多个迭代（SP）为 OpenClaw 添加必备工具链能力：大模型接入、飞书机器人、bigclaw 插件（composite-search）、关键 Skills。

**项目级工作流与公约**：见工作区根目录 [aispec.md](../../aispec.md)。整体进展见同一文件第三节 PROGRESS。

## 密钥与配置

密钥从 `private/keys/openclaw-cn-private/` 读取：

- `llm.env` — 阿里云百炼 API Key  
- `feishu.env` — 飞书机器人  
- `search.env` — 百度/高德搜索 API Key  

## 迭代与合并

| 迭代 | 说明 | 状态 |
|------|------|------|
| SP0216 | Qwen3-Max 模型接入 | ✅ 已合并 |
| SP0217 | bigclaw（composite-search） | ✅ 已合并 |
| SP0218 | 飞书 + Skills | ✅ 已合并 |
| SP0219 | 编号调整（SP0220→SP0218）+ 百度搜索接口更换（web_search） | ✅ 已合并 |
| SP0221 | 实时股市信息搜索 | 🚧 规划中 |
| SP0222 | 部署时 workspace 备份与恢复 | ✅ 已合并 |

合并后产物位于 **src/**（bigclaw、docker-compose、openclaw.template 等），本目录 **spec/** 为最终说明与报告（MRD、PRD、DESIGN、TEST、REVIEW）。

## 文档索引（spec）

| 文档 | 说明 |
|------|------|
| [README.md](./README.md) | 本文件；版本与总览 |
| [MRD.md](./MRD.md) | 需求概要与迭代 MRD 索引 |
| [PRD.md](./PRD.md) | 产品需求与验收 |
| [DESIGN.md](./DESIGN.md) | 技术方案与配置 |
| [TEST.md](./TEST.md) | 测试报告 |
| [REVIEW.md](./REVIEW.md) | 审查报告索引 |

## 部署

- **全部部署**（发布版本）：`./deploy.sh all` — 从 **src/** 与 **spec/** 部署，即当前合并后的最新版本。  
- 单迭代验证：`./deploy.sh sp0216` / `sp0217` / `sp0218` / `sp0221` — 使用 iteration 内脚本，优先读取 src/ 中已合并内容。

详见项目根目录 [README.md](../README.md) 与 [deploy.sh](../deploy.sh)。
