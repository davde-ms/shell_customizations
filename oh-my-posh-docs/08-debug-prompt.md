# Oh My Posh - Debug Prompt

Source: https://ohmyposh.dev/docs/configuration/debug-prompt

The debug prompt is displayed when a shell is in debug mode. It replaces the standard prompt with a custom one.

## Configuration

```json
{
  "debug_prompt": {
    "background": "transparent",
    "foreground": "#ffffff",
    "template": "Debugging> "
  }
}
```

## Options

| Property | Type | Description |
|---|---|---|
| `background` | string | Color |
| `foreground` | string | Color |
| `template` | string | Go text/template string |
