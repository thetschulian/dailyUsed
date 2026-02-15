#!/bin/bash

# ============================================
#  Universal Ubuntu Auto-Update Script
#  - Runs system updates
#  - Cleans old packages
#  - Logs output
#  - Self-installs cronjob (runs as root)
#  - Does NOT require executable permissions
#  - Built-in log rotation (max 35 MB, 1 backup)
#  - Dry-run mode (--dry-run or -n)
# ============================================

LOGFILE="/var/log/system-update.log"
CRONFILE="/etc/cron.d/system-auto-update"
SCRIPT_PATH="/usr/local/bin/update-system.sh"
MAXSIZE=$((35 * 1024 * 1024))   # 35 MB in bytes

# --------------------------------------------
# Dry-run detection
# --------------------------------------------
DRYRUN=false
if [[ "$1" == "--dry-run" || "$1" == "-n" ]]; then
    DRYRUN=true
fi

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

if [ "$DRYRUN" = true ]; then
    echo "===== DRY RUN started: $(date) =====" | tee -a "$LOGFILE"
else
    echo "===== System Update started: $(date) =====" | tee -a "$LOGFILE"
fi

# --------------------------------------------
# System updates
# --------------------------------------------
if [ "$DRYRUN" = true ]; then
    echo "[DRY RUN] apt update" | tee -a "$LOGFILE"
    echo "[DRY RUN] apt upgrade" | tee -a "$LOGFILE"
    echo "[DRY RUN] apt full-upgrade" | tee -a "$LOGFILE"
    echo "[DRY RUN] apt autoremove" | tee -a "$LOGFILE"
    echo "[DRY RUN] apt autoclean" | tee -a "$LOGFILE"
else
    apt update -y >> "$LOGFILE" 2>&1
    apt upgrade -y >> "$LOGFILE" 2>&1
    apt full-upgrade -y >> "$LOGFILE" 2>&1
    apt autoremove -y >> "$LOGFILE" 2>&1
    apt autoclean -y >> "$LOGFILE" 2>&1
fi

if [ "$DRYRUN" = true ]; then
    echo "===== DRY RUN finished: $(date) =====" | tee -a "$LOGFILE"
else
    echo "===== System Update finished: $(date) =====" | tee -a "$LOGFILE"
fi

# --------------------------------------------
# Install cronjob if missing
# --------------------------------------------
if [ ! -f "$CRONFILE" ]; then
    echo "Installing cronjob..."
    echo "0 3 * * * root bash $SCRIPT_PATH >/dev/null 2>&1" > "$CRONFILE"
    chmod 644 "$CRONFILE"
fi
