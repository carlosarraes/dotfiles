package config

import "fmt"

func HyprlandPatches(layout string) []Patch {
	return []Patch{
		// Replace monitor config with generic auto-detect
		{
			Type:    Replace,
			Match:   `(?m)^monitor=HDMI-A-1.*\n(#\s*monitor=.*\n)?monitor=eDP-1.*$`,
			Replace: "monitor=,preferred,auto,auto",
		},
		// Fix layout
		{
			Type:    Replace,
			Match:   `layout = hy3`,
			Replace: fmt.Sprintf("layout = %s", layout),
		},
		// Fix screenshot bind - remove specific monitor reference
		{
			Type:    Replace,
			Match:   `hyprshot -m output -m HDMI-A-1`,
			Replace: "hyprshot -m output",
		},
	}
}
