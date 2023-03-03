## Alias ##

# QoL
alias ..='cd ..'
alias ...='cd ../..'
alias logout='qdbus org.kde.ksmserver /KSMServer logout 1 3 3'
alias lzg=lazygit
alias gui=gitui
alias lzd='sudo lazydocker'
alias conky='conky -c ~/.config/conky/mocha.conf'

# Fixes and Installers
alias fixkeyboard='setxkbmap -rules evdev -model pc105+inet -layout us -variant intl'
alias setupnoto='sudo pacman -S $(pacman -Ssq "noto-fonts-*")'

# Docker
alias dclear='docker system prune -af'
alias dls='docker container ls -a'
alias dils='docker image ls -a'
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dclogs='docker-compose logs -f'

# OpenSSH
alias connectplex='ssh plex@192.168.15.45'
alias mapnetwork='sudo nmap -sP 192.168.15.0/24'

# Note
alias screenoff='xrandr --output eDP --off'
alias screenon='xrandr --output eDP --auto'

# NeoVim
alias vi='nvim'
alias vim='nvim'
alias setlint='nvim ~/.config/nvim/lua/plugins/lsp/null-ls.lua'
alias setcopilot='nvim ~/.config/nvim/lua/plugins/copilot.lua'

# ls
alias ls='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias l.='exa -als mod --color=always --group-directories-first -I .git'
alias ld='exa -ls mod --group-directories-first --color=always'
alias lda='exa -als mod --group-directories-first --color=always'

# Go
alias ghtml='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'
