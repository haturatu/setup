#!/bin/bash

dotfiles_setup() {
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
