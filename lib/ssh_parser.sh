#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Check if SSH host exists
ssh_host_exists() {
    local host="$1"
    grep -q "^Host ${host}$" "${SSH_CONFIG}" 2>/dev/null
}

# Extract SSH config section
get_ssh_section() {
    local host="$1"
    awk "/^Host ${host}$/,/^Host /" "${SSH_CONFIG}" | head -n -1
}

# Backup SSH config
backup_ssh_config() {
    local backup="${SSH_CONFIG}.gh-switch.backup"
    cp "${SSH_CONFIG}" "${backup}"
    log_info "SSH config backed up to ${backup}"
}