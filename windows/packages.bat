@echo off
setlocal enabledelayedexpansion

:: packages.bat - Unified Windows Environment Setup (Batch Version)
:: Description: Wrapper for Chocolatey and package installation with flags.

set "LOG_PREFIX=[OS_SETUP]"
set "RUN_CHOCO=0"
set "RUN_PACKAGES=0"
set "SHOW_HELP=0"

:: Parse Arguments
:parse_args
if "%~1"=="" goto end_parse
if /i "%~1"=="/choco" set "RUN_CHOCO=1" & shift & goto parse_args
if /i "%~1"=="/packages" set "RUN_PACKAGES=1" & shift & goto parse_args
if /i "%~1"=="/all" set "RUN_CHOCO=1" & set "RUN_PACKAGES=1" & shift & goto parse_args
if /i "%~1"=="/help" set "SHOW_HELP=1" & shift & goto parse_args
if /i "%~1"=="-h" set "SHOW_HELP=1" & shift & goto parse_args
echo %LOG_PREFIX% Unknown argument: %~1
set "SHOW_HELP=1"
:end_parse

:: Defaults if no flags provided
if %RUN_CHOCO%==0 if %RUN_PACKAGES%==0 (
    set "RUN_CHOCO=1"
    set "RUN_PACKAGES=1"
)

if %SHOW_HELP%==1 (
    echo Usage: packages.bat [flags]
    echo Flags:
    echo   /choco    Only install/check Chocolatey.
    echo   /packages Only install packages from packages.config.
    echo   /all      Install both (default).
    echo   /help     Show this help message.
    exit /b 0
)

echo %LOG_PREFIX% Starting Windows environment setup...

:: Check Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo %LOG_PREFIX% ERROR: This script must be run as an Administrator.
    pause
    exit /b 1
)

:: 1. Chocolatey
if %RUN_CHOCO%==1 (
    where choco >nul 2>&1
    if %errorLevel% neq 0 (
        echo %LOG_PREFIX% Installing Chocolatey...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
        set "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
    ) else (
        echo %LOG_PREFIX% SUCCESS: Chocolatey is already installed.
    )
)

:: 2. Packages
if %RUN_PACKAGES%==1 (
    set "CONFIG_FILE=%~dp0packages.config"
    if exist "!CONFIG_FILE!" (
        echo %LOG_PREFIX% Installing packages...
        choco install "!CONFIG_FILE!" -y --ignore-checksums
    ) else (
        echo %LOG_PREFIX% ERROR: packages.config not found.
    )
)

choco optimize
echo %LOG_PREFIX% Setup completed!
pause
exit /b 0