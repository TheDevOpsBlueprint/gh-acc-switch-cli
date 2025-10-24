#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/profile.sh"

cmd_current() {
    local current_file="${GH_SWITCH_DIR}/current"

    if [[ ! -f "$current_file" ]]; then
        echo "No profile currently active"
        return
    fi

    local profile_name=$(cat "$current_file")

    if load_profile "$profile_name"; then
        echo "Current profile: ${GREEN}${profile_name}${NC}"
        echo "  Git user: ${GIT_NAME}"
        echo "  Git email: ${GIT_EMAIL}"
        echo "  GitHub user: ${GITHUB_USER}"
        
        # Display GPG info if available
        if [[ -n "${GPG_KEY_ID:-}" ]]; then
            echo "  GPG key: ${GPG_KEY_ID}"
            if [[ "${GPG_SIGN_COMMITS:-false}" == "true" ]]; then
                echo "  GPG signing: Enabled"
            else
                echo "  GPG signing: Manual"
            fi
        fi

        if git rev-parse --git-dir &>/dev/null; then
            echo ""
            echo "Repository config:"
            echo "  user.name: $(get_git_config user.name)"
            echo "  user.email: $(get_git_config user.email)"
            
            # Display GPG config if set
            local signing_key=$(get_git_config user.signingkey)
            local gpg_sign=$(get_git_config commit.gpgsign)
            if [[ -n "$signing_key" ]]; then
                echo "  user.signingkey: ${signing_key}"
            fi
            if [[ -n "$gpg_sign" ]]; then
                echo "  commit.gpgsign: ${gpg_sign}"
            fi
        fi
    else
        log_error "Current profile '${profile_name}' not found"
    fi
}