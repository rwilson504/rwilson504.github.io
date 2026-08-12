<#
.SYNOPSIS
    Sync agents/skills/prompts between this repo and the marketplace.

.DESCRIPTION
    The marketplace at https://github.com/rwilson504/agent-plugins-personal
    is the source of truth. This script keeps .github/agents/, .github/skills/,
    and .github/prompts/ in sync with marketplace src/.

    Modes:
      -Pull   Pull latest from marketplace into this repo (overwrite local).
      -Push   Push local changes to marketplace src/, build plugins, commit, push.
      -Check  Compare local files against marketplace cache; nonzero exit on drift.

    The marketplace aggregates content from several consumer repos, so this
    repo is not its sole source. -Push is therefore ADDITIVE: it overwrites
    and adds, but never deletes marketplace items that are absent here.
    -Check reports marketplace-only items as informational, not drift.
    -Pull remains a true mirror (marketplace wins, local extras are removed).

    The marketplace is cached at .marketplace-cache/ (gitignored). The cache
    is created on first run and updated thereafter.

.PARAMETER Pull
    Update this repo's .github/agents, /skills, /prompts from the marketplace's
    src/ tree. Local files in those directories are overwritten.

.PARAMETER Push
    Copy this repo's .github/agents, /skills, /prompts into the marketplace's
    src/ tree, run the marketplace build, commit, and push. Additive only —
    content owned by other repos is left untouched.

.PARAMETER Check
    Verify local files match the marketplace. Exits 1 with a list of
    differences if drift is detected. Used by the pre-push git hook.

.PARAMETER Message
    Required with -Push. Commit message for the marketplace commit.

.PARAMETER DryRun
    Show what would be copied without making changes.

.EXAMPLE
    pwsh .github/scripts/sync-agents.ps1 -Pull

.EXAMPLE
    pwsh .github/scripts/sync-agents.ps1 -Push -Message "skill(cad-build123d-general): note OCCT shell-fix workaround"

.EXAMPLE
    pwsh .github/scripts/sync-agents.ps1 -Check
#>

[CmdletBinding(DefaultParameterSetName = 'Pull')]
param(
    [Parameter(ParameterSetName = 'Pull', Mandatory)]
    [switch]$Pull,

    [Parameter(ParameterSetName = 'Push', Mandatory)]
    [switch]$Push,

    [Parameter(ParameterSetName = 'Push', Mandatory)]
    [string]$Message,

    [Parameter(ParameterSetName = 'Check', Mandatory)]
    [switch]$Check,

    [switch]$DryRun,

    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot/../..").Path,
    [string]$MarketplaceUrl = 'https://github.com/rwilson504/agent-plugins-personal.git',
    [string]$CacheDir = (Join-Path (Resolve-Path "$PSScriptRoot/../..").Path '.marketplace-cache')
)

$ErrorActionPreference = 'Stop'

# --- Paths ---
$localAgents  = Join-Path $RepoRoot '.github/agents'
$localSkills  = Join-Path $RepoRoot '.github/skills'
$localPrompts = Join-Path $RepoRoot '.github/prompts'

$srcAgents    = Join-Path $CacheDir 'src/agents'
$srcSkills    = Join-Path $CacheDir 'src/skills'
$srcPrompts   = Join-Path $CacheDir 'src/prompts'

# --- Ensure cache exists / is up to date ---
function Update-Cache {
    if (Test-Path $CacheDir) {
        Write-Host "Updating marketplace cache..." -ForegroundColor DarkGray
        Push-Location $CacheDir
        try {
            git fetch origin --quiet
            git reset --hard origin/main --quiet
        } finally {
            Pop-Location
        }
    } else {
        Write-Host "Cloning marketplace cache to $CacheDir..." -ForegroundColor DarkGray
        git clone $MarketplaceUrl $CacheDir --quiet
    }
}

