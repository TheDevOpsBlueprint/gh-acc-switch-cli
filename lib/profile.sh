#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Profile structure:
# name|ssh_key|git_name|git_email|github_user|gpg_key_id|gpg_sign_commits

# Create a new profile file
create_profile() {
    local name="$1"
    local ssh_key="$2"
    local git_name="$3"
    local git_email="$4"
    local github_user="$5"
    local gpg_key_id="${6:-}"
    local gpg_sign_commits="${7:-false}"

    local profile_file="${PROFILES_DIR}/${name}"

    cat > "${profile_file}" <<EOF
SSH_KEY="${ssh_key}"
GIT_NAME="${git_name}"
GIT_EMAIL="${git_email}"
GITHUB_USER="${github_user}"
HOST_ALIAS="github.com-${name}"
GPG_KEY_ID="${gpg_key_id}"
GPG_SIGN_COMMITS="${gpg_sign_commits}"
EOF

    log_success "Profile '${name}' created"
}

# Load profile
load_profile() {
    local name="$1"
    local profile_file="${PROFILES_DIR}/${name}"

    if [[ -f "${profile_file}" ]]; then
        source "${profile_file}"
        
        # Set defaults for backward compatibility
        GPG_KEY_ID="${GPG_KEY_ID:-}"
        GPG_SIGN_COMMITS="${GPG_SIGN_COMMITS:-false}"
        
        return 0
    fi
    return 1
}