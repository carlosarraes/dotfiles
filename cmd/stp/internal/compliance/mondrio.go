package compliance

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/carraes/dotfiles/cmd/stp/internal/pathutil"
	"github.com/carraes/dotfiles/cmd/stp/internal/runner"
)

func Run(selected []string) error {
	selectedSet := make(map[string]bool, len(selected))
	for _, t := range selected {
		selectedSet[t] = true
	}

	proofDir := pathutil.ExpandHome("~/mondrio-compliance")
	if err := os.MkdirAll(proofDir, 0755); err != nil {
		return fmt.Errorf("create proof dir: %w", err)
	}

	if selectedSet["Enable UFW firewall"] {
		if err := enableUFW(proofDir); err != nil {
			return err
		}
	}
	if selectedSet["Install & enable osquery"] {
		if err := enableOsquery(proofDir); err != nil {
			return err
		}
	}
	if selectedSet["Enable systemd-timesyncd"] {
		if err := enableTimesyncd(); err != nil {
			return err
		}
	}
	if selectedSet["Verify LUKS encryption"] {
		if err := verifyLUKS(proofDir); err != nil {
			return err
		}
	}

	return nil
}

func TaskLabels() []string {
	return []string{
		"Enable UFW firewall",
		"Install & enable osquery",
		"Enable systemd-timesyncd",
		"Verify LUKS encryption",
	}
}

func enableUFW(proofDir string) error {
	if err := runner.RunInteractive("compliance", "sudo", "pacman", "-S", "--needed", "--noconfirm", "ufw"); err != nil {
		return err
	}
	if err := runner.RunInteractive("compliance", "sudo", "systemctl", "enable", "--now", "ufw"); err != nil {
		return err
	}
	if err := runner.RunInteractive("compliance", "sudo", "ufw", "default", "deny", "incoming"); err != nil {
		return err
	}
	if err := runner.RunInteractive("compliance", "sudo", "ufw", "default", "allow", "outgoing"); err != nil {
		return err
	}
	if err := runner.RunInteractive("compliance", "sudo", "ufw", "enable"); err != nil {
		return err
	}

	out, err := runner.Run("compliance", "sudo", "ufw", "status", "verbose")
	if err != nil {
		return err
	}
	return saveProof(proofDir, "ufw-status.txt", out)
}

func enableOsquery(proofDir string) error {
	if err := runner.RunInteractive("compliance", "sudo", "pacman", "-S", "--needed", "--noconfirm", "osquery"); err != nil {
		return err
	}
	if err := runner.RunInteractive("compliance", "sudo", "systemctl", "enable", "--now", "osqueryd"); err != nil {
		return err
	}

	out, err := runner.Run("compliance", "systemctl", "status", "osqueryd")
	if err != nil {
		return err
	}
	return saveProof(proofDir, "osquery-status.txt", out)
}

func enableTimesyncd() error {
	return runner.RunInteractive("compliance", "sudo", "systemctl", "enable", "--now", "systemd-timesyncd")
}

func verifyLUKS(proofDir string) error {
	out, err := runner.Run("compliance", "lsblk", "-f")
	if err != nil {
		return err
	}

	if err := saveProof(proofDir, "lsblk-encryption.txt", out); err != nil {
		return err
	}

	if !strings.Contains(out, "crypto_LUKS") {
		return fmt.Errorf("LUKS encryption NOT detected — check your disk setup")
	}

	runner.Log("compliance", "LUKS encryption verified")
	return nil
}

func saveProof(dir, filename, content string) error {
	path := filepath.Join(dir, filename)
	if err := os.WriteFile(path, []byte(content), 0644); err != nil {
		return fmt.Errorf("save proof %s: %w", filename, err)
	}
	runner.Log("compliance", "proof saved: %s", path)
	return nil
}
