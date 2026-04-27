using namespace System.Management.Automation
using namespace System.Management.Automation.Language

# ---------------------------------------------------------------------------
# Optimized PowerShell profile (op_ variant)
#
# Key load-time optimizations vs. the original:
#   1. oh-my-posh init output is cached and dot-sourced (skips spawning
#      oh-my-posh.exe on every shell start).
#   2. Terminal-Icons is deferred until the first idle tick.
#   3. PSReadLine is not explicitly imported (pwsh auto-loads it on first
#      Set-PSReadLine* call).
#   4. PSReadLine options are set BEFORE the (now trimmed) key handler block.
#   5. Theme can be overridden by the VS Code wrapper via $env:OMP_THEME.
# ---------------------------------------------------------------------------

# Resolve the repo root. Three strategies, in order:
#   1. $env:SHELL_CUSTOMIZATIONS_ROOT (set by Switch-Profile.ps1; works for
#      both symlinked and copied installs).
#   2. The symlink target of $PSCommandPath (works when the profile is a
#      symlink and the env var is not set).
#   3. $PSScriptRoot (works when the profile is dot-sourced from the repo).
$repoRoot = $null
if ($env:SHELL_CUSTOMIZATIONS_ROOT -and (Test-Path -LiteralPath $env:SHELL_CUSTOMIZATIONS_ROOT)) {
    $repoRoot = $env:SHELL_CUSTOMIZATIONS_ROOT
} else {
    try {
        $self = Get-Item -LiteralPath $PSCommandPath -Force -ErrorAction Stop
        if ($self.LinkType -eq 'SymbolicLink' -and $self.Target) {
            $target = if ([System.IO.Path]::IsPathRooted($self.Target)) {
                $self.Target
            } else {
                Join-Path $PSScriptRoot $self.Target
            }
            $repoRoot = Split-Path -Parent (Resolve-Path -LiteralPath $target).Path
        }
    } catch {}
}
if (-not $repoRoot) { $repoRoot = $PSScriptRoot }

# region: Oh My Posh (cached)

$ompTheme = if ($env:OMP_THEME) {
    $env:OMP_THEME
} elseif ($env:TERM_PROGRAM -eq 'vscode') {
    Join-Path $repoRoot 'oh-my-posh\sh.json'
} else {
    # Existing layout used $env:OneDriveConsumer\Documents\oh-my-posh\mytheme.json.
    # Prefer the repo-local theme first, fall back to the OneDrive copy.
    $local = Join-Path $repoRoot 'oh-my-posh\davde-theme.json'
    if (Test-Path $local) { $local } else { "$env:OneDriveConsumer\Documents\oh-my-posh\mytheme.json" }
}

if (Test-Path $ompTheme) {
    $cacheDir = Join-Path $env:LOCALAPPDATA 'oh-my-posh'
    if (-not (Test-Path $cacheDir)) { $null = New-Item -ItemType Directory -Path $cacheDir -Force }

    # Cache key: theme path + theme mtime + omp.exe mtime. If any changes, regenerate.
    $ompExe   = (Get-Command oh-my-posh -ErrorAction SilentlyContinue).Source
    $themeMt  = (Get-Item $ompTheme).LastWriteTimeUtc.Ticks
    $exeMt    = if ($ompExe) { (Get-Item $ompExe).LastWriteTimeUtc.Ticks } else { 0 }
    $key      = "{0}|{1}|{2}" -f $ompTheme, $themeMt, $exeMt
    $hash     = [BitConverter]::ToString(
                    [System.Security.Cryptography.SHA1]::HashData(
                        [System.Text.Encoding]::UTF8.GetBytes($key))).Replace('-', '').Substring(0, 16)
    $cacheFile = Join-Path $cacheDir "init.$hash.ps1"

    if (-not (Test-Path $cacheFile)) {
        # Clean stale entries for this theme
        Get-ChildItem $cacheDir -Filter 'init.*.ps1' -ErrorAction SilentlyContinue |
            Remove-Item -Force -ErrorAction SilentlyContinue
        oh-my-posh init pwsh --config $ompTheme | Set-Content -LiteralPath $cacheFile -Encoding UTF8
    }

    . $cacheFile
}

# endregion

# region: Argument completers (cheap - registration only; script blocks run on Tab)

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast  = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# endregion

# region: PSReadLine options (set first so prediction is active ASAP)

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# endregion

# region: PSReadLine key handlers (trimmed to the daily-useful ones)

# History search with Up/Down
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Token-aware word movement (Alt+...)
Set-PSReadLineKeyHandler -Key Alt+d         -Function ShellKillWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+b         -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+f         -Function ShellForwardWord
Set-PSReadLineKeyHandler -Key Alt+B         -Function SelectShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+F         -Function SelectShellForwardWord

