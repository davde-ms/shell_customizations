[CmdletBinding(DefaultParameterSetName = 'Status')]
param(
    [Parameter(ParameterSetName = 'Switch', Position = 0, Mandatory)]
    [ValidateSet('Original', 'Optimized')]
    [string]$Variant,

    [Parameter(ParameterSetName = 'Status')]
    [switch]$Status
)

# -------------------------------------------------------------------------
# Switch-Profile.ps1
#
# Repoints the user's PowerShell profile files (for both ConsoleHost and the
# VS Code integrated terminal) to either the Original or Optimized profile
# variant in this repo.
#
#   .\Switch-Profile.ps1                    # show current state
#   .\Switch-Profile.ps1 Optimized          # use op_* variants
#   .\Switch-Profile.ps1 Original           # use original variants
#
# Symlinks are used so edits in the repo are picked up on next shell start.
# Creating symlinks on Windows requires either (a) running as Administrator
# or (b) Developer Mode enabled. The script will fall back to a hard copy
# with a warning if symlink creation fails.
# -------------------------------------------------------------------------

$ErrorActionPreference = 'Stop'

# Resolve the profile directory once (CurrentUserAllHosts lives next to both
# Microsoft.PowerShell_profile.ps1 and Microsoft.VSCode_profile.ps1).
$profileDir = Split-Path -Parent $PROFILE.CurrentUserAllHosts

$repoRoot = $PSScriptRoot

# Map: live profile filename -> @(originalSource, optimizedSource)
$mapping = [ordered]@{
    'Microsoft.PowerShell_profile.ps1' = @{
        Original  = Join-Path $repoRoot 'Microsoft.PowerShell_profile.ps1'
        Optimized = Join-Path $repoRoot 'op_Microsoft.PowerShell_profile.ps1'
    }
    'Microsoft.VSCode_profile.ps1' = @{
        Original  = Join-Path $repoRoot 'Microsoft.VSCode_profile.ps1'
        Optimized = Join-Path $repoRoot 'op_Microsoft.VSCode_profile.ps1'
    }
}

function Get-LinkTarget {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    $item = Get-Item -LiteralPath $Path -Force
    # SymbolicLink, HardLink, Junction
    if ($item.LinkType) { return $item.Target -join ',' }
    return '(file, not a link)'
}

function Get-CurrentVariant {
    param([hashtable]$Sources, [string]$LivePath)
    $target = Get-LinkTarget -Path $LivePath
    if ($null -eq $target) { return 'Missing' }
    # Compare resolved paths case-insensitively
    $resolved = try { (Resolve-Path -LiteralPath $target -ErrorAction Stop).Path } catch { $target }
    foreach ($name in 'Original', 'Optimized') {
        if ($resolved -ieq (Resolve-Path -LiteralPath $Sources[$name]).Path) { return $name }
    }
    return 'Unknown'
}

function Show-Status {
    Write-Host ''
    Write-Host "Profile directory: $profileDir" -ForegroundColor DarkGray
    Write-Host ''
    foreach ($name in $mapping.Keys) {
        $live    = Join-Path $profileDir $name
        $sources = $mapping[$name]
        $current = Get-CurrentVariant -Sources $sources -LivePath $live
        $target  = Get-LinkTarget -Path $live
        $color   = switch ($current) {
            'Optimized' { 'Green' }
            'Original'  { 'Cyan' }
            'Missing'   { 'DarkGray' }
            default     { 'Yellow' }
        }
        Write-Host ("  {0,-38} -> " -f $name) -NoNewline
        Write-Host $current -ForegroundColor $color -NoNewline
        if ($target) { Write-Host "  ($target)" -ForegroundColor DarkGray } else { Write-Host '' }
    }
    Write-Host ''
}

function Set-ProfileLink {
    param(
        [string]$LivePath,
        [string]$SourcePath
    )

    if (-not (Test-Path -LiteralPath $SourcePath)) {
        throw "Source profile not found: $SourcePath"
    }

    # Back up an existing real file (not a link) once, just in case.
    if (Test-Path -LiteralPath $LivePath) {
        $existing = Get-Item -LiteralPath $LivePath -Force
        if (-not $existing.LinkType) {
            $backup = "$LivePath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Write-Warning "Backing up existing real file to: $backup"
            Move-Item -LiteralPath $LivePath -Destination $backup -Force
        } else {
            Remove-Item -LiteralPath $LivePath -Force
        }
    } else {
        $parent = Split-Path -Parent $LivePath
        if (-not (Test-Path -LiteralPath $parent)) {
            $null = New-Item -ItemType Directory -Path $parent -Force
        }
    }

    try {
        $null = New-Item -ItemType SymbolicLink -Path $LivePath -Target $SourcePath -ErrorAction Stop
        Write-Host "  linked  $LivePath  ->  $SourcePath" -ForegroundColor Green
    } catch {
        Write-Warning "Symlink creation failed ($($_.Exception.Message)). Falling back to copy."
        Copy-Item -LiteralPath $SourcePath -Destination $LivePath -Force
        Write-Host "  copied  $SourcePath  ->  $LivePath" -ForegroundColor Yellow
        Write-Host "  (Edits to the repo file will NOT propagate until you re-run this script.)" -ForegroundColor DarkYellow
    }
}

if ($PSCmdlet.ParameterSetName -eq 'Status' -or -not $Variant) {
    Show-Status
    return
}

Write-Host ''
Write-Host "Switching to: $Variant" -ForegroundColor Magenta
foreach ($name in $mapping.Keys) {
    $live   = Join-Path $profileDir $name
    $source = $mapping[$name][$Variant]
    Set-ProfileLink -LivePath $live -SourcePath $source
}

Write-Host ''
Show-Status
Write-Host 'Open a new shell (or reload VS Code terminal) for changes to take effect.' -ForegroundColor DarkGray
