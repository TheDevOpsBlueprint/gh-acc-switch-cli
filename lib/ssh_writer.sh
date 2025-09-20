#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/ssh_parser.sh"

# Add GitHub host to SSH config
add_ssh_host() {
    local name="$1"
    local ssh_key="$2"
    local host_alias="github.com-${name}"

    if ssh_host_exists "${host_alias}"; then
        log_info "SSH host ${host_alias} already exists"
        return 0
    fi

    cat >> "${SSH_CONFIG}" <<EOF

# GitHub account: ${name}
Host ${host_alias}
  HostName github.com
  User git
  IdentityFile ${ssh_key}
  IdentitiesOnly yes
EOF

    log_success "Added SSH host ${host_alias}"
}

# Remove SSH host
remove_ssh_host() {
    local host="$1"
    sed -i.bak "/^Host ${host}$/,/^$/d" "${SSH_CONFIG}"
}