$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$skillFiles = Get-ChildItem (Join-Path $root "skills") -Recurse -Filter "SKILL.md" -File
$utf8Bom = [byte[]](0xEF, 0xBB, 0xBF)
$failures = @()

foreach ($file in $skillFiles) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq $utf8Bom[0] -and $bytes[1] -eq $utf8Bom[1] -and $bytes[2] -eq $utf8Bom[2]
    $text = [System.IO.File]::ReadAllText($file.FullName)

    if ($hasBom) {
        $failures += "BOM detected: $($file.FullName)"
    }

    if (-not $text.StartsWith("---`n") -and -not $text.StartsWith("---`r`n")) {
        $failures += "Missing YAML frontmatter: $($file.FullName)"
        continue
    }

    if ($text -notmatch "(?ms)^---\r?\nname:\s*.+\r?\ndescription:\s*.+\r?\n---\r?\n") {
        $failures += "Invalid frontmatter shape: $($file.FullName)"
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Validated $($skillFiles.Count) skill file(s)."
