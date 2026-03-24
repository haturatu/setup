#!/bin/bash

detect_os() {
  if [[ "$OSTYPE" == darwin* ]]; then
    echo "macos"
  elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "$ID"
  else
    echo "unknown"
  fi
}
