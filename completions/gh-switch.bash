#!/usr/bin/env bash

_gh_switch() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Main commands
    opts="init add use current list delete auto help"

    case "${prev}" in
        gh-switch)
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
        use|delete)
            # Complete with profile names
            local profiles=""
            if [[ -d "$HOME/.config/gh-switch/profiles" ]]; then
                profiles=$(ls "$HOME/.config/gh-switch/profiles" 2>/dev/null)
            fi
            COMPREPLY=( $(compgen -W "${profiles}" -- ${cur}) )
            return 0
            ;;
    esac
}

complete -F _gh_switch gh-switch