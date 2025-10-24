#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/profile.sh"

cmd_list() {
    ensure_config_dir

    local current_profile=""
    if [[ -f "${GH_SWITCH_DIR}/current" ]]; then
        current_profile=$(cat "${GH_SWITCH_DIR}/current")
    fi

    echo "Available profiles:"
    echo "=================="

    for profile_file in "${PROFILES_DIR}"/*; do
        if [[ -f "$profile_file" ]]; then
            local profile_name=$(basename "$profile_file")
            source "$profile_file"

            if [[ "$profile_name" == "$current_profile" ]]; then
                echo -e "${GREEN}* ${profile_name}${NC} (active)"
            else
                echo "  ${profile_name}"
            fi
            echo "    User: ${GIT_NAME}"
            echo "    Email: ${GIT_EMAIL}"
            
            # Display GPG info if available
            if [[ -n "${GPG_KEY_ID:-}" ]]; then
                echo "    GPG Key: ${GPG_KEY_ID}"
                if [[ "${GPG_SIGN_COMMITS:-false}" == "true" ]]; then
                    echo "    GPG Signing: Enabled"
                else
                    echo "    GPG Signing: Manual"
                fi
            fi
            
            echo ""
        fi
    done
}