# Сборка Release + установщик Inno Setup
# Запуск из корня репозитория: .\scripts\build-installer.ps1

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

$ExePath = Join-Path $Root "Win32\Release\SQLiteManager.exe"
$DllPath = Join-Path $Root "sqlite3.dll"
$IssPath = Join-Path $Root "installer.iss"

# MSBuild RAD Studio (подставьте свою версию, если путь другой)
$MsbuildCandidates = @(
    "${env:ProgramFiles(x86)}\Embarcadero\Studio\21.0\bin\rsvars.bat",
    "${env:ProgramFiles(x86)}\Embarcadero\Studio\22.0\bin\rsvars.bat",
    "${env:ProgramFiles(x86)}\Embarcadero\Studio\23.0\bin\rsvars.bat"
)

$IsccCandidates = @(
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
    "${env:ProgramFiles}\Inno Setup 6\ISCC.exe"
)

Write-Host "=== 1. Release build (Win32) ===" -ForegroundColor Cyan
$built = $false
foreach ($rsvars in $MsbuildCandidates) {
    if (-not (Test-Path $rsvars)) { continue }
    $rsDir = Split-Path $rsvars -Parent
    cmd /c "`"$rsvars`" && msbuild `"$Root\SQLiteManager.dproj`" /p:Config=Release /p:Platform=Win32 /t:Build"
    if ($LASTEXITCODE -eq 0) { $built = $true; break }
}
if (-not $built) {
    Write-Warning "MSBuild не найден. Соберите вручную: Delphi → Release → Win32 → Build"
    if (-not (Test-Path $ExePath)) {
        throw "Нет файла: $ExePath"
    }
}

if (-not (Test-Path $ExePath)) {
    throw "После сборки не найден: $ExePath"
}

Write-Host "=== 2. sqlite3.dll ===" -ForegroundColor Cyan
if (-not (Test-Path $DllPath)) {
    throw @"
Положите 32-bit sqlite3.dll в корень проекта:
  $DllPath
Скачать: https://www.sqlite.org/download.html → sqlite-dll-win32-x86-*.zip
"@
}

Write-Host "=== 3. Inno Setup ===" -ForegroundColor Cyan
$iscc = $IsccCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $iscc) {
    throw "Установите Inno Setup 6: https://jrsoftware.org/isdl.php"
}

& $iscc $IssPath
if ($LASTEXITCODE -ne 0) { throw "ISCC failed" }

$setup = Get-ChildItem -Path (Join-Path $Root "installer") -Filter "SQLiteManagerSetup-*.exe" |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
Write-Host "Готово: $($setup.FullName)" -ForegroundColor Green
