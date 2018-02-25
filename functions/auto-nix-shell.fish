function auto-nix-shell-message
    if test "$auto_nix_shell_message_enabled" != "false"
        set_color $argv[1]
        echo -n "$argv[2] "
        set_color reset
        echo $argv[3]
    end
end

function enter-nix-shell
    auto-nix-shell-message blue "->" "Entering nix-shell..."

    set -gx DEFAULT_NIX_SHASUM (shasum default.nix)

    if test -e /tmp/nix-cmd
        nix-shell --run "fish /tmp/nix-cmd ; rm /tmp/nix-cmd ; fish"
    else
        nix-shell --run "fish"
    end

    set -g AUTO_NIX_SHELL_EXIT_CODE $status

    if test -e /tmp/nix-pwd
        # The user left nix-shell by `cd`ing out of the directory
        cd (cat /tmp/nix-pwd)
        rm /tmp/nix-pwd
    else if test "$AUTO_NIX_SHELL_EXIT_CODE" = "0"
        # Exit this shell too because the user exited with Ctrl+D
        exit
    else
        # Loading default.nix failed
    end
end

function exit-nix-shell
    auto-nix-shell-message red "<-" "Exiting nix-shell..."

    pwd > /tmp/nix-pwd
    exit
end

function auto-nix-shell -d "enters/exits nix-shell automatically"
    set -l hash (shasum default.nix 2>&1)

    if test -e default.nix -a -z "$IN_NIX_SHELL" -a \( "$hash" != "$DEFAULT_NIX_SHASUM" -o "$AUTO_NIX_SHELL_EXIT_CODE" = 0 \)
        enter-nix-shell
        # Loop in case default.nix was changed
        auto-nix-shell
    else if test ! -e default.nix -a -n "$IN_NIX_SHELL"
        exit-nix-shell
    else if test -e default.nix -a -n "$IN_NIX_SHELL"
        set -l hash (shasum default.nix)
        if test "$hash" != "$DEFAULT_NIX_SHASUM"
            auto-nix-shell-message green "*" "Reloading nix-shell..."

            # Save the command for reentry
            echo $argv > /tmp/nix-cmd

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
