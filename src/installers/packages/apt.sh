#!/bin/bash

apt_setup() {
  log_info "Updating package lists..."
  run_as_root apt update -y

  log_info "Installing necessary packages..."
  run_as_root apt install -y \
    git vim curl golang-go build-essential \
    python3 python3-pip python3-venv nodejs npm \
    cargo wget 7zip rbenv ruby-build ufw tree python3-maturin \
    chafa bash-completion

  run_as_root ufw enable
}