# RightArrow at end-of-line accepts the next predicted word instead of the whole suggestion.
Set-PSReadLineKeyHandler -Key RightArrow `
                         -BriefDescription ForwardCharAndAcceptNextSuggestionWord `
                         -LongDescription "Move right; at EOL accept next predicted word" `
                         -ScriptBlock {
    param($key, $arg)
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($cursor -lt $line.Length) {
        [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
    }
}

# Smart insert/delete for paired quotes and brackets.

Set-PSReadLineKeyHandler -Key '"',"'" `
                         -BriefDescription SmartInsertQuote `
                         -LongDescription "Insert paired quotes if not already on a quote" `
                         -ScriptBlock {
    param($key, $arg)
    $quote = $key.KeyChar

    $selectionStart = $null; $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($selectionStart -ne -1) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
            $selectionStart, $selectionLength,
            $quote + $line.SubString($selectionStart, $selectionLength) + $quote)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
        return
    }

    $ast = $null; $tokens = $null; $parseErrors = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$parseErrors, [ref]$null)

    function FindToken {
        param($tokens, $cursor)
        foreach ($token in $tokens) {
            if ($cursor -lt $token.Extent.StartOffset) { continue }
            if ($cursor -lt $token.Extent.EndOffset) {
                $result = $token
                $token  = $token -as [StringExpandableToken]
                if ($token) {
                    $nested = FindToken $token.NestedTokens $cursor
                    if ($nested) { $result = $nested }
                }
                return $result
            }
        }
        return $null
    }

    $token = FindToken $tokens $cursor

    if ($token -is [StringToken] -and $token.Kind -ne [TokenKind]::Generic) {
        if ($token.Extent.StartOffset -eq $cursor) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$quote$quote ")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
            return
        }
        if ($token.Extent.EndOffset -eq ($cursor + 1) -and $line[$cursor] -eq $quote) {
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
            return
        }
    }

    if ($null -eq $token -or
        $token.Kind -eq [TokenKind]::RParen -or $token.Kind -eq [TokenKind]::RCurly -or $token.Kind -eq [TokenKind]::RBracket) {
        if ($line[0..$cursor].Where{$_ -eq $quote}.Count % 2 -eq 1) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($quote)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$quote$quote")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
        }
        return
    }

    if ($token.Extent.StartOffset -eq $cursor) {
        if ($token.Kind -eq [TokenKind]::Generic -or $token.Kind -eq [TokenKind]::Identifier -or
            $token.Kind -eq [TokenKind]::Variable -or $token.TokenFlags.hasFlag([TokenFlags]::Keyword)) {
            $end = $token.Extent.EndOffset
            $len = $end - $cursor
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace($cursor, $len, $quote + $line.SubString($cursor, $len) + $quote)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($end + 2)
            return
        }
    }

    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($quote)
}

Set-PSReadLineKeyHandler -Key '(','{','[' `
                         -BriefDescription InsertPairedBraces `
                         -LongDescription "Insert matching braces" `
                         -ScriptBlock {
    param($key, $arg)
    $closeChar = switch ($key.KeyChar) {
        '(' { [char]')'; break }
        '{' { [char]'}'; break }
        '[' { [char]']'; break }
    }

    $selectionStart = $null; $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($selectionStart -ne -1) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
            $selectionStart, $selectionLength,
            $key.KeyChar + $line.SubString($selectionStart, $selectionLength) + $closeChar)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
}

Set-PSReadLineKeyHandler -Key ')',']','}' `
                         -BriefDescription SmartCloseBraces `
                         -LongDescription "Insert closing brace or skip" `
                         -ScriptBlock {
    param($key, $arg)
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[$cursor] -eq $key.KeyChar) {
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)")
    }
}

Set-PSReadLineKeyHandler -Key Backspace `
                         -BriefDescription SmartBackspace `
                         -LongDescription "Delete previous character or matching pair" `
                         -ScriptBlock {
    param($key, $arg)
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($cursor -gt 0) {
        $toMatch = $null
        if ($cursor -lt $line.Length) {
            switch ($line[$cursor]) {
                '"' { $toMatch = '"'; break }
                "'" { $toMatch = "'"; break }
                ')' { $toMatch = '('; break }
                ']' { $toMatch = '['; break }
                '}' { $toMatch = '{'; break }
            }
        }
        if ($null -ne $toMatch -and $line[$cursor - 1] -eq $toMatch) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 1, 2)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
        }
    }
}

# endregion

# region: Deferred imports (run after first prompt is on screen)

$null = Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -MaxTriggerCount 1 -Action {
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
}

# endregion
