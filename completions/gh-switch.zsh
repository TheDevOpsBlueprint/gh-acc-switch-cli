#compdef gh-switch

_gh_switch() {
    local commands profiles

    commands=(
        'init:Initialize gh-switch'
        'add:Add a new profile'
        'use:Switch to a profile'
        'current:Show current profile'
        'list:List all profiles'
        'delete:Delete a profile'
        'auto:Auto-detect profile'
        'help:Show help'
    )

    case $state in
        args)
            case $words[2] in
                use|delete)
                    profiles=(${(f)"$(ls ~/.config/gh-switch/profiles 2>/dev/null)"})
                    _arguments "*:profile:($profiles)"
                    ;;
                *)
                    _describe 'command' commands
                    ;;
            esac
            ;;
    esac
}

_gh_switch "$@"