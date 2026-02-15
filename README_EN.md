# OpenClaw Docker CN (One-Click Deployment)

[中文 (Chinese)](./README.md)

**A simple, stable, one-click solution for deploying OpenClaw.**
*Optimized for network environments that require mirrors (e.g., China), but works globally.*

## Key Features
*   🚀 **One-Click Deploy**: Auto-fetch source, inject custom Dockerfile, build image, and start services.
*   🇨🇳 **CN Optimization**: Built-in NPM Mirror configuration (optional but enabled by default).
*   🔒 **HTTPS Direct**: Integrated **Caddy** reverse proxy with **Origin Spoofing**, allowing Web UI access via Public IP without SSH Tunnels (bypassing OpenClaw's strict security checks).
*   🛠 **Ops Enhanced**: Pre-installed tools (`vim`, `curl`, `net-tools`) and `openclaw` CLI alias in the container.

## Quick Start

### 1. Prerequisites
*   A Linux server with Docker & SSH installed.
*   Local machine (Mac/Linux) with `rsync` and `git`.

### 2. Deploy (Community Version)
Run the script locally, passing the server IP:

```bash
./deploy-openclaw.sh <SERVER_IP>
# Example: ./deploy-openclaw.sh 1.2.3.4
```

The script will automatically:
1.  Fetch the latest OpenClaw source code from GitHub.
2.  Inject the custom Dockerfile.
3.  Sync build context to the server.
4.  Build and Start OpenClaw Gateway & Caddy.

### 3. Deploy with Local Source (Optional)
If you need to use local source code for development/debugging:

```bash
./deploy-openclaw.sh <SERVER_IP> <LOCAL_SOURCE_PATH>
# Example: ./deploy-openclaw.sh 1.2.3.4 /path/to/openclaw
```

### 4. Access & Pair
After successful deployment, the script outputs the URL.

1.  Open your browser: `https://<SERVER_IP>.nip.io:18443`
    *   *Note: Accept the self-signed certificate warning.*
2.  If you see **"Pairing Required"** or need to enter Token:
    *   Check the Token on server: `ssh root@<IP> "cat /data/openclaw-deploy/.env | grep TOKEN"`
    *   Go to Overview page in Web UI and enter the Token
3.  Click Connect and you're good to go!

## Operations

**Enter Container Console**:
```bash
ssh root@<IP> "docker exec -it openclaw-deploy-openclaw-gateway-1 /bin/bash"
# Inside container:
openclaw status
openclaw devices list
```

**View Logs**:
```bash
ssh root@<IP> "docker logs openclaw-deploy-openclaw-gateway-1 -f --tail 100"
```

**Check Token**:
```bash
ssh root@<IP> "cat /data/openclaw-deploy/.env | grep TOKEN"
```

## Files
*   `deploy-openclaw.sh`: Main deployment script.
*   `approve-device.sh`: Device pairing helper.
*   `Dockerfile`: Custom build file (injected during build).
*   `docker-compose.yml`: Service orchestration.
*   `Caddyfile`: Reverse proxy config (Origin Spoofing).

## Disclaimer
This project is a community deployment tool and is not affiliated with OpenClaw.
