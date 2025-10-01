# Logi Test Runner Script
# This script builds and runs tests for the Logi Qt application

param(
    [switch]$Clean,
    [switch]$BuildOnly,
    [switch]$TestOnly
)

# Set console encoding for proper Unicode display
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# Set Qt paths
$QtBinPath = "C:\Qt\6.9.2\mingw_64\bin"
$MinGWPath = "C:\Qt\Tools\mingw1310_64\bin"
$CMakePath = "C:\Qt\Tools\CMake_64\bin"

# Add to PATH temporarily
$env:PATH = "$QtBinPath;$MinGWPath;$CMakePath;" + $env:PATH

Write-Host "" # Empty line for spacing
Write-Host "[LOGI] Test Runner" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan

if ($Clean) {
    Write-Host "[CLEAN] Cleaning build directory..." -ForegroundColor Yellow
    if (Test-Path "build") {
        Remove-Item -Recurse -Force build
    }
}

if (-not $TestOnly) {
    Write-Host "[CONFIG] Configuring CMake..." -ForegroundColor Green
    & cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug -DCMAKE_PREFIX_PATH="C:\Qt\6.9.2\mingw_64" -G "MinGW Makefiles" -DCMAKE_CXX_COMPILER="C:\Qt\Tools\mingw1310_64\bin\g++.exe"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] CMake configuration failed!" -ForegroundColor Red
        exit $LASTEXITCODE
    }
    
    Write-Host "[BUILD] Building project..." -ForegroundColor Green
    & cmake --build build --config Debug
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Build failed!" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

if (-not $BuildOnly) {
    Write-Host "[TEST] Running tests..." -ForegroundColor Blue
    & ".\build\LogiTests.exe"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[SUCCESS] All tests passed!" -ForegroundColor Green
    } else {
        Write-Host "[FAILED] Some tests failed!" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

Write-Host "[DONE] Test run completed!" -ForegroundColor Cyan
