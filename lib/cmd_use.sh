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

    echo "${profile_name}" > "${GH_SWITCH_DIR}/current"

    # Update remote URL if in a git repo
    if git rev-parse --git-dir &>/dev/null; then
        update_remote_url "${profile_name}"
    fi

    log_success "Switched to profile: ${profile_name}"
}

update_remote_url() {
    local profile="$1"
    local remotes
    remotes=$(git remote)
    for remote in $remotes; do
        local current_url
        current_url=$(git remote get-url "$remote" 2>/dev/null) || continue
        local new_url=""
        case "$current_url" in
            git@github.com:*)
                [[ "$current_url" != git@github.com-"$profile":* ]] &&
                    new_url="${current_url/git@github.com:/git@github.com-${profile}:}"
                ;;
            https://github.com/*)
                [[ "$current_url" != https://github.com-"$profile"/* ]] &&
                    new_url="${current_url/https:\/\/github.com/https:\/\/github.com-${profile}}"
                ;;
        esac
        if [[ -n "$new_url" ]]; then
            git remote set-url "$remote" "$new_url"
            log_info "Updated '$remote' remote URL to use ${profile} profile"
        fi
    done
}