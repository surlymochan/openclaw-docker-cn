#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
LOCAL_SRC="/Users/chenchao/workspace/project/public/openclaw"
REMOTE_DIR="/data/openclaw-deploy"
CONFIG_DIR="/root/.openclaw"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"

# Progress tracking
TOTAL_STEPS=8
CURRENT_STEP=0

progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    echo ""
    echo -e "${BLUE}[${CURRENT_STEP}/${TOTAL_STEPS}]${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
    exit 1
}

# 部署入参：SERVER_IP、SERVER_USER 通过参数或环境变量传入；可选通过 OPENCLAW_DEPLOY_ENV 指向 deploy.env 加载（文件由调用方自行管理，不随仓库提供）
if [ -n "${OPENCLAW_DEPLOY_ENV:-}" ] && [ -f "$OPENCLAW_DEPLOY_ENV" ]; then
    set -a
    source "$OPENCLAW_DEPLOY_ENV"
    set +a
fi

SERVER_IP="${1:-${SERVER_IP:-}}"
SERVER_USER="${2:-${SERVER_USER:-root}}"

if [ -z "$SERVER_IP" ]; then
    error "未指定服务器IP。用法: ./install.sh <SERVER_IP> [USER]"
fi

echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}          OpenClaw Docker 全自动部署脚本              ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "目标服务器: ${BLUE}$SERVER_IP${NC}"
echo -e "用户名: ${BLUE}$SERVER_USER${NC}"
echo ""

# Step 1: Pre-flight checks
progress "环境预检"

# Check local source exists
if [ ! -d "$LOCAL_SRC" ]; then
    error "本地源码目录不存在: $LOCAL_SRC"
fi
success "本地源码目录存在"

# Check SSH connectivity
if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "$SERVER_USER@$SERVER_IP" "echo 'OK'" > /dev/null 2>&1; then
    error "SSH 连接失败，请检查: 1) 网络连通性 2) SSH 密钥配置"
fi
success "SSH 连接正常"

# Step 2: Detect existing configuration
progress "检测现有配置"

