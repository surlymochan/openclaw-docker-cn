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
    echo -e "${GREEN}║${NC}    OpenClaw 基础工具链 - 一键部署系统                ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_menu() {
    echo "请选择要执行的迭代:"
    echo ""
    echo "  1) SP0216 - Qwen3-Max 模型接入"
    echo "     配置阿里百炼 qwen3-max 模型 (80k context, 8k max tokens)"
    echo ""
    echo "  2) SP0217 - bigclaw 插件 (composite-search tool)"
    echo "     百度搜索 + 高德搜索 (OpenClaw 插件方式)"
    echo ""
    echo "  3) SP0218 - 飞书 + Skills"
    echo "     飞书机器人接入 + 关键 Skills 安装"
    echo ""
    echo "  4) 全部部署（从 src+spec 发布版本，见 spec/README.md）"
    echo ""
    echo "  5) SP0221 - 实时股市信息搜索 (bigclaw 扩展)"
    echo "     当前与 SP0218 共用部署；迭代合并后即生效"
    echo ""
    echo "  6) workspace-backup - 仅备份 workspace（不部署）"
    echo "  7) workspace-restore - 仅恢复 workspace（不部署）"
    echo ""
    echo "  q) 退出"
    echo ""
}

deploy_sp0216() {
    log_info "执行 SP0216 部署..."
    bash "$SCRIPT_DIR/iteration/SP0216/deploy.sh"
}

deploy_sp0217() {
    log_info "执行 SP0217 部署 (bigclaw 插件 / composite-search tool)..."
    bash "$SCRIPT_DIR/iteration/SP0217/deploy.sh"
}

deploy_sp0218() {
    log_info "执行 SP0218 部署 (飞书 + Skills)..."
    bash "$SCRIPT_DIR/iteration/SP0218/deploy.sh"
}

deploy_sp0221() {
    log_info "执行 SP0221 相关部署 (实时股市搜索在 bigclaw 内，当前同 SP0218)..."
    bash "$SCRIPT_DIR/iteration/SP0218/deploy.sh"
}

deploy_all() {
    # 全部部署 = 从 iteration 合并回 src+spec 的最新发布版本；仅使用 src/ 与 spec/，不跑迭代脚本。
    log_info "执行全部部署（从 src+spec 发布版本，见 spec/README.md 版本号）..."
    bash "$SCRIPT_DIR/scripts/deploy-from-src.sh"
}

main() {
    show_banner
    
    if [ "$1" = "sp0216" ]; then
        deploy_sp0216
        exit 0
    elif [ "$1" = "sp0217" ]; then
        deploy_sp0217
        exit 0
    elif [ "$1" = "sp0218" ]; then
        deploy_sp0218
        exit 0
    elif [ "$1" = "sp0221" ]; then
        deploy_sp0221
        exit 0
    elif [ "$1" = "all" ]; then
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
    read -p "请输入选项 (1-7/q): " choice
    
    case "$choice" in
        1)
            deploy_sp0216
            ;;
        2)
            deploy_sp0217
            ;;
        3)
            deploy_sp0218
            ;;
        4)
            deploy_all
            ;;
        5)
            deploy_sp0221
            ;;
        6)
            bash "$SCRIPT_DIR/scripts/workspace-backup.sh"
            ;;
        7)
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
