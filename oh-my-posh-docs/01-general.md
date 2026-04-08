# Oh My Posh - General Configuration

Source: https://ohmyposh.dev/docs/configuration/general

Oh My Posh renders your prompt based on **blocks** (like Lego) which contain one or more **segments**.
Supported formats: `json`, `yaml`, `toml`. A [JSON schema](https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json) is available for validation.

## Minimal Example

```json
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "final_space": true,
  "version": 4,
  "blocks": [
    {
      "type": "prompt",
      "alignment": "left",
      "segments": [
        {
          "type": "path",
          "style": "powerline",
          "powerline_symbol": "\uE0B0",
          "foreground": "#ffffff",
          "background": "#61AFEF",
          "options": {
            "style": "folder"
          }
        }
      ]
    }
  ]
}
```

## Top-Level Settings

| Property | Type | Default | Description |
|---|---|---|---|
| `final_space` | boolean | | When true, adds a space at the end of the prompt |
| `pwd` | string | | Notify terminal of CWD. Values: `osc99`, `osc7`, `osc51` (supports templates) |
| `terminal_background` | string | | Color - terminal background color, set to your terminal's bg when you notice black elements |
| `accent_color` | string | | Color - accent color, fallback when accent color not supported |
| `var` | map[string]any | | Config variables to use in templates. Can be any value |
| `shell_integration` | boolean | false | Enable shell integration using FinalTerm's OSC sequences |
| `enable_cursor_positioning` | boolean | false | Enable cursor position fetching in bash/zsh for auto-hiding leading newlines |
| `patch_pwsh_bleed` | boolean | false | Patch PowerShell bug where bg colors bleed into next line |
| `upgrade` | Upgrade | | Enable auto upgrade or upgrade notice |
| `iterm_features` | []string | false | iTerm2 features: `prompt_mark`, `current_dir`, `remote_host` |
| `maps` | Maps | | Custom text replacement mappings |
| `async` | boolean | false | Load prompt async (pwsh, powershell, zsh, bash, fish) |
| `version` | int | 4 | Config version, currently at 4 |
| `extends` | string | | Configuration to extend from |
| `streaming` | int | | Enable streaming mode with timeout in ms for pending segments |

## Maps

Text replacement mappings for user names, host names, and shell names:

```json
{
  "maps": {
    "user_name": {
      "jan": "🚀",
      "root": "⚡"
    },
    "host_name": {
      "laptop123": "work"
    },
    "shell_name": {
      "pwsh": "PowerShell"
    }
  }
}
```

The `shell_name` map modifies the `.Shell` global property.

## Extends

The `extends` key allows extending an existing configuration (local or remote path). Useful for building upon base configurations/themes.

- **Overriding values**: Repeat the key in new config to override.
- **Overriding blocks**: Match by same `type` and `alignment`.
- **Overriding segments**: Matched by `alias` or `type`.
- **Index-based override**: Use 1-based `index` on blocks/segments for positional overrides.

## JSON Schema Validation

Include the `$schema` property for editor validation/autocomplete:

```json
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json"
}
```

For YAML:
```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json
```
