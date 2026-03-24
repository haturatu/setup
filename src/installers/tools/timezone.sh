#!/bin/bash

timezone_set() {
  local timezone="Asia/Tokyo"

  sudo ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime

  if command -v hwclock >/dev/null 2>&1; then
    sudo hwclock --systohc
  else
    log_info "hwclock command not found. Skipping system clock update."
  fi

  log_info "Timezone set to $timezone and system clock updated."
}
