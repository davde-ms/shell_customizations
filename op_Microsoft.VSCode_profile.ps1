# Optimized VS Code profile (op_ variant)
#
# Thin wrapper around op_Microsoft.PowerShell_profile.ps1: just pins the
# theme and dot-sources the main profile.
#
# Resolves the repo root via three strategies (env var > symlink target >
# $PSScriptRoot) so it works whether installed by symlink or by copy.

$here = $null
if ($env:SHELL_CUSTOMIZATIONS_ROOT -and (Test-Path -LiteralPath $env:SHELL_CUSTOMIZATIONS_ROOT)) {
    $here = $env:SHELL_CUSTOMIZATIONS_ROOT
} else {
    try {
        $self = Get-Item -LiteralPath $PSCommandPath -Force -ErrorAction Stop
        if ($self.LinkType -eq 'SymbolicLink' -and $self.Target) {
            $target = if ([System.IO.Path]::IsPathRooted($self.Target)) {
                $self.Target
            } else {
                Join-Path $PSScriptRoot $self.Target
            }
            $here = Split-Path -Parent (Resolve-Path -LiteralPath $target).Path
        }
    } catch {}
}
if (-not $here) { $here = $PSScriptRoot }

$env:OMP_THEME = Join-Path $here 'oh-my-posh\sh.json'
. (Join-Path $here 'op_Microsoft.PowerShell_profile.ps1')
