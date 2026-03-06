package config

import "fmt"

func GhosttyPatches(fontSize string) []Patch {
	return []Patch{
		{Type: Replace, Match: `font-size=\d+`, Replace: fmt.Sprintf("font-size=%s", fontSize)},
	}
}
