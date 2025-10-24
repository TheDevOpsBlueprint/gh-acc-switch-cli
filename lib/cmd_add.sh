#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/profile.sh"
source "$(dirname "${BASH_SOURCE[0]}")/ssh_writer.sh"
source "$(dirname "${BASH_SOURCE[0]}")/gpg_utils.sh"

validate_ssh_key() {
    local key_path="$1"
    if [[ ! -f "$key_path" ]]; then
        log_error "Error: SSH key file '$key_path' does not exist."
        return 1
    fi
    local perms
    perms=$(stat -c "%a" "$key_path" 2>/dev/null || stat -f "%Lp" "$key_path")
    if [[ "$perms" != "600" ]]; then
        log_error "Error: SSH key file '$key_path' must have 600 permissions."
        return 1
    fi
    return 0
}

cmd_add() {
    local name="$1"

    if [[ -z "$name" ]]; then
        log_error "Usage: gh-switch add <profile-name>"
        exit 1
    fi

    echo "Creating profile: ${name}"

    read -p "SSH key path (~/.ssh/): " ssh_key
    ssh_key="${ssh_key/#\~/$HOME}"
    ssh_key="${ssh_key:-$HOME/.ssh/id_rsa}"

    if ! validate_ssh_key "$ssh_key"; then
        exit 1
    fi

    read -p "Git name: " git_name
    read -p "Git email: " git_email
    read -p "GitHub username: " github_user

    # GPG key setup (optional)
    local gpg_key=""
    local gpg_sign="false"
    
    if check_gpg_installed; then
        echo ""
        log_info "GPG Signing Configuration (Optional)"
        echo "Would you like to configure GPG commit signing for this profile?"
        read -p "Configure GPG signing? (y/N): " configure_gpg
        
        if [[ "$configure_gpg" =~ ^[Yy]$ ]]; then
            gpg_key=$(select_gpg_key_interactive)
            
            if [[ -n "$gpg_key" ]]; then
                read -p "Enable GPG signing for all commits? (Y/n): " enable_signing
                if [[ ! "$enable_signing" =~ ^[Nn]$ ]]; then
                    gpg_sign="true"
                fi
            fi
        fi
    fi

    create_profile "$name" "$ssh_key" "$git_name" "$git_email" "$github_user" "$gpg_key" "$gpg_sign"
    add_ssh_host "$name" "$ssh_key"

    log_success "Profile ${name} added successfully!"
    if [[ -n "$gpg_key" ]]; then
        log_info "GPG signing configured with key: ${gpg_key}"
    fi
    echo "Use 'gh-switch use ${name}' to activate"
}