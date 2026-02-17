# OpenClaw Docker CN

One command to deploy OpenClaw, an out-of-the-box AI assistant platform.

```bash
./deploy-openclaw.sh <YOUR_SERVER_IP>
```

[中文版 / Chinese Version](README.md)

---

## Key Features

| Feature | Description |
|---------|-------------|
| 🚀 **One-Click Deployment** | Complete deployment with a single command, no manual configuration |
| 🔥 **qwen3-max Model** | Built-in Qwen3 Max model (80k context window) |
| 🇨🇳 **China Optimized** | NPM mirror acceleration, solves network issues |
| 🔒 **HTTPS Direct Access** | Caddy auto HTTPS, no SSH tunnel required |
| 🔍 **Composite Search** | Baidu AI intelligent search + Gaode Maps POI search |
| 🛠️ **Built-in Tools** | Native commands and skills system, ready to use |
| 💾 **Persistent Workspace** | Automatically saves conversation history and files |
| 🌐 **Web Access** | Direct browser access, no local installation required |

---

## One-Click Start

```bash
# Deploy OpenClaw
./deploy-openclaw.sh <YOUR_SERVER_IP>
```

Done automatically:
- Fetch OpenClaw source → Build Docker image → Start services
- Configure qwen3-max model → Enable composite search plugin
- Setup HTTPS reverse proxy → Generate secure token

Visit `https://<IP>.nip.io:18443` and start using!

---

## AI Capabilities

### 🧠 qwen3-max Model
- **Ultra-long Context**: 80,000 tokens context window
- **Large Output**: Up to 8,192 tokens output
- **Native Support**: Built-in command system and skills framework
- **Persistent Workspace**: Automatically saves conversation history and generated files

### 🔍 Composite Search Features
- **Modular Architecture**: Extensible plugin design supporting multiple search tools
- **Baidu AI Search**: General Chinese search with AI intelligent summarization
- **Gaode Maps Search**: POI, addresses, routes, and travel information
- **Smart Routing**: Automatically selects the best search engine based on query content
- **Built-in Search Disabled**: Avoids duplicate functionality and token waste

## FAQ

**Where is the token?**
```bash
ssh root@<IP> "cat /data/openclaw-deploy/.env | grep TOKEN"
```

**How to restart?**
```bash
ssh root@<IP> "cd /data/openclaw-deploy && docker compose restart"
```

**View logs?**
```bash
ssh root@<IP> "docker logs openclaw-deploy-openclaw-gateway-1 -f"
```

---

## Advanced

### Enable LLM

Create `llm.env` in the project root directory:

```bash
BAILIAN_API_KEY=your-key
```

Re-run deploy.

### Local Source Debug

```bash
./deploy-openclaw.sh <IP> /path/to/openclaw
```

---

## Default Configuration

- **AI Model**: qwen3-max (80k context, 8192 output)
- **Web Access**: HTTPS port 18443 (Caddy auto certificate)
- **Gateway**: Port 18789 (internal communication)
- **Search Function**: Composite search plugin (Baidu AI + Gaode Maps)
- **Workspace**: Persistent storage (`/root/.openclaw/workspace`)
- **Command System**: Native commands and skills automatically enabled
- **Security**: Built-in token authentication, HTTPS encryption

---

## Disclaimer

Community tool. Not affiliated with OpenClaw.
