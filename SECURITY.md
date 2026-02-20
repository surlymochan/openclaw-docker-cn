# 安全策略

## 支持的范围

本仓库关注与以下内容相关的安全问题：

- 部署脚本（如 `scripts/deploy-from-src.sh`、workspace 备份/恢复）中的命令执行、路径与权限
- 密钥与配置的传递、注入方式（KEYS_DIR、环境变量、服务器 .env）
- 依赖（如 `src/bigclaw` 的 npm 依赖）的已知漏洞

## 如何报告漏洞

如发现可能影响安全的漏洞，请**不要**在公开 Issue 中直接披露细节。

- **推荐**：通过 GitHub 的 [Security Advisories](https://github.com/surlymochan/openclaw-cn/security/advisories) 或仓库的 **Security** 标签私下报告。
- 若无上述入口，可先开一个不包含技术细节的 Issue，说明「存在潜在安全问题，希望私下联系」，维护者会与你沟通。

我们会尽量在合理时间内确认并回复，修复后会按惯例在发布说明或 CHANGELOG 中致谢（若你同意署名）。

## 安全更新

- 依赖更新与安全相关修复会通过版本发布与 CHANGELOG 说明。
- 建议关注 Release 与 CHANGELOG，必要时升级部署。
