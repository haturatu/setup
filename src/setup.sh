#!/bin/bash
set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/os.sh"
source "$SCRIPT_DIR/config/apps.sh"
source "$SCRIPT_DIR/installers/packages/apt.sh"
source "$SCRIPT_DIR/installers/packages/pacman.sh"
source "$SCRIPT_DIR/installers/packages/brew.sh"
source "$SCRIPT_DIR/installers/tools/vim.sh"
source "$SCRIPT_DIR/installers/tools/git.sh"
source "$SCRIPT_DIR/installers/tools/pip.sh"
source "$SCRIPT_DIR/installers/tools/timezone.sh"
source "$SCRIPT_DIR/installers/apps/dotfiles.sh"
source "$SCRIPT_DIR/installers/apps/orig_apps.sh"

install_packages() {
  local os_id="$1"

  case "$os_id" in
    debian|ubuntu|linuxmint|devuan)
      apt_setup
      ;;
    arch|manjaro|artix)
      pacman_setup
      ;;
    macos)
      brew_setup
      ;;
    *)
      log_error "Unsupported OS: $os_id"
      return 1
      ;;
  esac
}

main() {
  require_env GIT_USER GIT_EMAIL

  local os_id
  os_id="$(detect_os)"

  install_packages "$os_id"
  vim_setup
  git_setup
  pip_setup
  timezone_set
  dotfiles_setup
  orig_app_setup
}

main "$@"
