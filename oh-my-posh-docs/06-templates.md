# Oh My Posh - Templates

Source: https://ohmyposh.dev/docs/configuration/templates

Every segment has a `template` property using Go's [text/template](https://pkg.go.dev/text/template) extended with [sprig](https://masterminds.github.io/sprig/).

## Global Properties

Available in any segment. If a segment has a property with the same name, prefix with `.$` to access the global one.

| Property | Type | Description |
|---|---|---|
| `.Root` | boolean | Is current user root/admin |
| `.PWD` | string | Current working directory (`~` for $HOME) |
| `.AbsolutePWD` | string | Current working directory (unaltered) |
| `.PSWD` | string | Current non-filesystem working directory in PowerShell |
| `.Folder` | string | Current working folder name |
| `.Shell` | string | Current shell name (may be overridden by `maps.shell_name`) |
| `.ShellVersion` | string | Current shell version |
| `.SHLVL` | int | Current shell level |
| `.UserName` | string | Current user name |
| `.HostName` | string | Host name |
| `.Code` | int | Last exit code |
| `.Jobs` | int | Number of background jobs (zsh, PowerShell, Nushell only) |
| `.OS` | string | Operating system |
| `.WSL` | boolean | In WSL yes/no |
| `.Templates` | string | Templates result |
| `.PromptCount` | int | Prompt counter (increments with each prompt invocation) |
| `.Version` | string | Oh My Posh version |
| `.Segment` | Segment | Current segment's metadata |

### Segment Metadata

| Property | Type | Description |
|---|---|---|
| `.Segment.Index` | int | Current segment's index (as rendered) |
| `.Segment.Text` | string | Segment's rendered text |

## Environment Variables

```
{{ .Env.VarName }}
```

Any environment variable where `VarName` is the variable name.

### Pre-prompt Variable Setting

For PowerShell:
```powershell
function Set-EnvVar([bool]$originalStatus) {
    $env:POSH=$(Get-Date)
}
New-Alias -Name 'Set-PoshContext' -Value 'Set-EnvVar' -Scope Global -Force
```

## Config Variables

Accessed via `.Var.VarName`:

```json
{
  "version": 4,
  "var": {
    "Hello": "hello",
    "World": "world"
  },
  "blocks": [
    {
      "type": "prompt",
      "alignment": "left",
      "segments": [
        {
          "type": "text",
          "style": "plain",
          "foreground": "p:white",
          "template": "{{ .Var.Hello }} {{ .Var.World }} "
        }
      ]
    }
  ]
}
```

## Template Logic

| Syntax | Description |
|---|---|
| `{{.}}` | Root element |
| `{{.Var}}` | Variable in a struct |
| `{{- .Var -}}` | Remove surrounding whitespace and newlines |
| `{{ $planet := "Earth"}} {{ $planet }}` | Store value in custom variable |
| `Hi {{if .Name}} {{.Name}} {{else}} visitor {{end}}` | If-else statement |
| `{{if and .Arg1 .Arg2}} both {{else}} nope {{end}}` | Boolean AND (also `or` available) |
| `{{with .Var}} {{end}}` | With statement (skips if absent) |
| `{{range .Array}} {{end}}` | Range over array/slice/map/channel |
| `{{ lt 3 4 }}` | Comparison: `eq`, `ne`, `lt`, `le`, `gt`, `ge` |

## Helper Functions

### Sprig

All [sprig functions](https://masterminds.github.io/sprig/) are included: string operations, path manipulation, math, etc.

### Custom Functions

| Function | Description |
|---|---|
| `{{ url .UpstreamIcon .UpstreamURL }}` | Create OSC8 hyperlink (needs terminal support) |
| `{{ path .Path .Location }}` | Create OSC8 file link to folder |
| `{{ secondsRound 3600 }}` | Round seconds to time indication (e.g., `1h`) |
| `{{ if glob "*.go" }}OK{{ else }}NOK{{ end }}` | Glob file matching (boolean) |
| `{{ if matchP ".*\\.Repo$" .Path }}Repo{{ end }}` | Regex matching (boolean) |
| `{{ replaceP "c.t" "cut code cat" "dog" }}` | Regex replace |
| `{{ .Code \| hresult }}` | Convert status code to HRESULT hex value |
| `{{ readFile ".version.json" }}` | Read file in current directory (returns string) |
| `{{ random (list "a" 2 .MyThirdItem) }}` | Random element from list |

## Cross-Segment Template Properties

Access another segment's properties via `{{ .Segments.SegmentType }}` (first letter uppercased):

```json
{
  "template": " {{ if .Segments.Git.UpstreamGone }}{{ else if gt .Code 0 }}{{ else }}{{ end }} "
}
```

**Requirements:**
- The referenced segment must exist in your config
- Use `alias` to distinguish between duplicate segment types

```json
{
  "segments": [
    { "type": "git", "alias": "GitMain", "style": "plain", "foreground": "#ffffff" },
    { "type": "git", "alias": "GitSecondary", "style": "plain", "foreground": "#ffffff" },
    {
      "type": "text",
      "style": "plain",
      "template": "{{ .Segments.GitMain.HEAD }} - {{ .Segments.GitSecondary.HEAD }}"
    }
  ]
}
```

Check if segment is active:
```json
{
  "template": "{{ if .Segments.Contains \"Git\" }}active{{ end }}"
}
```

## Text Decoration

| Syntax | Renders as |
|---|---|
| `<b>bold</b>` | **bold** |
| `<u>underline</u>` | underlined text |
| `<o>overline</o>` | overlined text |
| `<i>italic</i>` | *italic* |
| `<s>strikethrough</s>` | ~~strikethrough~~ |
| `<d>dimmed</d>` | dimmed text |
| `<f>blink</f>` | blinking text |
| `<r>reversed</r>` | reversed text |

Can be used in templates and icons/text inside config.
