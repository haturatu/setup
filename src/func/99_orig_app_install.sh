#!/bin/bash

APP_LIST=(
  "https://github.com/haturatu/ght.git"
  "https://github.com/haturatu/cuckooget.git"
)

# vim-plug installation script
orig_app_setup() {
  check_commands git || return

  mkdir -p git
  cd git || return
  if [ ! -d "dotfiles" ]; then
    git clone https://github.com/haturatu/dotfiles.git
    cd dotfiles || return
    make install
    source ~/.bashrc || return
  else
    cd dotfiles || return
    git pull || { echo "Failed to update dotfiles"; return; }
  fi

  for app in "${APP_LIST[@]}"; do
    git clone "$app" || { echo "Failed to clone $app"; continue; }
    app_name=$(basename "$app" .git)
    cd "$app_name" || continue

    # Check for requirements.txt and install Python dependencies if it exists
    if [ -f "requirements.txt" ]; then
      echo "Installing Python dependencies for $app_name..."
      if command -v pip3 >/dev/null 2>&1; then
        pip3 install -r requirements.txt || { echo "pip install failed for $app_name"; continue; }
      elif command -v pip >/dev/null 2>&1; then
        pip install -r requirements.txt || { echo "pip install failed for $app_name"; continue; }
      else
        echo "pip not found, skipping Python dependencies for $app_name"
      fi
    fi

    if [ -f "Makefile" ]; then
      echo "Installing $app_name using Makefile..."
      make build || { echo "Make build failed for $app_name"; continue; }
      sudo make install || { echo "Make failed for $app_name"; continue; }
    elif [ -f "install.sh" ]; then
      echo "Running install script for $app_name..."
      bash install.sh || { echo "Install script failed for $app_name"; continue; }
    elif [ -f "setup.sh" ]; then
      echo "Running setup script for $app_name..."
      bash setup.sh || { echo "Setup script failed for $app_name"; continue; }
    else
      echo "No install script found for $app_name"
    fi

    cd .. || return
  done

}

