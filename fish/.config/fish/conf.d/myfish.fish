## Alias ##

# QoL
alias ..='cd ..'
alias ...='cd ../..'
alias logout='qdbus org.kde.ksmserver /KSMServer logout 1 3 3'
alias lg=lazygit
alias conky='conky -c ~/.config/conky/mocha.conf'
alias fixkeyboard='setxkbmap -rules evdev -model pc105+inet -layout us -variant intl'

# Docker
alias cleardocker='docker system prune -af'
alias dockerls='docker container ls -a'
alias dockerils='docker image ls -a'
alias cdockerup='docker-compose up -d'
alias cdockerdown='docker-compose down'
alias cdockerlogs='docker-compose logs -f'

# Note
alias screenoff='xrandr --output eDP --off'
alias screenon='xrandr --output eDP --auto'

# NeoVim
alias vi=vim
alias vim=nvim
alias setlint='nvim ~/.config/nvim/lua/plugins/lsp/null-ls.lua'

# ls
alias ls='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias l.='exa -als mod --color=always --group-directories-first -I .git'
alias ld='exa -als mod --group-directories-first --color=always'

# Go
alias ghtml='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'
