#!/bin/bash

apt_setup_docker_repository() {
  log_info "Installing prerequisite packages for Docker repository..."
  run_as_root apt update -y
  run_as_root apt install -y ca-certificates curl gnupg lsb-release

  log_info "Setting up Docker GPG key..."
  run_as_root install -m 0755 -d /etc/apt/keyrings

  if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    curl -fsSL https://download.docker.com/linux/debian/gpg | run_as_root gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  fi

  run_as_root chmod a+r /etc/apt/keyrings/docker.gpg

  log_info "Adding Docker APT repository..."
  local codename
  local arch
  local docker_repo_distro

  . /etc/os-release

  case "$ID" in
    ubuntu)
      docker_repo_distro="ubuntu"
      codename="${VERSION_CODENAME:-$(lsb_release -cs)}"
      ;;
    linuxmint)
      docker_repo_distro="ubuntu"
      codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-$(lsb_release -cs)}}"
      ;;
    debian|devuan)
      docker_repo_distro="debian"
      codename="${VERSION_CODENAME:-$(lsb_release -cs)}"
      ;;
    *)
      log_error "Unsupported APT distro for Docker repository: $ID"
      return 1
      ;;
  esac

  arch="$(dpkg --print-architecture)"

  printf 'deb [arch=%s signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/%s %s stable\n' \
    "$arch" "$docker_repo_distro" "$codename" | run_as_root tee /etc/apt/sources.list.d/docker.list >/dev/null
}

apt_postinstall_docker() {
  if skip_in_ci "docker service enablement" "CI runners should not modify docker daemon startup state"; then
    return 0
  fi

  log_info "Enabling Docker service..."
  run_as_root systemctl enable docker
  run_as_root systemctl start docker

  log_info "Verifying Docker installation..."
  docker --version || true
  docker compose version || true
}

apt_setup() {
  apt_setup_docker_repository

  log_info "Updating package lists..."
  run_as_root apt update -y

  log_info "Installing necessary packages..."
  run_as_root apt install -y \
    git vim curl golang-go build-essential \
    python3 python3-pip python3-venv nodejs npm \
    cargo wget 7zip rbenv ruby-build ufw tree python3-maturin \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    chafa bash-completion

  enable_ufw_if_possible
  apt_postinstall_docker
}
