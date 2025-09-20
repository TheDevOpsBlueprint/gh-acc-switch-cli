#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/profile.sh"
source "$(dirname "${BASH_SOURCE[0]}")/ssh_writer.sh"

cmd_add() {
    local name="$1"

    if [[ -z "$name" ]]; then
        log_error "Usage: gh-switch add <profile-name>"
        exit 1
    fi

    echo "Creating profile: ${name}"

    read -p "SSH key path (~/.ssh/): " ssh_key
    ssh_key="${ssh_key:-$HOME/.ssh/id_rsa}"

    read -p "Git name: " git_name
    read -p "Git email: " git_email
    read -p "GitHub username: " github_user

    create_profile "$name" "$ssh_key" "$git_name" "$git_email" "$github_user"
    add_ssh_host "$name" "$ssh_key"

    log_success "Profile ${name} added successfully!"
    echo "Use 'gh-switch use ${name}' to activate"
}