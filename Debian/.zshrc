# ==============================================================================
# ~/.zshrc — Debian (WSL) Pro Edition
# ==============================================================================
# PREREQUISITES (Run these to make this config work):
#
# 1. System Tools:
#    sudo apt update && sudo apt install zoxide eza bat fzf direnv curl git -y
#
# 2. FNM (Node): curl -fsSL https://fnm.vercel.app/install | bash
# 3. Oh My Posh: curl -s https://ohmyposh.dev/install.sh | bash -s
# 4. Bun: curl -fsSL https://bun.sh/install | bash
# 5. Rust: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# 6. Go: Manual install to /usr/local/go (as performed earlier)
# 7. Zig: Extract to ~/zig-linux-x86_64-0.13.0
# ==============================================================================

# -------------------------------------------------
# 0. Performance Optimization
# -------------------------------------------------
[[ -z "$ZSH_VERSION" || $- != *i* ]] && return

autoload -Uz compinit
for dump in "${ZDOTDIR:-$HOME}/.zcompdump"(N.mh+24); do
  compinit
done
compinit -C

# -------------------------------------------------
# 1. Locale & Editor
# -------------------------------------------------
export LANG=en_US.UTF-8
export EDITOR='cursor --wait'
export VISUAL='cursor --wait'

# -------------------------------------------------
# 2. Tool Locations
# -------------------------------------------------
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export CARGO_HOME="$HOME/.cargo"
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/.local/share/pnpm"
export FNM_DIR="$HOME/.fnm"
export ZIG_PATH="$HOME/zig-linux-x86_64-0.13.0"

# -------------------------------------------------
# 3. PATH (Single Source of Truth)
# -------------------------------------------------
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/.fnm"
  "$GOROOT/bin"
  "$GOPATH/bin"
  "$CARGO_HOME/bin"
  "$ZIG_PATH"
  "$BUN_INSTALL/bin"
  "$PNPM_HOME"
  /usr/local/bin
  /usr/bin
  /bin
)
export PATH
# -------------------------------------------------
# 4. Zinit Plugin Manager
# -------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  print -P "%F{33}Installing Zinit…%f"
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-rust

# -------------------------------------------------
# 5. Zsh Styles (fzf-tab & Completion)
# -------------------------------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# -------------------------------------------------
# 6. Load Plugins
# -------------------------------------------------
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# -------------------------------------------------
# 7. Tool Hooks
# -------------------------------------------------
eval "$(fnm env --use-on-cd)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"

# -------------------------------------------------
# 8. History & Behavior
# -------------------------------------------------
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt appendhistory sharehistory hist_ignore_all_dups
setopt AUTO_CD EXTENDED_GLOB INTERACTIVE_COMMENTS NO_BEEP

# -------------------------------------------------
# 9. Keybindings
# -------------------------------------------------
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '\eb' backward-word
bindkey '\ef' forward-word

# -------------------------------------------------
# 10. Aliases
# -------------------------------------------------
# Navigation
alias cd='z'
alias ..='z ..'
alias ...='z ../..'

# Modern CLI
alias ls='eza --icons --git'
alias ll='eza -alF --icons --git'
alias lt='eza --tree --level=2 --icons'
alias cat='batcat --paging=never'

# Utilities
alias cls='clear'
alias zreload='source ~/.zshrc'
alias update='sudo apt update && sudo apt upgrade -y'
alias cursor='"/mnt/c/Program Files/cursor/resources/app/bin/cursor"'
alias code='cursor'
alias open='explorer.exe .'

# Git
alias gs='git status -sb'
alias ga='git add .'
alias gc='git commit -v'
alias gp='git push'

# -------------------------------------------------
# 11. Functions
# -------------------------------------------------
mkcd() { mkdir -p "$1" && cd "$1"; }
save() { git add .; git commit -m "$1"; git push; }
browse() { /mnt/c/Windows/System32/rundll32.exe url.dll,FileProtocolHandler "$1"; }

_TC() {
  awk -v IGNORECASE=1 '{
    n = split($0, w, " ")
    for (i = 1; i <= n; i++) {
      lw = tolower(w[i]);
      if (i != 1 && i != n && (lw ~ /^(and|or|the|a|an|of|in|on|to|for|with|at|by)$/)) 
        w[i] = lw;
      else w[i] = toupper(substr(w[i],1,1)) tolower(substr(w[i],2));
    }
    for (i = 1; i <= n; i++) printf "%s%s", w[i], (i < n ? " " : "\n")
  }'
}
alias TC='_TC'

flatten() {
  local root="${1:-.}"
  [[ ! -d "$root" ]] && return 1
  find "$root" -type d -mindepth 2 | sort -r | while read -r dir; do
    parent="$(dirname "$dir")"
    [[ "$(ls -A "$parent" | wc -l)" -gt 1 ]] && continue
    mv -i "$dir"/* "$parent"/ 2>/dev/null
    rmdir "$dir" 2>/dev/null
  done
}
alias flat='flatten'

# -------------------------------------------------
# 12. Prompt & Tool Completions
# -------------------------------------------------
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.json)"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
