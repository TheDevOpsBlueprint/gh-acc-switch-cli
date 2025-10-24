#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Check if GPG is installed
check_gpg_installed() {
    if ! command -v gpg &>/dev/null && ! command -v gpg2 &>/dev/null; then
        return 1
    fi
    return 0
}

# Get the GPG command (gpg or gpg2)
get_gpg_cmd() {
    if command -v gpg2 &>/dev/null; then
        echo "gpg2"
    elif command -v gpg &>/dev/null; then
        echo "gpg"
    else
        echo ""
    fi
}

# List all available GPG keys
list_gpg_keys() {
    local gpg_cmd=$(get_gpg_cmd)
    
    if [[ -z "$gpg_cmd" ]]; then
        log_error "GPG is not installed"
        return 1
    fi

    echo "Available GPG keys:"
    echo "==================="
    $gpg_cmd --list-secret-keys --keyid-format LONG 2>/dev/null | \
        grep -E "^(sec|uid)" | \
        sed 's/^/  /'
    echo ""
    echo "Hint: Use the key ID after 'sec' (e.g., 'rsa4096/ABCD1234EFGH5678')"
    echo "      Extract just the ID part: ABCD1234EFGH5678"
}

# Validate if a GPG key exists
validate_gpg_key() {
    local key_id="$1"
    local gpg_cmd=$(get_gpg_cmd)
    
    if [[ -z "$gpg_cmd" ]]; then
        log_error "GPG is not installed"
        return 1
    fi

    if [[ -z "$key_id" ]]; then
        return 0  # Empty key is valid (optional)
    fi

    # Check if the key exists in the keyring
    if $gpg_cmd --list-secret-keys "$key_id" &>/dev/null; then
        return 0
    else
        log_error "GPG key '$key_id' not found in keyring"
        return 1
    fi
}

# Get the email associated with a GPG key
get_gpg_key_email() {
    local key_id="$1"
    local gpg_cmd=$(get_gpg_cmd)
    
    if [[ -z "$gpg_cmd" ]] || [[ -z "$key_id" ]]; then
        return 1
    fi

    $gpg_cmd --list-keys "$key_id" 2>/dev/null | \
        grep -oP '(?<=<)[^>]+(?=>)' | \
        head -n 1
}

# Interactive GPG key selection
select_gpg_key_interactive() {
    local gpg_cmd=$(get_gpg_cmd)
    
    if [[ -z "$gpg_cmd" ]]; then
        log_info "GPG is not installed. Skipping GPG key setup."
        echo ""
        return 0
    fi

    # Check if there are any secret keys
    if ! $gpg_cmd --list-secret-keys &>/dev/null; then
        log_info "No GPG keys found in keyring. Skipping GPG key setup."
        echo ""
        return 0
    fi

    echo ""
    list_gpg_keys
    
    local gpg_key=""
    read -p "GPG key ID (optional, press Enter to skip): " gpg_key
    
    if [[ -n "$gpg_key" ]]; then
        if validate_gpg_key "$gpg_key"; then
            echo "$gpg_key"
            return 0
        else
            log_error "Invalid GPG key. Profile will be created without GPG signing."
            echo ""
            return 1
        fi
    fi
    
    echo ""
    return 0
}

