package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/carraes/dotfiles/cmd/stp/internal/compliance"
	"github.com/carraes/dotfiles/cmd/stp/internal/config"
	"github.com/carraes/dotfiles/cmd/stp/internal/packages"
	"github.com/carraes/dotfiles/cmd/stp/internal/pathutil"
	"github.com/carraes/dotfiles/cmd/stp/internal/runner"
	"github.com/carraes/dotfiles/cmd/stp/internal/state"
	"github.com/carraes/dotfiles/cmd/stp/internal/stow"
	"github.com/carraes/dotfiles/cmd/stp/internal/tasks"
	"github.com/carraes/dotfiles/cmd/stp/internal/ui"
)

type InitCmd struct{}

func (c *InitCmd) Run() error {
	if err := runner.InitLog(); err != nil {
		return fmt.Errorf("failed to init log: %w", err)
	}
	defer runner.CloseLog()

	ui.ShowBanner()

	// Step 1: Clone
	ui.Section("Clone Dotfiles")
	repoURL, err := ui.InputWithDefault("Repository URL", "https://github.com/carraes/dotfiles.git")
	if err != nil {
		return err
	}

	defaultClone := filepath.Join(pathutil.Home(), ".dotfiles")
	clonePath, err := ui.InputWithDefault("Clone path", defaultClone)
	if err != nil {
		return err
	}

	if err := stow.Clone(repoURL, clonePath); err != nil {
		ui.ErrorWithLog("Clone failed", err)
		return err
	}
	ui.Success("Repository cloned")

	// Step 2: Select packages
	ui.Section("Select Packages")
	pkgs, err := stow.Discover(clonePath)
	if err != nil {
		return err
	}

	optionToName := make(map[string]string, len(pkgs))
	options := make([]string, len(pkgs))
	for i, p := range pkgs {
		label := fmt.Sprintf("%s — %s", p.Name, p.Description)
		options[i] = label
		optionToName[label] = p.Name
	}

	selected, err := ui.MultiSelect("Select packages to setup", options)
	if err != nil {
		return err
	}

	pkgNames := make([]string, len(selected))
	for i, s := range selected {
		pkgNames[i] = optionToName[s]
	}

	// Step 3: Install system packages
	ui.Section("Install System Packages")
	installPkgs, err := ui.Confirm("Install system packages?", true)
	if err != nil {
		return err
	}

	if installPkgs {
		groupNames := packages.GroupNames()
		selectedGroups, err := ui.MultiSelect("Select package groups", groupNames)
		if err != nil {
			return err
		}
		if len(selectedGroups) > 0 {
			if err := packages.Install(selectedGroups); err != nil {
				ui.ErrorWithLog("Package install failed", err)
			} else {
				ui.Success("Packages installed")
			}
		}
	}

	// Step 4: Per-package config customization
	ui.Section("Configure Packages")
	selectedSet := make(map[string]bool, len(pkgNames))
	for _, name := range pkgNames {
		selectedSet[name] = true
	}

	if selectedSet["git"] {
		if err := configureGit(clonePath); err != nil {
			return err
		}
	}
	if selectedSet["zsh"] {
		if err := configureZsh(clonePath); err != nil {
			return err
		}
	}
	if selectedSet["hypr"] {
		if err := configureHypr(clonePath); err != nil {
			return err
		}
	}
	if selectedSet["ghostty"] {
		if err := configureGhostty(clonePath); err != nil {
			return err
		}
	}

	// Step 5: Stow
	ui.Section("Stow (symlink configs)")
	if err := stow.Stow(clonePath, pkgNames); err != nil {
		ui.ErrorWithLog("Stow failed", err)
		return err
	}
	ui.Success("Configs symlinked")

	// Save state
	if err := state.Save(&state.Config{
		ClonePath: clonePath,
		Packages:  pkgNames,
	}); err != nil {
		ui.Warning(fmt.Sprintf("Failed to save state: %v", err))
	}

	// Step 6: Post-stow tasks
	ui.Section("Post-Setup Tasks")
	taskLabels := tasks.TaskLabels()
	selectedTasks, err := ui.MultiSelect("Select tasks to run", taskLabels)
	if err != nil {
		return err
	}
	if len(selectedTasks) > 0 {
		if err := tasks.RunByLabels(selectedTasks); err != nil {
			ui.ErrorWithLog("Task failed", err)
		} else {
			ui.Success("Tasks completed")
		}
	}

	// Step 7: Mondrio compliance
	ui.Section("Mondrio Compliance")
	runCompliance, err := ui.Confirm("Run Mondrio compliance setup?", false)
	if err != nil {
		return err
	}
	if runCompliance {
		complianceTasks := compliance.TaskLabels()
		selectedCompliance, err := ui.MultiSelect("Select compliance tasks", complianceTasks)
		if err != nil {
			return err
		}
		if len(selectedCompliance) > 0 {
			if err := compliance.Run(selectedCompliance); err != nil {
				ui.ErrorWithLog("Compliance task failed", err)
			} else {
				ui.Success("Compliance setup complete — proof saved to ~/mondrio-compliance/")
			}
		}
	}

	fmt.Println()
	ui.Success("Setup complete!")
	ui.Info(fmt.Sprintf("Log: %s", runner.LogPath()))
	return nil
}

