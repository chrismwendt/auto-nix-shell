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
if test -e ~/.config/fish/functions/auto-nix-shell.fish
    . ~/.config/fish/functions/auto-nix-shell.fish
end
```

## Install for bash shell

- Clone this repo
- Download [bash-preexec](https://github.com/rcaloras/bash-preexec#quick-start)
- Add this to your `~/.bashrc`:

```bash
if [ -e ~/auto-nix-shell/auto-nix-shell.sh ]; then
  . ~/auto-nix-shell/auto-nix-shell.sh
fi
```

## Usage

`cd` into a directory that contains `default.nix` and auto-nix-shell will enter a nix-shell for you.

[travis-link]: https://travis-ci.org/chrismwendt/auto-nix-shell
[travis-badge]: https://img.shields.io/travis/chrismwendt/auto-nix-shell.svg
[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[fisherman]: https://github.com/fisherman/fisherman
