# MRD — 需求概要与迭代索引

本文档为 openclaw-cn-private 的**最终需求概要**及各迭代 MRD 索引。MRD 由项目负责人编写，单迭代 MRD 存放于各 SP 目录。

## 总体方向

- 为 OpenClaw 构建国内可用工具链：大模型（阿里百炼）、复合搜索（百度+高德）、飞书接入、关键 Skills。
- 扩展 composite_search：支持实时股市信息等（SP0221）。

## 迭代 MRD 索引

| 迭代 | 文件 | 概要 |
|------|------|------|
| SP0216 | [iteration/SP0216/](../../iteration/SP0216/) | 无独立 MRD；PRD/README 描述 Qwen3-Max 接入 |
| SP0217 | [iteration/SP0217/](../../iteration/SP0217/) | bigclaw 插件、composite_search（百度+高德） |
| SP0218 | [iteration/SP0218/](../../iteration/SP0218/) | 飞书 channel、关键 Skills |
| SP0219 | [iteration/SP0219/](../../iteration/SP0219/) | 编号调整 + 百度搜索接口更换为 web_search（见 CHANGELOG.md、PRD、TEST） |
| SP0221 | [iteration/SP0221/MRD.md](../../iteration/SP0221/MRD.md) | 实时股市信息搜索 |
| SP0222 | [iteration/SP0222/MRD.md](../../iteration/SP0222/MRD.md) | 部署时 workspace 备份与恢复（部署前备份、拉起后覆盖回，保留 Agent 记忆与配置） |

详细初始需求以各 `iteration/SP0xxx/MRD.md` 或迭代 README 为准。
