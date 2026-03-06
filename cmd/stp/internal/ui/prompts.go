package ui

import (
	"fmt"

	"github.com/carraes/dotfiles/cmd/stp/internal/runner"
	"github.com/pterm/pterm"
)

func InputWithDefault(label, defaultVal string) (string, error) {
	result, err := pterm.DefaultInteractiveTextInput.
		WithDefaultValue(defaultVal).
		Show(label)
	if err != nil {
		return "", err
	}
	if result == "" {
		return defaultVal, nil
	}
	return result, nil
}

func MultiSelect(label string, options []string) ([]string, error) {
	return pterm.DefaultInteractiveMultiselect.
		WithOptions(options).
		WithDefaultOptions(options).
		Show(label)
}

func Confirm(label string, defaultVal bool) (bool, error) {
	return pterm.DefaultInteractiveConfirm.
		WithDefaultValue(defaultVal).
		Show(label)
}

func Select(label string, options []string) (string, error) {
	return pterm.DefaultInteractiveSelect.
		WithOptions(options).
		Show(label)
}

func Success(msg string) {
	pterm.Success.Println(msg)
}

func Error(msg string) {
	pterm.Error.Println(msg)
}

func Info(msg string) {
	pterm.Info.Println(msg)
}

func Warning(msg string) {
	pterm.Warning.Println(msg)
}

func Section(title string) {
	pterm.DefaultSection.Println(title)
}

// ErrorWithLog prints an error message and a hint to check the log file.
func ErrorWithLog(msg string, err error) {
	pterm.Error.Printfln("%s: %v", msg, err)
	pterm.Info.Printfln("Check log: %s", runner.LogPath())
}

func Errorf(format string, args ...any) {
	pterm.Error.Println(fmt.Sprintf(format, args...))
}
