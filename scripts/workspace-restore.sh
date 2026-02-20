#!/bin/bash
# SP0222：仅从备份恢复 workspace，不备份、不部署。
# 若备份不存在则跳过并提示（首次部署无备份场景）。
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

log_info "仅恢复 workspace ← $BACKUP_PATH（目标服务器: $SERVER_IP）"

ssh "$SERVER_USER@$SERVER_IP" "set -e;
if [ ! -f '$BACKUP_PATH' ]; then
  echo '无有效备份，跳过恢复（首次部署或未执行过备份）';
  exit 0;
fi;
mkdir -p '$(dirname "$WORKSPACE_PATH")';
rm -rf '$WORKSPACE_PATH';
tar xf '$BACKUP_PATH' -C '$(dirname "$WORKSPACE_PATH")';
chown -R 1000:1000 '$WORKSPACE_PATH' 2>/dev/null || true;
echo 'Restore done: '$WORKSPACE_PATH'';
"

log_success "workspace 恢复完成"
