# check if we are on linux, otherwise return early
if test (uname) != "Linux"
    return
end

# clipboard: prefer wayland, fall back to x11
if set -q WAYLAND_DISPLAY; and type -q wl-copy
    alias clipcp="wl-copy"
    alias clipecho="wl-paste"
else if type -q xclip
    alias clipcp="xclip -selection clipboard"
    alias clipecho="xclip -selection clipboard -o"
else if type -q xsel
    alias clipcp="xsel --clipboard --input"
    alias clipecho="xsel --clipboard --output"
end
