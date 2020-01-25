####################################
# .zshrc configured for macos
# dated: 01/19/20
####################################

export PATH="/usr/local/sbin:$PATH"
export DOTFILES="$HOME/code/home/dotfiles"

####################################
# PROMPT
####################################
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

autoload -Uz vcs_info
precmd_vcs_info()
{
  vcs_info
}
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:git:*' formats '%F{142} (%b)%f'
zstyle ':vcs_info:*' enable git

git_prompt="\$vcs_info_msg_0_ "
dir_prompt="%F{yellow}%~%f"
user_prompt="%(!.%F{red}#%f.%F{white}» %f)"
cmd_prompt="%(?..%F{red} ✗ %?%f)"

PROMPT="${dir_prompt}${cmd_prompt}${git_prompt}${user_prompt}"
RPROMPT="%*"

export CLICOLOR=1

####################################
# HISTORY
####################################

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"

HISTSIZE=100000
SAVEHIST=100000
HISTCONTROL=ignoredups

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt HIST_NO_STORE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

####################################
# COMPLETION
####################################

# see http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Completion-System-Configuration

autoload -U compinit
compinit

unsetopt MENU_COMPLETE
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

zmodload -i zsh/complist

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

####################################
# INPUT / OUTPUT
####################################

setopt ALIASES
setopt AUTO_CD
setopt CORRECT_ALL
unsetopt FLOW_CONTROL
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias sudo='nocorrect sudo'

####################################
# ALIAS
####################################

alias brewup="brew update; brew upgrade; brew cleanup; brew doctor; brew cu -af -y --cleanup"
alias cd..="cd .." #handle the common typo
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cls="clear"
alias dock='/Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh && eval "$(docker-machine env default)"'
alias dockrm='docker rm $(docker ps -aq -f status=exited)'
alias grep="grep --color=auto"

alias ls="gls -h --group-directories-first --color=auto" # Use gnu ls
alias ll="ls -la" # Use a long listing format
alias l.="ls -d .*" # Show hidden files
alias lsd="ls -ld -- */" ## Show directories only

####################################
# FUNCTIONS
####################################

function h() # search entire history for "foo" with e.g. h foo
{
  # check if we passed any parameters
  if [ -z "$*" ]; then # if no parameters were passed print entire history
    history 1
  else # if words were passed use it as a search
    history 1 | egrep --color=auto "$@"
  fi
}

function mkd() # Create a new directory and enter it
{
  mkdir -p "$@" && cd "$_" || exit;
}

function preman() # open man page in preview: e.g. preman ls
{
  man -t "$@" | open -f -a "Preview"
}


####################################
# PLUGINS
####################################

source "$DOTFILES/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
