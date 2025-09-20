#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

cmd_init() {
    echo "Initializing gh-switch..."

    ensure_config_dir

    # Create default config
    if [[ ! -f "${CONFIG_FILE}" ]]; then
        cat > "${CONFIG_FILE}" <<EOF
# gh-switch configuration
VERSION=1.0.0
AUTO_DETECT=true
DEFAULT_PROFILE=
EOF
    fi

    # Check SSH directory
    if [[ ! -d "$HOME/.ssh" ]]; then
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
    fi

    # Create SSH config if not exists
    if [[ ! -f "${SSH_CONFIG}" ]]; then
        touch "${SSH_CONFIG}"
        chmod 600 "${SSH_CONFIG}"
    fi

    backup_ssh_config

    log_success "gh-switch initialized!"
    echo ""
    echo "Next steps:"
    echo "  1. Add a profile: gh-switch add personal"
    echo "  2. Use profile: gh-switch use personal"
}