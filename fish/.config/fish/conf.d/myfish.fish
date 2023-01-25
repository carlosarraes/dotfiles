## Alias ##

# QoL
alias ..='cd ..'
alias ...='cd ../..'
alias logout='qdbus org.kde.ksmserver /KSMServer logout 1 3 3'
alias lg=lazygit
alias conky='conky -c ~/.config/conky/mocha.conf'
alias fixkeyboard='setxkbmap -rules evdev -model pc105+inet -layout us -variant intl'

# NeoVim
alias vi=nvim
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
