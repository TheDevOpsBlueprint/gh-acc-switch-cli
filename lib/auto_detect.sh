#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/profile.sh"

# Detect profile based on repository
detect_profile() {
    if ! git rev-parse --git-dir &>/dev/null; then
        return 1
    fi

    local remote_url=$(git remote get-url origin 2>/dev/null)

    if [[ -z "$remote_url" ]]; then
        return 1
    fi

    # Check for profile-specific hosts
    if [[ "$remote_url" =~ github\.com-([a-z]+) ]]; then
        echo "${BASH_REMATCH[1]}"
        return 0
    fi

    # Check rules file
    if [[ -f "${GH_SWITCH_DIR}/rules" ]]; then
        while IFS='=' read -r pattern profile; do
            if [[ "$remote_url" =~ $pattern ]]; then
                echo "$profile"
                return 0
            fi
        done < "${GH_SWITCH_DIR}/rules"
    fi

    return 1
}

# Auto-switch command
cmd_auto() {
    local detected=$(detect_profile)

    if [[ -n "$detected" ]]; then
        log_info "Detected profile: ${detected}"
        cmd_use "$detected"
    else
        log_info "No profile detected for this repository"
    fi
}