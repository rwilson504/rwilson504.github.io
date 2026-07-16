param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [int]$TimeoutSeconds = 20
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Path)) {
    throw "File not found: $Path"
}

$content = Get-Content -LiteralPath $Path -Raw

$urls = [System.Collections.Generic.List[string]]::new()

# Markdown links and images: [text](https://example.com), ![alt](https://example.com)
$markdownMatches = [regex]::Matches($content, '\]\((https?://[^\s)]+)')
foreach ($match in $markdownMatches) {
    [void]$urls.Add($match.Groups[1].Value.Trim())
}

# Raw URLs in prose or reference lists.
$rawMatches = [regex]::Matches($content, '(?<!\]\()https?://[^\s<>)"'']+')
foreach ($match in $rawMatches) {
    [void]$urls.Add($match.Value.Trim())
}

$normalizedUrls = $urls |
    ForEach-Object { $_.TrimEnd('.', ',', ';', ':') } |
    Sort-Object -Unique

if (-not $normalizedUrls) {
    Write-Host "No external links found in $Path"
    exit 0
}

$failures = [System.Collections.Generic.List[object]]::new()

foreach ($url in $normalizedUrls) {
    Write-Host "Checking $url"
    $statusCode = $null
    $errorMessage = $null

    try {
        $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec $TimeoutSeconds -MaximumRedirection 5 -ErrorAction Stop
        $statusCode = [int]$response.StatusCode
    }
    catch {
        try {
            $response = Invoke-WebRequest -Uri $url -Method Get -TimeoutSec $TimeoutSeconds -MaximumRedirection 5 -Headers @{ Range = 'bytes=0-0' } -ErrorAction Stop
            $statusCode = [int]$response.StatusCode
        }
        catch {
            $errorMessage = $_.Exception.Message
        }
    }

    if ($statusCode -and $statusCode -lt 400) {
        Write-Host "  OK $statusCode"
        continue
    }

    if (-not $errorMessage) {
        $errorMessage = "HTTP status $statusCode"
    }

    Write-Host "  FAIL $errorMessage"
    [void]$failures.Add([pscustomobject]@{
        Url = $url
        Error = $errorMessage
    })
}

if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Broken or blocked links:"
    $failures | Format-Table -AutoSize | Out-String | Write-Host
    exit 1
}

Write-Host "All external links passed."