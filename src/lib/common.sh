#!/bin/bash

log_info() {
  echo "$*"
}

log_error() {
  echo "$*" >&2
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
