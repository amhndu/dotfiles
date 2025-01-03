function venvact
    set dir (pwd)
    set walk_up_limit 5

    while test "$dir" != "/" -a $walk_up_limit -gt 0
        set walk_up_limit (math $walk_up_limit - 1)

        set activate "$dir/venv/bin/activate.fish"
        if test -f "$activate"
            echo "Activating $activate"
            source "$activate"
            return
        end

        set alt_activate "$dir/.venv/bin/activate.fish"
        if test -f "$alt_activate"
            echo "Activating $alt_activate"
            source "$alt_activate"
            return
        end
        set dir (dirname $dir)
    end
    return 1
end
