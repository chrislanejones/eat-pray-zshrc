# ================================================
# ~/.zshrc — Debian Edition
# ================================================

# 0. Only run in interactive zsh shells
[[ -z "$ZSH_VERSION" ]] && return

# >>> managed by chatgpt (Debian zig & xrun) >>>
# Debian-friendly PATH setup (no duplicates). Includes common script locations
# so your separate 'xrun' script is discoverable and not shadowed.
for d in /usr/local/zig "$HOME/.local/bin" "$HOME/bin" /usr/local/bin; do
  case ":$PATH:" in
    *":$d:"*) ;;
    *) PATH="$d:$PATH" ;;
  esac
done
export PATH

# If an xrun binary/script exists somewhere on PATH, prefer it as-is.
# We intentionally DO NOT define an xrun function here to avoid shadowing.
# You can check with: command -v xrun
# <<< managed by chatgpt (Debian zig & xrun) <<<

[[ $- != *i* ]] && return

# 1. Environment variables and PATH
export PATH="$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export EDITOR=vim
export VISUAL=vim
export LANG=en_US.UTF-8

# 2. Zinit plugin manager setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  print -P "%F{33}Installing Zinit (%F{220}zdharma-continuum/zinit%F{33})…%f"
  mkdir -p "$(dirname "$ZINIT_HOME")" \
    && chmod g-rwX "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" \
    && print -P "%F{33}Zinit installed successfully.%f" \
    || print -P "%F{160}Zinit installation failed.%f"
fi
source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Zinit annexes
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

# 3. History and shell options
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
zstyle ':savehist:*' merge yes

setopt appendhistory sharehistory hist_ignore_space \
       hist_ignore_all_dups hist_save_no_dups hist_ignore_dups
setopt NO_BEEP
setopt AUTO_CD CHASE_LINKS PUSHD_IGNORE_DUPS PUSHD_SILENT CDABLE_VARS
setopt EXTENDED_GLOB KSH_GLOB
setopt INTERACTIVE_COMMENTS

# 4. Completion system setup
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Za-z} m:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':fzf-tab:complete:cd:*' \
  fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' \
  fzf-preview 'ls --color $realpath'

autoload -Uz compinit compaudit
compaudit | xargs chmod g-w 2>/dev/null
compinit

# 5. Zinit plugin loading (after compinit)
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit cdreplay -q
zinit snippet https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker

# 6. Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '\e[1;3D' backward-word
bindkey '\e[1;3C' forward-word
bindkey '\e\e[D' backward-word
bindkey '\e\e[C' forward-word
bindkey '\eb' backward-word
bindkey '\ef' forward-word

# 7. Aliases
alias cls='clear'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias less='less -R'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias mkdir='mkdir -pv'
alias gs='git status -sb'
alias ga='git add .'
alias gc='git commit -v'
alias gd='git diff'
alias gl='git log --oneline --decorate --graph'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gbr='git branch'
alias update='sudo apt update && sudo apt upgrade -y'
alias upgrade='sudo apt full-upgrade -y'
alias zreload='source ~/.zshrc'
alias ezsh='touch ~/.zshrc && vim ~/.zshrc'
alias flat="flatten"

# 8. Functions
mkcd() {
  mkdir -p "$1" && cd "$1"
}
xrun() {
  if [[ -f "$1" ]]; then
    chmod +x "$1" && "$@"
  else
    echo "xrun: '$1' not found or not a regular file."
    return 1
  fi
}
tnv() {
  [[ -z "$1" ]] && { echo "Usage: tnv <file1> [file2...]"; return 1; }
  touch "$@" && vim "$1"
}

# 9. Prompt (Oh My Posh)
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.json)"

# 10. Tool-specific completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# 11. Go language
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

# 12. PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# 13. Zig
export PATH="/usr/local/zig:$PATH"

# 14. Flatten nested directory (move files up one level)
flatten() {
  local target="${1:-.}"
  local inner

  if [[ ! -d "$target" ]]; then
    echo "flatten: '$target' is not a directory."
    return 1
  fi

  inner=$(find "$target" -mindepth 1 -maxdepth 1 -type d | head -n 1)
  if [[ -z "$inner" ]]; then
    echo "flatten: no subdirectory found in '$target'."
    return 1
  fi

  echo "Flattening: moving all contents from '$inner' → '$target' ..."
  
  if command -v shopt >/dev/null 2>&1; then
    shopt -s dotglob nullglob
  else
    setopt glob_dots
  fi
  mv -i "$inner"/* "$inner"/.[!.]* "$target"/ 2>/dev/null

  if [[ $? -eq 0 ]]; then
    echo -n "Remove now-empty directory '$inner'? [y/N] "
    read ans
    [[ "$ans" == [Yy]* ]] && rmdir "$inner" 2>/dev/null && echo "Removed: $inner"
  else
    echo "flatten: failed to move some files."
    return 1
  fi
}

