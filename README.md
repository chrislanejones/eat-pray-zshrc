![Eat Pray ZSH book Cover](EatPrayZSH.webp)

# Eat Pray ZSH

My personal Zsh setup for Debian, Arch, and Fedora — native and WSL. One
config, three package managers, the same fast shell everywhere: a
Rust-powered core (zoxide, eza, bat), fuzzy tab-completion, synced
history, and a themed prompt that sets itself up on first run.

## Why it's useful

Stock Zsh is fine. This makes it quick and legible:

- **Type less to move around.** `cd` is [zoxide](https://github.com/ajeetdsouza/zoxide) — it learns the directories you visit, so `cd dow` jumps to `~/Downloads` from anywhere.
- **See more at a glance.** `ls` is [eza](https://github.com/eza-community/eza) with icons and git status; `cat` is [bat](https://github.com/sharkdp/bat) with syntax highlighting and line numbers.
- **Find instead of remember.** [fzf](https://github.com/junegunn/fzf) + fzf-tab turn tab-completion into a fuzzy picker with a live preview window.
- **History that follows you.** [atuin](https://atuin.sh/) keeps shell history in a searchable database and can sync it across machines.
- **A prompt that tells you where you are.** [Oh My Posh](https://ohmyposh.dev/) shows the git branch, language versions, and last exit status.
- **Per-directory tooling.** [direnv](https://direnv.net/) loads and unloads env vars as you `cd`; [fnm](https://github.com/Schniz/fnm) switches Node versions automatically on `cd`.
- **No manual plugin management.** [Zinit](https://github.com/zdharma-continuum/zinit) installs itself on first launch and pulls every plugin — syntax highlighting, autosuggestions, completions, fzf-tab.
- **One-shot git and text helpers.** `save "msg"` to add/commit/push, `TC` to title-case a line, `flatten` to un-nest a lone subdirectory, and a few more (see [Functions](#functions)).

## Editions

Pick one file per machine.

| File | Use it on |
| --- | --- |
| `.zshrc` | Native Linux install |
| `.zshrc-WSL` | WSL — adds Windows shortcuts (Cursor, Explorer, `browse`) |

Distros: `Debian/`, `Arch/`, `Fedora/`.

## Prerequisites

Install these before copying the config — the file expects to find them
on `PATH`. The same list is kept in a comment block at the top of every
`.zshrc`. Several are `curl | sh` installers straight from the vendor;
read a script first if that bothers you (`curl -fsSL <url> -o setup.sh`,
skim it, then run it).

### 1. System tools

| Distro | Command |
| --- | --- |
| Debian | `sudo apt update && sudo apt install zoxide eza bat fzf direnv curl git -y` |
| Arch | `sudo pacman -S zoxide eza bat fzf direnv curl git` |
| Fedora | `sudo dnf install zoxide eza bat fzf direnv curl git -y` |

On Debian the `bat` binary is `batcat` (Debian names it that to avoid a
clash) — the config already aliases `cat` to `batcat` there.

### 2. Toolchains and extras

| Tool | Install |
| --- | --- |
| fnm (Node) | `curl -fsSL https://fnm.vercel.app/install \| bash` |
| Oh My Posh | `curl -s https://ohmyposh.dev/install.sh \| bash -s` |
| Bun | `curl -fsSL https://bun.sh/install \| bash` |
| Rust | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| Go | Debian: manual to `/usr/local/go` · Arch: `sudo pacman -S go` · Fedora: `sudo dnf install golang -y` |
| atuin | `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh \| sh` |

Everything except the language toolchains you don't want is optional —
the config guards the sources that can be missing, so a shell without
Bun or atuin still starts cleanly.

## Install

1. Pick your distro folder and copy `.zshrc` (or `.zshrc-WSL`) to `~/.zshrc`.
2. Install the [prerequisites](#prerequisites) above.
3. Copy the prompt theme into place so Oh My Posh can find it:
   ```sh
   mkdir -p ~/.config/ohmyposh
   cp ohmyposh/base.json ~/.config/ohmyposh/base.json
   ```
4. Restart your terminal. Zinit self-installs on the first launch and
   pulls every plugin — the first start is slower while it clones.

## Tools used

| Tool | What it does here |
| --- | --- |
| [Zinit](https://github.com/zdharma-continuum/zinit) | Plugin manager; installs on first run |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` that ranks directories by use (aliased as `cd`) |
| [eza](https://github.com/eza-community/eza) | Modern `ls` with icons and git status |
| [bat](https://github.com/sharkdp/bat) | Syntax-highlighted `cat` (`batcat` on Debian) |
| [fzf](https://github.com/junegunn/fzf) + fzf-tab | Fuzzy finder and fuzzy tab-completion with previews |
| [Oh My Posh](https://ohmyposh.dev/) | Prompt theme (config in `ohmyposh/base.json`) |
| [atuin](https://atuin.sh/) | Searchable, syncable shell history |
| [direnv](https://direnv.net/) | Per-directory environment variables |
| [fnm](https://github.com/Schniz/fnm) | Fast Node version manager, switches on `cd` |
| zsh-syntax-highlighting, zsh-autosuggestions, zsh-completions | Loaded via Zinit for highlighting, inline suggestions, and extra completions |

## Distro differences

| | Debian | Arch | Fedora |
| --- | --- | --- | --- |
| Package manager | `apt` | `pacman` | `dnf` |
| Update alias (`update`) | `apt update && apt upgrade -y` | `pacman -Syu` | `dnf upgrade --refresh` |
| Go bin on `PATH` | `/usr/local/go/bin` | `/usr/lib/go/bin` | `/usr/lib/golang/bin` |
| `bat` command | `batcat` | `bat` | `bat` |

## Functions

| Function | Description |
| --- | --- |
| `mkcd <dir>` | Create a directory and `cd` into it |
| `save "msg"` | `git add . && commit -m "msg" && push` in one shot (stops if the commit fails) |
| `TC` | Title-case a line via pipe — `echo "foo bar" \| TC` |
| `flatten [dir]` | Move files out of a lone subdirectory up one level (`flat` for short) |
| `pullscript` | fzf picker to copy a script from `~/scripts` into the current dir |
| `roll [dir]` | Run `~/.local/bin/roll_repo` against a target directory |
| `browse <url>` | Open a URL in the Windows browser (WSL only) |

## WSL-only aliases

| Alias | Does |
| --- | --- |
| `cursor` | Launch the Cursor editor from WSL |
| `open` | Open the current folder in Windows Explorer |
| `x` | Same as `open` |
| `rmzone` | Delete `Zone.Identifier` files left behind by Windows downloads |

## Keybindings

| Key | Action |
| --- | --- |
| `Ctrl+P` | History search backward |
| `Ctrl+N` | History search forward |
| `Ctrl+Arrow` | Move word forward / backward |
| `Alt+B` / `Alt+F` | Move word backward / forward |
