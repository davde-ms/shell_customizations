# Oh My Posh - Colors

Source: https://ohmyposh.dev/docs/configuration/colors

## Standard Colors

| Type | Example | Description |
|---|---|---|
| Hex (true color) | `#CB4B16` | Full RGB color |
| ANSI names (8 basic) | `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`, `default` | Basic terminal colors |
| ANSI names (8 extended) | `darkGray`, `lightRed`, `lightGreen`, `lightYellow`, `lightBlue`, `lightMagenta`, `lightCyan`, `lightWhite` | Extended terminal colors |
| 256 palette | `0`-`255` | Number-based color index |
| `transparent` | | Transparent fg override or bg using segment's fg |
| `foreground` | | Reference current segment's foreground color |
| `background` | | Reference current segment's background color |
| `parentForeground` | | Inherit previous active segment's foreground |
| `parentBackground` | | Inherit previous active segment's background |
| `accent` | | OS accent color (Windows/macOS only) |

## Color Templates

Array of template strings to set color dynamically based on context. First non-empty result wins; falls back to the static `foreground`/`background` value.

```json
{
  "type": "aws",
  "foreground": "#ffffff",
  "background": "#111111",
  "foreground_templates": [
    "{{if contains \"default\" .Profile}}#FFA400{{end}}",
    "{{if contains \"jan\" .Profile}}#f1184c{{end}}"
  ]
}
```

## Color Overrides (Inline)

Override colors inline within any text property:

```
<foreground,background>text</>
```

Examples:
- `<#ffffff,#000000>white on black</>` - both colors
- `<#FF479C>pink text</>` - foreground only
- `<,#FFFFFF>white bg</>` - background only

```json
{
  "template": "<#CB4B16>┏[</>"
}
```

## Palette

Define named colors at the top level for reuse across segments:

```json
{
  "palette": {
    "git-foreground": "#193549",
    "git": "#FFFB38",
    "git-modified": "#FF9248",
    "git-diverged": "#FF4500",
    "git-ahead": "#B388FF",
    "git-behind": "#B388FF",
    "red": "#FF0000",
    "green": "#00FF00",
    "blue": "#0000FF",
    "white": "#FFFFFF",
    "black": "#111111"
  }
}
```

### Using Palette

Reference with `p:<key>`:

```json
{
  "foreground": "p:git-foreground",
  "background": "p:git",
  "background_templates": [
    "{{ if or (.Working.Changed) (.Staging.Changed) }}p:git-modified{{ end }}"
  ]
}
```

### Invalid References
Invalid palette references (e.g., typo `p:bleu` vs `p:blue`) fall back to `transparent`.

### Recursive Resolution
Palette values can reference other palette entries:

```json
{
  "palette": {
    "light-blue": "#CAF0F8",
    "dark-blue": "#023E8A",
    "foreground": "p:light-blue",
    "background": "p:dark-blue"
  }
}
```

## Palettes (Conditional)

Multiple palettes switchable via template (e.g., light/dark mode):

```json
{
  "palettes": {
    "template": "{{ if eq .Shell \"pwsh\" }}latte{{ else }}frappe{{ end }}",
    "list": {
      "latte": {
        "red": "#e64553",
        "white": "#E0DEF4",
        "yellow": "#df8e1d",
        "blue": "#7287fd"
      },
      "frappe": {
        "red": "#D81E5B",
        "white": "#E0DEF4",
        "yellow": "#F3AE35",
        "blue": "#4B95E9"
      }
    }
  }
}
```

- Combine with a default `palette` for shared colors
- `palettes` colors take precedence over `palette` colors
- No match + no fallback `palette` = `transparent`

## Cycle

Display same color sequence regardless of active segments:

```json
{
  "cycle": [
    { "background": "p:blue", "foreground": "p:white" },
    { "background": "p:green", "foreground": "p:black" },
    { "background": "p:orange", "foreground": "p:white" }
  ]
}
```

A defined cycle always gets precedence over everything else.
