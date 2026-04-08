# Oh My Posh - Secondary Prompt

Source: https://ohmyposh.dev/docs/configuration/secondary-prompt

The secondary prompt appears when a command spans multiple lines. Default: `> `.

**Supported shells:** `powershell`, `zsh`, `bash`

## Configuration

```json
{
  "secondary_prompt": {
    "background": "transparent",
    "foreground": "#ffffff",
    "template": "-> "
  }
}
```

## Options

| Property | Type | Description |
|---|---|---|
| `background` | string | [Color](./05-colors.md) |
| `foreground` | string | [Color](./05-colors.md) |
| `template` | string | Go text/template (default: `> `) |

## Template Properties

| Property | Type | Description |
|---|---|---|
| `.Root` | boolean | Is current user root/admin |
| `.Shell` | string | Current shell name |
| `.UserName` | string | Current user name |
| `.HostName` | string | Host name |
