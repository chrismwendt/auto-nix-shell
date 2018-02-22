auto-nix-shell-log() {
    echo "$@"
}

function enter-nix-shell() {
  auto-nix-shell-log "⤓ Entering nix-shell..."
  export DEFAULT_NIX_SHASUM="$(shasum default.nix)"
  if [ -e /tmp/nix-cmd ]; then
    nix-shell --run "bash /tmp/nix-cmd ; bash"
    rm /tmp/nix-cmd
  else
    nix-shell --run "bash"
  fi
  if [ -e /tmp/nix-pwd ]; then
    # The user left nix-shell by `cd`ing out of the directory
    cd "$(cat /tmp/nix-pwd)"
    rm /tmp/nix-pwd
  else
    # Exit this shell too because the user exited with Ctrl+D
    exit
  fi
}

exit-nix-shell() {
  auto-nix-shell-log "↥ Exiting nix-shell..."
  pwd > /tmp/nix-pwd
  exit
}

auto-nix-shell() {
  if [ -e default.nix -a -z "$IN_NIX_SHELL" ]; then
    enter-nix-shell
    # Loop in case default.nix was changed
    auto-nix-shell
  elif [ ! -e default.nix -a -n "$IN_NIX_SHELL" ]; then
    exit-nix-shell
  elif [ -e default.nix -a -n "$IN_NIX_SHELL" ]; then
    hash="$(shasum default.nix)"
    if [ "$hash" != "$DEFAULT_NIX_SHASUM" ]; then
      auto-nix-shell-log "↻ Reloading nix-shell because default.nix changed..."
      # Save the command for reentry
      echo "$@" > /tmp/nix-cmd
      exit-nix-shell
    fi
  fi
}

source ~/.bash-preexec.sh
preexec() { auto-nix-shell "$@"; }
precmd() { auto-nix-shell "$@"; }
