# 变更记录

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)。

## [2026.2.19] - 2026-02

### 新增

- 全部部署流程：部署前自动备份 Agent workspace、部署后自动恢复，升级不丢对话与记忆。
- 单独命令：`./deploy.sh workspace-backup`、`./deploy.sh workspace-restore`，支持仅备份或仅恢复。
- 环境变量 `SKIP_WORKSPACE_BACKUP`、`SKIP_WORKSPACE_RESTORE` 可跳过备份或恢复步骤。
- 部署脚本支持 `KEYS_DIR` 指定密钥目录；未设置时使用默认相对路径。

### 变更

- 部署入口统一为 `deploy.sh`（all / workspace-backup / workspace-restore），README 与 spec 已同步。
- 密钥说明改为通过环境变量或 KEYS_DIR 提供，详见 README 与 spec/README.md。

### 文档

- README 增加一步启动、核心特性、复合搜索、常见问题、进阶配置与默认配置。
- spec 下 PRD、DESIGN、TEST、REVIEW 已整理为发布版说明，无迭代/私有路径引用。
- 新增 LICENSE（MIT）、CONTRIBUTING.md、SECURITY.md、CHANGELOG.md，符合开源常规规范。

### 安全与规范

- 脚本中不再使用默认 SERVER_IP，未设置时提示并退出，避免误连。
- .gitignore 增加 keys/、*.pem、.env.local、deploy.env，降低误提交密钥风险。

---

版本号与发布说明以 [spec/README.md](spec/README.md) 为准。
