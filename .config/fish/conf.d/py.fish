if not type -q python
    if type -q python3
        alias python="python3"
        alias py="python3"
    end
else
    alias py="python"
end
