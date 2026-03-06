package packages

import (
	"github.com/carraes/dotfiles/cmd/stp/internal/runner"
)

func Install(groups []string) error {
	var pacmanPkgs []string
	var aurPkgs []string

	for _, name := range groups {
		g := GroupByName(name)
		if g == nil {
			continue
		}
		if g.AUR {
			aurPkgs = append(aurPkgs, g.Packages...)
		} else {
			pacmanPkgs = append(pacmanPkgs, g.Packages...)
		}
	}

	if len(pacmanPkgs) > 0 {
		args := append([]string{"pacman", "-S", "--needed", "--noconfirm"}, pacmanPkgs...)
		if err := runner.RunInteractive("packages", "sudo", args...); err != nil {
			return err
		}
	}

	if len(aurPkgs) > 0 {
		args := append([]string{"-S", "--needed", "--noconfirm"}, aurPkgs...)
		if err := runner.RunInteractive("packages", "yay", args...); err != nil {
			return err
		}
	}

	return nil
}
