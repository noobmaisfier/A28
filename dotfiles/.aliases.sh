#!/bin/bash

# ==============================================================================
#  Alias and Useful Function Configuration
# ==============================================================================

# ------------------------------------------------------------------------------
#  General Aliases
# ------------------------------------------------------------------------------

# Source the TGPT aliases from a separate file
[ -f ~/.tgpt_aliases.sh ] && source ~/.tgpt_aliases.sh

# Create a file, including parent directories if needed
alias mkfile='f() { mkdir -p "$(dirname "$1")" && touch "$1"; }; f'

# Commented vi/nvim aliases (examples for different terminals)
# alias vi="alacritty --config-file ~/.config/alacritty-nvim/alacritty.toml -e nvim &"
# alias vi="foot -c $HOME/.config/foot-nvim.ini -e nvim&"

# ------------------------------------------------------------------------------
#  System Service Management
# ------------------------------------------------------------------------------

alias start='sudo systemctl start '
alias stop='sudo systemctl stop '
alias restart='sudo systemctl restart '
alias enable='sudo systemctl enable ' 
alias disable='sudo systemctl disable ' 



# ------------------------------------------------------------------------------
#  Download
# ------------------------------------------------------------------------------

yt-dlp() {
  command yt-dlp \
    --downloader aria2c \
    --external-downloader-args "aria2c:-x3 -s3 -k1M" \
    --download-archive "$HOME/.cache/yt-dlp/archive.txt" \
    --format "bestvideo[height<=1080]+bestaudio/best" \
    --merge-output-format mkv \
    --embed-chapters \
    --embed-subs \
    --embed-thumbnail \
    -o "$HOME/Videos/yt-dlp/%(uploader)s - %(playlist)s/%(title)s.%(ext)s" \
    "$@"
}

# ------------------------------------------------------------------------------
#  File Viewing (with bat)
# ------------------------------------------------------------------------------

# Use bat for file display (if installed)
alias cat="bat --pager=builtin"

# ------------------------------------------------------------------------------
#  Navigation
# ------------------------------------------------------------------------------

# Use z for quick navigation (if installed)
alias cd='z'

# Basic navigation shortcuts (use the cd=z alias)
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias -- -='cd -' # Return to the previous directory

# Improved file listing aliases with eza
alias l='eza --group-directories-first'
alias ls='eza -l  --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza --tree --level=2'
alias ltd='eza --tree --only-dirs'
alias ld='eza -l --group-directories-first --only-dirs'
alias lad='eza -l --group-directories-first --only-dirs -a'
alias lf='eza -l --icons --group-directories-first --only-files'
alias laf='eza -l --icons --only-files -a'
alias lz='exa --tree --level=3 --icons | fzf'

# ------------------------------------------------------------------------------
#  Common Shortcuts
# ------------------------------------------------------------------------------

alias c='clear' # Clear the screen
alias h='history' # Show the history
alias m='mkdir -p' # Create a directory (and parents if needed)
alias o='xdg-open' # Open a file with the default application

# ------------------------------------------------------------------------------
#  File Management (Interactive and Trash)
# ------------------------------------------------------------------------------

# Interactive safety commands (ask for confirmation before overwriting)
#alias cp='cp -i'
#alias mv='mv -i'
alias ln='ln -i'

# Use trash-cli to delete files (if installed)
alias rm='trash-put -v'
alias empty-trash='trash-empty'

# ------------------------------------------------------------------------------
#  Search
# ------------------------------------------------------------------------------

# Use grep with automatic coloring
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


# ------------------------------------------------------------------------------
#  Network
# ------------------------------------------------------------------------------

alias ping='ping -c 5' # Ping with 5 packets by default
alias web='python3 -m http.server' # Simple web server in the current directory


# ------------------------------------------------------------------------------
#  Package Manager (Pacman)
# ------------------------------------------------------------------------------

alias pacup='sudo pacman -Syyu --noconfirm"' # Update the system
alias pacout='sudo pacman -Rns' # Remove a package and its unused dependencies
alias pacin='sudo pacman -Sy --needed ' # Install a package (does not reinstall if already present)

# ------------------------------------------------------------------------------
#  Enhanced Git
# ------------------------------------------------------------------------------

alias gs='git status -sb' # Short status with branch
alias ga='git add' # Add files to the index
alias gc='git commit -m ' # Commit with a message
alias gp='git push' # Push the changes and show an emoticon
alias gd='git diff --color-words' # Show differences with word-level coloring


# Function to show the RAM used by an application
# Function to show the RAM used by an application
memtake() {
    local application="$1"
    local total_ram=0

    if [ -z "$application" ]; then
        echo "Usage: memtake <application_name>"
        return 1
    fi

    # Get the processes matching the application
    # Uses pgrep to find the PIDs, then ps to get the RSS memory
    for pid in $(pgrep -f "$application"); do
        # ps -p <pid> -o rss shows the resident memory in KiB
        local rss=$(ps -p "$pid" -o rss= 2>/dev/null) # 'rss=' removes the header
        if [ -n "$rss" ]; then # Check that rss is not empty
            total_ram=$((total_ram + rss))
        fi
    done

    if [ "$total_ram" -eq 0 ]; then
        echo "No process found for '$application' or unable to get memory information."
        return 1
    fi

    # Convert the total sum to megabytes
    # Uses printf to format the floating-point output
    local total_ram_mb=$(printf "%.2f" $(bc -l <<<"scale=2; $total_ram / 1024"))

    echo "The total RAM used by '$application' is $total_ram_mb MB."
}
