#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'
DOTFILES="$HOME/.dotfiles"

config_defaults() {
  echo "Configure macOS deafult settings ... "
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
  config_shell
  config_misc
  config_defaults
}
