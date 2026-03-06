package config

import "path/filepath"

func GitconfigPatches(name, email string) []Patch {
	return []Patch{
		{Type: Replace, Match: `name = carraes`, Replace: "name = " + name},
		{Type: Replace, Match: `email = carraeshb@gmail\.com`, Replace: "email = " + email},
		{Type: Replace, Match: `/home/carraes/\.gitignore_global`, Replace: filepath.Join("~", ".gitignore_global")},
	}
}
