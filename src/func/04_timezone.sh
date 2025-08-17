#!/bin/bash

# This script sets the timezone to Asia/Tokyo and updates the system clock.
timezone_set() {
    local timezone="Asia/Tokyo"
    
    # Set the timezone
    sudo ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime
    
    # Update the system clock
    if [ command -v hwclock > /dev/null ]; then
        sudo hwclock --systohc
    else
        echo "hwclock command not found. Skipping system clock update."
    fi
    
    echo "Timezone set to $timezone and system clock updated."
}
