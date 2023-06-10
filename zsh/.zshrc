export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Copy to Tmux
# echo 'source ~/.bashrc' >> ~/.bash_profile
plugins=(git)

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls="exa -al --color=always --group-directories-first"
alias ctt="echo 'source ~/.bashrc' >> ~/.bash_profile"
alias bak="cp ~/.zshrc ~/.config/nvim/.zshrc && cp ~/.tmux.conf ~/.config/nvim/.tmux.conf && cp ~/.config/polybar/config.ini ~/.config/nvim/polybar/ && cp ~/.config/polybar/launch.sh ~/.config/nvim/polybar/"
alias prettiercp="cp ~/.config/nvim/.prettierrc ."
alias aurtoruncp="cp ~/.config/nvim/lua/scripts/autorun.lua ."
alias lzg='lazygit'
alias lzd='lazydocker'
alias ..="cd .."
alias ...="cd ../.."

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
PROMPT='%{$fg[yellow]%}[%*] '$PROMPT

# Need to install fzf (from repo) and fd (pacman)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export PATH=/home/seti/.cargo/bin:$PATH
export PATH=/home/seti/.config/bin:$PATH

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

export PATH="$HOME/.gobrew/current/bin:$HOME/.gobrew/bin:$PATH"
export GOROOT="$HOME/.gobrew/current/go"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
