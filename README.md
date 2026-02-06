# 🚀 OS Packages: Production-Grade Environment Automator

A cross-platform, configuration-driven toolkit for automating the setup of development and productivity environments on **MacOS** and **Windows**. 

This repository provides robust, idempotent scripts that eliminate the manual toil of setting up a new machine. It leverages industry-standard package managers (**Homebrew** for Mac, **Chocolatey** for Windows) and centralizes software lists into easily maintainable configuration files.

### ✨ Key Features
- **Cross-Platform Consistency**: Parallel workflows for both Windows and MacOS.
- **Configuration-Driven**: Manage software via `Brewfile` (Mac) and `packages.config` (Windows).
- **Production-Grade Scripting**: Features built-in logging, error handling, and administrative privilege checks.
- **Idempotent Execution**: Safely re-run scripts multiple times without duplicating installations or causing errors.
- **Selective Installation**: Granular runtime flags to install only what you need.

## 🍎 MacOS Setup

Installs Homebrew, ZSH, Oh-My-Zsh, and a curated list of development and productivity tools.

### Usage
```bash
chmod +x MacOS/setup.sh
./MacOS/setup.sh
```

## 🪟 Windows Setup

Installs Chocolatey and uses `packages.config` to install software from the Chocolatey community repository.

### Usage
1. Open PowerShell or Command Prompt as **Administrator**.
2. Run with optional flags for selective installation:

**PowerShell (`setup.ps1`):**
```powershell
.\windows\setup.ps1 -InstallChoco     # Only check/install Chocolatey
.\windows\setup.ps1 -InstallPackages  # Only install packages
.\windows\setup.ps1 -All              # Install both (Default)
.\windows\setup.ps1 -Help             # Show help
```

**Batch (`packages.bat`):**
```batch
.\windows\packages.bat /choco         # Only check/install Chocolatey
.\windows\packages.bat /packages      # Only install packages
.\windows\packages.bat /all           # Install both (Default)
.\windows\packages.bat /help          # Show help
```

## 📦 Customizing Packages

- **MacOS**: Edit `MacOS/Brewfile`.
- **Windows**: Edit `windows/packages.config`.
