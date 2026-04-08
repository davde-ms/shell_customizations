# Oh My Posh - Line Error

Source: https://ohmyposh.dev/docs/configuration/line-error

**Supported shells:** `powershell` only

Line error replaces the last part of the prompt when entered text is invalid. Uses PSReadLine's `-PromptText` setting with two distinct prompts.

## Configuration

Two settings:
- `valid_line`: displayed when line is valid
- `error_line`: displayed when line has errors

```json
{
  "valid_line": {
    "background": "transparent",
    "foreground": "#ffffff",
    "template": "<#e0def4,#286983> </><#286983,transparent></> "
  },
  "error_line": {
    "background": "transparent",
    "foreground": "#ffffff",
    "template": "<#eb6f92,#286983> </><#286983,transparent></> "
  }
}
```

## Options

| Property | Type | Description |
|---|---|---|
| `background` | string | Color |
| `foreground` | string | Color |
| `template` | string | Fully featured template (default: empty) |
