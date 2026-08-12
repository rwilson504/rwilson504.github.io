<#
.SYNOPSIS
    Install repo-tracked git hooks into .git/hooks/.

.DESCRIPTION
    Copies hooks from .github/hooks/ into .git/hooks/ and marks them
    executable on Unix-like systems. Idempotent — re-run any time.

    Currently installs:
      - pre-push  (blocks `git push` if marketplace is out of sync)

.EXAMPLE
    pwsh .github/scripts/install-hooks.ps1
#>

[CmdletBinding()]
param(
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot/../..").Path
)

$ErrorActionPreference = 'Stop'

$srcDir = Join-Path $RepoRoot '.github/hooks'
$dstDir = Join-Path $RepoRoot '.git/hooks'

if (-not (Test-Path $srcDir)) { throw "Hooks source not found: $srcDir" }
if (-not (Test-Path $dstDir)) { throw ".git/hooks not found — is this a git repo?" }

$hooks = Get-ChildItem $srcDir -File
foreach ($h in $hooks) {
    $dst = Join-Path $dstDir $h.Name
    Copy-Item -Force $h.FullName $dst
    # Mark executable on Unix-like systems (no-op on Windows but safe)
    if ($IsLinux -or $IsMacOS) {
        chmod +x $dst
    }
    Write-Host "Installed: .git/hooks/$($h.Name)" -ForegroundColor Green
}

Write-Host ''
Write-Host "Hooks installed. Re-run this script after pulling new hook updates." -ForegroundColor DarkGray
