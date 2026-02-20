# DESIGN — 技术方案与配置（合并视图）

本文档为 openclaw-cn-private **合并后的技术方案**。单迭代设计见 `iteration/SP0xxx/DESIGN.md`。

## 部署与目录

- **src/**：最终代码与配置（bigclaw、docker-compose.yml、openclaw.template.json、Caddyfile、Dockerfile）。
- **spec/**：最终说明与报告（MRD、PRD、DESIGN、TEST、REVIEW、README）。
- **iteration/**：各 SP 迭代开发；完成后合并到 src/ 与 spec/。

## 配置来源

- 服务器 openclaw.json：由部署脚本根据 keys 与模板生成（当前 SP0218/deploy 或 deploy-from-src 内联写入）。
- 服务器 docker-compose：来自 **src/docker-compose.yml**，部署时写入 `/data/openclaw-deploy/`。
- openclaw.template.json：位于 **src/**，与当前生效配置一致，便于后续“从模板生成”迁移。

## 插件与工具

- bigclaw：源码在 **src/bigclaw/**，部署时 rsync 到服务器 `/data/bigclaw`，compose 挂载 `/data/bigclaw:/app/bigclaw`。
- composite_search：支持 source（baidu/gaode/auto）、query、以及结构化参数 region/landmark/keyword（高德 POI 用）。**百度分支**使用千帆 web_search API（`v2/ai_search/web_search`，edition: lite），返回 references 列表；重试与超时见 iteration/SP0219/CHANGELOG.md。

## 密钥注入

- 部署脚本将 search.env 的 GAODE_API_KEY、BAIDU_API_KEY 写入服务器 `openclaw-deploy/.env`，由 docker-compose 传入 gateway 容器。

## Workspace 备份与恢复（SP0222）

- **workspace 路径**：服务器上默认 `/root/.openclaw/workspace`，可配置 `OPENCLAW_WORKSPACE_PATH`。
- **备份路径**：默认 `/data/openclaw-deploy/workspace-backup.tar`，可配置 `OPENCLAW_WORKSPACE_BACKUP_PATH`；只保留最新一份，默认永久保留。
- **全部部署流程**：备份（若 workspace 存在）→ 同步/配置/重启 → 恢复（若备份存在）；可选 `SKIP_WORKSPACE_BACKUP=1` / `SKIP_WORKSPACE_RESTORE=1` 跳过。
- **单独操作**：`./deploy.sh workspace-backup`、`./deploy.sh workspace-restore` 或直接执行 `scripts/workspace-backup.sh`、`scripts/workspace-restore.sh`。详细约定见 iteration/SP0222/DESIGN.md。
