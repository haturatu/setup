APP_LIST=(
  "https://github.com/haturatu/ght.git"
  "https://github.com/haturatu/cuckooget.git"
)

# インストール方法を定義する連想配列
declare -A INSTALL_METHODS=(
  ["ght"]="sudo"
  ["cuckooget"]="user"
)

orig_app_setup() {
  check_commands git || return

  mkdir -p git
  cd git || return
  if [ ! -d "dotfiles" ]; then
    git clone https://github.com/haturatu/dotfiles.git
    cd dotfiles || return
    make install
    source ~/.bashrc || return
  else
    cd dotfiles || return
    git pull || { echo "Failed to update dotfiles"; return; }
  fi

  for app in "${APP_LIST[@]}"; do
    git clone "$app" || { echo "Failed to clone $app"; continue; }
    app_name=$(basename "$app" .git)
    cd "$app_name" || continue

    if [ -f "requirements.txt" ]; then
      echo "Installing Python dependencies for $app_name..."
      pip_cmd="pip3"
      if ! command -v pip3 >/dev/null 2>&1; then
        pip_cmd="pip"
      fi
      $pip_cmd install -r requirements.txt || { echo "pip install failed for $app_name"; continue; }
    fi

    if [ -f "Makefile" ]; then
      echo "Installing $app_name using Makefile..."
      
      make build || { echo "Make build failed for $app_name"; continue; }
      
      case "${INSTALL_METHODS[$app_name]}" in
        "sudo")
          echo "Using sudo for installation..."
          sudo make install || { echo "sudo make install failed for $app_name"; continue; }
          ;;
        "user")
          echo "Installing without sudo..."
          make install || { echo "make install failed for $app_name"; continue; }
          ;;
        *)
          echo "No install method specified for $app_name, defaulting to non-sudo"
          make install || { echo "make install failed for $app_name"; continue; }
          ;;
      esac

    elif [ -f "install.sh" ]; then
      bash install.sh || { echo "Install script failed for $app_name"; continue; }
    elif [ -f "setup.sh" ]; then
      bash setup.sh || { echo "Setup script failed for $app_name"; continue; }
    else
      echo "No install script found for $app_name"
    fi

    cd .. || return
  done
}
