# 0. Only run in interactive zsh shells
[[ -z "$ZSH_VERSION" ]] && return
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
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.toml)"

# 10. Tool-specific completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# 11. Go language: ensure unique PATH entries and prepend Go bins
typeset -U path
path=(
  /usr/local/go/bin
  $HOME/go/bin
  $path[@]
)
export PATH="${path[*]}"