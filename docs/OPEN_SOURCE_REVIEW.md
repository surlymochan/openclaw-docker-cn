# OpenClaw 国内版 — 开源标准审查报告

**审查日期**：按当前仓库状态  
**参照**：常见开源项目规范（License、CONTRIBUTING、SECURITY、文档、可维护性）

---

## 一、审查结论概览

| 类别 | 状态 | 说明 |
|------|------|------|
| 许可证 LICENSE | ❌ 缺失 | 必须补充，否则法律与使用范围不明确 |
| 贡献指南 CONTRIBUTING | ❌ 缺失 | 建议补充，便于社区参与 |
| 安全策略 SECURITY | ❌ 缺失 | 建议补充，规范漏洞反馈流程 |
| 变更记录 CHANGELOG | ❌ 缺失 | 建议补充，便于用户追踪版本 |
| README 与文档 | ✅ 良好 | 一步启动、常见问题、spec 已较完整 |
| 默认配置与隐私 | ⚠️ 待改进 | 脚本中默认 SERVER_IP 为具体 IP，建议去除或明确为示例 |
| .gitignore | ⚠️ 可加强 | 可增加 keys/、*.pem 等 |
| 上游与依赖声明 | ⚠️ 可加强 | 建议在 README 明确 OpenClaw 上游与依赖 |
| 自动化与质量 | ⚠️ 可选 | 无 CI；可增加脚本语法/静态检查 |

---

## 二、分项说明与建议

### 1. 许可证（必须）

- **现状**：仓库根目录无 `LICENSE` 文件。
- **建议**：
  - 增加 `LICENSE` 文件，推荐 **MIT** 或 **Apache-2.0**（与常见部署/工具类项目一致）。
  - 若依赖或衍生自 OpenClaw 等上游，需与上游许可证兼容并在 README 中注明「基于 OpenClaw，见 xxx」。
  - README 顶部或底部增加一行：`本项目采用 [MIT](LICENSE) 许可证。`

### 2. 贡献指南（强烈建议）

- **现状**：无 `CONTRIBUTING.md`。
- **建议**：新增 `CONTRIBUTING.md`，包含：
  - 如何提 Issue（问题描述、环境、复现步骤）。
  - 如何提 PR（分支策略、提交信息约定、测试/检查要求）。
  - 代码风格（Shell 用 `set -e`、引号规范；JS 与仓库现有风格一致）。
  - 如何本地验证（如 `bash -n scripts/*.sh`、部署前检查清单）。
  - README 末尾增加「参与贡献见 [CONTRIBUTING.md](CONTRIBUTING.md)」。

### 3. 安全策略（强烈建议）

- **现状**：无 `SECURITY.md`。
- **建议**：新增 `SECURITY.md`，包含：
  - 支持的安全问题范围（部署脚本、密钥处理、依赖等）。
  - 漏洞反馈方式（如通过 GitHub Security Advisories 或指定邮箱），并说明不公开披露前先私下报告。
  - 若暂无维护者邮箱，可写「请通过 GitHub Issue 私密说明或使用 Security tab」。

### 4. 变更记录（建议）

- **现状**：无 `CHANGELOG.md`，版本仅在 spec/README.md 中标注。
- **建议**：新增 `CHANGELOG.md`，按版本列出：
  - 新增功能（如 workspace 备份与恢复）。
  - 行为变更与不兼容变更。
  - Bug 修复与文档更新。  
  便于用户判断是否升级及升级影响。

### 5. README 与文档（已较好）

- **现状**：README 含一步启动、核心特性、常见问题、进阶配置；spec 含 PRD/DESIGN/TEST。
- **建议**：
  - 在「一步启动」前增加 **前置要求**：本机需 bash、ssh、rsync；目标机需 Docker、docker compose、可 SSH。
  - 在文末或「目录与文档」中增加 **上游与致谢**：如「本仓库为 OpenClaw 的国内一键部署方案，上游见 [openclaw/openclaw](https://github.com/openclaw/openclaw)。」
  - 若有 GitHub 仓库地址，可增加 **Badge**（如 license、version from spec/README.md）。

### 6. 默认 SERVER_IP 与隐私（建议修改）

- **现状**：`scripts/deploy-from-src.sh`、`workspace-backup.sh`、`workspace-restore.sh` 中 `SERVER_IP="${SERVER_IP:-175.178.157.123}"`，默认指向一具体 IP。
- **问题**：开源仓库中默认写死某 IP 易被理解为「仅限该环境」或存在隐私/安全顾虑；新用户若未设 `SERVER_IP` 会误连该地址。
- **建议**：
  - **方案 A**：去掉默认值，改为 `SERVER_IP="${SERVER_IP:?}"` 或脚本开头检查「若未设置 SERVER_IP 则报错并提示」。
  - **方案 B**：保留默认但仅在「无 SERVER_IP 时」打印明显 WARN 并退出，要求用户显式设置。  
  推荐 **方案 A**，在 README 与 spec 中已强调「SERVER_IP 必填」即可。

### 7. .gitignore（小改进）

- **现状**：已有 `node_modules/`、`.env`、`*.log`、`.DS_Store`。
- **建议**：增加 `keys/`、`*.pem`、`.env.local`、`deploy.env`，避免误提交密钥或本地配置。

### 8. 上游与依赖声明（建议）

- **现状**：README 未明确写出 OpenClaw 上游仓库及本仓库定位。
- **建议**：
  - 在 README 开篇或「目录与文档」中写一句：本项目为 **OpenClaw 的国内一键部署与定制**，基于 [OpenClaw](https://github.com/openclaw/openclaw)（或实际上游地址），并说明本仓库包含的定制（Qwen3-Max、复合搜索、飞书、workspace 备份等）。
  - `src/bigclaw/package.json` 可增加 `"license"`、`"repository"`、`"homepage"` 字段，便于 npm 与第三方引用时展示。

### 9. 自动化与质量（可选）

- **现状**：无 GitHub Actions 或其它 CI。
- **建议**（按需）：
  - 增加简单 CI：在每次 push/PR 时运行 `bash -n deploy.sh scripts/*.sh`（或 `shellcheck`），确保脚本语法正确。
  - 若有 Node 测试，可增加 `npm test` 或 `node src/bigclaw/scripts/test-baidu-web-search.js`（需 mock 或跳过真实请求）的步骤。  
  优先级可低于 LICENSE / CONTRIBUTING / SECURITY。

---

## 三、优先实施顺序

1. **必须**：添加 `LICENSE`（MIT 或 Apache-2.0），并在 README 中注明。
2. **必须**：去除或严格限制默认 `SERVER_IP`，避免误连与隐私问题。
3. **强烈建议**：添加 `CONTRIBUTING.md`、`SECURITY.md`，README 中链接。
4. **建议**：添加 `CHANGELOG.md`，补充 `.gitignore`，README 增加前置要求与上游声明。
5. **可选**：CI 脚本语法检查、package.json 元数据、Badge。

---

## 四、总结

项目在**使用文档（README、spec）和部署体验**上已具备较好基础；按开源标准**最需补足**的是**许可证**和**默认 SERVER_IP 行为**，其次为**贡献与安全策略**及**变更记录**。完成上述项后，即可更符合常见开源仓库规范，便于社区使用与参与。
