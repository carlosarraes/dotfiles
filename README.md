# Dotfiles

## Essentials

`sudo pacman -S git stow neovim zsh`

## Terminal

`sudo pacman -S fastfetch neovim vim eza fd bat ncdu btop ripgrep lazygit zoxide lf fzf zip unzip tmux starship yt-dlp`

## Wayland

`sudo pacman -S wl-clipboard grim swappy slurp wf-recorder waybar hyprpaper hyprshot dunst cliphist`

## Node

`sudo pacman -S nodejs-lts-iron npm`

## Yay

`pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si`

## Apps

`sudo pacman -S pavucontrol peek scrcpy chromium zathura zathura-pdf-poppler`

## Fonts

```bash
sudo pacman -S ttf-firacode-nerd ttf-hack-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono ttf-font-awesome
sudo pacman -S $(pacman -Ssq noto-fonts)
```

## Zsh Plugins

`chsh -s /bin/zsh`

[zsh autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

[zsh syntax highlight](https://github.com/zsh-users/zsh-syntax-highlighting)

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

## Tmux

`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

## RustUp

`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
