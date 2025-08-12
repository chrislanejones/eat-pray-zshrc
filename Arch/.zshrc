# -----------------------------------------------------------------------------
# Zsh Configuration File (~/.zshrc)
# Cleaned, Consolidated, and Expanded for Enhanced Productivity
# -----------------------------------------------------------------------------

# 1. Environment Variables and Path Setup
# -----------------------------------------------------------------------------
# Bun Installation Path
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# 2. Zinit Plugin Manager Setup
# -----------------------------------------------------------------------------
# Set the directory for Zinit and its plugins.
# Using XDG_DATA_HOME for better adherence to XDG Base Directory Specification.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it's not already present.
# This block is from Zinit's installer and is the ONLY one for Zinit core.
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$(dirname "$ZINIT_HOME")" && command chmod g-rwX "$(dirname "$ZINIT_HOME")"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Source/Load Zinit
source "$ZINIT_HOME/zinit.zsh"

# Autoload Zinit's own completions
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Zinit annexes (important for Zinit's functionality)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# 3. Zsh Options and History Configuration
# -----------------------------------------------------------------------------
# History Settings
HISTSIZE=5000       # Maximum number of history entries
HISTFILE=~/.zsh_history # Path to the history file
SAVEHIST=$HISTSIZE  # Number of history entries to save
HISTDUP=erase       # Erase older duplicates when adding new ones

# History Options
setopt appendhistory      # Append history lines, don't overwrite
setopt sharehistory       # Share history among all sessions
setopt hist_ignore_space  # Don't save commands starting with a space
setopt hist_ignore_all_dups # Ignore all duplicate commands (more aggressive)
setopt hist_save_no_dups  # Don't save duplicates
setopt hist_ignore_dups   # Don't re-add duplicates if they already exist

# General Zsh Options
setopt NO_BEEP # Disable the bell sound

# Input/Output
setopt AUTO_CD            # If a command is a directory name, change to it
setopt CHASE_LINKS        # Resolve symbolic links when changing directories
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates onto the directory stack
setopt PUSHD_SILENT         # Don't print the directory stack on pushd/popd
setopt CDABLE_VARS          # If variable is a directory, can cd to it (e.g., cd $HOME)

# Globbing
setopt EXTENDED_GLOB        # Enable extended globbing (e.g., ~(foo|bar))
setopt KSH_GLOB             # Enable ksh-like globbing (e.g., *(.) for regular files)

# Interactivity
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell (lines starting with #)

# 4. Completion System Setup (fpath, zstyle, compinit)
# This section must come BEFORE loading any plugins that affect completions.
# -----------------------------------------------------------------------------
# Add community completions to fpath
fpath=(/usr/share/zsh-completions $fpath)

# Completion Styling and Options
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z} m:{a-z}={A-Z}' # Case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Apply LS_COLORS to completion listings
zstyle ':completion:*' menu select # Use interactive menu for completions
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' # fzf-tab previews for 'cd'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath' # fzf-tab previews for zoxide

# Initialize the completion system
autoload -Uz compinit && compinit

# 5. Zinit Plugin Loading
# These should be loaded AFTER compinit if they affect completions or keybindings.
# -----------------------------------------------------------------------------
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit cdreplay -q
zinit snippet https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker

# zinit cdreplay (related to history and directory navigation)
zinit cdreplay -q

# 6. Keybindings
# Set these AFTER all plugins have loaded to ensure your bindings take precedence.
# -----------------------------------------------------------------------------
bindkey -e # Set Zsh to Emacs-style key bindings (default)

# Custom history navigation
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Kill region (Alt+w)
bindkey '^[w' kill-region

# Word movement keybindings
bindkey '^[[1;5D' backward-word # Ctrl+Left Arrow
bindkey '^[[1;5C' forward-word  # Ctrl+Right Arrow
bindkey '\e[1;3D' backward-word # Alt+Left Arrow
bindkey '\e[1;3C' forward-word  # Alt+Right Arrow
bindkey '\eb' backward-word     # Alt+b (Emacs-style)
bindkey '\ef' forward-word      # Alt+f (Emacs-style)

# Home and End keybindings
bindkey '^[[H' beginning-of-line # Home key
bindkey '^[[F' end-of-line       # End key

# 7. Aliases (Productivity and Convenience)
# -----------------------------------------------------------------------------
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

# Git Aliases
alias gs='git status -sb'
alias ga='git add .'
alias gc='git commit -v'
alias gd='git diff'
alias gl='git log --oneline --decorate --graph'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gbr='git branch'

# System Update
alias update='sudo pacman -Syu'
alias zreload='source ~/.zshrc'
alias ezsh='touch ~/.zshrc && vim ~/.zshrc'

# 8. Functions
# -----------------------------------------------------------------------------
mkcd() {
    mkdir -p "$1" && cd "$1"
}

xrun() {
    if [ -f "$1" ]; then
        chmod +x "$1" && "$@"
    else
        echo "xrun: Error: File '$1' not found or is not a regular file."
        return 1
    fi
}

tnv() {
    if [ -z "$1" ]; then
        echo "Usage: tnv <file1> [file2...]"
        return 1
    fi
    touch "$@" && vim "$1"
}

# 9. Prompt (Oh My Posh)
# -----------------------------------------------------------------------------
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.yaml)"

# 10. Tool-Specific Sourcing
# -----------------------------------------------------------------------------
[ -s "/home/clj/.bun/_bun" ] && source "/home/clj/.bun/_bun"