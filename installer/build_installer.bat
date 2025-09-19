@echo off
echo Building Logi Installer...

REM Set paths
set QT_IFW_PATH=C:\Qt\Tools\QtInstallerFramework\4.10\bin
set SOURCE_DIR=%~dp0..
set BUILD_DIR=%SOURCE_DIR%\build\Desktop_Qt_6_9_2_MinGW_64_bit-Release
set DIST_DIR=%SOURCE_DIR%\dist
set INSTALLER_DIR=%~dp0
set DATA_DIR=%INSTALLER_DIR%\packages\com.logi.logi\data
set OUTPUT_DIR=%INSTALLER_DIR%\output

REM Create output directory
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM Clean previous data
echo Cleaning previous installer data...
rmdir /s /q "%DATA_DIR%" 2>nul
mkdir "%DATA_DIR%"

REM Copy application files to installer data folder
echo Copying application files...
xcopy "%DIST_DIR%\*" "%DATA_DIR%\" /s /e /y /i

REM Create the installer
echo Creating installer...
"%QT_IFW_PATH%\binarycreator.exe" --offline-only -c "%INSTALLER_DIR%\config\config.xml" -p "%INSTALLER_DIR%\packages" "%OUTPUT_DIR%\LogiSetup.exe"

if %ERRORLEVEL% neq 0 (
    echo Error creating installer!
    pause
    exit /b 1
)

echo.
echo Installer created successfully: %OUTPUT_DIR%\LogiSetup.exe
echo.
pause