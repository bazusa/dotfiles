####################################
# .zshrc configured for macos
# dated: 01/19/20
####################################

export PATH="/usr/local/sbin:$PATH"
export DOTFILES="$HOME/.dotfiles"

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
zstyle ':vcs_info:git:*' formats ' %F{white}on%f %F{142} %b'
zstyle ':vcs_info:*' enable git



NEWLINE=$'\n'
git_prompt="\$vcs_info_msg_0_ "
dir_prompt="%F{yellow}%3~%f"
user_prompt="%(!.%F{red}#%f.%F{white}with %F{244}$SHELL%f ${NEWLINE}» %f)"
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

  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

    autoload -Uz compinit
    compinit -i
  fi

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
alias python="/usr/local/bin/python3"

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

function changeJDK() # Set the system Java JDK
{
if [ "$PROFILE_SHELL" = 'bash' ]; then
  JDKS_DIR="/Library/Java/JavaVirtualMachines"
  JDKS=( $(ls ${JDKS_DIR}) )
  JDKS_STATES=()

  # Map state of JDK
  for (( i = 0; i < ${#JDKS[@]}; i++ )); do
    if [[ -f "${JDKS_DIR}/${JDKS[$i]}/Contents/Info.plist" ]]; then
      JDKS_STATES[${i}]=enable
    else
      JDKS_STATES[${i}]=disable
    fi
    echo "${i} ${JDKS[$i]} ${JDKS_STATES[$i]}"
  done

  # Declare variables
  DEFAULT_JDK_DIR=""
  DEFAULT_JDK=""
  OPTION=""

  # OPTION for default jdk and set variables
  while [[ ! "$OPTION" =~ ^[0-9]+$ || OPTION -ge "${#JDKS[@]}" ]]; do
    read -r -p "Enter Default JDK: " OPTION

    if [[ ! "$OPTION" =~ ^[0-9]+$ ]]; then
      echo "Sorry integers only"
    fi

    if [[ OPTION -ge "${#JDKS[@]}" ]]; then
      echo "Out of index"
    fi
  done

  DEFAULT_JDK_DIR="${JDKS_DIR}/${JDKS[$OPTION]}"
  DEFAULT_JDK="${JDKS[$OPTION]}"

  # Disable all jdk
  for (( i = 0; i < ${#JDKS[@]}; i++ )); do
    if [[ -f "${JDKS_DIR}/${JDKS[$i]}/Contents/Info.plist" ]]; then
      sudo mv "${JDKS_DIR}/${JDKS[$i]}/Contents/Info.plist" "${JDKS_DIR}/${JDKS[$i]}/Contents/Info.plist.disable"
    fi
  done

  # Enable default jdk
  if [[ -f "${DEFAULT_JDK_DIR}/Contents/Info.plist.disable" ]]; then
    sudo mv "${DEFAULT_JDK_DIR}/Contents/Info.plist.disable" "${DEFAULT_JDK_DIR}/Contents/Info.plist"
    echo "Enable ${DEFAULT_JDK} as default JDK"
  fi

else
  #echo "Unable to changeJDK, switch to bash (chsh -s /bin/bash) and try again!"
  JDKS_DIR="/Library/Java/JavaVirtualMachines"
  JDKS=( $(ls ${JDKS_DIR}) )
  JDKS_STATES=()

  for ((i = 1; i <= $#JDKS; i++)); do
    if [[ -f "${JDKS_DIR}/${JDKS[i]}/Contents/Info.plist" ]]; then
      JDKS_STATES[${i}]=enable
    else
      JDKS_STATES[${i}]=disable
    fi
    echo "$i ${JDKS[i]} ${JDKS_STATES[i]}"
  done

  # Declare variables
  DEFAULT_JDK_DIR=""
  DEFAULT_JDK=""
  OPTION=""

  while [[ ! "$OPTION" =~ ^[1-9]+$ || OPTION -gt "${#JDKS[@]}" ]]; do
    read "OPTION?Enter Default JDK: "

    if [[ ! "$OPTION" =~ ^[0-9]+$ ]]; then
      echo "Sorry integers only"
    fi

    if [[ OPTION -gt "${#JDKS[@]}" ]]; then
      echo "Out of index"
    fi
  done

  DEFAULT_JDK_DIR="${JDKS_DIR}/${JDKS[$OPTION]}"
  DEFAULT_JDK="${JDKS[$OPTION]}"

  # Disable all jdk
  for ((i = 1; i <= $#JDKS; i++)); do
    if [[ -f "${JDKS_DIR}/${JDKS[i]}/Contents/Info.plist" ]]; then
      sudo mv "${JDKS_DIR}/${JDKS[i]}/Contents/Info.plist" "${JDKS_DIR}/${JDKS[i]}/Contents/Info.plist.disable"
    fi
  done

  # Enable default jdk
  if [[ -f "${DEFAULT_JDK_DIR}/Contents/Info.plist.disable" ]]; then
    sudo mv "${DEFAULT_JDK_DIR}/Contents/Info.plist.disable" "${DEFAULT_JDK_DIR}/Contents/Info.plist"
    echo "Enable ${DEFAULT_JDK} as default JDK"
  fi

fi
}

####################################
# PLUGINS
####################################

source "$DOTFILES/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# Created by `userpath` on 2020-02-16 17:32:04
export PATH="$PATH:/Users/bazusa/.local/bin"
