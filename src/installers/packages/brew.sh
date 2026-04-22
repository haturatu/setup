#!/bin/bash

BREW_PACKAGE_FILE="$SCRIPT_DIR/config/packages/brew.txt"

brew_setup() {
  local packages=()

  check_commands brew || return
  load_package_list "$BREW_PACKAGE_FILE" packages

  log_info "Installing Homebrew packages..."
  brew install "${packages[@]}"

  # Prefer Homebrew curl in interactive shells.
  if ! grep -Fq 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' "$HOME/.zshrc" 2>/dev/null; then
    echo 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' >> "$HOME/.zshrc"
  fi
}
