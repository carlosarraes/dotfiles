package stow

import (
	"github.com/carraes/dotfiles/cmd/stp/internal/pathutil"
	"github.com/carraes/dotfiles/cmd/stp/internal/runner"
)

func Stow(clonePath string, packages []string) error {
	home := pathutil.Home()
	for _, pkg := range packages {
		runner.Log("stow", "stowing %s", pkg)
		_, err := runner.Run("stow", "stow", "-d", clonePath, "-t", home, pkg)
		if err != nil {
			return err
		}
	}
	return nil
}
