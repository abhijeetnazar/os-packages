#!/bin/bash

# setup.sh - Production-grade MacOS Environment Setup
# Author: Antigravity AI
# Description: Installs Homebrew, ZSH, and packages from Brewfile.

set -e # Exit on error
set -u # Treat unset variables as an error

# --- Logging Setup ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# --- Helper Functions ---

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Main Script ---

log_info "Starting MacOS environment setup..."

# 1. Homebrew Installation
if ! command_exists "brew"; then
    log_info "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add brew to PATH for the current session
    if [[ -d "/opt/homebrew/bin" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    elif [[ -d "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
    fi
else
    log_success "Homebrew is already installed."
    # Ensure shellenv is loaded in current session
    if [[ -d "/opt/homebrew/bin" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# 2. ZSH & Oh-My-Zsh
if ! command_exists "zsh"; then
    log_info "Installing ZSH..."
    brew install zsh
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    log_success "Oh-My-Zsh is already installed."
fi

# 3. Install Packages from Brewfile
BREWFILE_PATH="$(dirname "$0")/Brewfile"

if [ -f "$BREWFILE_PATH" ]; then
    log_info "Installing packages from $BREWFILE_PATH..."
    brew bundle install --file="$BREWFILE_PATH"
else
    log_error "Brewfile not found at $BREWFILE_PATH"
    exit 1
fi

# 4. Cleanup
log_info "Cleaning up brew cache..."
brew cleanup

log_success "MacOS setup completed successfully!"
