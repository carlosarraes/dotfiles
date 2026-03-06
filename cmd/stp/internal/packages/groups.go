package packages

type Group struct {
	Name     string
	Packages []string
	AUR      bool // requires yay
}

var Groups = []Group{
	{
		Name:     "Essentials",
		Packages: []string{"git", "stow", "neovim", "zsh"},
	},
	{
		Name:     "Wayland",
		Packages: []string{"wl-clipboard", "grim", "swappy", "slurp", "wf-recorder", "waybar", "hyprpaper", "hyprshot", "dunst", "cliphist"},
	},
	{
		Name:     "Terminal tools",
		Packages: []string{"fastfetch", "vim", "eza", "fd", "bat", "ncdu", "btop", "ripgrep", "lazygit", "zoxide", "fzf", "zip", "unzip", "tmux", "starship", "yt-dlp"},
	},
	{
		Name:     "Node",
		Packages: []string{"nodejs-lts-iron", "npm"},
	},
	{
		Name:     "Manpages",
		Packages: []string{"wikiman", "arch-wiki-docs", "man-pages"},
	},
	{
		Name:     "Apps",
		Packages: []string{"pavucontrol", "peek", "scrcpy", "chromium", "zathura", "zathura-pdf-poppler"},
	},
	{
		Name:     "Fonts",
		Packages: []string{"ttf-firacode-nerd", "ttf-hack-nerd", "ttf-nerd-fonts-symbols", "ttf-nerd-fonts-symbols-common", "ttf-nerd-fonts-symbols-mono", "ttf-font-awesome"},
	},
	{
		Name:     "AUR",
		Packages: []string{"lazysql", "lazydocker"},
		AUR:      true,
	},
}

func GroupNames() []string {
	names := make([]string, len(Groups))
	for i, g := range Groups {
		names[i] = g.Name
	}
	return names
}

func GroupByName(name string) *Group {
	for _, g := range Groups {
		if g.Name == name {
			return &g
		}
	}
	return nil
}
