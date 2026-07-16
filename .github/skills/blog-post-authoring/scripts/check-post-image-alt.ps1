param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Path)) {
    throw "File not found: $Path"
}

$weakAltPattern = '^(\s*|image|screenshot|screen shot|test|enter image description here|\d+|\d{4}-\d{2}-\d{2}.*|\d{4}-\d{2}-\d{2}_.*)$'
$content = Get-Content -LiteralPath $Path -Raw
$body = $content -replace '(?s)^---\r?\n.*?\r?\n---\r?\n', ''
$matches = [regex]::Matches($body, '!\[([^\]]*)\]\(([^\)]+)\)')

if ($matches.Count -eq 0) {
    Write-Host "No Markdown body images found in $Path"
    exit 0
}

$weakImages = [System.Collections.Generic.List[object]]::new()

foreach ($match in $matches) {
    $alt = $match.Groups[1].Value.Trim()
    $src = $match.Groups[2].Value.Trim()

    if ($alt -match $weakAltPattern) {
        [void]$weakImages.Add([pscustomobject]@{
            Alt = if ($alt) { $alt } else { '<empty>' }
            Src = $src
        })
    }
}

if ($weakImages.Count -eq 0) {
    Write-Host "All Markdown body images have non-generic alt text."
    exit 0
}

Write-Host "Missing or weak body image alt text found:"
$weakImages | Format-Table -AutoSize | Out-String | Write-Host
Write-Host "Review each image with its surrounding article context and replace the alt text before publishing."
exit 1