#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
# set -x
IFS=$'\n\t'
DOTFILES="$HOME/.dotfiles"

main() {
  echo "${DOTFILES}"
  if ! [ -x "$(command -v brew)" ]; then
    echo "Installing homebrew ... "
  fi
  
  # if ! [ -x "$(command -v brew)" ]; then
  #   echo "Installing homebrew ..."
  #   #  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # else
  #   echo "Homebrew installed ... skipped"
  # fi

}

main "$@"
