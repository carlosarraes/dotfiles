package config

func ZshrcPatches(includeWork, includeWSL bool) []Patch {
	patches := []Patch{
		// Fix hardcoded home paths
		{Type: Replace, Match: `/home/carraes/`, Replace: "$HOME/"},

		// Strip inline API keys from aider aliases but keep the aliases
		{Type: Replace, Match: `--openai-api-key \S+\s*`, Replace: ""},
		{Type: Replace, Match: `--api-key deepseek=\S+\s*`, Replace: ""},

		// Remove webcam alias (machine-specific device)
		{Type: DeleteLine, Match: `alias webcam=`},

		// Wrap asdf source in conditional
		{Type: Replace, Match: `(?m)^\. "\$HOME/\.asdf/asdf\.sh"$`, Replace: `[ -f "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"`},

		// Wrap nvm in conditional (keep existing [ -s ] pattern but ensure it's there)
		// nvm already has conditionals, no change needed

		// Wrap fzf sources in conditional
		{Type: Replace, Match: `(?m)^source /usr/share/fzf/key-bindings\.zsh$`, Replace: `[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh`},
		{Type: Replace, Match: `(?m)^source /usr/share/fzf/completion\.zsh$`, Replace: `[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh`},

		// Wrap zsh plugins in conditional
		{Type: Replace, Match: `(?m)^source ~/\.zsh/zsh-autosuggestions/zsh-autosuggestions\.zsh$`, Replace: `[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh`},
		{Type: Replace, Match: `(?m)^source ~/\.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting\.zsh$`, Replace: `[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`},

		// Wrap tool evals in conditional (command -v check)
		{Type: Replace, Match: `(?m)^eval "\$\(starship init zsh\)"$`, Replace: `command -v starship &>/dev/null && eval "$(starship init zsh)"`},
		{Type: Replace, Match: `(?m)^eval "\$\(zoxide init zsh\)"$`, Replace: `command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"`},
		{Type: Replace, Match: `(?m)^eval "\$\(atuin init zsh.*\)"$`, Replace: `command -v atuin &>/dev/null && eval "$(atuin init zsh --disable-up-arrow)"`},
	}

	if !includeWork {
		// Remove work-specific functions
		patches = append(patches,
			Patch{Type: DeleteLine, Match: `^alias gcm='git checkout master'$`},
		)
		patches = append(patches, deleteFunctionPatches([]string{
			"rebuild", "rt", "rwt", "sign", "signhml",
		})...)
	}

	if !includeWSL {
		patches = append(patches, deleteFunctionPatches([]string{"transfer"})...)
	}

	return patches
}

func deleteFunctionPatches(funcNames []string) []Patch {
	var patches []Patch
	for _, name := range funcNames {
		// Match shell function from definition to closing brace
		// This handles the pattern: funcname() {\n...\n}
		patches = append(patches, Patch{
			Type:  Replace,
			Match: `(?ms)^# [^\n]*\n` + name + `\(\) \{.*?\n\}\n`,
		})
		// Also try without comment header
		patches = append(patches, Patch{
			Type:  Replace,
			Match: `(?ms)^` + name + `\(\) \{.*?\n\}\n`,
		})
	}
	return patches
}
