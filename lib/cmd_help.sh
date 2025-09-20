#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

cmd_help() {
    cat <<EOF
gh-switch - GitHub Account Switcher

USAGE:
    gh-switch <command> [options]

COMMANDS:
    init            Initialize gh-switch
    add <name>      Add a new profile
    use <name>      Switch to a profile
    current         Show current profile
    list            List all profiles
    delete <name>   Delete a profile
    auto            Auto-detect profile for current repo
    help            Show this help message

OPTIONS:
    --global        Apply profile globally (with 'use' command)

EXAMPLES:
    gh-switch init
    gh-switch add personal
    gh-switch use work
    gh-switch use personal --global
    gh-switch current
    gh-switch list

CONFIGURATION:
    Config dir: ~/.config/gh-switch/
    SSH config: ~/.ssh/config
EOF
}