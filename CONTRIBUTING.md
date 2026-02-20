# 参与贡献

欢迎为 OpenClaw 国内版提交 Issue 与 Pull Request。

## 提 Issue

- 请写清：**问题描述**、**环境**（本机/目标机系统、脚本版本）、**复现步骤**。
- 若为功能建议，请说明使用场景与期望行为。

## 提 Pull Request

1. Fork 本仓库，在单独分支上修改（如 `fix/xxx`、`docs/xxx`）。
2. 提交信息建议简洁明了，如：`docs: 补充前置要求`、`fix: 未设置 SERVER_IP 时提前报错`。
3. 修改脚本后请本地执行：
   - `bash -n deploy.sh scripts/*.sh` 确保语法正确。
   - 若改动了部署逻辑，建议在测试环境跑一遍 `./deploy.sh all` 再提交。
4. 提交前确认未包含密钥、本机路径、临时文件（`.env`、`keys/` 等已由 .gitignore 忽略）。

## 代码与风格

- Shell：使用 `set -e`，变量加双引号，路径用 `"$VAR"`。
- 文档：Markdown 与现有 README、spec 风格保持一致即可。

## 文档与 spec

- 若行为或配置有变更，请同步更新 README 或 spec/ 下 PRD/DESIGN/TEST，必要时更新 CHANGELOG.md。

如有疑问可在 Issue 中提出。
