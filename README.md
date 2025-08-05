# Pi Power Guard

Safe and reversible power-saving configuration for Raspberry Pi 3B (Model 1.2) on Raspberry Pi OS Bookworm (Debian 12).

This project includes:
- A systemd service that disables USB (and Ethernet) when a flag file is present
- Config.txt modifications to disable HDMI output, Bluetooth, and other unused subsystems
- Full recovery possible by editing files on the SD card from another machine

---

## 🔧 What It Does

### 1. **USB + Ethernet Power Control via Systemd**
- Disables USB ports (and Ethernet, which is USB-based on the Pi 3B)
- Only runs if a flag file `/boot/firmware/disable_usb` exists
- If disabling fails, it creates a debug marker (`usb_disable_failed`) in the user’s home directory

### 2. **Static Power Savings via `config.txt`**
Disables firmware-based subsystems:
- HDMI output
- Onboard Bluetooth
- Onboard audio (optional)
- Camera firmware loading (optional)

All changes are safe to undo by editing the SD card offline.

---

## 📁 Files

| File                          | Purpose                                       |
|-------------------------------|-----------------------------------------------|
| `disable-usb.service`         | systemd unit that runs once at boot          |
| `disable-usb-if-flagged.sh`   | Script that checks for the flag and disables USB |
| `README.md`                   | This documentation                           |

---

## 🛠️ Setup Instructions

### 1. Install the systemd USB control service

```bash
sudo cp disable-usb.service /etc/systemd/system/
sudo cp disable-usb-if-flagged.sh /usr/local/sbin/
sudo chmod +x /usr/local/sbin/disable-usb-if-flagged.sh
sudo systemctl daemon-reload
sudo systemctl enable disable-usb.service
