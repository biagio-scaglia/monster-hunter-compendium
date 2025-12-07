@echo off
echo Avvio Flutter con Chrome in modalita sviluppo...
echo.

REM Crea la directory ChromeDev se non esiste
if not exist "C:\ChromeDev" mkdir "C:\ChromeDev"

REM Imposta Chrome personalizzato come browser predefinito per Flutter
set CHROME_EXECUTABLE="C:\Program Files\Google\Chrome\Application\chrome.exe"

REM Avvia Flutter con Chrome personalizzato e flag
flutter run -d chrome ^
  --web-browser-flag="--disable-web-security" ^
  --web-browser-flag="--disable-gpu" ^
  --web-browser-flag="--user-data-dir=C:/ChromeDev"

pause

