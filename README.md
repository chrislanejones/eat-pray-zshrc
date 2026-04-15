![Eat Pray ZSH book Cover](EatPrayZSH.webp)

# Eat Pray ZSH

My personal Zsh configuration for Debian, Arch, and Fedora — including WSL variants with Windows integration.

## Editions

Each distro has two files:

| File | Description |
| --- | --- |
| `.zshrc` | Native Linux install |
| `.zshrc-WSL` | WSL with Windows shortcuts (Cursor, Explorer, etc.) |

## Tools Used

- **[Zinit](https://github.com/zdharma-continuum/zinit)** — plugin manager
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** — smarter `cd` (aliased as `cd`)
- **[eza](https://github.com/eza-community/eza)** — modern `ls` with icons and git status
- **[bat](https://github.com/sharkdp/bat)** — syntax-highlighted `cat`
- **[fzf](https://github.com/junegunn/fzf)** + **fzf-tab** — fuzzy tab completion
- **[Oh My Posh](https://ohmyposh.dev/)** — prompt theme
- **[atuin](https://atuin.sh/)** — shell history sync
- **[direnv](https://direnv.net/)** — per-directory env vars
- **[fnm](https://github.com/Schniz/fnm)** — fast Node version manager

## Distro Differences

| | Debian | Arch | Fedora |
| --- | --- | --- | --- |
| Package manager | `apt` | `pacman` | `dnf` |
| Update alias | `apt update && apt upgrade -y` | `pacman -Syu` | `dnf upgrade --refresh` |
| Go bin path | `/usr/local/go/bin` | `/usr/lib/go/bin` | `/usr/lib/golang/bin` |
| `bat` command | `batcat` | `bat` | `bat` |

## Functions

| Function | Description |
| --- | --- |
| `mkcd <dir>` | Create directory and cd into it |
| `save "msg"` | `git add . && commit && push` in one shot |
| `TC` | Title Case via pipe — `echo "foo bar" \| TC` |
| `flatten` | Move files out of a lone subdirectory up one level |
| `pullscript` | fzf picker to copy a script from `~/scripts` into current dir |
| `roll` | Run `roll_repo` against a target directory |
| `browse <url>` | Open URL in Windows browser (WSL only) |

## WSL-Only Aliases

| Alias | Does |
| --- | --- |
| `cursor` | Launch Cursor editor from WSL |
| `open` | Open current folder in Windows Explorer |
| `x` | Same as `open` |
| `rmzone` | Delete `Zone.Identifier` files left by Windows downloads |

## Keybindings

| Key | Action |
| --- | --- |
| `Ctrl+P` | History search backward |
| `Ctrl+N` | History search forward |
| `Ctrl+Arrow` | Move word forward/backward |
| `Alt+B` / `Alt+F` | Move word backward/forward |

## Install

1. Pick your distro folder and copy `.zshrc` (or `.zshrc-WSL`) to `~/.zshrc`
2. Install prerequisites listed at the top of the file
3. Restart your terminal — Zinit will self-install on first run
