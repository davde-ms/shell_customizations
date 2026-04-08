# Oh My Posh - Segment Configuration

Source: https://ohmyposh.dev/docs/configuration/segment

A segment is a part of the prompt with a certain context. Each segment has a `type` that determines what data it shows.

## Example

```json
{
  "segments": [
    {
      "type": "path",
      "style": "powerline",
      "powerline_symbol": "\uE0B0",
      "foreground": "#ffffff",
      "background": "#61AFEF",
      "template": " {{ .Path }} ",
      "include_folders": ["/Users/posh/Projects"]
    }
  ]
}
```

## Settings

| Property | Type | Default | Description |
|---|---|---|---|
| `type` | string | | Segment type (see segments docs for all values) |
| `style` | string | `plain` | Rendering style: `powerline`, `plain`, `diamond`, `accordion`, or a template resolving to one |
| `powerline_symbol` | string | | End character for powerline style (e.g., `\uE0B0`) |
| `leading_powerline_symbol` | string | | Start character for powerline style. Use when you see black artifacts (e.g., `\uE0D6` for `\uE0B0`) |
| `invert_powerline` | boolean | false | Swap foreground/background colors |
| `leading_diamond` | string | | Start character for diamond style (uses segment bg as fg) |
| `trailing_diamond` | string | | End character for diamond style (uses segment bg as fg) |
| `foreground` | string | | [Color](./05-colors.md) |
| `foreground_templates` | []Template | | [Color templates](./05-colors.md) |
| `background` | string | | [Color](./05-colors.md) |
| `background_templates` | []Template | | [Color templates](./05-colors.md) |
| `template` | string | | Go text/template string for prompt rendering |
| `templates` | []Template | | Multi-line template support (array of template strings) |
| `templates_logic` | string | `join` | `first_match` (return first non-empty) or `join` (evaluate all, join non-empty) |
| `options` | []Option | | Segment-specific options (see each segment's docs) |
| `interactive` | boolean | false | Don't escape segment text (for interactive prompt sequences in Bash/Zsh) |
| `alias` | string | | For cross-segment template references |
| `min_width` | int | 0 | Hide segment if terminal width < this value (0 = disable) |
| `max_width` | int | 0 | Hide segment if terminal width > this value (0 = disable) |
| `cache` | Cache | | Caching configuration |
| `include_folders` | []string | | Regex patterns - only render in matching folders |
| `exclude_folders` | []string | | Regex patterns - don't render in matching folders |
| `force` | boolean | false | Always render, even if only whitespace |
| `timeout` | int | 0 | Timeout in ms for segment execution (0 = no timeout) |
| `index` | int | | 1-based index for overriding segments in extended configs |
| `placeholder` | string | | Text while segment loads in streaming mode (default: `...`) |

## Styles

### Powerline
Uses a single `powerline_symbol` to separate segments. Takes previous segment's bg as fg and current segment's fg. Expects colored backgrounds.

### Plain
Colored text on transparent background. Set `foreground` for desired color.

### Diamond
Custom start/end symbols: `< my segment text >`. Diamond symbols use the segment's background as their foreground color.

### Accordion
Same as Powerline, but displays even when disabled (without text) - collapses like an accordion.

## Cache

```json
{
  "cache": {
    "duration": "1h",
    "strategy": "folder"
  }
}
```

| Property | Type | Description |
|---|---|---|
| `duration` | string | Cache duration (format: `1h2m3s`). Use `none` to disable |
| `strategy` | string | `session` (per shell session), `folder` (per directory), `device` (per device) |

## Include / Exclude Folders

- Values are **regular expressions** that must match the ENTIRE directory name
- Both `/` and `\` accepted as separators
- `~` matches user home directory
- Case-insensitive on Windows/macOS, case-sensitive on Linux
- In JSON, use `\\\\` for literal backslash in Windows paths

```json
{
  "include_folders": ["/Users/posh/Projects/.*"],
  "exclude_folders": ["/Users/posh/Projects/secret-project.*"]
}
```

## Hiding Segments

### Conditionally (via template)
Template must evaluate to empty string to hide:

```json
{
  "type": "text",
  "style": "diamond",
  "template": "{{ if .Env.POSH_ENV }}  {{ .Env.POSH_ENV }} {{ end }}"
}
```

### On the fly
Toggle segments at runtime:
```
oh-my-posh toggle <type>
oh-my-posh get toggles
```
Per shell session only.
