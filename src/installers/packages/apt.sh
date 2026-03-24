#!/bin/bash

apt_setup() {
  log_info "Updating package lists..."
  sudo apt update -y

  log_info "Installing necessary packages..."
  sudo apt install -y \
    git vim curl golang-go build-essential \
    python3 python3-pip python3-venv nodejs npm \
    cargo wget 7zip rbenv ruby-build ufw tree maturin \
    chafa bash-completion

  sudo ufw enable
}
