#!/bin/bash

# This script sets the timezone to Asia/Tokyo and updates the system clock.
timezone_set() {
    local timezone="Asia/Tokyo"
    
    # Set the timezone
    sudo ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime
    
    # Update the system clock
    sudo hwclock --systohc
    
    echo "Timezone set to $timezone and system clock updated."
}
