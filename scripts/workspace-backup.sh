#!/bin/bash
# SP0222：仅备份 workspace，不部署、不恢复。
# 在服务器上将 /root/.openclaw/workspace 打包为 /data/openclaw-deploy/workspace-backup.tar（只保留最新一份）。
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 若本脚本在项目 scripts/ 下，则 PROJECT_ROOT 为上一级；若在 iteration/SP0222/scripts/ 下，则为上两级
if [ -d "$SCRIPT_DIR/../src" ]; then PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"; else PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"; fi

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

SERVER_IP="${SERVER_IP:-175.178.157.123}"
SERVER_USER="${SERVER_USER:-root}"
WORKSPACE_PATH="${OPENCLAW_WORKSPACE_PATH:-/root/.openclaw/workspace}"
BACKUP_PATH="${OPENCLAW_WORKSPACE_BACKUP_PATH:-/data/openclaw-deploy/workspace-backup.tar}"

log_info "仅备份 workspace → $BACKUP_PATH（目标服务器: $SERVER_IP）"

ssh "$SERVER_USER@$SERVER_IP" "set -e;
if [ ! -d '$WORKSPACE_PATH' ]; then
  echo 'Workspace 目录不存在，跳过备份';
  exit 0;
fi;
rm -f '$BACKUP_PATH';
tar cf '$BACKUP_PATH' -C '$(dirname "$WORKSPACE_PATH")' '$(basename "$WORKSPACE_PATH")';
echo 'Backup done: '$BACKUP_PATH'';
ls -la '$BACKUP_PATH';
"

log_success "workspace 备份完成（仅保留最新一份，默认永久保留）"
