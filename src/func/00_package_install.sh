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
    cargo wget 7zip rbenv ruby-build ufw tree
  sudo ufw enable
}

# Arch/Manjaro/Artix specific setup
pacman_setup() {
  echo "Installing necessary packages..."
  sudo pacman -Rdd linux-firmware
  sudo pacman -Syu --noconfirm \
    git vim curl go base-devel \
    python python-pip python-virtualenv \                                             nodejs npm cargo wget 7zip rbenv ruby-build \
    chromium geoip ufw tree
  sudo ufw enable

  # Install mozoc and fcitx5
  sudo pacman -S --noconfirm \
    fcitx5 fcitx5-mozc fcitx5-configtool \
    fcitx5-gtk fcitx5-qt 

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
}

# macOS specific setup
brew_setup() {
  check_commands brew || return

  echo "Installing Homebrew packages..."
  brew install git vim curl go python node npm cargo wget p7zip curl rbenv ruby-build tree
  # Change default curl to use the Homebrew version
  echo 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc
}

