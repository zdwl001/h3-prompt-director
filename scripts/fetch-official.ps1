$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Dest = Join-Path $Root "references/official"
$Base = "https://raw.githubusercontent.com/MiniMax-AI/MiniMax-H3/main/skills/h3-prompt-writing"

Write-Host @"
This script downloads the official MiniMax H3 prompt-writing documents:

  - SKILL.md
  - references/base-en.txt
  - references/ref-en.txt

They are governed by the MiniMax H3 Community License Agreement:
https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

The license grants rights only within the "Applicable Territory":
worldwide excluding the European Union, the United Kingdom,
the Republic of Korea and the United States of America.

By continuing, you confirm that you are in the Applicable Territory and
that you accept the license terms. The downloaded files are for your own
use with this skill and are not redistributed by this repository.

"@

$answer = Read-Host "Type 'yes' to continue"
if ($answer -ne "yes") {
    Write-Host "Aborted."
    exit 1
}

New-Item -ItemType Directory -Force -Path $Dest | Out-Null

Write-Host "Fetching..."
Invoke-WebRequest -Uri "$Base/SKILL.md" -OutFile (Join-Path $Dest "official-skill.md")
Invoke-WebRequest -Uri "$Base/references/base-en.txt" -OutFile (Join-Path $Dest "base-en.txt")
Invoke-WebRequest -Uri "$Base/references/ref-en.txt" -OutFile (Join-Path $Dest "ref-en.txt")

Write-Host ""
Write-Host "Done. Files in $Dest:"
Get-ChildItem $Dest | Select-Object -ExpandProperty Name
