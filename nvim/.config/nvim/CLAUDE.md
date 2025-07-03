# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Neovim Configuration Overview

This repository contains a Neovim configuration that uses:
- Lazy.nvim as the plugin manager
- LSP for code intelligence through nvim-lspconfig and Mason
- Formatting with conform.nvim and linting with nvim-lint
- CodeCompanion AI integration with Deepseek model and MCPHub extension
- Many custom keybindings for editor functionality

## Key Files and Structure

- `init.lua`: Main configuration entry point
- `lua/options.lua`: Vim options and settings
- `lua/keymaps.lua`: Core keybinding definitions
- `lua/plugins/`: Individual plugin configurations
- `lua/plugins/lsp/`: LSP-related configurations
- `lua/local/`: Local utilities 

## Development Guidelines

When making changes to this configuration:

1. Follow the existing code style in each file
2. Maintain the organization of plugin configurations in separate files
3. Follow Neovim's Lua style conventions:
   - Use `local` for variables
   - Follow the tabbing/spacing (2 spaces) conventions established

## Plugin Configuration

When modifying plugin configurations, ensure that you:
1. Keep plugin-specific keybindings in the plugin file or in `keymaps.lua`
2. Maintain the format of `return { ... }` used in plugin files
3. Check for VSCode compatibility with the `if vim.g.vscode then return end` pattern

## Commit Guidelines

- Commits MUST be one line
- Commits MUST follow conventional commits

## Additional Notes

- Most plugins include VSCode compatibility checks
- Many plugins use the standard `setup()` pattern
- The configuration includes custom terminal implementation in `local/term.lua`