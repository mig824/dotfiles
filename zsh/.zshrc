# Plugin manager
zstyle ':znap:*' repos-dir ~/.zsh-snap/plugins
source ~/.zsh-snap/znap.zsh

# Plugins
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source rupa/z

# Completions
autoload -Uz compinit && compinit

# Preferred editor
export EDITOR='nvim'

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS

# Alias definitions
alias ll='ls -lah'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -v'
alias gco='git checkout'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gsi='git switch $(git branch | fzf)'
alias ..='cd ..'
alias ...='cd ../..'

# PATH additions
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.npm-global/bin"

# Enable colors
autoload -U colors && colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# FZF integration (if installed via Homebrew or otherwise)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source custom configs if they exist
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Machine-specific config (paths, aliases — not committed)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Secrets (API keys — not committed, chmod 600)
[[ -f ~/.secrets ]] && source ~/.secrets

# Prompt (must be last — starship hooks into precmd)
eval "$(starship init zsh)"
