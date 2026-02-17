#!/bin/bash

# 部署入参：SERVER_IP 通过参数或环境变量传入；可选通过 OPENCLAW_DEPLOY_ENV 指向 deploy.env 加载（文件由调用方自行管理，不随仓库提供）
if [ -n "${OPENCLAW_DEPLOY_ENV:-}" ] && [ -f "$OPENCLAW_DEPLOY_ENV" ]; then
    source "$OPENCLAW_DEPLOY_ENV"
fi

SERVER_IP="${1:-${SERVER_IP:-}}"
CONTAINER="openclaw-deploy-openclaw-gateway-1"

# 检查参数 (如果 Env 也没加载到)
if [ -z "$SERVER_IP" ]; then
    echo "❌ 错误: 未指定服务器IP"
    echo "用法: ./approve-device.sh <SERVER_IP>"
    exit 1
fi

echo "🔍 Scanning for pending devices on $SERVER_IP..."

# Get the list output
OUTPUT=$(ssh root@$SERVER_IP "docker exec $CONTAINER node dist/index.js devices list")

# Check if there are pending items (look for "Pending (N)")
if [[ $OUTPUT != *"Pending ("* ]]; then
    echo "✅ No pending devices found."
    exit 0
fi

echo "⚡ Found pending devices. Processing..."

# Extract Request IDs (UUIDs in the first column)
# Format: │ <UUID> │ ...
REQ_IDS=$(echo "$OUTPUT" | grep "│" | grep -v "Request" | grep -v "Device" | awk '{print $2}' | grep -E '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')

if [ -z "$REQ_IDS" ]; then
    echo "⚠️  Could not parse Request IDs. Please check manually."
    echo "$OUTPUT"
    exit 1
fi

for ID in $REQ_IDS; do
    echo "👉 Approving Request: $ID"
    ssh root@$SERVER_IP "docker exec $CONTAINER node dist/index.js devices approve $ID"
done

echo "✅ All pending devices approved!"
