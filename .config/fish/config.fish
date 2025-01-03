if status is-interactive

    # set vi mode
    fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual line

    # disable default greeting
    set fish_greeting

    # Function to check if a command exists
    function command_exists
        type -q $argv[1]
    end

    ## Aliases
    alias gdb="gdb -q"
    alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
    # Set clipboard commands based on OS
    if test (uname) = "Darwin"
        alias clipcp="pbcopy"
        alias clipecho="pbpaste"
    else if command_exists xclip
        alias clipcp="xclip -sel c"
        alias clipecho="xclip -sel c -o"
    end
    # ls aliases
    alias ll="ls -alhF"
    alias la="ls -A"
    alias l="ls -CF"

    if not command_exists python
        if command_exists python3
            alias python="python3"
        end
    end

    ## Configure commands

    # Add ~/bin to path
    fish_add_path ~/bin

    set -x EDITOR nvim
    # for mac / bsd coreutils
    set -x CLICOLOR 1

    # starship prompt
    starship init fish | source
end
