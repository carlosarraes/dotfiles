function restore
  cp ~/.zshrc ~/.config/nvim/.zshrc
  cp ~/.tmux.conf ~/.config/nvim/.tmux.conf
  cp ~/.config/nvim/polybar/config.ini ~/.config/polybar/
  cp ~/.config/nvim/polybar/launch.sh ~/.config/polybar/
  cp ~/.config/nvim/starship.toml ~/.config/starship.toml
  cp -r ~/.config/nvim/fish ~/.config/fish
  echo (set_color -o brwhite) 'Restore done.'
end
