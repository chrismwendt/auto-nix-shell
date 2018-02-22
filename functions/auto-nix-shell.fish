function auto-nix-shell -d "enters/exits nix-shell automatically"
    if test -e default.nix -a -z "$IN_NIX_SHELL"
        set_color green
        echo -n "⤓ "
        set_color reset
        echo "Entering nix-shell..."
        nix-shell --run "fish"
        cd (cat /tmp/nix-pwd)
    else if test ! -e default.nix -a -n "$IN_NIX_SHELL"
        set_color red
        echo -n "↥ "
        set_color reset
        echo "Exiting nix-shell..."
        pwd > /tmp/nix-pwd
        exit
    end
end

function prompt --on-event fish_prompt
    auto-nix-shell
end

function preexec --on-event fish_preexec
    auto-nix-shell
end

function postexec --on-event fish_postexec
    auto-nix-shell
end
