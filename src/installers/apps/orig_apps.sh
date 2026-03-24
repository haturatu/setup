#!/bin/bash

install_python_dependencies() {
  local app_name="$1"

  if [ ! -f "requirements.txt" ]; then
    return 0
  fi

  log_info "Installing Python dependencies for $app_name..."

  if command -v pip3 >/dev/null 2>&1; then
    pip3 install -r requirements.txt
  else
    pip install -r requirements.txt
  fi
}

install_app_payload() {
  local app_name="$1"
  local install_method="${INSTALL_METHODS[$app_name]:-user}"

  if [ -f "Makefile" ]; then
    log_info "Installing $app_name using Makefile..."
    make build

    case "$install_method" in
      sudo)
        run_as_root make install
        ;;
      user)
        make install
        ;;
      *)
        log_info "Unknown install method for $app_name: $install_method"
        make install
        ;;
    esac
    return 0
  fi

  if [ -f "install.sh" ]; then
    bash install.sh
    return 0
  fi

  if [ -f "setup.sh" ]; then
    bash setup.sh
    return 0
  fi

  log_info "No install script found for $app_name"
}

orig_app_setup() {
  check_commands git || return

  local workspace_dir="$HOME/git"
  local repo_url
  local app_name
  local app_dir

  ensure_dir "$workspace_dir"

  for repo_url in "${APP_REPOS[@]}"; do
    app_name="$(basename "$repo_url" .git)"
    app_dir="$workspace_dir/$app_name"

    clone_or_update_repo "$repo_url" "$app_dir" || {
      log_error "Failed to prepare repository: $repo_url"
      continue
    }

    (
      cd "$app_dir" || exit 1
      install_python_dependencies "$app_name" || exit 1
      install_app_payload "$app_name"
    ) || log_error "Installation failed for $app_name"
  done
}
