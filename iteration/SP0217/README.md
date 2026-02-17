# SP0217 迭代：复合搜索插件

## 迭代目标

为 OpenClaw 添加复合搜索插件能力，聚合百度搜索、高德搜索。

## 完成状态

✅ **已上线**

## 项目结构

```
iteration/SP0217/
├── deploy.sh              # 一键部署脚本
├── bigclaw/               # 复合搜索插件代码
│   ├── index.js           # 插件入口
│   ├── index.ts           # TypeScript 源码
│   ├── openclaw.plugin.json
│   └── package.json
├── PRD.md                 # 需求文档
├── DESIGN.md              # 设计文档
└── README.md              # 本文件
```

## 实现内容

### 1. 复合搜索插件

- **搜索源**:
  - 百度搜索 (通用搜索) ✅
  - 高德搜索 (POI、路线、出行) ✅
- **加载方式**: OpenClaw Plugin (非 MCP)
- **工具名称**: composite_search
- **智能路由**: 自动根据查询内容选择最佳搜索引擎

### 2. 禁用内置搜索

- 禁用 OpenClaw 内置的 web_search 工具
- 避免重复功能和 token 浪费

## 一键部署

```bash
cd iteration/SP0217
./deploy.sh
```

部署脚本执行内容：
1. 同步 bigclaw 插件代码到服务器
2. 渲染 openclaw.json 配置并上传
3. 复制插件到容器
4. 重启服务

## 访问信息

- **Web UI**: https://175.178.157.123.nip.io:18443/
- **Token**: 9fdea33381da4fe1acb517121ab8c473

## 搜索测试

```
使用工具: composite_search
示例: /search 杭州西湖
```

## 注意事项

- API Keys 存储在 `private/keys/openclaw-docker-cn-private/search.env`
- 前置迭代：SP0216（模型配置）

## 相关文件

- `iteration/SP0217/deploy.sh` - 部署脚本
- `iteration/SP0217/bigclaw/` - 插件代码
- `private/keys/openclaw-docker-cn-private/` - API 密钥
- `iteration/SP0216/` - 前置迭代 (模型配置)

## 需求池（未来）

- Brave API（海外搜索兜底）- 待验证 API 可用性后集成