#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Get current git config
get_git_config() {
    local key="$1"
    local scope="${2:-local}"

    if [[ "$scope" == "local" ]] && ! git rev-parse --git-dir &>/dev/null; then
        return 1
    fi

    git config --${scope} --get "${key}" 2>/dev/null
}

# Set git config
set_git_config() {
    local key="$1"
    local value="$2"
    local scope="${3:-local}"

    if [[ "$scope" == "local" ]] && ! git rev-parse --git-dir &>/dev/null; then
        log_error "Not in a git repository"
        return 1
    fi

    git config --${scope} "${key}" "${value}"
}

# Apply profile to git
apply_git_profile() {
    local name="$1"
    local email="$2"
    local scope="${3:-local}"

    set_git_config "user.name" "${name}" "${scope}"
    set_git_config "user.email" "${email}" "${scope}"
}

# Apply GPG configuration to git
apply_git_gpg_config() {
    local gpg_key_id="$1"
    local gpg_sign_commits="$2"
    local scope="${3:-local}"

    if [[ -n "$gpg_key_id" ]]; then
        set_git_config "user.signingkey" "${gpg_key_id}" "${scope}"
        log_info "Set GPG signing key: ${gpg_key_id}"
        
        if [[ "$gpg_sign_commits" == "true" ]]; then
            set_git_config "commit.gpgsign" "true" "${scope}"
            log_info "Enabled automatic GPG commit signing"
        else
            set_git_config "commit.gpgsign" "false" "${scope}"
        fi
    else
        # Unset GPG config if no key is provided (for profiles without GPG)
        if [[ "$scope" == "local" ]] && git rev-parse --git-dir &>/dev/null; then
            git config --${scope} --unset user.signingkey 2>/dev/null || true
            git config --${scope} --unset commit.gpgsign 2>/dev/null || true
        elif [[ "$scope" == "global" ]]; then
            git config --${scope} --unset user.signingkey 2>/dev/null || true
            git config --${scope} --unset commit.gpgsign 2>/dev/null || true
        fi
    fi
}