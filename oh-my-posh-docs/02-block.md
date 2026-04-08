# Oh My Posh - Block Configuration

Source: https://ohmyposh.dev/docs/configuration/block

A block is a container for segments. Blocks define the layout structure of the prompt.

## Example

```json
{
  "blocks": [
    {
      "type": "prompt",
      "alignment": "left",
      "segments": []
    }
  ]
}
```

## Settings

| Property | Type | Description |
|---|---|---|
| `type` | string | `prompt` (renders segments) or `rprompt` (right-aligned, only one allowed) |
| `newline` | boolean | Start block on a new line (default: false). For pwsh/cmd, won't print newline on first block when prompt is first line |
| `alignment` | string | `left` or `right` - block alignment direction |
| `filler` | string | Characters repeated to join left and right aligned blocks. Add to the *right* aligned block. Supports [color overrides](./05-colors.md). Also supports templates with `.Overflow` and `.Padding` properties |
| `overflow` | string | `break` or `hide` - behavior when right block overflows left block. Default: printed as-is on same line |
| `leading_diamond` | string | Character for leading diamond of first segment in block (always used regardless of which segment is enabled) |
| `trailing_diamond` | string | Character for trailing diamond of last segment in block |
| `segments` | array | Array of one or more segments |
| `force` | boolean | When true, block always renders even if all segments empty (default: false) |
| `index` | int | 1-based index for overriding a specific block in extended configurations |

## Filler Template Properties

When using filler with a template:

| Property | Type | Description |
|---|---|---|
| `.Overflow` | text | Empty if no overflow. Otherwise `hide` or `break` |
| `.Padding` | int | Computed length of padding between left and right blocks |

### Filler Example

```json
{
  "blocks": [
    {
      "alignment": "right",
      "overflow": "hide",
      "filler": "{{ if .Overflow }} {{ else }}-{{ end }}"
    }
  ]
}
```
