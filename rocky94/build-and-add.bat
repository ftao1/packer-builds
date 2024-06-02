@echo off
REM build-and-add.bat - Windows batch script for Rocky94 Vagrant box
REM Works on Windows Command Prompt and PowerShell

echo ========================================
echo Rocky94 Vagrant Box Builder
echo ========================================

REM Check if we're in the right directory
if not exist "rocky94.pkr.hcl" (
    echo Error: rocky94.pkr.hcl not found. Please run this script from the rocky94 directory.
    pause
    exit /b 1
)

REM Check if required tools are available
packer version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: packer is not installed or not in PATH
    pause
    exit /b 1
)

vagrant version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: vagrant is not installed or not in PATH
    pause
    exit /b 1
)

echo Starting Packer build...
echo This will take some time (typically 1-2 hours)...
echo.

REM Run the build
packer build -force -timestamp-ui rocky94.pkr.hcl

if %errorlevel% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build completed successfully!
echo The Rocky94 box has been automatically added to Vagrant.
echo.
echo To use the box:
echo   mkdir my-rocky94-vm
echo   cd my-rocky94-vm
echo   vagrant init Rocky94
echo   vagrant up
echo ========================================
pause