# --- Copy helpers ---
function Sync-Folder {
    param(
        [string]$Source,
        [string]$Dest,
        [string[]]$IncludeExt,
        [switch]$RecurseDirs,
        # Additive mirror: copy source over dest but never prune dest-only items.
        # Required when pushing, because the marketplace aggregates content from
        # several repos and this one is not its sole source.
        [switch]$NoDelete
    )
    if (-not (Test-Path $Source)) {
        Write-Warning "Source not found: $Source"
        return
    }
    if (-not (Test-Path $Dest)) {
        if ($DryRun) {
            Write-Host "  [dry-run] would create $Dest" -ForegroundColor DarkGray
        } else {
            New-Item -ItemType Directory -Force -Path $Dest | Out-Null
        }
    }

    if ($DryRun) {
        Write-Host "  [dry-run] would mirror $Source -> $Dest" -ForegroundColor DarkGray
        return
    }

    # Mirror: remove items in dest that aren't in source (only at top level for files;
    # skill folders are mirrored entirely)
    if ($RecurseDirs) {
        # Mirror skill folders: remove dest folders not in source, copy all source folders
        $srcDirs = @(Get-ChildItem $Source -Directory | Select-Object -ExpandProperty Name)
        if ((Test-Path $Dest) -and -not $NoDelete) {
            Get-ChildItem $Dest -Directory | Where-Object { $srcDirs -notcontains $_.Name } | ForEach-Object {
                Write-Host "  removing stale $($_.Name)/" -ForegroundColor DarkYellow
                Remove-Item -Recurse -Force $_.FullName
            }
        }
        foreach ($d in $srcDirs) {
            $s = Join-Path $Source $d
            $t = Join-Path $Dest $d
            if (Test-Path $t) { Remove-Item -Recurse -Force $t }
            Copy-Item -Recurse -Force $s $Dest
        }
    } else {
        # File mirror with extension filter
        # NOTE: nested Where-Object pipelines shadow $_ — capture the FileInfo's
        # name in a closure variable before checking each extension suffix.
        $srcFiles = @(Get-ChildItem $Source -File | Where-Object {
            $name = $_.Name
            -not $IncludeExt -or ($IncludeExt | Where-Object { $name -like "*$_" })
        })
        $srcNames = $srcFiles | Select-Object -ExpandProperty Name
        if ((Test-Path $Dest) -and -not $NoDelete) {
            Get-ChildItem $Dest -File | Where-Object {
                $name = $_.Name
                ($srcNames -notcontains $name) -and
                ($IncludeExt | Where-Object { $name -like "*$_" })
            } | ForEach-Object {
                Write-Host "  removing stale $($_.Name)" -ForegroundColor DarkYellow
                Remove-Item -Force $_.FullName
            }
        }
        foreach ($f in $srcFiles) {
            Copy-Item -Force $f.FullName $Dest
        }
    }
}

# --- PULL ---
if ($Pull) {
    Update-Cache

    Write-Host "Pulling agents..." -ForegroundColor Cyan
    Sync-Folder -Source $srcAgents -Dest $localAgents -IncludeExt '.agent.md'

    Write-Host "Pulling skills..." -ForegroundColor Cyan
    Sync-Folder -Source $srcSkills -Dest $localSkills -RecurseDirs

    Write-Host "Pulling prompts..." -ForegroundColor Cyan
    Sync-Folder -Source $srcPrompts -Dest $localPrompts -IncludeExt '.prompt.md'

    Write-Host ''
    Write-Host "Pull complete." -ForegroundColor Green
    Write-Host "Review changes with: git status" -ForegroundColor DarkGray
    return
}

# --- PUSH ---
if ($Push) {
    Update-Cache

    Write-Host "Pushing agents..." -ForegroundColor Cyan
    Sync-Folder -Source $localAgents -Dest $srcAgents -IncludeExt '.agent.md' -NoDelete

    Write-Host "Pushing skills..." -ForegroundColor Cyan
    Sync-Folder -Source $localSkills -Dest $srcSkills -RecurseDirs -NoDelete

    Write-Host "Pushing prompts..." -ForegroundColor Cyan
    Sync-Folder -Source $localPrompts -Dest $srcPrompts -IncludeExt '.prompt.md' -NoDelete

    if ($DryRun) {
        Write-Host ''
        Write-Host "[dry-run] would now run build + commit + push in $CacheDir" -ForegroundColor Yellow
        return
    }

    Write-Host "Building plugins..." -ForegroundColor Cyan
    Push-Location $CacheDir
    try {
        pwsh scripts/build-plugins.ps1
        if ($LASTEXITCODE -ne 0) { throw "build-plugins.ps1 failed" }

        Write-Host "Linting marketplace..." -ForegroundColor Cyan
        pwsh scripts/lint.ps1
        if ($LASTEXITCODE -ne 0) { throw "lint.ps1 failed" }

        $changes = git status --short
        if (-not $changes) {
            Write-Host "No changes to push." -ForegroundColor Yellow
            return
        }

        Write-Host "Committing..." -ForegroundColor Cyan
        git add -A
        git commit -m $Message
        if ($LASTEXITCODE -ne 0) { throw "git commit failed" }

        Write-Host "Pushing to origin..." -ForegroundColor Cyan
        git push origin main
        if ($LASTEXITCODE -ne 0) { throw "git push failed" }
    } finally {
        Pop-Location
    }

    Write-Host ''
    Write-Host "Push complete." -ForegroundColor Green
    return
}

