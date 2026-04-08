# Oh My Posh Theme Syntax Reference

This folder contains a complete reference for Oh My Posh theme configuration syntax,
extracted from the official documentation at https://ohmyposh.dev/docs/.

## File Index

| File | Topic | Description |
|---|---|---|
| [01-general.md](./01-general.md) | General | Top-level config properties, schema, extends, maps |
| [02-block.md](./02-block.md) | Block | Block containers (prompt/rprompt), alignment, filler, overflow |
| [03-segment.md](./03-segment.md) | Segment | Segment properties, styles (powerline/plain/diamond/accordion), caching, folder filtering |
| [04-console-title.md](./04-console-title.md) | Console Title | Terminal window title template |
| [05-colors.md](./05-colors.md) | Colors | Color types, templates, overrides, palette system, cycle |
| [06-templates.md](./06-templates.md) | Templates | Go text/template syntax, global properties, env vars, helper functions, cross-segment refs, text decoration |
| [07-secondary-prompt.md](./07-secondary-prompt.md) | Secondary Prompt | Multi-line command continuation prompt |
| [08-debug-prompt.md](./08-debug-prompt.md) | Debug Prompt | Shell debug mode prompt |
| [09-transient-prompt.md](./09-transient-prompt.md) | Transient Prompt | Simplified prompt after command execution |
| [10-line-error.md](./10-line-error.md) | Line Error | PSReadLine valid/error line indicators (PowerShell) |
| [11-tooltips.md](./11-tooltips.md) | Tooltips | Context-aware right-aligned segments on keyword typing |

## Theme Structure (Quick Reference)

```
{
  "$schema": "...",              // JSON schema for validation
  "version": 4,                 // Config version
  "final_space": true,          // Space at end of prompt
  "console_title_template": "", // Window title
  "var": {},                    // Config variables
  "palette": {},                // Named color definitions
  "palettes": {},               // Conditional palette sets
  "cycle": [],                  // Color cycling
  "blocks": [                   // Array of prompt blocks
    {
      "type": "prompt|rprompt",
      "alignment": "left|right",
      "newline": false,
      "segments": [             // Array of segments in block
        {
          "type": "...",        // Segment type (path, git, az, etc.)
          "style": "...",       // powerline|plain|diamond|accordion
          "foreground": "",     // Color
          "background": "",     // Color
          "template": "",       // Go template string
          "options": {}         // Segment-specific options
        }
      ]
    }
  ],
  "secondary_prompt": {},       // Multi-line continuation
  "debug_prompt": {},           // Debug mode prompt
  "transient_prompt": {},       // Simplified previous prompts
  "valid_line": {},             // PSReadLine valid indicator
  "error_line": {},             // PSReadLine error indicator
  "tooltips": []                // Keyword-triggered segments
}
```

## Segment Types (Common)

For full list see: https://ohmyposh.dev/docs/segments/cli/angular

Common types: `path`, `git`, `session`, `exit`/`status`, `text`, `time`, `az`, `aws`,
`battery`, `shell`, `node`, `python`, `dotnet`, `java`, `go`, `rust`, `docker`, `kubectl`, `terraform`
