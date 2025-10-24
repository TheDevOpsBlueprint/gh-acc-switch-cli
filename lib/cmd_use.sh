#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/profile.sh"
source "$(dirname "${BASH_SOURCE[0]}")/git_config.sh"

cmd_use() {
    local profile_name="$1"
    local scope="${2:-local}"

    if [[ -z "$profile_name" ]]; then
        log_error "Usage: gh-switch use <profile> [--global]"
        exit 1
    fi

    if [[ "$2" == "--global" ]]; then
        scope="global"
    fi

    if ! load_profile "$profile_name"; then
        log_error "Profile '${profile_name}' not found"
        exit 1
    fi

    apply_git_profile "${GIT_NAME}" "${GIT_EMAIL}" "${scope}"
    apply_git_gpg_config "${GPG_KEY_ID}" "${GPG_SIGN_COMMITS}" "${scope}"

    echo "${profile_name}" > "${GH_SWITCH_DIR}/current"

    # Update remote URL if in a git repo
    if git rev-parse --git-dir &>/dev/null; then
        update_remote_url "${profile_name}"
    fi

    log_success "Switched to profile: ${profile_name}"
}

update_remote_url() {
    local profile="$1"
    local current_url=$(git remote get-url origin 2>/dev/null)

    if [[ -n "$current_url" ]]; then
        local new_url=$(echo "$current_url" | sed "s/github\.com[-a-z]*/github.com-${profile}/")
        git remote set-url origin "$new_url"
        log_info "Updated origin URL to use ${profile} profile"
    fi
}