# --- CHECK ---
if ($Check) {
    Update-Cache

    function Get-PathHash {
        param([string]$Path, [string[]]$IncludeExt, [switch]$DirsOnly)
        if (-not (Test-Path $Path)) { return @{} }
        $map = @{}
        if ($DirsOnly) {
            Get-ChildItem $Path -Recurse -File | ForEach-Object {
                $rel = $_.FullName.Substring($Path.Length).TrimStart('\','/').Replace('\','/')
                $map[$rel] = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash
            }
        } else {
            Get-ChildItem $Path -File | Where-Object {
                $f = $_
                ($IncludeExt | Where-Object { $f.Name.EndsWith($_) }).Count -gt 0
            } | ForEach-Object {
                $map[$_.Name] = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash
            }
        }
        return $map
    }

    $diffs = @()
    $remoteOnly = @()

    function Compare-Maps {
        param($Local, $Remote, $Label)
        $allKeys = ($Local.Keys + $Remote.Keys | Sort-Object -Unique)
        foreach ($k in $allKeys) {
            # Marketplace-only content belongs to another consumer repo; -Push is
            # additive and never removes it, so it is not drift.
            if (-not $Local.ContainsKey($k))      { $script:remoteOnly += "[$Label] $k" }
            elseif (-not $Remote.ContainsKey($k)) { $script:diffs += "[$Label] only-in-local:       $k" }
            elseif ($Local[$k] -ne $Remote[$k])   { $script:diffs += "[$Label] differs:              $k" }
        }
    }

    Compare-Maps `
        -Local  (Get-PathHash -Path $localAgents  -IncludeExt '.agent.md') `
        -Remote (Get-PathHash -Path $srcAgents    -IncludeExt '.agent.md') `
        -Label  'agents'

    Compare-Maps `
        -Local  (Get-PathHash -Path $localSkills  -DirsOnly) `
        -Remote (Get-PathHash -Path $srcSkills    -DirsOnly) `
        -Label  'skills'

    Compare-Maps `
        -Local  (Get-PathHash -Path $localPrompts -IncludeExt '.prompt.md') `
        -Remote (Get-PathHash -Path $srcPrompts   -IncludeExt '.prompt.md') `
        -Label  'prompts'

    if ($remoteOnly.Count -gt 0) {
        Write-Host ''
        Write-Host "Marketplace has $($remoteOnly.Count) item(s) not present locally (not drift):" -ForegroundColor DarkGray
        $remoteOnly | Select-Object -First 10 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
        if ($remoteOnly.Count -gt 10) {
            Write-Host "  ... and $($remoteOnly.Count - 10) more" -ForegroundColor DarkGray
        }
        Write-Host "  Run -Pull to bring them into this repo." -ForegroundColor DarkGray
    }

    if ($diffs.Count -eq 0) {
        Write-Host "In sync with marketplace." -ForegroundColor Green
        exit 0
    }

    Write-Host ''
    Write-Host "Out of sync with marketplace ($($diffs.Count) difference(s)):" -ForegroundColor Red
    $diffs | Select-Object -First 30 | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    if ($diffs.Count -gt 30) {
        Write-Host "  ... and $($diffs.Count - 30) more" -ForegroundColor Red
    }
    Write-Host ''
    Write-Host "Run: pwsh .github/scripts/sync-agents.ps1 -Push -Message '<msg>'" -ForegroundColor Yellow
    Write-Host "  to mirror local changes to the marketplace, or" -ForegroundColor Yellow
    Write-Host "Run: pwsh .github/scripts/sync-agents.ps1 -Pull" -ForegroundColor Yellow
    Write-Host "  to pull marketplace changes into this repo." -ForegroundColor Yellow
    exit 1
}
