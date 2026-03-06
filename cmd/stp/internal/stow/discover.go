package stow

import (
	"os"
	"sort"
)

var allowed = map[string]string{
	"dunst":    "notification daemon",
	"ghostty":  "terminal emulator",
	"git":      "git config + delta pager",
	"hypr":     "hyprland WM + lock + wallpaper",
	"kitty":    "terminal emulator",
	"nvim":     "neovim + LSPs + plugins",
	"starship": "shell prompt",
	"tmux":     "terminal multiplexer",
	"waybar":   "status bar",
	"wofi":     "application launcher",
	"zsh":      "shell + aliases + functions",
}

type Package struct {
	Name        string
	Description string
}

func Discover(clonePath string) ([]Package, error) {
	entries, err := os.ReadDir(clonePath)
	if err != nil {
		return nil, err
	}

	var pkgs []Package
	for _, e := range entries {
		if !e.IsDir() {
			continue
		}
		desc, ok := allowed[e.Name()]
		if !ok {
			continue
		}
		pkgs = append(pkgs, Package{Name: e.Name(), Description: desc})
	}

	sort.Slice(pkgs, func(i, j int) bool {
		return pkgs[i].Name < pkgs[j].Name
	})
	return pkgs, nil
}
