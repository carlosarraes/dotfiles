package tasks

import (
	"os"
	"os/exec"

	"github.com/carraes/dotfiles/cmd/stp/internal/pathutil"
	"github.com/carraes/dotfiles/cmd/stp/internal/runner"
)

type Task struct {
	Name    string
	Label   string
	RunFunc func() error
}

var tasks = []Task{
	{Name: "zsh_plugins", Label: "Install zsh plugins (autosuggestions + syntax-highlighting)", RunFunc: installZshPlugins},
	{Name: "set_zsh_default", Label: "Set zsh as default shell", RunFunc: setZshDefault},
	{Name: "tpm", Label: "Install TPM (tmux plugin manager)", RunFunc: installTPM},
	{Name: "rustup", Label: "Install Rust via rustup", RunFunc: installRust},
	{Name: "yay", Label: "Install yay (AUR helper)", RunFunc: installYay},
	{Name: "hy3", Label: "Install hy3 plugin (hyprpm)", RunFunc: installHy3},
	{Name: "hypridle", Label: "Setup hypridle (5min screen lock)", RunFunc: setupHypridle},
}

func TaskLabels() []string {
	labels := make([]string, len(tasks))
	for i, t := range tasks {
		labels[i] = t.Label
	}
	return labels
}

func RunByLabels(labels []string) error {
	labelSet := make(map[string]bool, len(labels))
	for _, l := range labels {
		labelSet[l] = true
	}
	for _, t := range tasks {
		if labelSet[t.Label] {
			runner.Log("tasks", "running: %s", t.Label)
			if err := t.RunFunc(); err != nil {
				return err
			}
		}
	}
	return nil
}

func installZshPlugins() error {
	if err := cloneIfMissing("https://github.com/zsh-users/zsh-autosuggestions", pathutil.ExpandHome("~/.zsh/zsh-autosuggestions")); err != nil {
		return err
	}
	return cloneIfMissing("https://github.com/zsh-users/zsh-syntax-highlighting.git", pathutil.ExpandHome("~/.zsh/zsh-syntax-highlighting"))
}

func cloneIfMissing(repo, dest string) error {
	if _, err := os.Stat(dest); err == nil {
		runner.Log("tasks", "%s already exists, skipping clone", dest)
		return nil
	}
	_, err := runner.Run("tasks", "git", "clone", repo, dest)
	return err
}

func setZshDefault() error {
	return runner.RunInteractive("tasks", "chsh", "-s", "/bin/zsh")
}

func installTPM() error {
	_, err := runner.Run("tasks", "git", "clone", "https://github.com/tmux-plugins/tpm", pathutil.ExpandHome("~/.tmux/plugins/tpm"))
	return err
}

func installRust() error {
	return runner.RunInteractive("tasks", "sh", "-c", "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh")
}

func installYay() error {
	if _, err := exec.LookPath("yay"); err == nil {
		runner.Log("tasks", "yay already installed, skipping")
		return nil
	}
	os.RemoveAll("/tmp/yay")
	return runner.RunInteractive("tasks", "sh", "-c", "sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si --noconfirm")
}

func installHy3() error {
	if err := runner.RunInteractive("tasks", "sudo", "pacman", "-S", "--needed", "--noconfirm", "cpio"); err != nil {
		return err
	}
	if _, err := runner.Run("tasks", "hyprpm", "update"); err != nil {
		return err
	}
	if _, err := runner.Run("tasks", "hyprpm", "add", "https://github.com/outfoxxed/hy3"); err != nil {
		return err
	}
	_, err := runner.Run("tasks", "hyprpm", "enable", "hy3")
	return err
}

func setupHypridle() error {
	return runner.RunInteractive("tasks", "sudo", "pacman", "-S", "--needed", "--noconfirm", "hyprlock", "hypridle")
}
