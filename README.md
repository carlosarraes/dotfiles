# Dotfiles

## Installer

Requires `curl`. Supports Arch and Debian-family distributions; the installer handles everything else.

```bash
curl -fsSL https://raw.githubusercontent.com/carlosarraes/dotfiles/main/install.sh | bash
```

| Flag | Description |
| --- | --- |
| `--dry-run` | Print actions without changing the system; interactive prompts still run. |
| `--non-interactive` | Select everything without prompts. |
| `--repo <path>` | Use an existing repository clone. |

Fresh machines get `~/.zshrc` generated from `zsh/.zshrc.template`, keeping only selected tools' blocks. The owner's live `zsh/.zshrc` is untouched by the installer.

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

## Hyprland

You need to install `cpio`.

`sudo pacman -S cpio`

Then you can install hyprland `hy3` plugin with `hyprpm`.

`hyprpm update`

`hyprpm add https://github.com/outfoxxed/hy3`

`hyprpm enable hy3`
