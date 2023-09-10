## Alias ##

# QoL
alias ..='cd ..'
alias ...='cd ../..'
alias logout='qdbus org.kde.ksmserver /KSMServer logout 1 3 3'
alias lzg=lazygit
alias lzd=lazydocker
alias gui=gitui
alias lzd='sudo lazydocker'
alias pm=pnpm
alias px=pnpx
alias conky='conky -c ~/.config/conky/mocha.conf'

# Fixes and Installers
alias fixkeyboard='setxkbmap -rules evdev -model pc105+inet -layout us -variant intl'
alias setupnoto='sudo pacman -S $(pacman -Ssq "noto-fonts-*")'

# Docker
alias dclear='docker system prune -af'
alias dls='docker container ls -a'
alias dils='docker image ls -a'
alias dcup='docker compose up -d'
alias dcdown='docker compose down'
alias dclogs='docker compose logs -f'

# OpenSSH
alias connectplex='ssh plex@192.168.15.45'
alias mapnetwork='sudo nmap -sP 192.168.15.0/24'

# Note
alias screenoff='xrandr --output eDP --off'
alias screenon='xrandr --output eDP --auto'

# NeoVim
alias setlint='nvim ~/.config/nvim/lua/plugins/lsp/null-ls.lua'
alias setcopilot='nvim ~/.config/nvim/lua/plugins/copilot.lua'
alias vim='nvim'
alias rvim='vim'

# ls
alias ls='eza -al --color=always --group-directories-first'
alias la='eza -a --color=always --group-directories-first'
alias ll='eza -l --color=always --group-directories-first'
alias lt='eza -aT --color=always --group-directories-first'
alias l.='eza -als mod --color=always --group-directories-first -I .git'
alias ld='eza -ls mod --group-directories-first --color=always'
alias lda='eza -als mod --group-directories-first --color=always'

# Go
alias coverago='go test ./... -coverprofile=coverage.out && go tool cover -html=coverage.out'
alias nodego='nodemon --exec go run main.go --signal SIGTERM'

# CURL 
alias purl='curl -X POST'