func configureGit(clonePath string) error {
	ui.Info("Configuring git...")
	name, err := ui.InputWithDefault("Git name", "carraes")
	if err != nil {
		return err
	}
	email, err := ui.InputWithDefault("Git email", "carraeshb@gmail.com")
	if err != nil {
		return err
	}
	patches := config.GitconfigPatches(name, email)
	return config.PatchFile(filepath.Join(clonePath, "git", ".gitconfig"), patches)
}

func configureZsh(clonePath string) error {
	ui.Info("Configuring zsh...")

	browser, err := ui.InputWithDefault("Default browser", "chromium")
	if err != nil {
		return err
	}
	envPatches := config.ZshenvPatches(browser)
	if err := config.PatchFile(filepath.Join(clonePath, "zsh", ".zshenv"), envPatches); err != nil {
		return err
	}

	includeWork, err := ui.Confirm("Include work functions? (rebuild, rt, rwt, sign, signhml)", false)
	if err != nil {
		return err
	}
	includeWSL, err := ui.Confirm("Include WSL functions? (transfer)", false)
	if err != nil {
		return err
	}
	rcPatches := config.ZshrcPatches(includeWork, includeWSL)
	return config.PatchFile(filepath.Join(clonePath, "zsh", ".zshrc"), rcPatches)
}

func configureHypr(clonePath string) error {
	ui.Info("Configuring hyprland...")

	layout, err := ui.Select("Window layout", []string{"dwindle", "hy3"})
	if err != nil {
		return err
	}

	hyprPatches := config.HyprlandPatches(layout)
	hyprConf := filepath.Join(clonePath, "hypr", ".config", "hypr", "hyprland.conf")
	if err := config.PatchFile(hyprConf, hyprPatches); err != nil {
		return err
	}

	wallpaper, err := ui.InputWithDefault("Wallpaper path", "~/.config/backgrounds/wallpaper.jpg")
	if err != nil {
		return err
	}
	hyprpaperPath := filepath.Join(clonePath, "hypr", ".config", "hypr", "hyprpaper.conf")
	return os.WriteFile(hyprpaperPath, []byte(config.HyprpaperContent(wallpaper)), 0644)
}

func configureGhostty(clonePath string) error {
	ui.Info("Configuring ghostty...")
	fontSize, err := ui.InputWithDefault("Font size", "11")
	if err != nil {
		return err
	}
	patches := config.GhosttyPatches(fontSize)
	return config.PatchFile(filepath.Join(clonePath, "ghostty", ".config", "ghostty", "config"), patches)
}
