#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

show_banner() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}    OpenClaw 国内版 - 一键部署                         ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_menu() {
    echo "请选择操作："
    echo ""
    echo "  1) 全部部署（从 src 部署，含 workspace 备份与恢复）"
    echo "  2) workspace-backup - 仅备份 workspace"
    echo "  3) workspace-restore - 仅恢复 workspace"
    echo ""
    echo "  q) 退出"
    echo ""
}

deploy_all() {
    log_info "执行全部部署（从 src 发布版本，见 spec/README.md）..."
    bash "$SCRIPT_DIR/scripts/deploy-from-src.sh"
}

main() {
    show_banner

    if [ "$1" = "all" ]; then
        deploy_all
        exit 0
    elif [ "$1" = "workspace-backup" ]; then
        bash "$SCRIPT_DIR/scripts/workspace-backup.sh"
        exit 0
    elif [ "$1" = "workspace-restore" ]; then
        bash "$SCRIPT_DIR/scripts/workspace-restore.sh"
        exit 0
    fi

    show_menu
    read -p "请输入选项 (1-3/q): " choice

    case "$choice" in
        1)
            deploy_all
            ;;
        2)
            bash "$SCRIPT_DIR/scripts/workspace-backup.sh"
            ;;
        3)
            bash "$SCRIPT_DIR/scripts/workspace-restore.sh"
            ;;
        q|Q)
            log_info "退出"
            exit 0
            ;;
        *)
            log_info "无效选项"
            exit 1
            ;;
    esac
}

main "$@"
