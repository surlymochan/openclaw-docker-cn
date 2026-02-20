# MRD — 需求概要

本文档为 **openclaw-cn** 发布版的需求概要。

## 总体方向

- 为 OpenClaw 构建国内可用工具链：大模型（阿里百炼）、复合搜索（百度+高德）、飞书接入、关键 Skills。
- 部署流程支持 workspace 备份与恢复，保留 Agent 记忆与配置。

## 能力概览

| 能力 | 说明 |
|------|------|
| 模型 | 阿里百炼 qwen3-max（80k context） |
| 工具 | composite_search（百度 web_search + 高德 POI） |
| 通道 | 飞书机器人 |
| 插件 | bigclaw（OpenClaw Plugin） |
| 部署 | 全部部署含 workspace 备份与恢复；支持仅备份/仅恢复 |

详细需求与验收见 [PRD.md](./PRD.md)，技术约定见 [DESIGN.md](./DESIGN.md)。
