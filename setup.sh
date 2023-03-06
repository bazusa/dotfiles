#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'
DOTFILES="$HOME/.dotfiles"

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
