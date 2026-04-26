# Optimized VS Code profile (op_ variant)
#
# Thin wrapper around op_Microsoft.PowerShell_profile.ps1: just pins the
# theme and dot-sources the main profile. Keeps the two profiles in sync.

$env:OMP_THEME = "$PSScriptRoot\oh-my-posh\sh.json"
. "$PSScriptRoot\op_Microsoft.PowerShell_profile.ps1"
