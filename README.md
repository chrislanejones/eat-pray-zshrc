![Eat Pray ZSH book Cover](EatPrayZSH.jpg)

# My Zsh Configuration (`.zshrc`)

I plan to change this a lot. This file contains my personal Zsh shell configuration, designed to enhance productivity and streamline my command-line experience.

## Key Features:

- **Cleaned and Organized Structure:** The configuration is logically ordered to ensure proper loading of plugins, options, and custom settings, reducing potential conflicts.
- **Zinit Plugin Management:** Leverages [Zinit](https://github.com/zdharma-continuum/zinit) for efficient and robust loading of Zsh plugins.
  - **Plugins Included:**
    - `zsh-syntax-highlighting`: Highlights commands as you type for easier readability and error detection.
    - `zsh-completions`: Enhanced completion definitions for various commands.
    - `zsh-autosuggestions`: Suggests commands based on your history as you type.
    - `fzf-tab`: Integrates `fzf` for a powerful tab-completion experience.
- **Custom Keybindings:** Configured for efficient navigation and editing in the command line, including Ctrl+Arrow and Alt+Arrow word jumps.
- **Productivity Aliases:** A collection of short, convenient aliases for frequently used commands (e.g., `ll`, `gs` for git status, `update` for system updates on Arch).
- **Custom Functions:**
  - `mkcd`: Creates a directory and immediately changes into it.
  - `xrun`: Makes a script executable (`chmod +x`) and then runs it, respecting the script's shebang line and passing all arguments.
- **Enhanced History Management:** Settings to improve command history, preventing duplicates and ensuring better recall.
- **Zsh Options (`setopt`):** Various Zsh options are enabled for improved globbing, directory navigation, and general shell behavior.
- **Oh My Posh Integration:** Configured to load a custom prompt theme using [Oh My Posh](https://ohmyposh.dev/).
- **Bun Integration:** Includes sourcing for Bun's shell completions and setting its necessary environment variables.

## How to Use (or Borrow From):

1.  **Backup your existing `~/.zshrc`** before replacing it: `cp ~/.zshrc ~/.zshrc.bak`
2.  **Save this content** as `~/.zshrc`.
3.  **Ensure Zinit is installed:** The file includes a self-installing block for Zinit, but you may need `git` installed.
4.  **Install external utilities/fonts** if not already present (e.g., `xclip` or `wl-clipboard` for clipboard support, Nerd Fonts for Oh My Posh).
5.  **Restart your terminal sessions** for changes to take effect.

Feel free to adapt parts of this configuration for your own Zsh setup!
