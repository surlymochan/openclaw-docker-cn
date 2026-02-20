#!/bin/bash
set -e

# Ensure config directory exists
mkdir -p /home/node/.openclaw

# Generate Config from Template using Environment Variables
echo "🔧 Generating OpenClaw Configuration..."
# Check if envsubst is available (installed in Dockerfile)
if command -v envsubst >/dev/null; then
    envsubst < /app/openclaw.template.json > /home/node/.openclaw/openclaw.json
    echo "✅ Config generated at /home/node/.openclaw/openclaw.json"
else
    echo "❌ Error: envsubst not found. Config generation failed."
    exit 1
fi

# Ensure permissions
chown -R node:node /home/node/.openclaw

# Handover to OpenClaw
echo "🚀 Starting OpenClaw Gateway..."
# Switch to node user if running as root
if [ "$(id -u)" = "0" ]; then
    exec gosu node node dist/index.js gateway --allow-unconfigured --bind 0.0.0.0 --port 18789
else
    exec node dist/index.js gateway --allow-unconfigured --bind 0.0.0.0 --port 18789
fi
