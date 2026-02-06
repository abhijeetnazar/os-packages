#!/bin/bash

# packages.sh - Production-grade MacOS Environment Setup
# Author: Antigravity AI
# Description: Wrapper for setup.sh or standalone production-grade installation using Brewfile.

set -e

# --- Logging Setup ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check for setup.sh wrapper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/setup.sh" ]; then
    log_info "Redirecting to setup.sh..."
    exec "$SCRIPT_DIR/setup.sh"
fi

# Fallback production-grade logic if setup.sh is missing
log_info "Starting MacOS environment setup..."

if ! command -v brew >/dev/null 2>&1; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

BREWFILE="$SCRIPT_DIR/Brewfile"
if [ -f "$BREWFILE" ]; then
    log_info "Installing packages from $BREWFILE..."
    brew bundle install --file="$BREWFILE"
    log_success "Setup completed successfully!"
else
    log_error "Brewfile not found at $BREWFILE"
    exit 1
fi