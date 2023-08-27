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

    UNAME_MACHINE="$(/usr/bin/uname -m)"
    if [[ "${UNAME_MACHINE}" == "arm64" ]]
        then
        # On ARM macOS, this script installs to /opt/homebrew only
        echo 'eval $("/opt/homebrew/bin/brew shellenv")' >> "${HOME}/.zprofile"
    else
        # On Intel macOS, this script installs to /usr/local only
        echo 'eval $("/usr/local/homebrew/bin/brew shellenv")' >> "${HOME}/.zprofile"
    fi
    cat "${HOME}/.zprofile"
}

config_defaults() {
    echo "Configure macOS default settings ... TODO"
}

config_shell() {
    echo "=> Configure shell ... "
    if [ -f "$HOME"/.zshrc ]; then
        echo "Saving existing file to $HOME/.zshrc.old"
        mv "$HOME"/.zshrc "$HOME"/.zshrc.old
    fi
    
    if [ -f "$HOME"/.zprofile ]; then
        echo "Saving existing file to $HOME/.zprofile.old"
        mv "$HOME"/.zprofile "$HOME"/.zprofile.old
    fi
    
    ln -sv "$DOTFILES"/sys/.zshrc "$HOME"/.zshrc
    ln -sv "$DOTFILES"/sys/.zprofile "$HOME"/.zprofile
}

config_misc() {
    echo "Configure misc ... TODO"
}

main() {
    bootstrap
    config_shell
    config_apps
    config_misc
    config_defaults
}

main
