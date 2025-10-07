@echo off
REM ##################################################################
REM # The script does the following:
REM # - Declares the needed parameters: Build/Release directories, exes etc.
REM # - Verifies that a build exists by checking if a BUILD_DIR and MAIN_EXE exists
REM # 	- If not, exits the program and prompts the user to build the project in Qt first
REM # - Checks if the build is up to date by using the check_build_time script
REM # 	- if the check_build_time script returns an error, it prompts the user to build the app in Qt
REM # - Creates a clean release directory
REM # - Copies the files from the build directory to the release directory
REM # - Copies the icon file resources directory to release directory
REM # - Renames the main executable (from appLogi to Logi)
REM # - Verifies the final executable is in the release directory
REM ##################################################################
echo Preparing Logi Release...

REM Configuration
set BUILD_DIR=build\Desktop_Qt_6_9_2_MinGW_64_bit-Release
set RELEASE_DIR=release
set MAIN_EXE=appLogi.exe
set RELEASE_EXE=Logi.exe
set ICON_FILE=resources\Logo_Logi_v1_desktop.ico

REM Verify build exists
if not exist "%BUILD_DIR%\%MAIN_EXE%" (
    echo ERROR: %MAIN_EXE% not found in %BUILD_DIR%
    echo Please build the project in Qt Creator first.
    pause
    exit /b 1
)

REM Check if build is up to date
echo Checking if build is up to date...
REM Check build vs CMakeLists.txt timestamps
powershell -ExecutionPolicy Bypass -File "scripts\check_build_time.ps1" -BuildFile "%BUILD_DIR%\%MAIN_EXE%"
if %ERRORLEVEL% neq 0 (
    pause
    exit /b 1
)

REM Create/clean release directory
if exist "%RELEASE_DIR%" (
    echo Cleaning existing release directory...
    rmdir /s /q "%RELEASE_DIR%"
)
mkdir "%RELEASE_DIR%"

REM Copy all files from build directory
echo Copying files from build directory...
xcopy "%BUILD_DIR%\*" "%RELEASE_DIR%\" /s /e /y /i

REM Rename main executable
echo Renaming %MAIN_EXE% to %RELEASE_EXE%...
move "%RELEASE_DIR%\%MAIN_EXE%" "%RELEASE_DIR%\%RELEASE_EXE%"

REM Copy icon file
if exist "%ICON_FILE%" (
    echo Copying icon file...
    copy "%ICON_FILE%" "%RELEASE_DIR%\" /y
) else (
    echo WARNING: Icon file %ICON_FILE% not found!
)

REM Verify final executable
if exist "%RELEASE_DIR%\%RELEASE_EXE%" (
    echo ✓ Release preparation complete!
    echo ✓ Main executable: %RELEASE_DIR%\%RELEASE_EXE%
    echo ✓ Ready for installer build
) else (
    echo ERROR: Failed to create %RELEASE_EXE%
    pause
    exit /b 1
)

echo.
echo Next steps:
echo 1. Test the application: %RELEASE_DIR%\%RELEASE_EXE%
echo 2. Build installer: installer\build_installer.bat
echo.
pause