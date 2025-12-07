# Script PowerShell per avviare Flutter con Chrome in modalità sviluppo
Write-Host "Avvio Flutter con Chrome in modalita sviluppo..." -ForegroundColor Green
Write-Host ""

# Crea la directory ChromeDev se non esiste
if (-not (Test-Path "C:\ChromeDev")) {
    New-Item -ItemType Directory -Path "C:\ChromeDev" | Out-Null
    Write-Host "Directory C:\ChromeDev creata" -ForegroundColor Yellow
}

# Imposta Chrome personalizzato come browser predefinito per Flutter
$env:CHROME_EXECUTABLE = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# Avvia Flutter con Chrome personalizzato e flag
flutter run -d chrome `
    --web-browser-flag="--disable-web-security" `
    --web-browser-flag="--disable-gpu" `
    --web-browser-flag="--user-data-dir=C:/ChromeDev"

