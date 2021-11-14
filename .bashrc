# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Set unlimited history
HISTSIZE=
HISTFILESIZE=
# rotate bash history in monthly chunks
~/bin/history-backup.sh

# Save command history after every command
PROMPT_COMMAND="history -a"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Add ~/bin to path
export PATH=~/bin:$PATH
export TERM=xterm-256color

# Some custom aliases
alias yt-audio='youtube-dl -xf bestaudio'
alias aria-ll='aria2c -x 15 -s 15'
alias gxx='g++ -std=c++17 -Wall -Wextra'
alias clipcp='xclip -sel c'
alias clipecho='xclip -sel c -o'
alias gdb="gdb -q"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dc='docker-compose'
alias ytdlll='youtube-dl -f bestvideo+bestaudio --external-downloader aria2c'
alias vtdlll='youtube-dl -f best --external-downloader aria2c'
alias vtime='/usr/bin/time -v'
alias cola='cola &'

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
        DIR="$(dirname "$DIR")"
    done
    return 1
}

function grephist() {
    grep "$1" ~/.bash_archive/*
}

shopt -s globstar
export EDITOR=vim
export BROWSER=firefox

# For Arch
if [ -f "/usr/share/git/completion/git-prompt.sh" ]; then
    source "/usr/share/git/completion/git-prompt.sh"
fi

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
    PS1+="[${LBLUE}\w${PURPLE}${GIT_INFO}${RESET}]\n"

    PS1+="${YELLOW}\T${RESET} "

    if [ $EXIT != 0 ]; then
        PS1+="${RED}{${EXIT}}${RESET} "
    fi

    PS1+="${GREEN}\$${RESET} "

}

export PROMPT_COMMAND="__prompt_command; $PROMPT_COMMAND"
function func_vpn {
        CURRENT_WG=`ip addr | grep POINTOPOINT | sed -E  's/^.+?: (.+?):.*$/\1/'`
        [[ -z "$CURRENT_WG" ]] && echo "No vpn active." || sudo wg-quick down $CURRENT_WG
        [[ "$1" != "down" ]] && sudo wg-quick up $1 || echo "Took vpn down."
}
alias vpn="func_vpn"

if [[ -x "/etc/wireguard" ]]; then
    # arch/personal doesn't have permission to read, so check before accessing it
    complete -W "`ls /etc/wireguard | sed -E 's/(.*)\..*/\1/' | tr "\n" " "`" vpn
fi

source "$HOME/.cargo/env"
