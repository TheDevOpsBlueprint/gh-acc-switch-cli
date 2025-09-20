#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/profile.sh"
source "$(dirname "${BASH_SOURCE[0]}")/ssh_parser.sh"

cmd_delete() {
    local profile_name="$1"

    if [[ -z "$profile_name" ]]; then
        log_error "Usage: gh-switch delete <profile>"
        exit 1
    fi

    local profile_file="${PROFILES_DIR}/${profile_name}"

    if [[ ! -f "$profile_file" ]]; then
        log_error "Profile '${profile_name}' not found"
        exit 1
    fi

    read -p "Delete profile '${profile_name}'? (y/n): " confirm

    if [[ "$confirm" != "y" ]]; then
        echo "Cancelled"
        exit 0
    fi

    # Remove SSH host
    remove_ssh_host "github.com-${profile_name}"

    # Remove profile file
    rm -f "$profile_file"

    # Clear current if it's this profile
    if [[ -f "${GH_SWITCH_DIR}/current" ]]; then
        current=$(cat "${GH_SWITCH_DIR}/current")
        if [[ "$current" == "$profile_name" ]]; then
            rm -f "${GH_SWITCH_DIR}/current"
        fi
    fi

    log_success "Profile '${profile_name}' deleted"
}