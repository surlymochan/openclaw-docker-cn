# OpenClaw CN

One command to deploy OpenClaw with composite search plugin (Gaode Maps + Baidu AI Search).

```bash
./deploy-openclaw-cn.sh <YOUR_SERVER_IP>
```

[中文版 / Chinese Version](README.md)

---

## Key Features

| Feature | Description |
|---------|-------------|
| 🚀 **One-Click Deployment** | Complete deployment with a single command, no manual configuration |
| 🔥 **qwen3-max Model** | Built-in Qwen3 Max model (80k context window) |
| 🇨🇳 **China Optimized** | NPM mirror acceleration, solves network issues |
| 🔒 **Public HTTPS** | Caddy auto HTTPS, enables public web access |
| 🔍 **Composite Search** | Baidu AI intelligent search + Gaode Maps POI search |

---

## One-Click Start

```bash
# Deploy OpenClaw
./deploy-openclaw-cn.sh <YOUR_SERVER_IP>
```

Done automatically:
- Fetch OpenClaw source → Build Docker image → Start services
- Configure qwen3-max model → Enable composite search plugin
- Setup HTTPS reverse proxy → Generate secure token

Visit `https://<IP>.nip.io:18443` and start using!

---

## Composite Search Features

### Feature Highlights
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
- **Public Access**: HTTPS port 18443 (Caddy auto certificate)
- **Search Function**: Composite search plugin (Baidu AI + Gaode Maps)

---

## Disclaimer

Community tool. Not affiliated with OpenClaw.
