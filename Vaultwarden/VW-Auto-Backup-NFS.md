##  Enable Auto-Backup (Docker Images, SQL, local files)
> To enable Auto Backup blabla
>
> sudo nano /usr/local/bin/backup-vaultwarden.sh

```bash
#!/bin/bash
###############################################################
# Vaultwarden Backup Script (Self‑Installing, Full Features)
# - Backs up Vaultwarden directory
# - Dumps PostgreSQL database
# - Saves Docker images
# - Retains last 7 backups
# - Ensures NFS share is mounted
# - Logs with rotation
# - Installs cronjob (Sundays 02:30)
###############################################################

set -e

# === Configuration ===
SOURCE_DIR="/home/user/Vault-DIR"
BACKUP_DIR="/mnt/USB-BACKUP"
NFS_SERVER="192.168.0.0"
NFS_EXPORT="/mnt/usb-backupdisk/BACKUP-DISK/VaultWarden"

DATE=$(date +%F_%H-%M)

DB_CONTAINER="vaultwarden-db-container"
DB_NAME="vaultwarden-db"
DB_USER="vault-user"
DB_PASSWORD="changeme"

VAULTWARDEN_IMAGE="vaultwarden/server:latest"
POSTGRES_IMAGE="postgres:16"

LOG_FILE="/var/log/vaultwarden-backup.log"
MAX_LOG_SIZE=$((100 * 1024 * 1024))  # 100 MB

CRONFILE="/etc/cron.d/vaultwarden-backup"
SCRIPT_PATH="/usr/local/bin/backup-vaultwarden.sh"

###############################################################
# Log rotation
###############################################################
if [ -f "$LOG_FILE" ]; then
    FILESIZE=$(stat -c%s "$LOG_FILE")
    if [ "$FILESIZE" -gt "$MAX_LOG_SIZE" ]; then
        mv "$LOG_FILE" "${LOG_FILE}.1"
        touch "$LOG_FILE"
        echo "===== LOG ROTATED: $(date) =====" >> "$LOG_FILE"
    fi
fi

###############################################################
# Log header
###############################################################
{
echo ""
echo "============================================================"
echo "===== VAULTWARDEN BACKUP RUN: $(date) ====="
echo "============================================================"
echo ""
} >> "$LOG_FILE"

echo "📦 Starting Vaultwarden backup..."
echo "Logfile: $LOG_FILE"
echo "--------------------------------------------"

###############################################################
# Ensure NFS share is mounted
###############################################################
if ! mountpoint -q "$BACKUP_DIR"; then
    echo "→ NFS share not mounted. Attempting to mount..." | tee -a "$LOG_FILE"
    mount -t nfs "${NFS_SERVER}:${NFS_EXPORT}" "$BACKUP_DIR" >> "$LOG_FILE" 2>&1

    if ! mountpoint -q "$BACKUP_DIR"; then
        echo "❌ ERROR: Failed to mount NFS share ${NFS_SERVER}:${NFS_EXPORT}" | tee -a "$LOG_FILE"
        exit 1
    fi

    echo "→ Successfully mounted NFS share." | tee -a "$LOG_FILE"
fi

mkdir -p "$BACKUP_DIR"

###############################################################
# Backup Vaultwarden directory
###############################################################
echo "→ Backing up Vaultwarden directory..." | tee -a "$LOG_FILE"
tar -czf "$BACKUP_DIR/vaultwarden_full_$DATE.tar.gz" \
    -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" >> "$LOG_FILE" 2>&1

echo "✔ Directory backup complete." | tee -a "$LOG_FILE"

###############################################################
# Backup PostgreSQL database
###############################################################
echo "→ Dumping PostgreSQL database..." | tee -a "$LOG_FILE"

docker exec -e PGPASSWORD="$DB_PASSWORD" "$DB_CONTAINER" \
    pg_dump -U "$DB_USER" "$DB_NAME" \
    | gzip > "$BACKUP_DIR/postgres_$DATE.sql.gz"

echo "✔ PostgreSQL dump complete." | tee -a "$LOG_FILE"

###############################################################
# Save Docker images
###############################################################
echo "→ Saving Docker images..." | tee -a "$LOG_FILE"

docker save -o "$BACKUP_DIR/vaultwarden_image_$DATE.tar" "$VAULTWARDEN_IMAGE"
docker save -o "$BACKUP_DIR/postgres_image_$DATE.tar" "$POSTGRES_IMAGE"

echo "✔ Docker images saved." | tee -a "$LOG_FILE"

###############################################################
# Retention: keep only last 7 backups
###############################################################
echo "→ Pruning old backups (keeping last 7)..." | tee -a "$LOG_FILE"

cd "$BACKUP_DIR"

ls -1t vaultwarden_full_*.tar.gz | tail -n +8 | xargs -r rm --
ls -1t postgres_*.sql.gz        | tail -n +8 | xargs -r rm --
ls -1t vaultwarden_image_*.tar | tail -n +8 | xargs -r rm --
ls -1t postgres_image_*.tar    | tail -n +8 | xargs -r rm --

echo "✔ Old backups pruned." | tee -a "$LOG_FILE"

###############################################################
# Log file size limit (100 MB)
###############################################################
if [ -f "$LOG_FILE" ]; then
    LOG_SIZE=$(stat -c%s "$LOG_FILE")
    if [ "$LOG_SIZE" -gt "$MAX_LOG_SIZE" ]; then
        echo "→ Log file exceeded 100MB. Truncating..." >> "$LOG_FILE"
        tail -c $((MAX_LOG_SIZE / 2)) "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
        echo "→ Log file truncated to ~50MB." >> "$LOG_FILE"
    fi
fi

###############################################################
# Footer
###############################################################
echo "✔ Vaultwarden backup finished successfully." | tee -a "$LOG_FILE"
echo "------------------------------------------------" >> "$LOG_FILE"

###############################################################
# Install cronjob if missing
###############################################################
if [ ! -f "$CRONFILE" ]; then
    echo "Installing cronjob for Sundays at 02:30..."
    echo "30 2 * * 0 root bash $SCRIPT_PATH >/dev/null 2>&1" > "$CRONFILE"
    chmod 644 "$CRONFILE"
fi

```
> Now run the script once
```bash
sudo bash /usr/local/bin/backup-vaultwarden.sh
```
