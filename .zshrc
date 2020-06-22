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
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
# zstyle ':vcs_info:git:*' stagedstr '%B%F{green}+%f%b'
# zstyle ':vcs_info:git:*' unstagedstr '%B%F{yellow}!%f%b'
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '%F{white}on%f %F{142}%f [%F{142}%b%f %m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'
# zstyle ':vcs_info:git:*' formats '%F{white}on%f %F{142} %b %c%u'

function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{blue}●%f"
  fi
}

# {user} in {dir} with {current_shell} [on {git_branch} [unstaged] [staged] ] {newline} >
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  user_prompt="%F{red}%n@%m%f in "
else
  user_prompt="%F{blue}%n%f in "
fi

dir_prompt="%F{yellow}%~%f"
# dir_prompt_short="%FS{yellow}%3~%f" #short dir - last 3 segments
cmd_prompt="%(?..%F{red} ✗ %?%f) "
shell_info_prompt="%F{white}with%f %F{244}$SHELL%f "
git_prompt="\$vcs_info_msg_0_"
new_line=$'\n'
entry_prompt="%(!.%F{red}#%f.%F{white}➔%f) "

PROMPT="${user_prompt}${dir_prompt}${cmd_prompt}${shell_info_prompt}${git_prompt}${new_line}${entry_prompt}"
RPROMPT="%t"

####################################
# HISTORY
####################################

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"

HISTSIZE=100000
SAVEHIST=100000
HISTCONTROL=ignoredups

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

function h() # search entire history for "foo" with e.g. h foo
{
  # check if we passed any parameters
  if [ -z "$*" ]; then # if no parameters were passed print entire history
    history 1
  else # if words were passed use it as a search
    history 1 | egrep --color=auto "$@"
  fi
}

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
setopt AUTO_PARAM_SLASH
setopt CORRECT_ALL
unsetopt FLOW_CONTROL

# exceptions to auto-correction
alias bundle='nocorrect bundle'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias sudo='nocorrect sudo'

####################################
# ALIAS
####################################

alias brewup='brew update; brew upgrade; brew cleanup; brew doctor; brew cu -af -y --cleanup'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cls='clear'
alias dock='/Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh && eval "$(docker-machine env default)"'
alias dockrm='docker rm $(docker ps -aq -f status=exited)'
alias grep='grep --color=auto'
alias ls='gls -h --group-directories-first --color=auto' # Use gnu ls
alias ll='ls -la' # Use a long listing format
alias l.='ls -d .*' # Show hidden files
alias lsd='ls -ld -- */' ## Show directories only
alias python='/usr/local/bin/python3'
alias work='/Users/Shared/repos'
####################################
# FUNCTIONS
####################################

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

function webdrivers() # Download the latest webdrivers
{
WEBDRIVER_LOCATION="$HOME/webdrivers"
mkdir -p "$WEBDRIVER_LOCATION"

# ChromeDriver
# echo "Installing latest ChromeDriver ..."
# version=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE)
# download_chrome_url=https://chromedriver.storage.googleapis.com/"$version"/chromedriver_mac64.zip
# echo "Downloading ... $download_chrome_url"
# if wget -q -nc --progress=bar:force "$download_chrome_url" && unzip -n -qq chromedriver_mac64.zip
# then
#   chmod +x chromedriver
#   mv chromedriver $WEBDRIVER_LOCATION/chromedriver
#   rm chromedriver_mac64.zip
#   echo "Installed chromedriver binary in $WEBDRIVER_LOCATION"
# else
#   echo "Failed, check download url: $download_chrome_url"
# fi

echo "installing edge"
version=$("/Applications/Microsoft\ Edge.app/Contents/MacOS/Microsoft\ Edge1 --version"  >/dev/null 2>&1 || awk '{print $3}')
echo "ver = $version"

# ## GeckoDriver
# echo "Installing latest GeckoDriver (Firefox) ..."
# json=$(wget -qO- https://api.github.com/repos/mozilla/geckodriver/releases/latest)
# echo $json
# download_geckodriver_url=$(echo "$json" | jq -r '.assets[].browser_download_url | select(contains("macos"))')
# echo "Downloading ... $download_geckodriver_url"
# if curl -s -L "$download_geckodriver_url" | tar -xz
# then
#   chmod +x geckodriver
#   mv geckodriver "$WEBDRIVER_LOCATION"
#   echo "Installed geckodriver binary in $WEBDRIVER_LOCATION"
# else
#   echo "Failed, check download url: $download_geckodriver_url"
# fi
}

####################################
# PLUGINS
####################################

source "$DOTFILES/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
