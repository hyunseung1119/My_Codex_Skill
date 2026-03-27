$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$HomeDir = Join-Path $env:USERPROFILE ".codex"
$BackupRoot = Join-Path $HomeDir ("backups\repo-install-$Timestamp")

function Write-Section {
    param([string]$Text)
    Write-Host ""
    Write-Host "== $Text ==" -ForegroundColor Cyan
}

function Ensure-Dir {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Backup-Existing {
    param(
        [string]$Path,
        [string]$BackupPath
    )

    if (Test-Path -LiteralPath $Path) {
        Ensure-Dir (Split-Path -Parent $BackupPath)
        Move-Item -LiteralPath $Path -Destination $BackupPath
        return $true
    }

    return $false
}

function New-LinkPreferred {
    param(
        [string]$TargetPath,
        [string]$LinkPath,
        [bool]$IsDirectory
    )

    Ensure-Dir (Split-Path -Parent $LinkPath)

    if ($IsDirectory) {
        try {
            New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath -Force | Out-Null
            return "SymbolicLink"
        } catch {
            New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath -Force | Out-Null
            return "Junction"
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath -Force | Out-Null
        return "SymbolicLink"
    } catch {
        New-Item -ItemType HardLink -Path $LinkPath -Target $TargetPath -Force | Out-Null
        return "HardLink"
    }
}

function Sync-Collection {
    param(
        [string]$SourceDir,
        [string]$DestinationDir,
        [bool]$Directories,
        [string[]]$SkipNames = @(),
        [string]$BackupRoot
    )

    Ensure-Dir $DestinationDir
    $items = if ($Directories) { Get-ChildItem -LiteralPath $SourceDir -Directory } else { Get-ChildItem -LiteralPath $SourceDir -File }
    $results = @()

    foreach ($item in $items) {
        if ($SkipNames -contains $item.Name) { continue }

        $destPath = Join-Path $DestinationDir $item.Name
        $backupPath = Join-Path $BackupRoot $item.Name
        $backedUp = Backup-Existing -Path $destPath -BackupPath $backupPath
        $linkType = New-LinkPreferred -TargetPath $item.FullName -LinkPath $destPath -IsDirectory:$item.PSIsContainer

        $results += [pscustomobject]@{
            Name = $item.Name
            BackedUp = $backedUp
            LinkType = $linkType
        }
    }

    return $results
}

Write-Host "Repository: $RepoDir" -ForegroundColor Green
Write-Host "Target: $HomeDir" -ForegroundColor Green
Write-Section "Installing Codex assets"

Ensure-Dir $HomeDir
Ensure-Dir (Join-Path $HomeDir "skills")
Ensure-Dir (Join-Path $HomeDir "agents")
Ensure-Dir (Join-Path $HomeDir "rules")
Ensure-Dir (Join-Path $HomeDir "commands")
Ensure-Dir $BackupRoot

$skillResults = Sync-Collection -SourceDir (Join-Path $RepoDir "skills") -DestinationDir (Join-Path $HomeDir "skills") -Directories $true -SkipNames @(".system") -BackupRoot (Join-Path $BackupRoot "skills")
$agentResults = Sync-Collection -SourceDir (Join-Path $RepoDir "agents") -DestinationDir (Join-Path $HomeDir "agents") -Directories $false -BackupRoot (Join-Path $BackupRoot "agents")
$ruleResults = Sync-Collection -SourceDir (Join-Path $RepoDir "rules") -DestinationDir (Join-Path $HomeDir "rules") -Directories $false -BackupRoot (Join-Path $BackupRoot "rules")
$commandResults = Sync-Collection -SourceDir (Join-Path $RepoDir "commands") -DestinationDir (Join-Path $HomeDir "commands") -Directories $false -BackupRoot (Join-Path $BackupRoot "commands")

$agentsSource = Join-Path $RepoDir "AGENTS.md"
if (Test-Path -LiteralPath $agentsSource) {
    $agentsDest = Join-Path $HomeDir "AGENTS.md"
    $agentsBackup = Join-Path $BackupRoot "AGENTS.md"
    [void](Backup-Existing -Path $agentsDest -BackupPath $agentsBackup)
    [void](New-LinkPreferred -TargetPath $agentsSource -LinkPath $agentsDest -IsDirectory:$false)
}

Write-Host "Backup root: $BackupRoot" -ForegroundColor Yellow
Write-Host ("Skills : {0}" -f $skillResults.Count) -ForegroundColor Green
Write-Host ("Agents : {0}" -f $agentResults.Count) -ForegroundColor Green
Write-Host ("Rules  : {0}" -f $ruleResults.Count) -ForegroundColor Green
Write-Host ("Commands: {0}" -f $commandResults.Count) -ForegroundColor Green
Write-Section "Done"
Write-Host "Read GUIDE.md and MCP_QUICK_SETUP.md next." -ForegroundColor Cyan
