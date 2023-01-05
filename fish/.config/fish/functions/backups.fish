function backups
  echo 'source ~/.bashrc' >> ~/.bash_profile # source bashrc
  cp -r ~/.config/nvim/ ~/dotfiles/nvim/.config/ # nvim backup
  cp -r ~/.config/fish/ ~/dotfiles/fish/.config/ # fish backup
  cp -r ~/.config/polybar/ ~/dotfiles/polybar/.config/ # polybar backup
  cp -r ~/.config/rofi/ ~/dotfiles/rofi/.config/ # rofi backup
  cp ~/.zshrc ~/dotfiles/zsh/ # zsh backup
  cp ~/.tmux.conf ~/dotfiles/tmux/ # tmux backup
  cp ~/.config/starship.toml ~/dotfiles/starship/.config/ # starship backup
  echo (set_color -o brwhite) 'Backup done.'
end
