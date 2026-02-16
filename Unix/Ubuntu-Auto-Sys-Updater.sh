#!/bin/bash
######### Download 
#
#  sudo curl -o /usr/local/bin/update-system.sh https://raw.githubusercontent.com/thetschulian/dailyUsed/main/Unix/Ubuntu-Auto-Sys-Updater.sh
#  sudo bash /usr/local/bin/update-system.sh
#  more /var/log/system-update.log
#
######### Download 

# ============================================
#  Universal Ubuntu Auto-Update Script
#  - Runs system updates
#  - Cleans old packages
#  - Logs output with dividers
#  - Self-installs cronjob (runs as root sundays 3am)
#  - Does NOT require executable permissions
#  - Built-in log rotation (max 35 MB, 1 backup)
#  - Dry-run mode (--dry-run or -n)
#  - Visual output for manual execution
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
        echo "===== LOG ROTATED: $(date) =====" >> "$LOGFILE"
    fi
fi

# --------------------------------------------
# Log divider for easier debugging
# --------------------------------------------
{
echo ""
echo "============================================================"
echo "===== NEW RUN: $(date) ====="
echo "============================================================"
echo ""
} >> "$LOGFILE"

# --------------------------------------------
# Visual output header
# --------------------------------------------
if [ "$DRYRUN" = true ]; then
    echo "🔧 DRY RUN MODE — no changes will be applied"
else
    echo "🔧 SYSTEM UPDATE STARTED"
fi
echo "Logfile: $LOGFILE"
echo "--------------------------------------------"

# --------------------------------------------
# System updates
# --------------------------------------------
if [ "$DRYRUN" = true ]; then
    echo "[DRY RUN] apt update"
    echo "[DRY RUN] apt upgrade"
    echo "[DRY RUN] apt full-upgrade"
    echo "[DRY RUN] apt autoremove"
    echo "[DRY RUN] apt autoclean"

    echo "[DRY RUN] apt update"       >> "$LOGFILE"
    echo "[DRY RUN] apt upgrade"      >> "$LOGFILE"
    echo "[DRY RUN] apt full-upgrade" >> "$LOGFILE"
    echo "[DRY RUN] apt autoremove"   >> "$LOGFILE"
    echo "[DRY RUN] apt autoclean"    >> "$LOGFILE"

else
    echo "→ Running apt update..."
    echo "→ Running apt update..." >> "$LOGFILE" 2>&1
    apt update -y >> "$LOGFILE" 2>&1

    echo "→ Running apt upgrade..."
    echo "→ Running apt upgrade..." >> "$LOGFILE" 2>&1
    apt upgrade -y >> "$LOGFILE" 2>&1

    echo "→ Running apt full-upgrade..."
    echo "→ Running apt full-upgrade..." >> "$LOGFILE" 2>&1
    apt full-upgrade -y >> "$LOGFILE" 2>&1

    echo "→ Running apt autoremove..."
    echo "→ Running apt autoremove..." >> "$LOGFILE" 2>&1
    apt autoremove -y >> "$LOGFILE" 2>&1

    echo "→ Running apt autoclean..."
    echo "→ Running apt autoclean..." >> "$LOGFILE" 2>&1
    apt autoclean -y >> "$LOGFILE" 2>&1
fi

# --------------------------------------------
# Visual footer
# --------------------------------------------
if [ "$DRYRUN" = true ]; then
    echo "--------------------------------------------"
    echo "✔ DRY RUN FINISHED"
else
    echo "--------------------------------------------"
    echo "✔ SYSTEM UPDATE FINISHED"
fi

# --------------------------------------------
# Install cronjob if missing
# --------------------------------------------
if [ ! -f "$CRONFILE" ]; then
    echo "Installing cronjob to run updates daily at 3 am ..."
    echo "0 3 * * * root bash $SCRIPT_PATH >/dev/null 2>&1" > "$CRONFILE"
    chmod 644 "$CRONFILE"
    echo "Setting Timezone to Europe/Berlin"
    timedatectl set-timezone Europe/Berlin
fi
