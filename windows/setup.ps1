<#
.SYNOPSIS
    setup.ps1 - Unified Windows Environment Setup
.DESCRIPTION
    Installs Chocolatey and/or software packages from packages.config.
    Supports flags for selective installation.
.PARAMETER InstallChoco
    Install/Check Chocolatey only.
.PARAMETER InstallPackages
    Install packages from packages.config only.
.PARAMETER All
    Install both Chocolatey and packages (default behavior).
.EXAMPLE
    .\setup.ps1 -InstallChoco
    .\setup.ps1 -InstallPackages
    .\setup.ps1 -All
#>

param(
    [switch]$InstallChoco,
    [switch]$InstallPackages,
    [switch]$All,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# --- Help Output ---
if ($Help) {
    Write-Host "Usage: .\setup.ps1 [flags]"
    Write-Host "Flags:"
    Write-Host "  -InstallChoco     Only install/check Chocolatey."
    Write-Host "  -InstallPackages  Only install packages from packages.config."
    Write-Host "  -All              Install both (default if no flags provided)."
    Write-Host "  -Help             Show this help message."
    exit 0
}

# --- Logging Helpers ---
function Write-LogInfo { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] $Message" -ForegroundColor Green }
function Write-LogWarn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-LogError { param($Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }

# --- Elevation Check ---
function Test-IsAdmin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
    Write-LogError "This script must be run as an Administrator."
    exit 1
}

# Determine actions
$runChoco = $InstallChoco -or $All -or (-not $InstallChoco -and -not $InstallPackages)
$runPackages = $InstallPackages -or $All -or (-not $InstallChoco -and -not $InstallPackages)

Write-LogInfo "Starting Windows environment setup..."

# --- 1. Chocolatey Installation ---
if ($runChoco) {
    if (-not (Get-Command "choco" -ErrorAction SilentlyContinue)) {
        Write-LogWarn "Chocolatey not found. Installing..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        # Reload environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } else {
        Write-LogSuccess "Chocolatey is already installed."
    }
}

# --- 2. Package Installation ---
if ($runPackages) {
    $ConfigPath = Join-Path $PSScriptRoot "packages.config"

    if (Test-Path $ConfigPath) {
        Write-LogInfo "Installing packages from $ConfigPath..."
        choco install $ConfigPath -y --ignore-checksums
    } else {
        Write-LogError "packages.config not found at $ConfigPath."
    }
}

# --- Cleanup ---
if ($runChoco -or $runPackages) {
    Write-LogInfo "Optimizing Chocolatey..."
    choco optimize
    Write-LogSuccess "Windows setup completed successfully!"
}
