# Plugin manager
zstyle ':znap:*' repos-dir ~/.zsh-snap/plugins
source ~/.zsh-snap/znap.zsh

# Completions (must be before fzf-tab)
autoload -Uz compinit && compinit

# Plugins
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
eval "$(zoxide init zsh)"
znap source Aloxaf/fzf-tab
znap source zsh-users/zsh-history-substring-search

# History substring search keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

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
alias gcof='git branch --sort=-committerdate | fzf --preview "git log --oneline -10 {}" | xargs git switch'
alias gaf='git ls-files -m -o --exclude-standard | fzf -m --preview "git diff --color=always {}" | xargs git add'
alias glf='git log --format="%h %an (%al): %s" --since="2 weeks ago" | fzf | cut -d" " -f1 | xargs -r git rev-parse | tr -d "\n" | { read h; [ -n "$h" ] && printf "\e]52;c;%s\a" "$(echo -n "$h" | base64)" >/dev/tty && echo "$h copied"; }'
alias fkill='ps -ef | sed 1d | fzf -m | awk "{print \$2}" | xargs kill -9'
# Mini file manager — preview pane, Enter opens file/enters dir, Esc quits
lf() {
  local bat_cmd
  if command -v batcat &>/dev/null; then bat_cmd=batcat
  elif command -v bat &>/dev/null; then bat_cmd=bat
  fi
  local dir="${1:-.}"
  while true; do
    local preview="f='$dir/{}'; if [ -d \"\$f\" ]; then tree -C -L 2 \"\$f\" 2>/dev/null; elif [ -n '$bat_cmd' ]; then $bat_cmd --color=always --style=numbers --line-range=:100 \"\$f\" 2>/dev/null || file \"\$f\"; else head -80 \"\$f\" 2>/dev/null || file \"\$f\"; fi"
    local sel
    sel=$(ls -Ap "$dir" | fzf \
      --preview "$preview" \
      --preview-window=right:50% \
      --header "$dir — Enter: open/cd | Esc: quit") || return
    [[ -z "$sel" ]] && return
    if [[ -d "$dir/$sel" ]]; then
      dir="$dir/$sel"
    else
      ${EDITOR:-nvim} "$dir/$sel"
      return
    fi
  done
}

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

# FZF defaults — gruvbox colors, reverse layout, fd for file finding
export FZF_DEFAULT_OPTS='
  --height=40% --layout=reverse --border
  --color=bg+:#3c3836,bg:#282828,spinner:#fb4934,hl:#928374
  --color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
  --color=fg+:#ebdbb2,marker:#fb4934,prompt:#fabd2f,hl+:#fb4934
'
if command -v fdfind &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
elif command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
if command -v batcat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'batcat --color=always --style=numbers --line-range=:100 {}'"
elif command -v bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:100 {}'"
else
  export FZF_CTRL_T_OPTS="--preview 'head -100 {}'"
fi
export FZF_ALT_C_OPTS="--preview 'tree -C -L 2 {} 2>/dev/null || ls -la {}'"

# Source custom configs if they exist
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Machine-specific config (paths, aliases — not committed)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Secrets (API keys — not committed, chmod 600)
[[ -f ~/.secrets ]] && source ~/.secrets

# Prompt (must be last — starship hooks into precmd)
eval "$(starship init zsh)"
