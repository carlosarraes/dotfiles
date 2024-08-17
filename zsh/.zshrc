# Init
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Keyboard
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey '^K' kill-line

# Setup
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /opt/homebrew/opt/fzf/shell/completion.zsh

# Alias
alias ls='eza -al --color=always --group-directories-first'
alias la='eza -a --color=always --group-directories-first'
alias ll='eza -l --color=always --group-directories-first'
alias lt='eza -aT --color=always --group-directories-first'
alias l.='eza -als mod --color=always --group-directories-first -I .git'
alias ld='eza -ls mod --group-directories-first --color=always'
alias lda='eza -als mod --group-directories-first --color=always'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='curlie'
alias lzg='lazygit'
alias cat='bat'

# Rust
alias cwr="cargo watch -q -c -x 'run -q'"

# Python
alias py='python3'

# history
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Funcs
v() {
  if [ $# -eq 0 ]; then
    local file
    file=$(rg --files --glob '!node_modules/*' | fzf)
    if [ $? -eq 0 ]; then
      nvim "$file"
    fi
  else
    nvim "$@"
  fi
}

vr() {
  local selection
  selection=$(rg --line-number . | fzf --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' | awk -F ':' '{print "+"$2, $1}')

  if [ -n "$selection" ]; then
    local linecmd=$(echo $selection | cut -d' ' -f1)
    local filename=$(echo $selection | cut -d' ' -f2-)
    nvim "$linecmd" "$filename"
  fi
}

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

take() {
  mkdir -p "$1"
  cd "$1"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# bun completions
[ -s "/Users/carraes/.bun/_bun" ] && source "/Users/carraes/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
