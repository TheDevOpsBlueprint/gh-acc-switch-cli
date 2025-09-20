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