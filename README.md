# Shell Customizations

A portable collection of PowerShell profile configurations, Oh My Posh prompt themes, PSReadLine keybindings, and Nerd Fonts — designed to be cloned and linked into a new machine's PowerShell profile paths for a consistent, productive terminal experience.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation Guide](#installation-guide)
  - [Step 1 — Verify PowerShell Version](#step-1--verify-powershell-version)
  - [Step 2 — Install Oh My Posh](#step-2--install-oh-my-posh)
  - [Step 3 — Install Required PowerShell Modules](#step-3--install-required-powershell-modules)
  - [Step 4 — Install the Nerd Font](#step-4--install-the-nerd-font)
  - [Step 5 — Configure Your Terminal Font](#step-5--configure-your-terminal-font)
  - [Step 6 — Clone This Repository](#step-6--clone-this-repository)
  - [Step 7 — Find Your Profile Path](#step-7--find-your-profile-path)
  - [Step 8 — Back Up Existing Profiles](#step-8--back-up-existing-profiles)
  - [Step 9 — Create Symbolic Links](#step-9--create-symbolic-links)
  - [Step 10 — Verify the Setup](#step-10--verify-the-setup)
- [Repository Structure](#repository-structure)
- [How PowerShell Profiles Work](#how-powershell-profiles-work)
  - [What Is a Profile?](#what-is-a-profile)
  - [How the Host Determines Which Profile Loads](#how-the-host-determines-which-profile-loads)
  - [Why Symbolic Links?](#why-symbolic-links)
  - [Execution Order Inside the Profile](#execution-order-inside-the-profile)
- [Profile Differences: Console vs. VS Code](#profile-differences-console-vs-vs-code)
- [What the Profiles Configure](#what-the-profiles-configure)
  - [Modules Loaded](#modules-loaded)
  - [CLI Tab-Completion](#cli-tab-completion)
  - [PSReadLine Configuration](#psreadline-configuration)
- [Oh My Posh Themes](#oh-my-posh-themes)
- [Fonts](#fonts)
- [Troubleshooting](#troubleshooting)
- [Uninstalling](#uninstalling)

---

## Prerequisites

| Requirement | Minimum Version | How to Check |
|---|---|---|
| **Windows** | Windows 10 1903+ or Windows 11 | `winver` |
| **PowerShell** | 7.0+ (PowerShell Core) | `$PSVersionTable.PSVersion` |
| **Git** | Any recent version | `git --version` |
| **Windows Terminal** | Recommended (not required) | Available from Microsoft Store |
| **winget** | Any recent version (ships with Windows 11 / App Installer) | `winget --version` |

> **Note:** These profiles are designed for **PowerShell 7+** (pwsh.exe), not Windows PowerShell 5.1 (powershell.exe). While they may partially work on 5.1, some features (like `PredictionSource`, `AcceptNextSuggestionWord`, and the `using namespace` declarations) require PowerShell 7+.

---

## Installation Guide

### Step 1 — Verify PowerShell Version

Open a terminal and check your PowerShell version:

```powershell
$PSVersionTable.PSVersion
```

You should see version **7.x** or higher. If you see **5.1**, you're running Windows PowerShell, not PowerShell Core.

**To install PowerShell 7+:**

```powershell
winget install Microsoft.PowerShell
```

After installation, use `pwsh.exe` (not `powershell.exe`) to launch PowerShell 7.

### Step 2 — Install Oh My Posh

[Oh My Posh](https://ohmyposh.dev/) is the prompt theme engine used by both profiles.

```powershell
winget install JanDeDobbeleer.OhMyPosh
```

After installation, **restart your terminal** so that `oh-my-posh` is available on your `PATH`.

Verify the installation:

```powershell
oh-my-posh --version
```

### Step 3 — Install Required PowerShell Modules

```powershell
# Terminal-Icons — adds file/folder icons to directory listings (used by the console profile)
Install-Module -Name Terminal-Icons -Scope CurrentUser -Force

# PSReadLine — should already be included with PowerShell 7+, but update to latest
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
```

### Step 4 — Install the Nerd Font

The Oh My Posh themes use powerline glyphs and icons that require a **Nerd Font**. This repo includes the **Caskaydia Cove Nerd Font** (a patched version of Cascadia Code) in the `fonts/` directory.

**Option A — Manual install:**
1. Navigate to the `fonts/` folder in this repo
2. Double-click `Caskaydia Cove Nerd Font Complete Mono Windows Compatible.ttf`
3. Click **Install**

**Option B — Install for all users (requires Admin):**
1. Copy the `.ttf` files to `C:\Windows\Fonts`

**Option C — Install via Oh My Posh:**
```powershell
oh-my-posh font install CascadiaCode
```

### Step 5 — Configure Your Terminal Font

After installing the font, configure your terminal application to use it.

#### Windows Terminal

1. Open **Settings** (Ctrl+,)
2. Select a profile (e.g., **PowerShell**) under **Profiles**
3. Go to **Appearance**
4. Set **Font face** to `CaskaydiaCove Nerd Font Mono`
5. Click **Save**

Alternatively, edit `settings.json` directly:

```json
{
    "profiles": {
        "defaults": {
            "font": {
                "face": "CaskaydiaCove Nerd Font Mono"
            }
        }
    }
}
```

#### VS Code

1. Open **Settings** (Ctrl+,)
2. Search for `terminal.integrated.fontFamily`
3. Set the value to `CaskaydiaCove Nerd Font Mono`

Or add to `settings.json`:

```json
{
    "terminal.integrated.fontFamily": "CaskaydiaCove Nerd Font Mono"
}
```

### Step 6 — Clone This Repository

Clone the repo to a permanent location on your machine. This location matters — the symbolic links will point here, so don't move or delete it later.

```powershell
# Example: clone to a repos folder
cd C:\Github Repos
git clone https://github.com/davde-ms/shell_customizations.git
```

> **Important:** Remember the full path to the cloned repo. You'll need it in Step 9. In the examples below, we use `C:\Github Repos\shell_customizations` — replace this with your actual path.

### Step 7 — Find Your Profile Path

PowerShell stores your profile path in the `$PROFILE` variable. The exact location depends on your system configuration — it may be in your local `Documents` folder, or it might be redirected to OneDrive.

Run this to see all profile paths:

```powershell
$PROFILE | Format-List -Force
```

Example output:

```
AllUsersAllHosts       : C:\Program Files\PowerShell\7\profile.ps1
AllUsersCurrentHost    : C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\you\Documents\PowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\you\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

The path you care about is **CurrentUserCurrentHost**. Common locations:

| Scenario | Typical Path |
|---|---|
| Standard local Documents | `C:\Users\<you>\Documents\PowerShell\` |
| OneDrive Personal folder redirect | `C:\Users\<you>\OneDrive\Documents\PowerShell\` |
| OneDrive for Business folder redirect | `C:\Users\<you>\OneDrive - <OrgName>\Documents\PowerShell\` |

> **Tip:** Save the profile directory to a variable for the next steps:
> ```powershell
> $profileDir = Split-Path $PROFILE
> ```

If the profile directory doesn't exist yet, create it:

```powershell
$profileDir = Split-Path $PROFILE
if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}
```

### Step 8 — Back Up Existing Profiles

If you already have profile files, back them up before creating symbolic links. The symlink creation will replace any existing files at the target path.

```powershell
$profileDir = Split-Path $PROFILE

# Back up PowerShell console profile (if it exists)
$psProfile = Join-Path $profileDir "Microsoft.PowerShell_profile.ps1"
if (Test-Path $psProfile) {
    Copy-Item $psProfile "$psProfile.bak"
    Write-Host "Backed up: $psProfile -> $psProfile.bak"
}

# Back up VS Code profile (if it exists)
$vscProfile = Join-Path $profileDir "Microsoft.VSCode_profile.ps1"
if (Test-Path $vscProfile) {
    Copy-Item $vscProfile "$vscProfile.bak"
    Write-Host "Backed up: $vscProfile -> $vscProfile.bak"
}
```

### Step 9 — Create Symbolic Links

Symbolic links make your profile path point to the files in this repo. This means any changes you pull from the repo are immediately active, and `$PSScriptRoot` resolves to the repo directory (so theme paths like `$PSScriptRoot\oh-my-posh\sh.json` work correctly).

> **You must run this in an elevated (Administrator) PowerShell terminal.**

```powershell
# Set these to match your setup
$repoPath = "C:\Github Repos\shell_customizations"   # <-- change this to your clone path
$profileDir = Split-Path $PROFILE

# Remove existing files (already backed up in Step 8)
$psProfile = Join-Path $profileDir "Microsoft.PowerShell_profile.ps1"
$vscProfile = Join-Path $profileDir "Microsoft.VSCode_profile.ps1"

if (Test-Path $psProfile) { Remove-Item $psProfile -Force }
if (Test-Path $vscProfile) { Remove-Item $vscProfile -Force }

# Create symbolic links
New-Item -ItemType SymbolicLink -Path $psProfile -Target (Join-Path $repoPath "Microsoft.PowerShell_profile.ps1")
New-Item -ItemType SymbolicLink -Path $vscProfile -Target (Join-Path $repoPath "Microsoft.VSCode_profile.ps1")
```

Verify the links were created:

```powershell
Get-Item $psProfile | Select-Object FullName, LinkTarget
Get-Item $vscProfile | Select-Object FullName, LinkTarget
```

You should see `LinkTarget` pointing to the repo files.

### Step 10 — Verify the Setup

1. **Close all terminals** (PowerShell console, VS Code, Windows Terminal)
2. **Open a new PowerShell console** — you should see the Oh My Posh prompt with powerline glyphs
3. **Open VS Code's integrated terminal** — you should see the simpler single-line prompt

If you see broken characters (rectangles, question marks), your terminal font is not set to a Nerd Font — revisit [Step 5](#step-5--configure-your-terminal-font).

---

## Repository Structure

```
├── Microsoft.PowerShell_profile.ps1   # Profile for the standard PowerShell console
├── Microsoft.VSCode_profile.ps1       # Profile for the VS Code integrated terminal
├── fonts/
│   ├── Caskaydia Cove Nerd Font Complete.ttf
│   ├── Caskaydia Cove Nerd Font Complete Mono.ttf
│   └── Caskaydia Cove Nerd Font Complete Mono Windows Compatible.ttf
├── oh-my-posh/
│   ├── davde-theme-json               # Multi-line powerline prompt theme (console)
│   └── sh.json                        # Simpler single-line prompt theme (VS Code)
├── LICENSE
└── README.md
```

---

## How PowerShell Profiles Work

### What Is a Profile?

A PowerShell profile is a `.ps1` script that runs automatically every time a new PowerShell session starts. It's the equivalent of `.bashrc` or `.zshrc` in Unix shells. You use it to load modules, set aliases, configure keybindings, and customize your prompt.

### How the Host Determines Which Profile Loads

PowerShell supports multiple "hosts" — each host is an application that embeds the PowerShell engine. The two most common are:

| Host Name | Application | Profile Filename |
|---|---|---|
| `ConsoleHost` | Windows Terminal, pwsh.exe, standard console | `Microsoft.PowerShell_profile.ps1` |
| `Visual Studio Code Host` | VS Code integrated terminal | `Microsoft.VSCode_profile.ps1` |

When PowerShell starts, it:
1. Detects which host it's running inside
2. Resolves the `$PROFILE` path based on the host name
3. Looks for the profile file at that path
4. Executes it line-by-line if found

This is why this repo has **two separate profile files** — PowerShell automatically picks the right one based on where you open your terminal.

### Why Symbolic Links?

You could simply copy the profile files to your `$PROFILE` directory, but symbolic links offer two advantages:

1. **Single source of truth** — Pulling updates from this repo via `git pull` immediately updates your active profiles. No need to re-copy files.
2. **`$PSScriptRoot` resolution** — The VS Code profile references `$PSScriptRoot\oh-my-posh\sh.json`. When accessed through a symlink, `$PSScriptRoot` resolves to the **repo directory** (where the `oh-my-posh/` folder exists). If you copy the file instead, `$PSScriptRoot` would resolve to your `Documents\PowerShell\` directory, and the theme file wouldn't be found.

### Execution Order Inside the Profile

When the profile runs, the following happens in order:

```
1. using namespace declarations
   (System.Management.Automation, System.Management.Automation.Language)
        │
2. Module imports
   (PSReadLine, Terminal-Icons)
        │
3. Oh My Posh initialization
   (runs oh-my-posh.exe → generates prompt functions → Invoke-Expression)
        │
4. CLI argument completers registered
   (winget, dotnet — callbacks stored, not executed yet)
        │
5. PSReadLine keybindings registered
   (~15 key handlers — callbacks stored, not executed yet)
        │
6. PSReadLine options set
   (prediction source, view style, edit mode)
        │
7. Command validation handler registered
   (git cmt → git commit auto-correction)
        │
8. Build macro keybindings registered
   (Ctrl+Shift+B, Ctrl+Shift+T)
        │
   ✓ Shell is ready — prompt displayed
```

---

## Profile Differences: Console vs. VS Code

The VS Code profile is intentionally lighter for use in VS Code's smaller terminal panel, where much of the visual context (Git, Azure, file icons) is already provided by the editor itself.

| Feature | Console Profile | VS Code Profile |
|---|---|---|
| **Oh My Posh theme** | `davde-theme-json` via OneDrive (multi-line, 4 rows) | `sh.json` from this repo (single-line) |
| **Terminal-Icons** | Loaded | Commented out |
| **PredictionViewStyle** | `ListView` (dropdown menu) | `InlineView` (subtle ghost text) |
| **PSReadLine keybindings** | All | All (identical) |
| **Tab completers** | winget + dotnet | winget + dotnet (identical) |

---

## What the Profiles Configure

### Modules Loaded

| Module | Console | VS Code | Purpose |
|---|---|---|---|
| **PSReadLine** | Yes | Yes | Advanced command-line editing (auto-loaded on PS 7+, explicitly imported for PS 5.1 `ConsoleHost`) |
| **Terminal-Icons** | Yes | No | Adds file/folder icons to `Get-ChildItem` output |

### CLI Tab-Completion

Native argument completers are registered for:

| CLI | What It Enables |
|---|---|
| **winget** | Tab-completion for all `winget` commands, arguments, and package names |
| **dotnet** | Tab-completion for `dotnet` CLI commands and options |

These are lazy — the completer callbacks only run when you press `Tab` after typing the command name.

### PSReadLine Configuration

#### General Options

| Option | Console | VS Code |
|---|---|---|
| `PredictionSource` | `History` | `History` |
| `PredictionViewStyle` | `ListView` | `InlineView` |
| `EditMode` | `Windows` | `Windows` |

#### Keybindings Reference

**History & Navigation:**

| Key | Action |
|---|---|
| `Up Arrow` | Search backward through history matching current input |
| `Down Arrow` | Search forward through history matching current input |
| `F7` | Open interactive history browser in `Out-GridView` (supports filtering and multi-select) |
| `Right Arrow` | Move cursor right, or accept the next suggested word when at end of line |

**Smart Insert / Delete:**

| Key | Action |
|---|---|
| `"` or `'` | Smart quote insertion — auto-pairs quotes, wraps selected text, skips closing quotes contextually |
| `(`, `{`, `[` | Auto-insert matching closing brace; wraps selected text if a selection exists |
| `)`, `]`, `}` | Skip over the closing character if it already exists, otherwise insert |
| `Backspace` | Delete matching pairs (quotes, braces) together when cursor is between them |

**Word Movement (Emacs-style):**

| Key | Action |
|---|---|
| `Alt+b` | Move backward one shell word |
| `Alt+f` | Move forward one shell word |
| `Alt+B` | Select backward one shell word |
| `Alt+F` | Select forward one shell word |
| `Alt+d` | Delete the next shell word |
| `Alt+Backspace` | Delete the previous shell word |

**Text Manipulation:**

| Key | Action |
|---|---|
| `Ctrl+V` | Paste clipboard contents as a PowerShell here-string (`@'...'@`) |
| `Alt+(` | Wrap the current selection (or entire line) in parentheses |
| `Alt+'` | Cycle the token under the cursor through: no quotes → single quotes → double quotes |
| `Alt+%` | Expand all aliases on the current line to their full command names |
| `Alt+a` | Cycle through and select command arguments on the current line (supports digit argument for position) |
| `Alt+w` | Save the current line to history without executing it |

**Directory Bookmarks:**

| Key | Action |
|---|---|
| `Ctrl+J` then a key | Mark the current directory with that key |
| `Ctrl+j` then a key | Jump to the directory previously marked with that key |
| `Alt+j` | Show all currently marked directories |

**Build Macros:**

| Key | Action |
|---|---|
| `Ctrl+Shift+B` | Run `dotnet build` in the current directory |
| `Ctrl+Shift+T` | Run `dotnet test` in the current directory |

**Other:**

| Key | Action |
|---|---|
| `F1` | Open the help window for the command under the cursor |
| `Ctrl+D, Ctrl+C` | Capture the current screen (useful for sharing terminal sessions) |

#### Command Auto-Correction

A command validation handler automatically corrects common Git typos:

| Typed | Corrected To |
|---|---|
| `git cmt` | `git commit` |

---

## Oh My Posh Themes

### `davde-theme-json` — Multi-Line Powerline Theme

Used by the **console profile**. A feature-rich, multi-line prompt with four rows:

**Row 1 (left-aligned):**
- **Session** — Username, hostname, and SSH indicator (blue `#0077c2` background)
- **Path** — Current folder name with folder icon
- **Git** — Branch name, ahead/behind status, working/staging changes, stash count. Background changes color based on state:
  - Yellow `#fffb38` — clean
  - Orange `#FF9248` — uncommitted changes
  - Red-orange `#ff4500` — diverged (ahead AND behind)
  - Purple `#B388FF` — ahead or behind only
- **Exit code** — Green checkmark on success, red error symbol with meaning on failure

**Row 1 (right-aligned):**
- **Shell name** — Shows the current shell (e.g., `pwsh`)
- **Battery** — Percentage and icon with color-coded state (charging/discharging/full)

**Row 2:**
- **Azure context** — Current Azure subscription name and environment (displays "Global" for AzureCloud)

**Row 3:**
- **Input prompt** — A ` => ` indicator for command input

### `sh.json` — Simple Single-Line Theme

Used by the **VS Code profile**. A compact single-line powerline prompt with:
- **Path** — Current folder (pink `#ff479c` background)
- **Git** — Branch and status (yellow `#fffb38` background)
- **.NET version** — Current SDK version (green `#6CA35E` background)
- **Root indicator** — Warning when running as admin
- **Exit code** — Color-coded background (teal on success, red on error)

---

## Fonts

The `fonts/` directory contains the **Caskaydia Cove Nerd Font** (patched Cascadia Code), which is required for rendering the powerline glyphs, icons, and special characters used by the Oh My Posh themes and Terminal-Icons module.

| File | Variant | Recommended For |
|---|---|---|
| `Caskaydia Cove Nerd Font Complete.ttf` | Proportional | General use |
| `Caskaydia Cove Nerd Font Complete Mono.ttf` | Monospaced | Terminal use |
| `Caskaydia Cove Nerd Font Complete Mono Windows Compatible.ttf` | Monospaced (Windows metrics) | Windows Terminal / VS Code |

> **Use the Mono variant for terminals.** Proportional fonts cause alignment issues with powerline segments.

---

## Troubleshooting

### Broken characters (squares, question marks) in the prompt

Your terminal font is not set to a Nerd Font. See [Step 5 — Configure Your Terminal Font](#step-5--configure-your-terminal-font).

### `oh-my-posh: The term 'oh-my-posh' is not recognized`

Oh My Posh is not installed or not on your `PATH`. Install it with `winget install JanDeDobbeleer.OhMyPosh` and restart your terminal.

### `The file ... cannot be loaded because running scripts is disabled`

PowerShell's execution policy is blocking the profile. Run this in an elevated PowerShell:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Oh My Posh theme not found (VS Code profile)

If you copied the profile file instead of creating a symlink, `$PSScriptRoot` points to your `Documents\PowerShell\` directory instead of the repo. Either:
- Create a symlink (recommended — see [Step 9](#step-9--create-symbolic-links))
- Or change the theme path in the VS Code profile to an absolute path:
  ```powershell
  oh-my-posh init pwsh --config "C:\Github Repos\shell_customizations\oh-my-posh\sh.json" | Invoke-Expression
  ```

### Profile loads slowly

Oh My Posh initialization takes ~100-200ms. If startup feels slow:
- Run `oh-my-posh debug` to see timing
- Run `Measure-Command { & $PROFILE }` to measure total profile load time
- Consider caching the Oh My Posh init output (see the wiki or Oh My Posh docs)

### `Terminal-Icons` not showing icons

Ensure you're using a Nerd Font in your terminal. Terminal-Icons requires Nerd Font glyphs for file/folder icons.

### Symlink creation fails with "Access denied"

You must run the `New-Item -ItemType SymbolicLink` command from an **elevated (Administrator)** PowerShell session. Right-click Windows Terminal or pwsh and select "Run as Administrator".

### How do I check if my profile is a symlink?

```powershell
Get-Item $PROFILE | Select-Object FullName, LinkTarget, Attributes
```

If `LinkTarget` shows a path, it's a symlink. If it's empty, it's a regular file.

---

## Uninstalling

To restore your original profiles and remove the symlinks:

```powershell
$profileDir = Split-Path $PROFILE

# Remove the symlinks
Remove-Item (Join-Path $profileDir "Microsoft.PowerShell_profile.ps1") -Force
Remove-Item (Join-Path $profileDir "Microsoft.VSCode_profile.ps1") -Force

# Restore backups (if you created them in Step 8)
$psBackup = Join-Path $profileDir "Microsoft.PowerShell_profile.ps1.bak"
$vscBackup = Join-Path $profileDir "Microsoft.VSCode_profile.ps1.bak"

if (Test-Path $psBackup) { Rename-Item $psBackup "Microsoft.PowerShell_profile.ps1" }
if (Test-Path $vscBackup) { Rename-Item $vscBackup "Microsoft.VSCode_profile.ps1" }
```

To uninstall Oh My Posh:

```powershell
winget uninstall JanDeDobbeleer.OhMyPosh
```

To uninstall the modules:

```powershell
Uninstall-Module -Name Terminal-Icons
Uninstall-Module -Name PSReadLine
```
