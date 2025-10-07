######################################################################
# This is a helper script for prepare_release.bat
# Compares the timestamp of the exe in the build directory to that
# of the CMakeLists.txt. If the CMakeLists.txt file is newer, it sends
# an error back and prompts the user to rebuild the app in Qt
######################################################################

param(
    [string]$BuildFile,
    [string]$CmakeFile = "CMakeLists.txt"
)

# Get file timestamps
$buildTime = (Get-Item $BuildFile).LastWriteTime
$cmakeTime = (Get-Item $CmakeFile).LastWriteTime

# Display timestamps
Write-Host ("Build time: " + $buildTime.ToString())
Write-Host ("CMakeLists.txt time: " + $cmakeTime.ToString())

# Compare timestamps
if ($cmakeTime -gt $buildTime) {
    Write-Host ""
    Write-Host "ERROR: CMakeLists.txt is newer than the build!" -ForegroundColor Red
    Write-Host "Please rebuild in Qt Creator after version changes." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "Build is up to date." -ForegroundColor Green
    exit 0
}