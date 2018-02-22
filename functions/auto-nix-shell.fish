function auto-nix-shell-log
    echo $argv
end

function enter-nix-shell
    set_color green
    auto-nix-shell-log -n "⤓ "
    set_color reset
    set -x DEFAULT_NIX_SHASUM (shasum default.nix)
    auto-nix-shell-log "Entering nix-shell..."
    if test -e /tmp/nix-cmd
        set -l cmd (cat /tmp/nix-cmd)
        nix-shell --run "fish -c "(string escape (cat /tmp/nix-cmd))" ; fish"
        rm /tmp/nix-cmd
    else
        nix-shell --run "fish"
    end
    if test -e /tmp/nix-pwd
        # The user left nix-shell by `cd`ing out of the directory
        cd (cat /tmp/nix-pwd)
        rm /tmp/nix-pwd
    else
        # Exit this shell too because the user exited with Ctrl+D
        exit
    end
end

function exit-nix-shell
    set_color red
    auto-nix-shell-log -n "↥ "
    set_color reset
    auto-nix-shell-log "Exiting nix-shell..."
    pwd > /tmp/nix-pwd
    touch /tmp/nix-pwd
    exit
end

function auto-nix-shell -d "enters/exits nix-shell automatically"
    if test -e default.nix -a -z "$IN_NIX_SHELL"
        enter-nix-shell
        # Loop in case default.nix was changed
        auto-nix-shell
    else if test ! -e default.nix -a -n "$IN_NIX_SHELL"
        exit-nix-shell
    else if test -e default.nix -a -n "$IN_NIX_SHELL"
        set -l hash (shasum default.nix)
        if test "$hash" != "$DEFAULT_NIX_SHASUM"
            set_color blue
            auto-nix-shell-log -n "↻ "
            set_color reset
            # Save the command for reentry
            echo $argv > /tmp/nix-cmd
            auto-nix-shell-log "Reloading nix-shell because default.nix changed..."
            exit-nix-shell
        end
    else
    end
end

function prompt --on-event fish_prompt
    auto-nix-shell $argv
end

function preexec --on-event fish_preexec
    auto-nix-shell $argv
end
