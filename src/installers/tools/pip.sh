#!/bin/bash

pip_setup() {
  local pip_dir="$HOME/.pip"
  local pip_conf="$pip_dir/pip.conf"

  if command -v pip3 >/dev/null 2>&1; then
    :
  elif command -v pip >/dev/null 2>&1; then
    :
  else
    check_commands pip3 pip || return
  fi

  ensure_dir "$pip_dir"

  if [ ! -f "$pip_conf" ]; then
    {
      echo "[global]"
      echo "break-system-packages = true"
    } > "$pip_conf"
  else
    log_info "pip configuration already exists."
  fi
}
