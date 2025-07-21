# =============================================================================
# 1. ENVIRONMENT & PATH SETUP (HIGHEST PRIORITY)
# =============================================================================
# This section ensures all necessary paths and variables are set before any
# other commands, plugins, or tools are loaded.

# Set default terminal type for better color support
export TERM=xterm-256color

# History settings
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# bun package manager
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# asdf version manager
# Note: asdf.sh handles its own path exporting
. "$HOME/.asdf/asdf.sh"

# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Turso CLI
export PATH="$PATH:/home/carraes/.turso"

# Custom user scripts directory
export PATH="$PATH:/home/carraes/scripts"

# Source environment file from .local/bin (often used by installers)
# This is likely where the `atuin` binary path is added.
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# =============================================================================
# 2. ZSH PLUGINS & COMPLETIONS
# =============================================================================
# Load the completion system first, then source plugins and completion scripts.

autoload -Uz compinit
compinit

# Zsh plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# FZF (Fuzzy Finder)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Completion scripts for other tools
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"   # nvm completion
[ -s "/home/carraes/.bun/_bun" ] && source "/home/carraes/.bun/_bun" # bun completion
[ -f <(ng completion script) ] && source <(ng completion script)     # Angular CLI completion

# =============================================================================
# 3. TOOL INITIALIZATION (EVALS)
# =============================================================================
# With the PATH set and plugins loaded, these tools will initialize correctly.

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

# =============================================================================
# 4. KEYBINDINGS
# =============================================================================

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey '^O' kill-line
bindkey -v

# =============================================================================
# 5. ALIASES
# =============================================================================

# General Navigation & Listing
alias ls='eza -al --color=always --group-directories-first --sort=date'
alias la='eza -a --color=always --group-directories-first'
alias ll='eza -l --color=always --group-directories-first'
alias lt='eza -aT --color=always --group-directories-first'
alias l.='eza -als mod --color=always --group-directories-first -I .git'
alias ld='eza -ls mod --group-directories-first --color=always'
alias lda='eza -als mod --group-directories-first --color=always'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Replacements & Shortcuts
alias cat='bat'
alias ff='fastfetch'
alias h='http'
alias py='python3'

# Lazy Tools
alias lzg='lazygit'
alias lzd='lazydocker'
alias lzs='lazysql'

# Development & AI
alias cyolo="claude --dangerously-skip-permissions"

# Rust
alias cwr="cargo watch -q -c -x 'run -q'"

# Git
alias g='git'
alias gc='git cherry-pick'
alias gfp='git fetch -p && git pull'
alias gcm='git checkout master'
alias gcb='git checkout -b'
alias gcc='git checkout'
alias gs='git switch'
alias gsc='git switch -c'
alias gsd='git switch $(git_develop_branch)'
alias gsm='git switch $(git_main_branch)'
alias gpo='git push origin'
alias gmm='git merge master'

# =============================================================================
# 6. FUNCTIONS
# =============================================================================

# Claude helper
c() {
  if [ $# -eq 0 ]; then
    claude
    return
  fi

  if [[ "$1" == -* ]]; then
    claude "$@"
    return
  fi

  claude -p "$*"
}

# Google search via Gemini
google() {
  gemini -p "Search google for <query>$1</query> and summarize results"
}

# Stream youtube video to mpv
yt() {
  yt-dlp -o - "$1" | mpv -
}

# Fuzzy find file with rg and open in nvim
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

# Fuzzy find content with rg and open in nvim at the specific line
vr() {
  local selection
  selection=$(rg --line-number . | fzf --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' | awk -F ':' '{print "+"$2, $1}')

  if [ -n "$selection" ]; then
    local linecmd=$(echo $selection | cut -d' ' -f1)
    local filename=$(echo $selection | cut -d' ' -f2-)
    nvim "$linecmd" "$filename"
  fi
}

# Create a directory and cd into it
take() {
  mkdir -p "$1"
  cd "$1"
}

# Awk field extractor
field() {
  awk -F "${2:-}" "{ print \$${1:-1} }"
}

# Transfer file to Windows user directory (for WSL)
transfer() {
  if [ -z "$1" ]; then
    echo "Usage: transfer <file>"
    return 1
  fi
  cp $1 /mnt/c/Users/carlos.arraes_zapsig/Transfer/
}

# Rebuild and restart a docker-compose service
rebuild() {
  if [ -z "$1" ]; then
    echo "Usage: rebuild <service-name>"
    return 1
  fi

  local service=$1
  echo "Stopping $service..."
  docker compose -f docker-compose-build-lite.yml stop $service

  echo "Removing $service..."
  docker compose -f docker-compose-build-lite.yml rm -f $service

  echo "Building $service..."
  docker compose -f docker-compose-build-lite.yml build $service

  echo "Starting $service..."
  docker compose -f docker-compose-build-lite.yml up -d $service

  echo "Showing logs..."
  docker compose -f docker-compose-build-lite.yml logs -f $service
}

# Git cherry-pick a range of commits
gcr() {
  if [ -z "$1" ]; then
    echo "Usage: gc <initial_commit_hash> <final_commit_hash>, missing initial_commit_hash"
    return 1
  fi

  if [ -z "$2" ]; then
    echo "Usage: gc <initial_commit_hash> <final_commit_hash>, missing final_commit_hash"
    return 1
  fi

  git rev-list --reverse $1^..$2 | git cherry-pick --stdin
}

# Run Django tests inside docker
rt() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <test1> <test2> ... <testN>"
    exit 1
  fi

  TESTS="$*"

  docker exec -it dev-django-1 bash -c "
  coverage run --source='.' manage.py test $TESTS && coverage combine && coverage xml
  "
}

# Run web tests inside docker
rwt() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <test1> <test2> ... <testN>"
    exit 1
  fi

  TESTS="$*"

  docker exec -it dev-web-1 bash -c "
  npx jest $TESTS --no-coverage
  "
}

# Reload kitty terminal configuration
kitty-reload() {
  kill -SIGUSR1 $(pidof kitty)
}

# Yazi file manager integration
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Git helper to find the development branch name
git_develop_branch() {
  if git show-ref --verify --quiet refs/heads/homolog; then
    echo "homolog"
  elif git show-ref --verify --quiet refs/heads/development; then
    echo "development"
  elif git show-ref --verify --quiet refs/heads/dev; then
    echo "dev"
  elif git show-ref --verify --quiet refs/heads/devel; then
    echo "devel"
  else
    echo "homolog" # Default fallback
  fi
}

# Git helper to find the main branch name
git_main_branch() {
  if git show-ref --verify --quiet refs/heads/main; then
    echo "main"
  else
    echo "master"
  fi
}

# ZapSign API helpers
sign() {
  xh POST "http://localhost:3001/api/v1/signer/$3/sign" Authorization:"Bearer $1" <"$2"
}
signhml() {
  xh POST "https://api.hml.zapsign.com.br/api/v1/signer/$3/sign" Authorization:"Bearer $1" <"$2"
}
