export DOTFILES="$HOME/.dotfiles"

for DOTFILE in "$DOTFILES"/sys/extras/*; do
  [ -f "$DOTFILE" ] && source "$DOTFILE"
done
