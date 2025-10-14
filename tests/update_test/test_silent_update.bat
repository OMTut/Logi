@echo off
echo.
echo ============================================
echo  🧪 Logi Silent Update Testing Workflow
echo ============================================
echo.

echo 📋 Pre-flight checklist:
echo   1. ✅ Installer built (LogiSetup.exe exists)
echo   2. ✅ Python 3 installed and available
echo   3. ✅ Current Logi version is 1.0.0 or 1.0.1
echo.

echo 🔍 Checking installer...
if exist "..\..\installer\output\LogiSetup.exe" (
    echo ✅ Installer found: LogiSetup.exe
) else (
    echo ❌ Installer not found!
    echo    Please run: installer\build_installer_inno.bat
    echo.
    pause
    exit /b 1
)

echo.
echo 🚀 Starting test server...
echo    Server will run on: http://localhost:8080
echo    Test version available: 1.0.2
echo.
echo 💡 To test the silent update:
echo    1. Keep this window open (server running)
echo    2. Open a new terminal and run your Logi app
echo    3. Temporarily modify UpdateChecker.cpp:
echo       Change VERSION_CHECK_URL to "http://localhost:8080/version.json"
echo    4. Rebuild and run Logi
echo    5. Look for update banner showing version 1.0.2
echo    6. Click "Update Now" to test the progress dialog
echo.
echo ⚠️  Press Ctrl+C to stop the server when done testing
echo.
python test_server.py