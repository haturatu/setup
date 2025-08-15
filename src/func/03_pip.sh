#!/bin/bash

# vim-plug installation script
pip_setup() {
  check_commands pip python || return

  if [ ! -f ~/.pip ]; then
    mkdir -p ~/.pip
  fi

  if [ ! -f ~/.pip/pip.conf ]; then
    echo "[global]" > ~/.pip/pip.conf
    echo "break-system-packages = true" >> ~/.pip/pip.conf
  else
    echo "pip configuration already exists."
  fi
  
}

