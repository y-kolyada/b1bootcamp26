# AI Bootcamp - the Windows half of the setup / windows-половина установки.
#
# Run it in Windows PowerShell (not in Ubuntu):
#     .\setup-windows.ps1              English
#     .\setup-windows.ps1 -Lang ru     по-русски
#     .\setup-windows.ps1 -Lang uk     українською
#     .\setup-windows.ps1 -Lang de     auf Deutsch
#
# WHY A SECOND FILE AT ALL. setup.sh runs inside Ubuntu and installs everything
# that lives there. VS Code is a Windows program: Ubuntu cannot install it, and
# a script that pretended otherwise would report success for something that did
# not happen. So the editor is installed from here, and one line - the WSL
# extension - is what lets the Ubuntu half see `code` afterwards.
#
# NO ADMINISTRATOR RIGHTS. winget installs VS Code for the current user.

# UTF-8 WITH A BOM, AND THAT IS NOT DECORATION. Windows PowerShell 5.1 - the
# one preinstalled on every Windows - reads a .ps1 file as the system ANSI code
# page unless a byte-order mark says otherwise. Without the BOM the Cyrillic and
# German strings below are mis-decoded, a byte pair ends a string early, and the
# whole switch fails to parse. Measured 2026-10-08: five parse errors, no
# mention of encoding among them.
#
param([ValidateSet('en','ru','uk','de')][string]$Lang = 'en')

$ErrorActionPreference = 'Continue'

# The console also has to be told, or the editor's own encoding is not enough.
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$S = switch ($Lang) {
  'ru' { @{
    head='AI Bootcamp - установка редактора'
    intro='Поставлю VS Code и то, что связывает его с Ubuntu. Пароль не нужен.'
    nowinget='В этой Windows нет winget. Поставь VS Code вручную: code.visualstudio.com'
    have='уже есть'; doing='ставлю'; ok='готово'; failed='не получилось'
    code='Редактор VS Code'; wsl='Связь редактора с Ubuntu'
    next='Дальше: открой Ubuntu и запусти ./setup.sh --ru'
    reopen='Если редактор был открыт - закрой и открой его заново.'
  } }
  'uk' { @{
    head='AI Bootcamp - встановлення редактора'
    intro='Встановлю VS Code і те, що зв''язує його з Ubuntu. Пароль не потрібен.'
    nowinget='У цій Windows немає winget. Встанови VS Code вручну: code.visualstudio.com'
    have='уже є'; doing='встановлюю'; ok='готово'; failed='не вдалося'
    code='Редактор VS Code'; wsl='Зв''язок редактора з Ubuntu'
    next='Далі: відкрий Ubuntu і запусти ./setup.sh --uk'
    reopen='Якщо редактор був відкритий - закрий і відкрий його знову.'
  } }
  'de' { @{
    head='AI Bootcamp - Editor einrichten'
    intro='Ich installiere VS Code und die Verbindung zu Ubuntu. Kein Passwort nötig.'
    nowinget='Dieses Windows hat kein winget. Installiere VS Code manuell: code.visualstudio.com'
    have='schon da'; doing='installiere'; ok='fertig'; failed='fehlgeschlagen'
    code='Editor VS Code'; wsl='Verbindung des Editors zu Ubuntu'
    next='Weiter: öffne Ubuntu und starte ./setup.sh --de'
    reopen='War der Editor offen - schließe ihn und öffne ihn neu.'
  } }
  default { @{
    head='AI Bootcamp - editor setup'
    intro='I install VS Code and what connects it to Ubuntu. No password needed.'
    nowinget='This Windows has no winget. Install VS Code by hand: code.visualstudio.com'
    have='already there'; doing='installing'; ok='done'; failed='failed'
    code='Editor VS Code'; wsl='The editor''s link to Ubuntu'
    next='Next: open Ubuntu and run ./setup.sh'
    reopen='If the editor was open - close it and open it again.'
  } }
}

function Row([string]$label, [string]$mark, [string]$value, [string]$colour) {
  Write-Host ('  [ ') -NoNewline
  Write-Host $mark -ForegroundColor $colour -NoNewline
  Write-Host (' ] ' + $label.PadRight(32) + ' ' + $value)
}

Write-Host ''
Write-Host ('  ' + $S.head)
Write-Host ('  ' + (Get-Date -Format 'yyyy-MM-dd HH:mm'))
Write-Host '  ------------------------------------------------------------------'
Write-Host ('  ' + $S.intro)
Write-Host ''

$code = Get-Command code -ErrorAction SilentlyContinue
if ($code) {
  Row $S.code $S.have '' 'DarkGray'
} else {
  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Row $S.code $S.failed $S.nowinget 'Red'
    Write-Host ''
    exit 1
  }
  Row $S.code $S.doing '' 'Yellow'
  winget install --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements --silent | Out-Null
  # winget does not put `code` on this shell's PATH until it is restarted, so the
  # result is read from where the user installation actually lands rather than
  # from Get-Command, which would report a failure that did not happen.
  $exe = Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\bin\code.cmd'
  if (Test-Path $exe) { Row $S.code $S.ok '' 'Green' } else { Row $S.code $S.failed '' 'Red' }
}

# THE ONE EXTENSION THAT MATTERS HERE. Claude Code itself is installed into the
# editor by the Ubuntu half; this one is what makes the editor reach into Ubuntu
# at all, which is why it belongs on this side.
$codecmd = (Get-Command code -ErrorAction SilentlyContinue).Source
if (-not $codecmd) { $codecmd = Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\bin\code.cmd' }
if (Test-Path $codecmd) {
  $installed = & $codecmd --list-extensions 2>$null
  if ($installed -match 'ms-vscode-remote.remote-wsl') {
    Row $S.wsl $S.have '' 'DarkGray'
  } else {
    Row $S.wsl $S.doing '' 'Yellow'
    & $codecmd --install-extension ms-vscode-remote.remote-wsl 2>$null | Out-Null
    $after = & $codecmd --list-extensions 2>$null
    if ($after -match 'ms-vscode-remote.remote-wsl') { Row $S.wsl $S.ok '' 'Green' }
    else { Row $S.wsl $S.failed '' 'Red' }
  }
} else {
  Row $S.wsl $S.failed '' 'Red'
}

Write-Host ''
Write-Host '  ------------------------------------------------------------------'
Write-Host ('  ' + $S.reopen)
Write-Host ('  ' + $S.next)
Write-Host ''
