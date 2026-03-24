#!/bin/bash

pacman_setup() {
  log_info "Installing necessary packages..."

  if pacman -Qi linux-firmware >/dev/null 2>&1; then
    run_as_root pacman -Rdd --noconfirm linux-firmware
  fi

  run_as_root pacman -Syu --noconfirm

  local base_packages=(
    git vim curl go base-devel
    python python-pip python-virtualenv
    nodejs npm rust wget 7zip rbenv ruby-build
    chromium geoip ufw tree maturin
    chafa bash-completion
  )
  local repo_packages=()
  local missing_packages=()
  local ime_packages=(fcitx5 fcitx5-mozc fcitx5-configtool fcitx5-gtk fcitx5-qt)
  local ime_install=()
  local pkg

  for pkg in "${base_packages[@]}"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      repo_packages+=("$pkg")
    else
      missing_packages+=("$pkg")
    fi
  done

  if [ "${#repo_packages[@]}" -gt 0 ]; then
    run_as_root pacman -S --noconfirm --needed "${repo_packages[@]}"
  fi

  enable_ufw_if_possible

  for pkg in "${ime_packages[@]}"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      ime_install+=("$pkg")
    else
      missing_packages+=("$pkg")
    fi
  done

  if [ "${#ime_install[@]}" -gt 0 ]; then
    run_as_root pacman -S --noconfirm --needed "${ime_install[@]}"
  fi

  if pacman -Si fakeroot >/dev/null 2>&1; then
    run_as_root pacman -S --noconfirm --needed fakeroot
  fi

  if skip_in_ci "AUR package installation" "GitHub Actions Arch containers run as root and cannot build yay with makepkg"; then
    return 0
  fi

  if [ "$(id -u)" -eq 0 ]; then
    if [ "${#missing_packages[@]}" -gt 0 ]; then
      log_info "Skipping AUR packages in root environment: ${missing_packages[*]}"
    fi
    return 0
  fi

  if command -v yay >/dev/null 2>&1; then
    log_info "Yay is already installed."
  else
    log_info "Installing yay..."
    git clone https://aur.archlinux.org/yay.git "$HOME/yay"
    (
      cd "$HOME/yay" || exit 1
      makepkg -si --noconfirm
    )
    rm -rf "$HOME/yay"
  fi

  if command -v yay >/dev/null 2>&1 && [ "${#missing_packages[@]}" -gt 0 ]; then
    log_info "Installing missing packages via yay: ${missing_packages[*]}"
    yay -S --noconfirm --needed "${missing_packages[@]}" || true
  fi
}
