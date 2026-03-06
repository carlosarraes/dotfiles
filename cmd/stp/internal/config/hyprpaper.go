package config

import "fmt"

func HyprpaperContent(wallpaperPath string) string {
	return fmt.Sprintf("preload = %s\nwallpaper = ,%s\n", wallpaperPath, wallpaperPath)
}
