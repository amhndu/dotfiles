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

# Save command history after every command
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

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

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
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

# Custom prompt
#export PS1='\[\033[38;5;196m\][\[\033[01;32m\](\D{%d %b %I:%M %p}) \[\033[01;34m\]\w\[\033[38;5;196m\]]\[\033[00m\]\n\$ \[$(tput sgr0)\]'

#Library path extension
#export LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH
#export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
#export CPLUS_INCLUDE_PATH=/usr/local/include:$CPLUS_INCLUDE_PATH

# Add ~/bin to path
export PATH=~/bin:$PATH
export TERM=xterm-256color

# Aliases
alias histless='history | less'
alias yt-audio='youtube-dl -xf bestaudio'
alias aria-ll='aria2c -x 15 -s 15'
alias gxx='g++ -std=c++17 -Wall -Wextra'
alias clipcp='xclip -sel c'
alias clipecho='xclip -sel c -o'
alias vpn-connect='sudo openvpn --config other-home/Others/client1.ovpn'
alias vtime="/bin/time -f \"Time:\nreal:\t%es\nuser:\t%Us\nsys:\t%Ss\nMemory\nMax:\t%MKb\nAvg:\t%tKb\""
alias gdb="gdb -q"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Used for one off calculations with python eg. $ pc 4*log(2)
function pc()
{
    python -c "from math import *;print($1)";
}

function embed-sub()
{
    ffmpeg -i "$1" -vf "subtitles='${1}'" -c:a copy "$1-embed.mkv"
}

# Welcome message if interactive (possibly breaks scp otherwise)
# case $- in *i*)
#    fortune definitions wisdom linux computers science;
#    echo;
# esac

shopt -s globstar
export EDITOR=vim

source ~/.bash-powerline.sh
