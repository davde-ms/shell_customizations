# Shell Customizations

A ready-to-use PowerShell setup for Windows: a beautiful prompt, smart history search, file-type icons, and the bundled font that makes it all look right. Everything lives in this repo — clone it, run one script, and your terminals (Windows Terminal, VS Code, plain pwsh) all look and behave the same.

> **Don't know PowerShell yet? That's fine.** Follow the steps in [Quick Start](#quick-start) line by line. You can copy-paste each command.

---

## What you get

- 🎨 A **colorful prompt** showing your current folder, Git status, last command's success/failure, and Azure context (powered by [Oh My Posh](https://ohmyposh.dev)).
- ⚡ **Smart history search** — start typing a command, press Up Arrow, and PowerShell finds the last matching command you ran.
- 🤖 **Inline command suggestions** as you type, based on your history.
- 📁 **Icons next to files and folders** in directory listings (powered by Terminal-Icons).
- 🔤 The **Nerd Font** the prompt needs to render its icons.
- 🚀 An **optimized profile** that loads ~3× faster than the standard one.
- 🔄 A **switcher script** to flip between the original and optimized profiles whenever you want.

---

## Table of Contents

- [Quick Start](#quick-start)
- [What's in this repo](#whats-in-this-repo)
- [How it works](#how-it-works)
- [Switching between Original and Optimized](#switching-between-original-and-optimized)
- [Updating, moving, or uninstalling](#updating-moving-or-uninstalling)
- [Troubleshooting](#troubleshooting)
- [For curious users — what the profiles actually do](#for-curious-users--what-the-profiles-actually-do)

---

## Quick Start

You'll need about 10 minutes. Open **PowerShell 7** (look for the icon labeled **PowerShell** that opens a window with the title `pwsh` — not the old "Windows PowerShell").

### 1. Install the prerequisites (one-time)

Copy and paste this whole block into PowerShell. It installs PowerShell 7 (if missing), Oh My Posh, and the icon module.

```powershell
# Install PowerShell 7 if you don't have it (skip if you're already in pwsh)
winget install --id Microsoft.PowerShell -e --accept-source-agreements --accept-package-agreements

# Install Oh My Posh (the prompt engine)
winget install --id JanDeDobbeleer.OhMyPosh -e --accept-source-agreements --accept-package-agreements

# Install the icon module
Install-Module -Name Terminal-Icons -Scope CurrentUser -Force
```

**Close and reopen your terminal** so it picks up the new commands.

### 2. Install the font

The fancy prompt uses special icon characters that only render correctly with a **Nerd Font**. The simplest option:

```powershell
oh-my-posh font install CascadiaCode
```

When it asks which variant, choose **CascadiaCode**.

> Alternatively, double-click any `.ttf` file in this repo's `fonts/` folder and click **Install**.

### 3. Tell your terminal to use the font

**Windows Terminal**
1. Press `Ctrl+,` to open Settings.
2. Click your **PowerShell** profile (or **Defaults** to apply to all profiles).
3. Go to **Appearance** → **Font face** → select **CaskaydiaCove Nerd Font Mono**.
4. Click **Save**.

**VS Code**
1. Press `Ctrl+,` to open Settings.
2. Search for `terminal.integrated.fontFamily`.
3. Set it to `CaskaydiaCove Nerd Font Mono`.

### 4. Clone this repo

Pick any folder you like — just remember where you put it. Don't delete or move it after step 5.

```powershell
# Example: clone into C:\Tools
mkdir C:\Tools -Force | Out-Null
cd C:\Tools
git clone https://github.com/davde-ms/shell_customizations.git
cd shell_customizations
```

### 5. Run the switcher

```powershell
.\Switch-Profile.ps1 Optimized
```

You should see green or yellow output saying it linked or copied two files. **Close and reopen your terminal** — your new prompt is live.

That's it. Open Windows Terminal or a VS Code terminal — both should show the new prompt.

---

## What's in this repo

| File / folder | What it is |
|---|---|
| `Microsoft.PowerShell_profile.ps1` | The **original** profile for regular PowerShell windows (Windows Terminal, standalone pwsh.exe). |
| `Microsoft.VSCode_profile.ps1` | The **original** profile for VS Code's integrated terminal. |
| `op_Microsoft.PowerShell_profile.ps1` | The **optimized** profile for regular PowerShell windows. Faster startup. |
| `op_Microsoft.VSCode_profile.ps1` | The **optimized** profile for VS Code's integrated terminal. |
| `Switch-Profile.ps1` | The **switcher script** — flips your active profile between Original and Optimized. |
| `oh-my-posh/` | The prompt theme files (`.json`). |
| `oh-my-posh-docs/` | Reference docs for the Oh My Posh theme syntax (for editing themes). |
| `fonts/` | The Caskaydia Cove Nerd Font files. |

---

## How it works

PowerShell automatically runs a script called your **profile** every time it starts. Your profile is just a `.ps1` file at a specific location:

```
C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1     ← regular PowerShell
C:\Users\<you>\Documents\PowerShell\Microsoft.VSCode_profile.ps1         ← VS Code's terminal
```

(If you use OneDrive, your `Documents` folder may live under `OneDrive\Documents\` or `OneDrive - <Org>\Documents\`. PowerShell knows where it is — type `$PROFILE` to see your exact path.)

**The switcher (`Switch-Profile.ps1`) replaces those files with pointers to the version you want from this repo.** It also remembers where this repo lives by saving its path in an environment variable called `SHELL_CUSTOMIZATIONS_ROOT`, so the profiles can find their theme files no matter where you cloned the repo.

### Symlink vs. Copy

The switcher prefers to use a **symbolic link** (symlink): a tiny pointer file. With a symlink, when you edit a file in this repo, the change is live the next time you open a terminal — no re-running needed.

But Windows requires either **administrator rights** or **Developer Mode** to create symlinks. If neither is available, the switcher **falls back to a regular file copy**. That works fine, but with one trade-off: after editing a profile in this repo, you have to re-run `.\Switch-Profile.ps1 Optimized` for the change to take effect.

#### Recommended one-time setup: enable Developer Mode

This lets symlinks work without admin rights.

1. Open Windows **Settings**.
2. Go to **Privacy & security** → **For developers**.
3. Turn **Developer Mode** to **On**.
4. Re-run `.\Switch-Profile.ps1 Optimized`.

---

## Switching between Original and Optimized

The optimized profile loads in about a third of the time. It does this by:

- **Caching** the prompt initialization output (no need to spawn `oh-my-posh.exe` on every shell start).
- **Loading icons lazily** — Terminal-Icons starts in the background after your first prompt is on screen.
- **Trimming unused** PSReadLine sample handlers.

Run any of these from inside the cloned repo folder:

```powershell
.\Switch-Profile.ps1                # show which version is currently active
.\Switch-Profile.ps1 Optimized      # use the fast version (recommended)
.\Switch-Profile.ps1 Original       # go back to the verbose original
```

After switching, **close and reopen your terminal** for the change to take effect.

### Measure the difference yourself

```powershell
1..5 | ForEach-Object {
    (Measure-Command { pwsh -NoLogo -Command exit }).TotalMilliseconds
} | Measure-Object -Average
```

Run that line, switch profiles, then run it again.

---

## Updating, moving, or uninstalling

### To pull the latest changes

```powershell
cd <wherever-you-cloned-the-repo>
git pull
```

If you used **symlink mode**, you're done — your terminals will pick up the new version next time they start.

If you used **copy mode** (no Developer Mode / no admin), re-run the switcher to refresh the copies:

```powershell
.\Switch-Profile.ps1 Optimized
```

### To move the repo to a different folder

1. Move (or re-clone) the repo to the new location.
2. From the new location, run `.\Switch-Profile.ps1 Optimized` again. This updates the saved repo path and refreshes the links/copies.

### To uninstall completely

The switcher backed up any pre-existing profiles for you with names like `Microsoft.PowerShell_profile.ps1.backup-<timestamp>`. To restore them:

```powershell
$dir = Split-Path $PROFILE
Remove-Item "$dir\Microsoft.PowerShell_profile.ps1", "$dir\Microsoft.VSCode_profile.ps1" -Force -ErrorAction SilentlyContinue
# Then rename the most recent .backup-<timestamp> file back to the original name, if you want it.
```

To remove the saved repo path:

```powershell
[Environment]::SetEnvironmentVariable('SHELL_CUSTOMIZATIONS_ROOT', $null, 'User')
```

---

## Troubleshooting

### My prompt looks like a row of boxes or question marks

You haven't installed the Nerd Font, or your terminal isn't using it. Repeat steps 2 and 3 of the [Quick Start](#quick-start).

### My prompt looks plain (no colors, no icons)

Most likely the profile didn't run, or it can't find its theme file. Check:

```powershell
# Is the profile file in place?
Test-Path $PROFILE

# Does PowerShell know where this repo is?
[Environment]::GetEnvironmentVariable('SHELL_CUSTOMIZATIONS_ROOT','User')

# Is oh-my-posh on PATH?
Get-Command oh-my-posh
```

If the env var is empty or `oh-my-posh` is missing, re-run the [Quick Start](#quick-start) steps that set them up.

### "Symlink creation failed (Administrator privilege required)"

This is a warning, not an error — the switcher fell back to copying the files, which still works. To stop seeing this warning, either run PowerShell as administrator once when running the switcher, or (recommended) [enable Developer Mode](#recommended-one-time-setup-enable-developer-mode).

### `Switch-Profile.ps1` says my profile is "Unknown"

This happens in **copy mode** — the switcher can't tell which version is currently in place because the file isn't a symlink. The profile is still working; the status display just can't introspect it. Enable Developer Mode and re-run the switcher to get accurate status.

### I edit a file in the repo but nothing changes

You're in **copy mode**. Either enable Developer Mode (so future installs use symlinks) or just re-run `.\Switch-Profile.ps1 Optimized` after each edit.

### `oh-my-posh: command not found`

Either oh-my-posh isn't installed, or you didn't restart your terminal after installing it. Run:

```powershell
winget install --id JanDeDobbeleer.OhMyPosh -e
```

…then **fully close and reopen** your terminal.

---

## For curious users — what the profiles actually do

Skip this section if you just want things to work.

### Modules loaded

- **PSReadLine** — gives PowerShell its modern command-line editing (history search, syntax coloring, predictions). Built into PowerShell 7+.
- **Terminal-Icons** — adds file-type icons to `Get-ChildItem` output.
- **Oh My Posh** — renders the prompt itself based on a theme JSON.

### Tab completion is configured for

- `winget` (Windows package manager)
- `dotnet` (.NET CLI)

### Useful key bindings (PSReadLine)

| Key | What it does |
|---|---|
| `Up Arrow` / `Down Arrow` | Search history starting with what you've typed |
| `Right Arrow` (at end of line) | Accept the next word of the predicted command |
| `Alt+f` / `Alt+b` | Move forward / backward by one shell-aware word |
| `Alt+Backspace` | Delete the previous shell word |
| `(`, `[`, `"`, `'` | Auto-insert the matching closing character |
| `Backspace` | Delete an empty matching pair in one keystroke |

### Theme files

Two themes ship in `oh-my-posh/`:

- **`davde-theme-json`** — a fuller theme with session, path, Git, exit code, shell, battery, and Azure segments. Used by the standalone PowerShell host.
- **`sh.json`** — a lighter theme with session, path, Git, exit code, and Azure. Used inside VS Code (where vertical space matters more).

Editing themes? See `oh-my-posh-docs/00-overview.md` for a syntax reference, or the official site at [ohmyposh.dev/docs/configuration](https://ohmyposh.dev/docs/configuration/general).

### Performance optimizations in the `op_*` profiles

1. **Cached prompt init.** `oh-my-posh init` is run once and its output saved to `%LOCALAPPDATA%\oh-my-posh\init.<hash>.ps1`. The cache is invalidated automatically when the theme JSON or `oh-my-posh.exe` is updated.
2. **Lazy icon loading.** `Terminal-Icons` is imported on the first `OnIdle` event after your prompt appears, instead of blocking startup.
3. **PSReadLine auto-loaded.** No explicit `Import-Module PSReadLine` — pwsh loads it the first time `Set-PSReadLine*` is called.
4. **Trimmed key handlers.** Only frequently-used bindings are kept; the dozens of sample handlers from the original profile are removed.

Together these typically take cold start from ~700–1000 ms down to ~250–400 ms.
