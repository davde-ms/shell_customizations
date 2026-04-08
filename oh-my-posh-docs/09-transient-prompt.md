# Oh My Posh - Transient Prompt

Source: https://ohmyposh.dev/docs/configuration/transient

Transient prompt replaces previous prompts with a simpler one after command execution, giving more screen real estate.

**Supported shells:** `nu`, `fish`, `zsh`, `powershell` (not ConstrainedLanguage mode), `bash` (with ble.sh), `cmd`

Enabled automatically for all shells except `cmd` (for cmd: `clink set prompt.transient always`).

## Configuration

```json
{
  "transient_prompt": {
    "background": "transparent",
    "foreground": "#ffffff",
    "template": "{{ .Shell }}> "
  }
}
```

## Options

| Property | Type | Description |
|---|---|---|
| `foreground` | string | Color |
| `foreground_templates` | array | Color templates |
| `background` | string | Color |
| `background_templates` | array | Color templates |
| `template` | string | Go text/template (default: `{{ .Shell }}> `) |
| `filler` | string | Repeated characters spanning terminal width (added after template text) |
| `newline` | boolean | Add newline before the prompt |

All [template](./06-templates.md) functionality is available, including cross-segment references from the previous primary prompt run.
