# Package catalog: name|arch|debian|group. "-" means unavailable on that distro.
CATALOG=(
  "git|git|git|essentials"
  "stow|stow|stow|essentials"
  "neovim|neovim|neovim|essentials"
  "zsh|zsh|zsh|essentials"

  "fastfetch|fastfetch|-|terminal"
  "vim|vim|vim|terminal"
  "eza|eza|-|terminal"
  "fd|fd|fd-find|terminal"
  "bat|bat|bat|terminal"
  "ncdu|ncdu|ncdu|terminal"
  "btop|btop|btop|terminal"
  "ripgrep|ripgrep|ripgrep|terminal"
  "lazygit|lazygit|-|terminal"
  "zoxide|zoxide|zoxide|terminal"
  "yazi|yazi|-|terminal"
  "fzf|fzf|fzf|terminal"
  "zip|zip|zip|terminal"
  "unzip|unzip|unzip|terminal"
  "tmux|tmux|tmux|terminal"
  "starship|starship|-|terminal"
  "yt-dlp|yt-dlp|yt-dlp|terminal"

  "wl-clipboard|wl-clipboard|wl-clipboard|wayland"
  "grim|grim|grim|wayland"
  "swappy|swappy|-|wayland"
  "slurp|slurp|slurp|wayland"
  "wf-recorder|wf-recorder|-|wayland"
  "waybar|waybar|waybar|wayland"
  "hyprpaper|hyprpaper|-|wayland"
  "hyprshot|hyprshot|-|wayland"
  "dunst|dunst|dunst|wayland"
  "cliphist|cliphist|cliphist|wayland"

  "nerd-fonts|ttf-firacode-nerd ttf-hack-nerd ttf-nerd-fonts-symbols-mono|fonts-firacode|fonts"
  "noto-fonts|noto-fonts|fonts-noto-core|fonts"

  "node-lts|nodejs-lts-iron|nodejs npm|node"

  "wikiman|wikiman|-|manpages"
  "man-pages|man-pages|manpages-dev|manpages"

  "pavucontrol|pavucontrol|pavucontrol|apps"
  "scrcpy|scrcpy|scrcpy|apps"
  "chromium|chromium|chromium|apps"
  "zathura|zathura|zathura|apps"
  "zathura-pdf|zathura-pdf-poppler|-|apps"
)

catalog_groups() {
  printf '%s\n' "${CATALOG[*]##*|}" | tr ' ' '\n' | sort -u
}

catalog_packages() {
  local group=$1 entry distro_field arch deb grp
  for entry in "${CATALOG[@]}"; do
    IFS='|' read -r _ arch deb grp <<<"$entry"
    [ "$grp" = "$group" ] || continue
    case "$DISTRO" in
      arch)   distro_field=$arch ;;
      debian) distro_field=$deb ;;
      *) continue ;;
    esac
    [ "$distro_field" = "-" ] && continue
    printf '%s:%s\n' "${entry%%|*}" "$distro_field"
  done
}

# Usage: detect_distro [os_release_file]  (defaults to /etc/os-release)
# Sets DISTRO (arch|debian) and PKG (pacman|apt); dies on anything else.
detect_distro() {
  local os_release=${1:-/etc/os-release}
  [ -r "$os_release" ] || die "$os_release not found; unsupported system"
  # shellcheck disable=SC1090
  . "$os_release"
  case "${ID:-}${ID_LIKE:-}" in
    *arch*)   DISTRO=arch;   PKG=pacman ;;
    *debian*) DISTRO=debian; PKG=apt    ;;
    *) die "unsupported distro: ${ID:-unknown} (only Arch and Debian families are supported)" ;;
  esac
}
