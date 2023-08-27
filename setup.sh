#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'
DOTFILES="$HOME/.dotfiles"

bootstrap() {
    echo "=> Clone dotfiles"
    if [ ! -d "$DOTFILES" ]; then
        git clone --recursive https://bazusa@github.com/bazusa/dotfiles.git "$DOTFILES"
    fi
}

config_defaults() {
    echo "Configure macOS default settings ... "
}

config_shell() {
    echo "Configure shell ... "
}
config_misc() {
    echo "Configure misc ... "
}

config_apps() {
    echo "Configure apps ... "
}

main() {
    bootstrap
    config_apps
    echo $?
    
    config_shell
    echo $?
     
    config_misc
    echo $?
    
    config_defaults
    echo $?
}

main
