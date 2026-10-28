[[ $- != *i* ]] && return

ZSH_THEME="cypher"
#ZSH_THEME="amuse"
#ZSH_THEME="afowler"
#ZSH_THEME="dieter"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

export ZSH="$HOME/.oh-my-zsh"
export ARCHFLAGS="-arch $(uname -m)"
export PATH="$PATH:$HOME/.turso"
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
export SCCACHE_DIR=~/.cache/sccache
export PATH="/usr/lib/ccache/bin:$PATH"
export EDITOR='vim'
export EXA_ICON_SPACING=2

# Default command for fzf (use fd if installed)
export FZF_DEFAULT_COMMAND="fd --type f -H"

# Default options for fzf
export FZF_DEFAULT_OPTS="
--height 70%
--reverse
--border rounded
--ansi
#--color='fg:#abb2bf,bg:#282c34,hl:#98c379'
#--color='fg+:#ffffff,bg+:#2c313a,hl+:#98c379'
#--color='info:#61afef,prompt:#e06c75,pointer:#c678dd'
#--color='marker:#e5c07b,spinner:#56b6c2,header:#56b6c2'
--prompt='   '
--pointer='→'
--marker='✓'
"

# fzf colors per theme: change-theme writes ~/.cache/fzf-theme
# (an FZF_DEFAULT_OPTS export snippet); new shells adopt the theme
# without sed. Official Flexoki:
# https://github.com/kepano/flexoki/tree/main/fzf
[ -f ~/.cache/fzf-theme ] && . ~/.cache/fzf-theme




HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 7
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_AUTO_TITLE="true"
#ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"


autoload -Uz compinit
compinit

plugins=(git zsh-completions fzf  gitignore zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
source ~/.aliases.sh
[ -f ~/.env ] && source ~/.env

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# End of lines configured by zsh-newuser-install
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
if [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


setopt AUTOCD              # change directory just by typing its name
setopt PROMPT_SUBST        # enable command substitution in prompt
#setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED		   # The completion menu takes less space.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD    # Complete from both ends of a word

bindkey "^[." insert-last-word

eval "$(zoxide init zsh)"




# Go binaries (migrate, jet, etc.)
if [[ ":$PATH:" != *":$(go env GOPATH)/bin:"* ]]; then
    export PATH="$PATH:$(go env GOPATH)/bin"
fi

# Globally installed npm packages
if [[ -d "$HOME/.npm-global/bin" ]]; then
    if [[ ":$PATH:" != *":$HOME/.npm-global/bin:"* ]]; then
        export PATH="$HOME/.npm-global/bin:$PATH"
    fi
fi

if [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi


# export BAT_THEME_DARK="gruvbox-light"

#export BAT_THEME_LIGHT="Coldark-Cold"
#
# Local secrets (API keys): outside the repo, in ~/.config/id-86/secrets.sh
[ -f "$HOME/.config/id-86/secrets.sh" ] && . "$HOME/.config/id-86/secrets.sh"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# kilo
export PATH="$HOME/.kilo/bin:$PATH"

# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
