#!/bin/bash

timezone_set() {
  local timezone="Asia/Tokyo"

  if skip_in_ci "timezone setup" "CI should not modify the runner timezone or hardware clock"; then
    return 0
  fi

  run_as_root ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime

  if command -v hwclock >/dev/null 2>&1; then
    run_as_root hwclock --systohc
  else
    log_info "hwclock command not found. Skipping system clock update."
  fi

  log_info "Timezone set to $timezone and system clock updated."
}