EXISTING_TOKEN=$(ssh "$SERVER_USER@$SERVER_IP" "
    if [ -f '$CONFIG_FILE' ]; then
        cat '$CONFIG_FILE' | grep -o '\"token\": \"[^\"]*\"' | cut -d'\"' -f4 2>/dev/null || echo ''
    else
        echo ''
    fi
" 2>/dev/null || echo "")

if [ -n "$EXISTING_TOKEN" ]; then
    success "检测到现有配置，复用 Token"
    TOKEN="$EXISTING_TOKEN"
else
    warning "未检测到现有配置，将生成新 Token"
    TOKEN=$(openssl rand -hex 16)
fi

# Step 3: Sync source code
progress "同步源码到服务器"

TEMP_SRC="openclaw-src-tmp-$$"
rm -rf "$TEMP_SRC"

# Copy local source
if ! rsync -a --exclude='.git' --exclude='CLAUDE.md' "$LOCAL_SRC/" "$TEMP_SRC/" 2>/dev/null; then
    error "本地源码复制失败"
fi

# Inject Dockerfile
cp Dockerfile "$TEMP_SRC/"

# Create remote directories
ssh "$SERVER_USER@$SERVER_IP" "mkdir -p $REMOTE_DIR/context $CONFIG_DIR $CONFIG_DIR/workspace"

# Sync to server
if ! rsync -az --delete "$TEMP_SRC/" "$SERVER_USER@$SERVER_IP:$REMOTE_DIR/context/" 2>/dev/null; then
    rm -rf "$TEMP_SRC"
    error "同步到服务器失败"
fi

# Sync compose files
rsync -az docker-compose.yml Caddyfile "$SERVER_USER@$SERVER_IP:$REMOTE_DIR/" 2>/dev/null

rm -rf "$TEMP_SRC"
success "源码同步完成"

# Step 4: Remote deployment
progress "远程构建与部署"

DEPLOY_OUTPUT=$(ssh "$SERVER_USER@$SERVER_IP" << EOF
    set -e
    cd $REMOTE_DIR
    export SERVER_IP=$SERVER_IP
    
    # Create .env file
    cat > .env << EENV
OPENCLAW_IMAGE=openclaw:local
OPENCLAW_GATEWAY_TOKEN=$TOKEN
OPENCLAW_CONFIG_DIR=$CONFIG_DIR
OPENCLAW_WORKSPACE_DIR=$CONFIG_DIR/workspace
OPENCLAW_GATEWAY_PORT=18789
OPENCLAW_BRIDGE_PORT=18790
OPENCLAW_GATEWAY_BIND=0.0.0.0
OPENCLAW_GATEWAY_TRUSTED_PROXIES="0.0.0.0/0"
TRUSTED_PROXIES="0.0.0.0/0"
CLAUDE_AI_SESSION_KEY=""
SERVER_IP=$SERVER_IP
EENV
    
    # Stop existing containers
    docker compose down 2>/dev/null || true
    
    # Build image
    cd context
    docker build -t openclaw:local . 2>&1
    cd ..
    
    # Start services
    docker compose up -d 2>&1
    
    # Cleanup
    rm -rf context
    
    echo "BUILD_SUCCESS"
EOF
)

if echo "$DEPLOY_OUTPUT" | grep -q "BUILD_SUCCESS"; then
    success "Docker 镜像构建完成"
else
    error "构建失败: $DEPLOY_OUTPUT"
fi

# Step 5: Wait for services
progress "等待服务启动"

MAX_WAIT=60
WAITED=0

while [ $WAITED -lt $MAX_WAIT ]; do
    if ssh "$SERVER_USER@$SERVER_IP" "docker ps | grep -q 'openclaw-deploy-openclaw-gateway-1.*Up'" 2>/dev/null; then
        break
    fi
    sleep 1
    WAITED=$((WAITED + 1))
    echo -n "."
done

echo ""

if [ $WAITED -ge $MAX_WAIT ]; then
    error "服务启动超时"
fi

success "服务容器已启动"

# Step 6: Health check
progress "健康检查"

MAX_HEALTH_CHECK=30
HEALTH_WAITED=0
HEALTHY=false

while [ $HEALTH_WAITED -lt $MAX_HEALTH_CHECK ]; do
    if curl -k -s -o /dev/null -w "%{http_code}" "https://$SERVER_IP.nip.io:18443/" 2>/dev/null | grep -q "200"; then
        HEALTHY=true
        break
    fi
    sleep 1
    HEALTH_WAITED=$((HEALTH_WAITED + 1))
    echo -n "."
done

echo ""

if [ "$HEALTHY" = false ]; then
    warning "Web UI 响应较慢，但服务可能仍在启动中"
else
    success "Web UI 健康检查通过"
fi

# Step 7: Verify container status
progress "验证容器状态"

CONTAINER_STATUS=$(ssh "$SERVER_USER@$SERVER_IP" "docker ps --format 'table {{.Names}}\t{{.Status}}' | grep openclaw-deploy" 2>/dev/null || echo "")

if echo "$CONTAINER_STATUS" | grep -q "openclaw-deploy-openclaw-gateway-1"; then
    success "Gateway 容器运行正常"
else
    error "Gateway 容器未正常运行"
fi

if echo "$CONTAINER_STATUS" | grep -q "openclaw-deploy-caddy-1"; then
    success "Caddy 容器运行正常"
else
    error "Caddy 容器未正常运行"
fi

# Step 8: Display final info
progress "部署完成"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}              🎉 部署成功！                            ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "🔗 ${BLUE}Web UI:${NC} https://$SERVER_IP.nip.io:18443/"
echo -e "🔑 ${BLUE}Token:${NC}  $TOKEN"
echo ""
echo -e "${YELLOW}⚠️  首次访问请在浏览器中接受自签名证书${NC}"
echo ""
echo -e "${GREEN}使用说明:${NC}"
echo "  1. 打开 Web UI 链接"
echo "  2. 点击左侧 'Overview' 菜单"
echo "  3. 在 Gateway Token 处输入上面的 Token"
echo "  4. 点击 Connect，即可连接成功"
echo ""
