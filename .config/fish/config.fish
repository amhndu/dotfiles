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
    # clipcp/clipecho are defined per-OS in conf.d/{mac,linux}.fish
    # ls aliases
    alias ll="ls -alhF"
    alias la="ls -A"
    alias l="ls -CF"

    # Add ~/bin to path
    fish_add_path ~/bin


    set -x EDITOR nvim

    # starship prompt
    starship init fish | source


    if test -d /usr/lib/emscripten
        fish_add_path /usr/lib/emscripten
    end

end

