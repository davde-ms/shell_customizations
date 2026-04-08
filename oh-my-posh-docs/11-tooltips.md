# Oh My Posh - Tooltips

Source: https://ohmyposh.dev/docs/configuration/tooltips

**Supported shells:** `fish`, `zsh`, `powershell` (not ConstrainedLanguage mode), `cmd` (Clink v1.2.46+)

Tooltips are segments displayed right-aligned while typing specific keywords. They use `tips` to define which commands trigger them.

**Note:** Tooltip rendering is blocking - if the segment is slow, you can't type until it's visible.

## Configuration

```json
{
  "tooltips_action": "replace",
  "tooltips": [
    {
      "type": "git",
      "tips": ["git", "g"],
      "style": "diamond",
      "foreground": "#193549",
      "background": "#fffb38",
      "leading_diamond": "",
      "trailing_diamond": "",
      "template": "{{ .HEAD }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}",
      "options": {
        "fetch_status": true,
        "fetch_upstream_icon": true
      }
    }
  ]
}
```

### Multiple Tooltips for Same Command

```json
{
  "tooltips": [
    {
      "type": "aws",
      "tips": ["aws", "terraform"],
      "style": "plain",
      "foreground": "#e0af68",
      "template": " {{.Profile}}{{if .Region}}@{{.Region}}{{end}}"
    },
    {
      "type": "az",
      "tips": ["az", "terraform"],
      "style": "plain",
      "foreground": "#b4f9f8",
      "template": " {{ .Name }}"
    }
  ]
}
```

## Tooltips Action

Controls how tooltips relate to the existing rprompt:

| Value | Description |
|---|---|
| `replace` | Replace current rprompt (default) |
| `extend` | Append tooltips to current rprompt |
| `prepend` | Prepend tooltips to current rprompt |

```json
{
  "tooltips_action": "extend"
}
```
