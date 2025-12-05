@echo off
setlocal enabledelayedexpansion
echo Building Logi Installer with Inno Setup...

REM Set paths
set INNO_SETUP_PATH=C:\Program Files (x86)\Inno Setup 6
set SCRIPT_FILE=%~dp0logi-setup.iss
set SOURCE_DIR=%~dp0..
set DIST_DIR=%SOURCE_DIR%\release

REM Extract version from CMakeLists.txt
for /f "tokens=3" %%i in ('findstr /C:"project(Logi VERSION" "%SOURCE_DIR%\CMakeLists.txt"') do set APP_VERSION=%%i
if not defined APP_VERSION (
    echo Error: Could not extract version from CMakeLists.txt
    pause
    exit /b 1
)
echo Detected version: %APP_VERSION%

REM Check if Inno Setup is installed
if not exist "%INNO_SETUP_PATH%\iscc.exe" (
    echo Error: Inno Setup not found at "%INNO_SETUP_PATH%"
    echo Please install Inno Setup or adjust the path in this script.
    pause
    exit /b 1
)

REM Check if release directory exists
if not exist "%DIST_DIR%" (
    echo Error: Release directory not found at "%DIST_DIR%"
    echo Please build your Qt application first.
    pause
    exit /b 1
)

REM Check if main executable exists
if not exist "%DIST_DIR%\Logi.exe" (
    echo Error: Logi.exe not found in release directory
    echo Please build your Qt application first.
    pause
    exit /b 1
)

echo Found Logi.exe in release directory
echo Using Inno Setup at: "%INNO_SETUP_PATH%"

REM Create the installer
echo Compiling installer script...
"%INNO_SETUP_PATH%\iscc.exe" /DAppVersion=%APP_VERSION% "%SCRIPT_FILE%"

if %ERRORLEVEL% neq 0 (
    echo Error creating installer!
    pause
    exit /b 1
)

echo.
echo Installer created successfully!
echo Location: %~dp0output\LogiSetup.exe
echo.

REM Show file size comparison
if exist "%~dp0output\LogiSetup.exe" (
    for %%A in ("%~dp0output\LogiSetup.exe") do (
        echo Inno Setup installer size: %%~zA bytes
    )
)

if exist "%~dp0output\LogiSetup.exe" (
    for %%A in ("%~dp0output\LogiSetup.exe") do (
        set /a size_mb=%%~zA/1024/1024
        echo Approximate size: !size_mb! MB
    )
)

echo.
echo Build complete!
pause