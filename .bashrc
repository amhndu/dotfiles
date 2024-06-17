# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

## History management
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend

# Set unlimited history

HISTSIZE=
HISTFILESIZE=

# rotate bash history in monthly chunks
[ -x ~/bin/history-backup.sh ] && ~/bin/history-backup.sh
# Save command history after every command
PROMPT_COMMAND="history -a"


# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# Enable globstar
shopt -s globstar



# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


## Completion
# enable programmable completion features .
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# brew bash completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"


## Aliases
alias xb='killall xbindkeys && xbindkeys'
alias aria-ll='aria2c -x 15 -s 15'
alias gxx='g++ -std=c++17 -Wall -Wextra'
alias clipcp='xclip -sel c'
alias clipecho='xclip -sel c -o'
alias gdb="gdb -q"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias vtime='/usr/bin/time -v'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ls aliases
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'

alias mosh-naisho="mosh -p 12301 --no-ssh-pty naisho"

# some custom functions
function venvact() {
    DIR="$(pwd)"

    WALK_UP_LIMIT=5
    while [ "$DIR" != "/" ] && [ $WALK_UP_LIMIT -gt 0 ]; do
        WALK_UP_LIMIT=$((WALK_UP_LIMIT-1))

        ACTIVATE="$DIR/venv/bin/activate"
        if [ -f "$ACTIVATE" ]; then
            echo "Activating" "$ACTIVATE"
            source "$ACTIVATE"
            return 0
        fi

        ALT_ACTIVATE="$DIR/.venv/bin/activate"
        if [ -f "$ALT_ACTIVATE" ]; then
            echo "Activating" "$ALT_ACTIVATE"
            source "$ALT_ACTIVATE"
            return 0
        fi
        DIR="$(dirname "$DIR")"
    done
    return 1
}
function grephistory() {
    grep -a "$1" ~/.bashrc ~/.bash_archive/*
}


# Add ~/bin to path
export PATH=~/bin:$PATH
export TERM=xterm-256color
export EDITOR=nvim
# for mac / bsd coreutils
export CLICOLOR=1
# load system-specific env
[ -x ~/.env.sh ] && source ~/.env.sh



# Source git-prompt in Arch for prompt-command to work
if [ -f "/usr/share/git/completion/git-prompt.sh" ]; then
    source "/usr/share/git/completion/git-prompt.sh"
fi

__prompt_colored_host() {
   local number
   local seed=44
   number=$(
       # get "random" string that depends on hostname
       md5sum <<<"$1+$seed" |
       # meh - take first byte and convert it to decimal
       cut -c-2 | xargs -I{} printf "%d\n" "0x{}" |
       # convert 0-255 range into 30-37 range
       awk '{print int($0/255.0*(37-30)+30)}'
  )
  printf '\[\e[%d;1m\]%s\[\e[m\]' "$number" "$1"
  echo
}

__prompt_command() {
    local EXIT="$?"
    local RESET='\[\033[m\]'
    local CYAN='\[\033[0;36m\]'
    local LBLUE='\[\033[0;94m\]'
    local PURPLE='\[\033[0;35m\]'
    local GREEN='\[\033[0;32m\]'
    local RED='\[\033[0;31m\]'
    local YELLOW='\[\033[0;33m\]'

    PS1=""

    if [ "$VIRTUAL_ENV" != "" ]; then
        PS1+="(`basename \"$VIRTUAL_ENV\"`) "
    fi

    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWCOLORHINTS=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    local GIT_INFO="$(declare -F __git_ps1 &>/dev/null && __git_ps1 " (%s)")"
    PS1+="[${LBLUE}\w${RESET}@$(__prompt_colored_host $HOSTNAME)${RESET}${GIT_INFO}${RESET}]\n"

    PS1+="${YELLOW}\T${RESET} "

    if [ $EXIT != 0 ]; then
        PS1+="${RED}{${EXIT}}${RESET} "
    fi

    PS1+="${GREEN}\$${RESET} "

}

export PROMPT_COMMAND="__prompt_command; $PROMPT_COMMAND"
