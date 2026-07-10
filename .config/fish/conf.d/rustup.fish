if test -f ~/.cargo/env.fish
    source "$HOME/.cargo/env.fish"
else if test -d ~/.cargo/bin/
    fish_add_path ~/.cargo/bin/
end
