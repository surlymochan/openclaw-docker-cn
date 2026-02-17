#!/bin/bash
# SP0217 一键部署脚本：复合搜索插件
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

SERVER_IP="${SERVER_IP:-<SERVER_IP>}"
SERVER_USER="${SERVER_USER:-root}"

KEYS_DIR="$PROJECT_ROOT/../../private/keys/openclaw-docker-cn-private"
if [ -f "$KEYS_DIR/search.env" ]; then
    source "$KEYS_DIR/search.env"
fi
if [ -f "$KEYS_DIR/llm.env" ]; then
    source "$KEYS_DIR/llm.env"
fi

log_info "开始部署 SP0217: 复合搜索插件"
log_info "目标服务器: $SERVER_IP"

echo ""
log_info "[1/5] 同步 composite-search 到服务器..."
rsync -avz --delete "$SCRIPT_DIR/composite-search/" "$SERVER_USER@$SERVER_IP:/data/bigclaw/" > /dev/null 2>&1
log_success "bigclaw 同步完成"

echo ""
log_info "[2/5] 配置 OpenClaw (启用复合搜索插件)..."

ssh "$SERVER_USER@$SERVER_IP" "cat > /root/.openclaw/openclaw.json << 'EOF'
{
  \"meta\": {
    \"lastTouchedVersion\": \"2026.2.13\",
    \"lastTouchedAt\": \"$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)\"
  },
  \"models\": {
    \"mode\": \"merge\",
    \"providers\": {
      \"bailian\": {
        \"baseUrl\": \"https://dashscope.aliyuncs.com/compatible-mode/v1\",
        \"apiKey\": \"${BAILIAN_API_KEY:-}\",
        \"api\": \"openai-completions\",
        \"models\": [
          {
            \"id\": \"qwen3-max\",
            \"name\": \"Qwen3 Max\",
            \"contextWindow\": 80000,
            \"maxTokens\": 8192
          }
        ]
      }
    }
  },
  \"agents\": {
    \"defaults\": {
      \"model\": {
        \"primary\": \"bailian/qwen3-max\"
      },
      \"models\": {
        \"bailian/qwen3-max\": {}
      },
      \"workspace\": \"/home/node/.openclaw/workspace\"
    }
  },
  \"commands\": {
    \"native\": \"auto\",
    \"nativeSkills\": \"auto\"
  },
  \"tools\": {
    \"deny\": [\"web_search\"],
    \"allow\": [\"composite_search\"]
  },
  \"plugins\": {
    \"enabled\": true,
    \"load\": {
      \"paths\": [\"/app/bigclaw\"]
    },
    \"entries\": {
      \"bigclaw\": {
        \"enabled\": true
      }
    }
  },
  \"gateway\": {
    \"port\": 18789,
    \"controlUi\": {
      \"allowInsecureAuth\": true
    },
    \"trustedProxies\": [
      \"0.0.0.0/0\"
    ]
  }
}
EOF"

ssh "$SERVER_USER@$SERVER_IP" "chown -R 1000:1000 /root/.openclaw 2>/dev/null || true"
log_success "OpenClaw 配置完成"

echo ""
log_info "[3/5] 更新 docker-compose.yml 挂载..."
ssh "$SERVER_USER@$SERVER_IP" "sed -i 's|/data/composite-search:/app/composite-search|/data/bigclaw:/app/bigclaw|g' /data/openclaw-deploy/docker-compose.yml"
log_success "docker-compose.yml 更新完成"

echo ""
log_info "[4/5] 重启 OpenClaw 服务..."
ssh "$SERVER_USER@$SERVER_IP" "cd /data/openclaw-deploy && docker compose down && docker compose up -d"
sleep 10

if ssh "$SERVER_USER@$SERVER_IP" "docker ps | grep -q 'openclaw-deploy-openclaw-gateway-1.*Up'"; then
    log_success "服务已启动"
else
    log_error "服务启动失败"
    exit 1
fi

echo ""
log_info "[5/5] 验证部署..."

sleep 5

HEALTH_STATUS=$(curl -k -s -o /dev/null -w "%{http_code}" "https://$SERVER_IP.nip.io:18443/" 2>/dev/null || echo "000")

if [ "$HEALTH_STATUS" = "200" ]; then
    log_success "健康检查通过 (HTTP 200)"
else
    log_warn "健康检查返回 HTTP $HEALTH_STATUS，继续观察..."
fi

echo ""
log_success "SP0217 部署完成!"
echo ""
echo -e "${GREEN}访问信息:${NC}"
echo "  Web UI: https://$SERVER_IP.nip.io:18443/"
echo "  Token:  <GATEWAY_TOKEN>"
echo ""
echo -e "${GREEN}功能列表:${NC}"
echo "  [OK] 复合搜索插件 (composite_search)"
echo "  [OK] 百度 AI 搜索 + 高德地图搜索"
echo "  [OK] 智能路由自动选择最佳搜索引擎"
echo "  [OK] 禁用内置 web_search 工具"
echo ""
echo -e "${YELLOW}搜索测试:${NC}"
echo "  使用工具: composite_search"
echo "  示例: /search 杭州西湖"
echo ""