## SP0217 需求文档：复合搜索插件

### 迭代目标

为 OpenClaw 添加复合搜索插件能力，聚合多个搜索源以提供全面的搜索体验。

### 核心需求

1. **复合搜索插件**
   - 百度搜索 API（通用中文搜索）
   - 高德搜索 API（POI、路线、出行）
   - 以 OpenClaw 插件方式加载

2. **禁用内置搜索**
   - 禁用 OpenClaw 内置的 web_search 工具
   - 避免重复功能和 token 浪费

### 验证标准

1. https://175.178.157.123.nip.io:18443/overview 可正常访问
2. 搜索功能正常工作：`/search 杭州西湖` 返回结果
3. 日志中能看到 composite_search 工具被调用

### 技术方案

- 插件形式：OpenClaw Plugin (非 MCP)
- 插件代码位置：`/data/bigclaw/`
- 插件加载配置：在 openclaw.json 中配置 plugins 字段

### 相关说明

1. API Keys 存储在 `private/keys/openclaw-docker-cn-private/search.env`
2. 前置迭代：SP0216（模型配置）

### 需求池（未来迭代）

- Brave API（海外搜索兜底）- 待验证 API 可用性后集成