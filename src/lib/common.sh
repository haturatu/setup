#!/bin/bash

log_info() {
  echo "$*"
}

log_error() {
  echo "$*" >&2
}

is_ci() {
  [ "${CI:-}" = "true" ] || [ "${GITHUB_ACTIONS:-}" = "true" ]
}

check_commands() {
  local missing=()
  local cmd

  for cmd in "$@"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing+=("$cmd")
    fi
  done

  if [ "${#missing[@]}" -ne 0 ]; then
    printf '%s\n' "${missing[@]}"
    return 1
  fi
}

require_env() {
  local missing=()
  local name

  for name in "$@"; do
    if [ -z "${!name:-}" ]; then
      missing+=("$name")
    fi
  done

  if [ "${#missing[@]}" -ne 0 ]; then
    log_error "Please set environment variables: ${missing[*]}"
    return 1
  fi
}

ensure_dir() {
  mkdir -p "$1"
}

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
    return
  fi

  if command -v sudo >/dev/null 2>&1; then
    sudo "$@"
    return
  fi

  log_error "This step requires root privileges: $*"
  return 1
}

skip_in_ci() {
  local task_name="$1"
  local reason="${2:-}"

  if ! is_ci; then
    return 1
  fi

  if [ -n "$reason" ]; then
    log_info "Skipping $task_name in CI: $reason"
  else
    log_info "Skipping $task_name in CI."
  fi
  return 0
}

enable_ufw_if_possible() {
  if skip_in_ci "firewall setup" "containerized runners cannot safely modify ufw or iptables"; then
    return 0
  fi

  if ! command -v ufw >/dev/null 2>&1; then
    log_info "ufw command not found. Skipping firewall setup."
    return 0
  fi

  if run_as_root ufw enable; then
    return 0
  fi

  log_info "ufw enable failed in this environment. Skipping firewall setup."
  return 0
}

clone_or_update_repo() {
  local repo_url="$1"
  local dest_dir="$2"

  if [ -d "$dest_dir/.git" ]; then
    git -C "$dest_dir" pull --ff-only || {
      log_error "Failed to update repository: $dest_dir"
      return 1
    }
    return 0
  fi

  git clone "$repo_url" "$dest_dir"
}
