#/bin/bash

detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "$ID"
  else
    echo "unknown OS"
  fi
}

# Debian/Ubuntu/Linux Mint specific setup
apt_setup() {
  echo "Updating package lists..."
  sudo apt update -y

  echo "Installing necessary packages..."
  sudo apt install -y \
    git vim curl golang-go build-essential \
    python3 python3-pip python3-venv nodejs npm \
    cargo wget 7zip rbenv ruby-build ufw tree maturin \
    chafa 
  sudo ufw enable
}

# Arch/Manjaro/Artix specific setup
pacman_setup() {
  echo "Installing necessary packages..."
  if pacman -Qi linux-firmware >/dev/null 2>&1; then
    sudo pacman -Rdd --noconfirm linux-firmware
  fi

  sudo pacman -Syu --noconfirm

  local base_packages=(
    git vim curl go base-devel
    python python-pip python-virtualenv
    nodejs npm rust wget 7zip rbenv ruby-build
    chromium geoip ufw tree maturin
    chafa
  )
  local repo_packages=()
  local missing_packages=()

  for pkg in "${base_packages[@]}"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      repo_packages+=("$pkg")
    else
      missing_packages+=("$pkg")
    fi
  done

  if [ "${#repo_packages[@]}" -gt 0 ]; then
    sudo pacman -S --noconfirm --needed "${repo_packages[@]}"
  fi

  sudo ufw enable

  # Install mozc and fcitx5
  local ime_packages=(fcitx5 fcitx5-mozc fcitx5-configtool fcitx5-gtk fcitx5-qt)
  local ime_install=()
  for pkg in "${ime_packages[@]}"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      ime_install+=("$pkg")
    else
      missing_packages+=("$pkg")
    fi
  done
  if [ "${#ime_install[@]}" -gt 0 ]; then
    sudo pacman -S --noconfirm --needed "${ime_install[@]}"
  fi

  if pacman -Si fakeroot >/dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed fakeroot
  fi

  if command -v yay &> /dev/null; then
    echo "Yay is already installed."
  else
    echo "Installing yay..."
    cd ~
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf yay
  fi

  if command -v yay &> /dev/null && [ "${#missing_packages[@]}" -gt 0 ]; then
    echo "Installing missing packages via yay: ${missing_packages[*]}"
    yay -S --noconfirm --needed "${missing_packages[@]}" || true
  fi
}

# macOS specific setup
brew_setup() {
  check_commands brew || return

  echo "Installing Homebrew packages..."
  brew install git vim curl go python node npm cargo wget p7zip curl rbenv ruby-build tree maturin
  # Change default curl to use the Homebrew version
  echo 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc
}
