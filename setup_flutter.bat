@echo off
cd /d "%~dp0"
where flutter >nul 2>&1
if errorlevel 1 (
    echo Flutter nije u PATH-u. Instaliraj SDK: https://docs.flutter.dev/get-started/install
    exit /b 1
)
echo Generisanje platform fajlova...
flutter create . --project-name aplikacija --org com.aitradingbot --platforms=android,ios,web,windows
flutter pub get
echo.
echo Gotovo. Pokreni: flutter run -d windows
pause
