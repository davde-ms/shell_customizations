# Oh My Posh - Console Title

Source: https://ohmyposh.dev/docs/configuration/title

## Configuration

```json
{
  "console_title_template": "{{.Folder}}{{if .Root}} :: root{{end}} :: {{.Shell}}"
}
```

## Template Examples

Assuming CWD is `/usr/home/omp` and shell is `zsh`:

| Template | Output |
|---|---|
| `{{.Folder}}{{if .Root}} :: root{{end}} :: {{.Shell}}` | `omp :: zsh` (or `omp :: root :: zsh` when root) |
| `{{.Folder}}` | `omp` |
| `{{.Shell}} in {{.PWD}}` | `zsh in /usr/home/omp` |
| `{{.UserName}}@{{.HostName}} {{.Shell}} in {{.PWD}}` | `MyUser@MyMachine zsh in /usr/home/omp` |
| `{{.Env.USERDOMAIN}} {{.Shell}} in {{.PWD}}` | `MyCompany zsh in /usr/home/omp` |

All [template](./06-templates.md) functionality is available, including environment variables.
