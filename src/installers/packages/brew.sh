#!/bin/bash

brew_setup() {
  check_commands brew || return

  log_info "Installing Homebrew packages..."
  brew install git vim curl go python node npm cargo wget p7zip rbenv ruby-build tree maturin

  # Prefer Homebrew curl in interactive shells.
  if ! grep -Fq 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' "$HOME/.zshrc" 2>/dev/null; then
    echo 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' >> "$HOME/.zshrc"
  fi
}
