# check if we are on mac, otherwise return early
if test (uname) != "Darwin"
    return
end

if test -f /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # disable auto-update
    set -x HOMEBREW_NO_AUTO_UPDATE 1
end

if test -d ~/.local/bin
    # pipx uses this path
    fish_add_path ~/.local/bin
end


# for mac / bsd coreutils
set -x CLICOLOR 1
