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

config_apps() {
    echo "=> Configure apps ... "
    if ! command -v brew &> /dev/null
    then
        echo "homebrew could not be found"
    else
        echo "skipped, homebrew already installed."
    fi
    
    brew tap Homebrew/bundle
    brew bundle --file="$DOTFILES"/brewfile
}

config_defaults() {
    echo "Configure macOS default settings ... TODO"
}

config_shell() {
    echo "Configure shell ... TODO"
}
config_misc() {
    echo "Configure misc ... TODO"
}

main() {
    bootstrap
    config_apps
    config_shell
    config_misc
    config_defaults
}

main
