#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Profile structure:
# name|ssh_key|git_name|git_email|github_user

# Create a new profile file
create_profile() {
    local name="$1"
    local ssh_key="$2"
    local git_name="$3"
    local git_email="$4"
    local github_user="$5"

    local profile_file="${PROFILES_DIR}/${name}"

    cat > "${profile_file}" <<EOF
SSH_KEY="${ssh_key}"
GIT_NAME="${git_name}"
GIT_EMAIL="${git_email}"
GITHUB_USER="${github_user}"
HOST_ALIAS="github.com-${name}"
EOF

    log_success "Profile '${name}' created"
}

# Load profile
load_profile() {
    local name="$1"
    local profile_file="${PROFILES_DIR}/${name}"

    if [[ -f "${profile_file}" ]]; then
        source "${profile_file}"
        return 0
    fi
    return 1
}