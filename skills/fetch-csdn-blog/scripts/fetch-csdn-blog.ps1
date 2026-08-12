param(
    [string]$Username = "qq_58062502",
    [int]$Count = 5,
    [string]$ReadmePath = "README.md"
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$blogUrl = "https://blog.csdn.net/${Username}?type=blog"

Write-Host "Fetching $blogUrl ..."

$html = (Invoke-WebRequest -Uri $blogUrl -UseBasicParsing -TimeoutSec 60).Content

$pattern = '"type":"blog","formatTime":"([^"]+)","title":"([^"]+)","description":"(?:[^"\\]|\\.)*","hasOriginal":[a-z]+,"diggCount":\d+,"commentCount":\d+,"postTime":\d+,"createTime":\d+,"updateTime":\d+,"url":"([^"]+)"'
$matches = [regex]::Matches($html, $pattern, 'Singleline')

if ($matches.Count -eq 0) {
    Write-Error "No articles found. CSDN may have returned an anti-bot page. Retry or check Username."
    exit 1
}

$articles = @()
foreach ($m in $matches) {
    $articles += [pscustomobject]@{
        Date  = $m.Groups[1].Value
        Title = $m.Groups[2].Value
        Url   = $m.Groups[3].Value -replace '\\u002F', '/'
    }
}

$latest = $articles | Select-Object -First $Count

Write-Host "`nLatest $Count articles:"
$latest | ForEach-Object {
    $year, $month, $day = $_.Date.Split('.')
    $monthName = @('', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')[[int]$month]
    $line = "- $monthName $day - [$($_.Title)]($($_.Url))"
    Write-Host $line
}

Write-Host ""
$update = Read-Host "Write these $Count articles into $ReadmePath between <!-- feed start --> and <!-- feed end -->? [y/N]"

if ($update -ne "y" -and $update -ne "Y") {
    Write-Host "Skipped. Copy the lines above manually if needed."
    exit 0
}

$readme = Get-Content $ReadmePath -Raw -Encoding UTF8

$startMarker = "<!-- feed start -->"
$endMarker = "<!-- feed end -->"

$startIdx = $readme.IndexOf($startMarker)
$endIdx = $readme.IndexOf($endMarker)

if ($startIdx -lt 0 -or $endIdx -lt 0 -or $endIdx -le $startIdx) {
    Write-Error "Feed markers not found in $ReadmePath. Add `<!-- feed start -->` and `<!-- feed end -->` first."
    exit 1
}

$feedBlock = "$startMarker`n"
$feedBlock += ($latest | ForEach-Object {
    $month, $day, $year = $_.Date.Split('.')
    $monthName = @('', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')[[int]$month]
    "- $monthName $day - [$($_.Title)]($($_.Url))"
}) -join "`n"
$feedBlock += "`n$endMarker"

$newReadme = $readme.Substring(0, $startIdx) + $feedBlock + $readme.Substring($endIdx + $endMarker.Length)

[System.IO.File]::WriteAllText($ReadmePath, $newReadme, [System.Text.UTF8Encoding]::new($false))

Write-Host "`nDone. Updated feed section in $ReadmePath"
