package config

import (
	"fmt"
	"strings"
)

var secretKeys = []string{
	"ANTHROPIC_API_KEY",
	"OPENAI_API_KEY",
	"DEEPSEEK_API_KEY",
	"GEMINI_API_KEY",
	"DD_APPLICATION_KEY",
	"DD_APP_KEY",
	"DD_APPLICATION_KEY_ID",
	"DD_API_KEY",
	"DD_API_KEY_ID",
	"BITBUCKET_EMAIL",
	"BITBUCKET_API_TOKEN",
	"OPENROUTER_API_KEY",
	"OPENCODE_API_KEY",
	"GITHUB_TOKEN",
	"JIRA_URL",
	"JIRA_API_TOKEN",
	"SONARCLOUD_TOKEN",
	"BOARD",
}

func secretDeletePattern() string {
	return `(?i)^(export|#\s*export)\s+(` + strings.Join(secretKeys, "|") + `)=`
}

func ZshenvPatches(browser string) []Patch {
	patches := []Patch{
		{Type: DeleteLine, Match: secretDeletePattern()},
		{Type: Replace, Match: `/home/carraes/`, Replace: "$HOME/"},
		{Type: Replace, Match: `BROWSER="chromium"`, Replace: fmt.Sprintf(`BROWSER="%s"`, browser)},
		{Type: Replace, Match: `(?m)^\. "\$HOME/\.cargo/env"$`, Replace: `[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"`},
		{Type: Replace, Match: `(?m)^\. "\$HOME/\.local/share/bob/env/env\.sh"$`, Replace: `[ -f "$HOME/.local/share/bob/env/env.sh" ] && . "$HOME/.local/share/bob/env/env.sh"`},
	}

	var comments string
	comments = "\n# Secrets - uncomment and set your values"
	for _, key := range secretKeys {
		comments += fmt.Sprintf("\n# export %s=your-%s-here", key, key)
	}
	patches = append(patches, Patch{Type: Append, Replace: comments})

	return patches
}
