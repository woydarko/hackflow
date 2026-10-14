# Install the /hackaton skill for Claude Code, Codex, OpenCode and other harnesses that read SKILL.md folders.
# Default targets: ~\.agents\skills (Codex user scope, OpenCode) and ~\.claude\skills (Claude Code).
# Usage: .\install.ps1 [-Dest dir1,dir2]
param([string[]]$Dest = @("$HOME\.agents\skills", "$HOME\.claude\skills"))
$ErrorActionPreference = "Stop"

$src = Join-Path $PSScriptRoot "skills\hackaton"
if (-not (Test-Path (Join-Path $src "SKILL.md"))) { throw "skills\hackaton\SKILL.md not found next to install.ps1" }

foreach ($d in $Dest) {
  if (-not $d) { throw "empty -Dest entry" }
  New-Item -ItemType Directory -Force $d | Out-Null
  $target = Join-Path $d "hackaton"
  if (Test-Path $target) { Remove-Item -Recurse -Force $target }   # only our own skill folder
  Copy-Item -Recurse $src $target
  Write-Host "installed: $target"
}
Write-Host "Restart or reload your agent. Dependency check needs bash (Git Bash/WSL): bash <dest>/hackaton/scripts/check-deps.sh"
