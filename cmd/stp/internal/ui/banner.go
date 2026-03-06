package ui

import (
	"fmt"
	"os"
	"strings"

	"github.com/pterm/pterm"
)

func ShowBanner() {
	banner := pterm.DefaultBigText.WithLetters(
		pterm.NewLettersFromStringWithStyle("stp", pterm.NewStyle(pterm.FgCyan)),
	)
	rendered, _ := banner.Srender()
	fmt.Println(rendered)

	pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgDarkGray)).
		WithTextStyle(pterm.NewStyle(pterm.FgLightCyan)).
		Println("dotfiles setup tool")

	distro := detectDistro()
	if distro != "" {
		pterm.Info.Printfln("Detected: %s", distro)
	}
	fmt.Println()
}

func detectDistro() string {
	data, err := os.ReadFile("/etc/os-release")
	if err != nil {
		return ""
	}
	for _, line := range strings.Split(string(data), "\n") {
		if strings.HasPrefix(line, "PRETTY_NAME=") {
			name := strings.TrimPrefix(line, "PRETTY_NAME=")
			return strings.Trim(name, "\"")
		}
	}
	return ""
}
