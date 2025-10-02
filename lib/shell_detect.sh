#!/usr/bin/env bash

# Detect current shell type
detect_shell() {
    # Check parent process
    local parent_cmd=$(ps -o comm= -p $PPID 2>/dev/null)
    
    # Try to determine shell from parent process
    if [[ "$parent_cmd" == *"zsh"* ]]; then
        echo "zsh"
    elif [[ "$parent_cmd" == *"bash"* ]]; then
        echo "bash"
    # Check SHELL environment variable as fallback
    elif [[ "$SHELL" == *"zsh"* ]]; then
        echo "zsh"
    elif [[ "$SHELL" == *"bash"* ]]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

# Install shell completions for detected shell
install_completions() {
    local shell_type=$(detect_shell)
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local completions_dir="${script_dir}/../completions"
    
    log_info "Detected shell: $shell_type"
    
    case "$shell_type" in
        bash)
            install_bash_completions "$completions_dir"
            ;;
        zsh)
            install_zsh_completions "$completions_dir"
            ;;
        unknown)
            log_info "Could not detect shell type. Skipping completion installation."
            log_info "You can manually install completions from: $completions_dir"
            return 1
            ;;
    esac
}

# Install bash completions
install_bash_completions() {
    local completions_dir="$1"
    local bash_completion_file="${completions_dir}/gh-switch.bash"
    
    if [[ ! -f "$bash_completion_file" ]]; then
        log_error "Bash completion file not found: $bash_completion_file"
        return 1
    fi
    
    # Try different bash completion directories
    local bash_comp_dirs=(
        "/etc/bash_completion.d"
        "/usr/local/etc/bash_completion.d"
        "$HOME/.bash_completion.d"
    )
    
    for dir in "${bash_comp_dirs[@]}"; do
        if [[ -d "$dir" ]] && [[ -w "$dir" ]]; then
            cp "$bash_completion_file" "$dir/gh-switch"
            log_success "Bash completions installed to $dir/gh-switch"
            return 0
        elif [[ -d "$dir" ]]; then
            # Directory exists but not writable, try with sudo
            if sudo cp "$bash_completion_file" "$dir/gh-switch" 2>/dev/null; then
                log_success "Bash completions installed to $dir/gh-switch (with sudo)"
                return 0
            fi
        fi
    done
    
    # Fallback: create user-level completion directory
    local user_comp_dir="$HOME/.bash_completion.d"
    mkdir -p "$user_comp_dir"
    cp "$bash_completion_file" "$user_comp_dir/gh-switch"
    log_success "Bash completions installed to $user_comp_dir/gh-switch"
    log_info "Add this to your ~/.bashrc: source $user_comp_dir/gh-switch"
    return 0
}

# Install zsh completions
install_zsh_completions() {
    local completions_dir="$1"
    local zsh_completion_file="${completions_dir}/gh-switch.zsh"
    
    if [[ ! -f "$zsh_completion_file" ]]; then
        log_error "Zsh completion file not found: $zsh_completion_file"
        return 1
    fi
    
    # Try different zsh completion directories
    local zsh_comp_dirs=(
        "/usr/local/share/zsh/site-functions"
        "/usr/share/zsh/site-functions"
        "$HOME/.zsh/completions"
    )
    
    for dir in "${zsh_comp_dirs[@]}"; do
        if [[ -d "$dir" ]] && [[ -w "$dir" ]]; then
            cp "$zsh_completion_file" "$dir/_gh-switch"
            log_success "Zsh completions installed to $dir/_gh-switch"
            return 0
        elif [[ -d "$dir" ]]; then
            # Directory exists but not writable, try with sudo
            if sudo cp "$zsh_completion_file" "$dir/_gh-switch" 2>/dev/null; then
                log_success "Zsh completions installed to $dir/_gh-switch (with sudo)"
                return 0
            fi
        fi
    done
    
    # Fallback: create user-level completion directory
    local user_comp_dir="$HOME/.zsh/completions"
    mkdir -p "$user_comp_dir"
    cp "$zsh_completion_file" "$user_comp_dir/_gh-switch"
    log_success "Zsh completions installed to $user_comp_dir/_gh-switch"
    log_info "Add this to your ~/.zshrc: fpath=($user_comp_dir \$fpath)"
    log_info "Then run: autoload -Uz compinit && compinit"
    return 0
}

