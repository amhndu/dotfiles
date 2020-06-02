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
alias histless='history | less'
alias yt-audio='youtube-dl -xf bestaudio'
alias aria-ll='aria2c -x 15 -s 15'
alias gxx='g++ -std=c++17 -Wall -Wextra'
alias clipcp='xclip -sel c'
alias clipecho='xclip -sel c -o'
alias gdb="gdb -q"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dc='docker-compose'
alias ytdlll='youtube-dl -f best --external-downloader aria2c'

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

shopt -s globstar
export EDITOR=vim
export BROWSER=firefox

source ~/.bash-powerline.sh
