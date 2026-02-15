#!/bin/bash

# ============================================
#  Universal Ubuntu Auto-Update Script
#  - Runs system updates
#  - Cleans old packages
#  - Logs output
#  - Self-installs cronjob (runs as root)
#  - Does NOT require executable permissions
#  - Built-in log rotation (max 35 MB, 1 backup)
# ============================================

LOGFILE="/var/log/system-update.log"
CRONFILE="/etc/cron.d/system-auto-update"
SCRIPT_PATH="/usr/local/bin/update-system.sh"
MAXSIZE=$((35 * 1024 * 1024))   # 35 MB in bytes

# --------------------------------------------
# Log rotation (1 rotation only)
# --------------------------------------------
if [ -f "$LOGFILE" ]; then
    FILESIZE=$(stat -c%s "$LOGFILE")
    if [ "$FILESIZE" -gt "$MAXSIZE" ]; then
        mv "$LOGFILE" "${LOGFILE}.1"
        touch "$LOGFILE"
        echo "===== Log rotated: $(date) =====" >> "$LOGFILE"
    fi
fi

echo "===== System Update started: $(date) =====" | tee -a "$LOGFILE"

# --------------------------------------------
# System updates
# --------------------------------------------
apt update -y >> "$LOGFILE" 2>&1
apt upgrade -y >> "$LOGFILE" 2>&1
apt full-upgrade -y >> "$LOGFILE" 2>&1
apt autoremove -y >> "$LOGFILE" 2>&1
apt autoclean -y >> "$LOGFILE" 2>&1

echo "===== System Update finished: $(date) =====" | tee -a "$LOGFILE"

# --------------------------------------------
# Install cronjob if missing
# --------------------------------------------
if [ ! -f "$CRONFILE" ]; then
    echo "Installing cronjob..."
    echo "0 3 * * * root bash $SCRIPT_PATH >/dev/null 2>&1" > "$CRONFILE"
    chmod 644 "$CRONFILE"
fi
