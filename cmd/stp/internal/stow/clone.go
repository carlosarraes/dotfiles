package stow

import (
	"github.com/carraes/dotfiles/cmd/stp/internal/runner"
)

func Clone(repoURL, clonePath string) error {
	_, err := runner.Run("clone", "git", "clone", repoURL, clonePath)
	return err
}
