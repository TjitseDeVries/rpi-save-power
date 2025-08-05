#!/bin/bash

# Path to flag file on boot partition
FLAG_FILE="/boot/firmware/disable_usb"

# Path to USB power control
USB_PWR_PATH="/sys/devices/platform/soc/3f980000.usb/buspower"

# Fallback dummy file name
DUMMY_FILE="usb_disable_failed"

# Resolve home directory of the invoking user (fallback to /root)
USER_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
USER_HOME="${USER_HOME:-/root}"

# Proceed only if the flag file exists
if [ -f "$FLAG_FILE" ]; then
    echo "Flag file found: $FLAG_FILE"

    if [ -w "$USB_PWR_PATH" ]; then
        echo 0 > "$USB_PWR_PATH" && echo "USB power disabled." || {
            echo "Failed to write to $USB_PWR_PATH"
            touch "$USER_HOME/$DUMMY_FILE"
        }
    else
        echo "Path not writable: $USB_PWR_PATH"
        touch "$USER_HOME/$DUMMY_FILE"
    fi
else
    echo "Flag file not present. USB remains enabled."
fi
