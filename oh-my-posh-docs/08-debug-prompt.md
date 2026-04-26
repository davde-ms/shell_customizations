# Oh My Posh - Debug Prompt

Source: https://ohmyposh.dev/docs/configuration/debug-prompt

**Supported shells:** `powershell` only

The debug prompt is displayed when you debug a script from the command line or Visual Studio Code. The default is `[DBG]: `.

Uses Go [text/template](https://pkg.go.dev/text/template) extended with [sprig](https://masterminds.github.io/sprig/). Environment variables are available, just like in `console_title_template`.

## Configuration

```json
{
  "debug_prompt": {
    "background": "transparent",
    "foreground": "#ffffff",
    "template": "Debugging "
  }
}
```

## Options

| Property | Type | Description |
|---|---|---|
| `foreground` | string | [Color](./05-colors.md) |
| `foreground_templates` | array | [Color templates](./05-colors.md) |
| `background` | string | [Color](./05-colors.md) |
| `background_templates` | array | [Color templates](./05-colors.md) |
| `template` | string | Go text/template (default: `[DBG]: `) |

## Template Properties

| Property | Type | Description |
|---|---|---|
| `.Root` | boolean | Is current user root/admin |
| `.PWD` | string | Current working directory |
| `.Folder` | string | Current working folder |
| `.Shell` | string | Current shell name |
| `.UserName` | string | Current user name |
| `.HostName` | string | Host name |
| `.Code` | int | Last exit code |
| `.Env.VarName` | string | Any environment variable (`VarName` is the variable name) |
