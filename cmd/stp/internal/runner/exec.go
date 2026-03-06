package runner

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"github.com/carraes/dotfiles/cmd/stp/internal/pathutil"
)

var logFile *os.File

func InitLog() error {
	dir := pathutil.ConfigDir()
	if err := os.MkdirAll(dir, 0755); err != nil {
		return err
	}
	path := filepath.Join(dir, "stp.log")
	var err error
	logFile, err = os.OpenFile(path, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		return err
	}
	writeLog("=== stp started at %s ===", time.Now().Format(time.RFC3339))
	return nil
}

func CloseLog() {
	if logFile != nil {
		logFile.Close()
	}
}

func LogPath() string {
	return filepath.Join(pathutil.ConfigDir(), "stp.log")
}

func writeLog(format string, args ...any) {
	if logFile == nil {
		return
	}
	ts := time.Now().Format("15:04:05")
	msg := fmt.Sprintf(format, args...)
	fmt.Fprintf(logFile, "[%s] %s\n", ts, msg)
}

// Run executes a command, logs it, and returns combined output.
func Run(step, name string, args ...string) (string, error) {
	cmdStr := name + " " + strings.Join(args, " ")
	writeLog("[%s] exec: %s", step, cmdStr)

	cmd := exec.Command(name, args...)
	out, err := cmd.CombinedOutput()
	output := strings.TrimSpace(string(out))

	if err != nil {
		writeLog("[%s] FAIL (exit %v): %s", step, err, output)
		return output, fmt.Errorf("%s: %w\n%s", cmdStr, err, output)
	}

	writeLog("[%s] OK: %s", step, output)
	return output, nil
}

// RunInteractive runs a command attached to the terminal (for sudo, pacman, etc).
func RunInteractive(step, name string, args ...string) error {
	cmdStr := name + " " + strings.Join(args, " ")
	writeLog("[%s] interactive: %s", step, cmdStr)

	cmd := exec.Command(name, args...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		writeLog("[%s] FAIL: %s -> %v", step, cmdStr, err)
		return fmt.Errorf("%s: %w", cmdStr, err)
	}

	writeLog("[%s] OK: %s", step, cmdStr)
	return nil
}

// Log writes a message to the log file without running a command.
func Log(step, format string, args ...any) {
	writeLog("[%s] %s", step, fmt.Sprintf(format, args...))
}
