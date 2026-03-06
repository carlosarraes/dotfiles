package pathutil

import (
	"os"
	"path/filepath"
)

var home string

func init() {
	home, _ = os.UserHomeDir()
}

func Home() string {
	return home
}

func ExpandHome(path string) string {
	if len(path) > 1 && path[:2] == "~/" {
		return filepath.Join(home, path[2:])
	}
	return path
}

func ConfigDir() string {
	return filepath.Join(home, ".config", "stp")
}
