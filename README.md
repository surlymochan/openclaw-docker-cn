# OpenClaw 基础工具链（私有项目）

本仓库采用 **iteration（迭代开发）+ src（最终项目文件）+ spec（最终说明报告）** 结构。项目级工作流与专属规则见 **[aispec.md](../../aispec.md)**（工作区根目录）。通用工作流/结构变更汇总见 **private/aispec-private**（[README](../aispec-private/README.md)、[CHANGELOG](../aispec-private/CHANGELOG.md)）。

---

## 目录结构

```
openclaw-cn-private/
├── deploy.sh              # 统一部署入口（菜单与命令行）
├── scripts/
│   └── deploy-from-src.sh # 全部部署：仅从 src+spec 发布，供 deploy all 调用
├── iteration/             # 迭代开发（各 SP 的 MRD/PRD/DESIGN/deploy/README）
│   ├── SP0216/
│   ├── SP0217/
│   ├── SP0218/
│   ├── SP0219/             # 迭代编号调整（SP0220→SP0218）；通用变更见 private/aispec-private
│   └── SP0221/
├── src/                   # 最终项目文件（合并后的代码与配置）
│   ├── bigclaw/           # 插件，同步到服务器 /data/bigclaw
│   ├── docker-compose.yml
│   ├── openclaw.template.json
│   ├── Caddyfile
│   └── Dockerfile
├── spec/                  # 最终说明报告（MRD、PRD、DESIGN、TEST、REVIEW、README）
│   ├── README.md          # 版本号与总览（当前发布版本见此处）
│   ├── MRD.md
│   ├── PRD.md
│   ├── DESIGN.md
│   ├── TEST.md
│   └── REVIEW.md
└── README.md              # 本文件：结构索引
```

---

## 部署

| 命令 | 说明 |
|------|------|
| `./deploy.sh all` | **全部部署**：从 **src+spec** 发布版本部署（见 spec/README.md 版本号），不跑迭代脚本 |
| `./deploy.sh sp0216` | 仅部署 SP0216（模型） |
| `./deploy.sh sp0217` | 仅部署 SP0217（bigclaw），优先用 src/bigclaw |
| `./deploy.sh sp0218` | 仅部署 SP0218（飞书+Skills），优先用 src/bigclaw |
| `./deploy.sh sp0221` | 当前同 SP0218；SP0221 合并后即生效 |

**密钥**：从 `private/keys/openclaw-cn-private/` 读取（llm.env、feishu.env、search.env），见 [spec/README.md](spec/README.md)。

---

## 合并约定

- 迭代验证通过后，将产出**合并到 src/**（代码、docker-compose、openclaw.template 等）并**同步更新 spec/**（PRD、DESIGN、TEST 等；README 中更新版本号）。
- **deploy all** 始终指向 **src+spec** 中已合并的最新版本。

详细流程与文档责任人见 [aispec.md](../../aispec.md) 与 [CONVENTIONS](../../private/aispec-private/spec/CONVENTIONS.md)；完整说明与版本见 **[spec/README.md](spec/README.md)**。
