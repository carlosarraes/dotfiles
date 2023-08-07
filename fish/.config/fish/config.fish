set fish_greeting
set TERM "xterm-256color"

set -x EDITOR nvim

function theme
  set -U fish_color_normal cdd6f4
  set -U fish_color_command 89b4fa
  set -U fish_color_param f2cdcd
  set -U fish_color_keyword f38ba8
  set -U fish_color_quote a6e3a1
  set -U fish_color_redirection f5c2e7
  set -U fish_color_end fab387
  set -U fish_color_comment 7f849c
  set -U fish_color_error f38ba8
  set -U fish_color_gray 6c7086
  set -U fish_color_selection --background=313244
  set -U fish_color_search_match --background=313244
  set -U fish_color_operator f5c2e7
  set -U fish_color_escape eba0ac
  set -U fish_color_autosuggestion 6c7086
  set -U fish_color_cancel f38ba8
  set -U fish_color_cwd f9e2af
  set -U fish_color_user 94e2d5
  set -U fish_color_host 89b4fa
  set -U fish_color_host_remote a6e3a1
  set -U fish_color_status f38ba8
  set -U fish_pager_color_progress 6c7086
  set -U fish_pager_color_prefix f5c2e7
  set -U fish_pager_color_completion cdd6f4
  set -U fish_pager_color_description 6c7086
end

# Envs
set -x OPENAI_API_KEY (cat ~/.config/fish/chatkey.txt)

# Sources
alias rename_files "~/.config/fish/functions/rename_files.fish"
starship init fish | source
zoxide init fish | source

# Existing PATH configuration
set PATH $HOME/.cargo/bin $PATH

# Add d2 to PATH
set PATH $HOME/.local/bin $PATH

# Ruby
set -gx PATH $HOME/.local/share/gem/ruby/3.0.0/bin $PATH

# tmuxifier
source ~/.tmuxifier/init.fish

# pnpm
set -gx PNPM_HOME "/home/seti/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/carraes/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/home/carraes/Downloads/google-cloud-sdk/path.fish.inc'; end

# pnpm
set -gx PNPM_HOME "/home/seti/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# workspace
set -x SC_MAKE_FSPATH ~/ws/sc-make/assets/.sc-make/make
set -x GIT_USER_NAME carlosarraes
set -x GIT_USER_EMAIL carraeshb@gmail.com
set -x GIT_USER_SSH_PUB ~/.ssh/carraes_github.pub
set -Ua fish_user_paths (go env GOPATH)/bin $fish_user_paths

# asdf
source ~/.asdf/asdf.fish

# cuda
set -x PATH /opt/cuda/bin $PATH

# flyctl
set -x FLYCTL_INSTALL "/home/carraes/.fly"
set -x PATH $FLYCTL_INSTALL/bin $PATH

# Vi mode
fish_vi_key_bindings

# For Thunar:
# alacritty --command fish -C "cd %f"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
