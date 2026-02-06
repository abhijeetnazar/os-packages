# OS Packages Setup

Production-grade scripts to automate the installation of essential software on MacOS and Windows.

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
