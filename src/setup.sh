#!/bin/bash
set -x

#GIT_USER="haturatu"
#GIT_EMAIL="taro@eyes4you.org"

if [ -z "${GIT_USER}" ] || [ -z "${GIT_EMAIL}" ]; then
    echo "Please set GIT_USER and GIT_EMAIL environment variables."
    exit 1
fi

source ./func/00_package_install.sh
source ./func/01_vim.sh
source ./func/02_git.sh

missing_command=()

check_commands() {
    local missing=()
    for cmd in "$@"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done

    if [ "${#missing[@]}" -ne 0 ]; then
        for cmd in "${missing[@]}"; do
            echo "$cmd"
        done
        return 1
    fi
    return 0
}

dotfiles_install() {
  if [ ! -d "$HOME/git/dotfiles" ]; then
    echo "Creating directory for dotfiles..."
    mkdir -p "$HOME/git"
    git clone https://github.com/haturatu/dotfiles.git
    make install
  else
    echo "Directory for dotfiles already exists."
  fi
}

main() {
  os_id=$(detect_os)

  case "$os_id" in
    debian|ubuntu|linuxmint|devuan)
      apt_setup || return
      ;;
    arch|manjaro|artix)
      pacman_setup || return
      ;;
    macos)
      brew_setup || return
      ;;
    *)
      echo "Unsupported OS: $os_id"
      return 1
      ;;
  esac

  vim_setup
  git_setup
}

main
