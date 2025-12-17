![Eat Pray ZSH book Cover](EatPrayZSH.webp)

# My Zsh Configuration (`.zshrc`)

I plan to change this a lot. This file contains my personal Zsh shell configuration, designed to enhance productivity and streamline my command-line experience.

**Now available in three editions:**

- **Debian Edition** — `~/.zshrc` (uses `apt`)
- **Arch Edition** — Uses `pacman` and Arch-specific paths
- **Fedora Edition** — Uses `dnf` and Fedora-specific paths

## Key Features:

- **Cleaned and Organized Structure:** The configuration is logically ordered to ensure proper loading of plugins, options, and custom settings, reducing potential conflicts.
- **Zinit Plugin Management:** Leverages [Zinit](https://github.com/zdharma-continuum/zinit) for efficient and robust loading of Zsh plugins.
  - **Plugins Included:**
    - `zsh-syntax-highlighting`: Highlights commands as you type for easier readability and error detection.
    - `zsh-completions`: Enhanced completion definitions for various commands.
    - `zsh-autosuggestions`: Suggests commands based on your history as you type.
    - `fzf-tab`: Integrates `fzf` for a powerful tab-completion experience.
- **Custom Keybindings:** Configured for efficient navigation and editing in the command line, including Ctrl+Arrow and Alt+Arrow word jumps.
- **Productivity Aliases:** A collection of short, convenient aliases for frequently used commands (e.g., `ll`, `gs` for git status, `update` for system updates).
- **Custom Functions:**
  - `mkcd`: Creates a directory and immediately changes into it.
  - `xrun`: Makes a script executable (`chmod +x`) and then runs it, respecting the script's shebang line and passing all arguments.
  - `_TC` / `TC`: Title Case converter - transforms input text to title case via `awk`, properly handling common articles and prepositions (lowercase: `and`, `or`, `the`, `a`, `an`, `of`, `in`, `on`, `to`, `for`, `with`, `at`, `by`).
  - `flatten`: Moves all files from a nested single subdirectory up one level, then prompts to remove the now-empty directory.
  - `tnv`: Creates and immediately opens files in Vim.
- **Enhanced History Management:** Settings to improve command history, preventing duplicates and ensuring better recall.
- **Zsh Options (`setopt`):** Various Zsh options are enabled for improved globbing, directory navigation, and general shell behavior.
- **Oh My Posh Integration:** Configured to load a custom prompt theme using [Oh My Posh](https://ohmyposh.dev/).
- **Bun Integration:** Includes sourcing for Bun's shell completions and setting its necessary environment variables.
- **Multi-Distro Support:** Automatically handles different package managers and tool paths per distro.

## Distro-Specific Differences:

| Feature         | Debian                      | Arch                  | Fedora                  |
| --------------- | --------------------------- | --------------------- | ----------------------- |
| Package Manager | `apt`                       | `pacman`              | `dnf`                   |
| Go Binary Path  | `/usr/local/go/bin`         | `/usr/lib/go/bin`     | `/usr/lib/golang/bin`   |
| Update Alias    | `apt update && apt upgrade` | `pacman -Syu`         | `dnf upgrade --refresh` |
| Zig             | `/usr/local/zig` (optional) | System `/usr/bin/zig` | System `/usr/bin/zig`   |

All three editions are otherwise identical in behavior and structure.

## How to Use (or Borrow From):

1. **Choose your distro:** Select the appropriate edition (Debian, Arch, or Fedora).
2. **Backup your existing `~/.zshrc`** before replacing it: `cp ~/.zshrc ~/.zshrc.bak`
3. **Save the content** as `~/.zshrc`.
4. **Ensure Zinit is installed:** The file includes a self-installing block for Zinit, but you may need `git` installed.
5. **Install external utilities/fonts** if not already present:
   - `fzf` — for fzf-tab completions
   - `oh-my-posh` — for the prompt theme
   - Nerd Fonts — for proper symbol rendering in Oh My Posh
   - `xclip` or `wl-clipboard` — for clipboard support (if needed)
6. **Restart your terminal sessions** for changes to take effect.

## Notes on the `TC` Function:

The Title Case function was refactored from a complex inline `awk` alias into a cleaner function-backed alias:

- **Function name:** `_TC()`
- **Alias:** `TC='_TC'`
- **Usage:** `echo "the lord of the rings" | TC` → `The Lord of the Rings`

This allows the function to be reused within scripts or other shell operations while maintaining the familiar `TC` alias for interactive use.

## Custom Keybindings Reference:

- `Ctrl+P` — Search history backward
- `Ctrl+N` — Search history forward
- `Ctrl+Alt+W` — Kill region
- `Ctrl+Arrow` — Move word forward/backward
- `Alt+Arrow` — Move word forward/backward (alternative binding)
- `Alt+B` — Move backward one word
- `Alt+F` — Move forward one word

Feel free to adapt parts of this configuration for your own Zsh setup!
