# Copilot Instructions — shell_customizations

## Repository Purpose

This repo contains portable PowerShell profile configurations, Oh My Posh prompt themes, and Nerd Fonts — designed to be cloned and symlinked into a machine's PowerShell profile paths for a consistent terminal experience.

## Repository Layout

```
Microsoft.PowerShell_profile.ps1   # Console host profile (loads different theme per terminal)
Microsoft.VSCode_profile.ps1       # VS Code integrated terminal profile (uses sh.json)
oh-my-posh/                        # Theme files (JSON)
  davde-theme-json                 # Full-featured theme (session, path, git, exit, shell, battery, az)
  sh.json                          # Lighter theme (session, path, git, exit, az)
oh-my-posh-docs/                   # Local Oh My Posh syntax reference (do NOT delete)
fonts/                             # Caskaydia Cove Nerd Font files
```

## Oh My Posh Theme Syntax Reference

**Before creating or modifying any Oh My Posh theme, read the relevant reference files in `oh-my-posh-docs/`.**

Start with `oh-my-posh-docs/00-overview.md` for the full index and quick structure reference. Key files:

| When you need to... | Read |
|---|---|
| Understand the overall config structure | `oh-my-posh-docs/01-general.md` |
| Add/modify prompt blocks or alignment | `oh-my-posh-docs/02-block.md` |
| Add/modify segments (path, git, az, etc.) | `oh-my-posh-docs/03-segment.md` |
| Set window/tab title | `oh-my-posh-docs/04-console-title.md` |
| Work with colors, palettes, or color overrides | `oh-my-posh-docs/05-colors.md` |
| Write or edit Go template expressions | `oh-my-posh-docs/06-templates.md` |
| Configure secondary/debug/transient prompts | `oh-my-posh-docs/07-secondary-prompt.md` through `09-transient-prompt.md` |
| Set up PSReadLine line error indicators | `oh-my-posh-docs/10-line-error.md` |
| Add command-triggered tooltips | `oh-my-posh-docs/11-tooltips.md` |

## Rules for Theme Files

1. **Format**: Themes use JSON. Always include the `$schema` property for validation:
   ```json
   {
     "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json"
   }
   ```

2. **Version**: The current config version is **4**. Use `"version": 4` for new themes. Existing themes in this repo use version 2 — when upgrading them, update the version number.

3. **File naming**: Theme files go in `oh-my-posh/`. Use `.json` extension. Names should be descriptive (e.g., `minimal.json`, `full-featured.json`).

4. **Nerd Font icons**: This repo ships Caskaydia Cove Nerd Font. Templates can use Nerd Font unicode glyphs (e.g., `\ue0b0`, `\uf07b`, `\uf817`). Verify glyphs render correctly with the bundled font.

5. **Segment types**: Refer to `oh-my-posh-docs/03-segment.md` for the style options (`powerline`, `plain`, `diamond`, `accordion`) and all segment properties. For the list of available segment types, see https://ohmyposh.dev/docs/segments/cli/angular.

6. **Templates**: All `template` values use Go `text/template` syntax extended with sprig. See `oh-my-posh-docs/06-templates.md` for available global properties (`.Root`, `.PWD`, `.Shell`, `.UserName`, `.Code`, etc.), environment variables (`.Env.VarName`), config variables (`.Var.VarName`), cross-segment references (`.Segments.Git.HEAD`), helper functions, and text decoration tags (`<b>`, `<i>`, etc.).

7. **Colors**: Use hex colors (`#RRGGBB`), ANSI names, `transparent`, `parentBackground`, `parentForeground`, or palette references (`p:name`). See `oh-my-posh-docs/05-colors.md`. When defining many colors, prefer a `palette` block for maintainability.

8. **Validation**: After editing a theme, verify it renders via:
   ```
   oh-my-posh print primary --config oh-my-posh/<theme>.json --shell uni
   ```

## PowerShell Profile Conventions

- **Console profile** (`Microsoft.PowerShell_profile.ps1`): Loads different themes based on terminal context — `sh.json` for VS Code terminal, `mytheme.json` for standalone consoles. Theme paths reference `$env:OneDriveConsumer\Documents\oh-my-posh\`.
- **VS Code profile** (`Microsoft.VSCode_profile.ps1`): Always loads `sh.json` from `$PSScriptRoot\oh-my-posh\` (repo-relative path).
- Both profiles import `PSReadLine` and `Terminal-Icons` modules, and register tab-completion for `winget` and `dotnet`.
- Profiles target **PowerShell 7+** (`pwsh.exe`). Some features require PS7 (e.g., `PredictionSource`, `AcceptNextSuggestionWord`, `using namespace`).

## General Guidelines

- Do not modify files in `oh-my-posh-docs/` — they are a reference copy of the official Oh My Posh documentation and should only be updated by re-fetching from the website.
- When suggesting theme changes, show the specific JSON diff rather than rewriting the entire file.
- Preserve existing segment ordering and block structure unless the user explicitly asks to reorganize.
- Keep `console_title_template` and `final_space` consistent with existing themes unless asked to change.
