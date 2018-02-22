# auto-nix-shell

[![Build Status][travis-badge]][travis-link]
[![Slack Room][slack-badge]][slack-link]

enters/exits nix-shell automatically

## Install for fish shell

With [fisherman]

```
fisher chrismwendt/auto-nix-shell
```

Then add this to your `~/.config/fish/config.fish`:

```fish
. ~/.config/fish/functions/auto-nix-shell.fish
```

## Install for bash shell

Get [bash-preexec](https://github.com/rcaloras/bash-preexec#quick-start) then add this to your `~/.bashrc`:

```bash
autonixshell() {
  if test -e default.nix -a -z "$IN_NIX_SHELL"; then
    echo "⤓ Entering nix-shell..."
    nix-shell --run "bash"
    cd $(cat /tmp/nix-pwd)
  elif test ! -e default.nix -a -n "$IN_NIX_SHELL"; then
    echo "↥ Exiting nix-shell..."
    pwd > /tmp/nix-pwd
    exit
  fi
}

source ~/.bash-preexec.sh
preexec() { autonixshell }
precmd() { autonixshell }
```

## TODO

- Re-run `nix-shell` if `default.nix` changed (e.g. after `git pull`)

## Usage

`cd` into a directory that contains `default.nix` and auto-nix-shell will enter a nix-shell for you.

[travis-link]: https://travis-ci.org/chrismwendt/auto-nix-shell
[travis-badge]: https://img.shields.io/travis/chrismwendt/auto-nix-shell.svg
[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[fisherman]: https://github.com/fisherman/fisherman
