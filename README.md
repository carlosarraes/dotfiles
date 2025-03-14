# Dotfiles

## Essentials

`sudo pacman -S git stow neovim zsh`

## Wayland

`sudo pacman -S wl-clipboard grim swappy slurp wf-recorder waybar hyprpaper hyprshot dunst cliphist`

## Terminal

`sudo pacman -S fastfetch vim eza fd bat ncdu btop ripgrep lazygit zoxide yazi fzf zip unzip tmux starship yt-dlp`

## Node

`sudo pacman -S nodejs-lts-iron npm`

## Manpages

`sudo pacman -S wikiman arch-wiki-docs man-pages`

## Yay

`pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si`

## Apps

`sudo pacman -S pavucontrol peek scrcpy chromium zathura zathura-pdf-poppler`

## Fonts

```bash
sudo pacman -S ttf-firacode-nerd ttf-hack-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono ttf-font-awesome
sudo pacman -S $(pacman -Ssq noto-fonts)
```

## Yay - Pkgs

`yay -S lazysql lazydocker`

## Zsh Plugins

`chsh -s /bin/zsh`

[zsh autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

`git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions`

[zsh syntax highlight](https://github.com/zsh-users/zsh-syntax-highlighting)

`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting`

## Tmux

`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

## RustUp

`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
