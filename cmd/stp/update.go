package main

import (
	"fmt"
	"strings"

	"github.com/carraes/dotfiles/cmd/stp/internal/runner"
	"github.com/carraes/dotfiles/cmd/stp/internal/state"
	"github.com/carraes/dotfiles/cmd/stp/internal/stow"
	"github.com/carraes/dotfiles/cmd/stp/internal/ui"
)

type UpdateCmd struct{}

func (c *UpdateCmd) Run() error {
	if err := runner.InitLog(); err != nil {
		return fmt.Errorf("failed to init log: %w", err)
	}
	defer runner.CloseLog()

	cfg, err := state.Load()
	if err != nil {
		return fmt.Errorf("no stp config found — run 'stp init' first: %w", err)
	}

	ui.Info(fmt.Sprintf("Updating dotfiles at %s", cfg.ClonePath))

	// Check if working tree is dirty
	out, err := runner.Run("update", "git", "-C", cfg.ClonePath, "status", "--porcelain")
	if err != nil {
		return fmt.Errorf("not a valid git repo at %s: %w", cfg.ClonePath, err)
	}
	dirty := strings.TrimSpace(out) != ""
	stashed := false

	if dirty {
		ui.Warning("Working tree has changes, stashing...")
		if _, err := runner.Run("update", "git", "-C", cfg.ClonePath, "stash"); err != nil {
			return fmt.Errorf("git stash failed: %w", err)
		}
		stashed = true
	}

	// Pull
	if _, err := runner.Run("update", "git", "-C", cfg.ClonePath, "pull", "--rebase"); err != nil {
		if stashed {
			ui.Error("Pull failed — your changes are still stashed. Run 'git stash pop' in the repo to recover them.")
		}
		return fmt.Errorf("git pull failed: %w", err)
	}

	// Pop stash
	if stashed {
		if _, err := runner.Run("update", "git", "-C", cfg.ClonePath, "stash", "pop"); err != nil {
			ui.Error("Stash pop failed — conflict detected!")
			ui.Info(fmt.Sprintf("Resolve manually: cd %s && git stash pop", cfg.ClonePath))
			return fmt.Errorf("stash pop conflict: %w", err)
		}
	}

	// Re-stow to pick up any new packages or fix broken symlinks
	if err := stow.Stow(cfg.ClonePath, cfg.Packages); err != nil {
		ui.ErrorWithLog("Re-stow failed", err)
		return err
	}

	ui.Success("Dotfiles updated — symlinked configs are live")
	return nil
}
