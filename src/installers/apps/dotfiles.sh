#!/bin/bash

dotfiles_setup() {
  if skip_in_ci "dotfiles setup" "CI does not need to install personal dotfiles"; then
    return 0
  fi

  check_commands git make || return

  local workspace_dir="$HOME/git"
  local dotfiles_dir="$workspace_dir/dotfiles"

  ensure_dir "$workspace_dir"
  clone_or_update_repo "https://github.com/haturatu/dotfiles.git" "$dotfiles_dir"

  (
    cd "$dotfiles_dir" || exit 1
    make install
  )
}
