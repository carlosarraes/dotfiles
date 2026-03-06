package config

import (
	"os"
	"regexp"
	"strings"
)

type PatchType int

const (
	Replace PatchType = iota
	DeleteLine
	Append
)

type Patch struct {
	Type    PatchType
	Match   string // regex pattern for the line(s) to match
	Replace string // replacement (for Replace type) or content (for Append)
}

func ApplyPatches(content string, patches []Patch) string {
	for _, p := range patches {
		switch p.Type {
		case Replace:
			re := regexp.MustCompile(p.Match)
			content = re.ReplaceAllString(content, p.Replace)
		case DeleteLine:
			re := regexp.MustCompile(p.Match)
			lines := strings.Split(content, "\n")
			var kept []string
			for _, line := range lines {
				if !re.MatchString(line) {
					kept = append(kept, line)
				}
			}
			content = strings.Join(kept, "\n")
		case Append:
			content = strings.TrimRight(content, "\n") + "\n" + p.Replace + "\n"
		}
	}
	return content
}

func PatchFile(path string, patches []Patch) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	result := ApplyPatches(string(data), patches)
	return os.WriteFile(path, []byte(result), 0644)
}
