#!/bin/bash

set -e

# === Configuration ===
SOURCE_DIR="/home/changeme/changemet"
BACKUP_DIR="/mnt/ESX-USB-BACKUP"
NFS_SERVER="changeme"
NFS_EXPORT="/mnt/usb-backupdisk/BACKUP-DISK/VaultWarden"
DATE=$(date +%F_%H-%M)

DB_CONTAINER="changeme-db"
DB_NAME="changeme"
DB_USER="changeme"
DB_PASSWORD="changeme"

VAULTWARDEN_IMAGE="vaultwarden/server:latest"     # adjust tag if needed
POSTGRES_IMAGE="postgres:16"

LOG_FILE="/var/log/vault_backup.log"
MAX_LOG_SIZE=$((100 * 1024 * 1024))  # 100 MB

echo "[$(date '+%F %T')] Starting backup..." >> "$LOG_FILE"
sudo apt-get install nfs-common -y
# === Ensure NFS share is mounted ===
if ! mountpoint -q "$BACKUP_DIR"; then
    echo "[$(date '+%F %T')] NFS share not mounted. Attempting to mount..." >> "$LOG_FILE"
    sudo mount -t nfs "${NFS_SERVER}:${NFS_EXPORT}" "$BACKUP_DIR"
    if ! mountpoint -q "$BACKUP_DIR"; then
        echo "[$(date '+%F %T')] ERROR: Failed to mount NFS share ${NFS_SERVER}:${NFS_EXPORT} to $BACKUP_DIR" >> "$LOG_FILE"
        exit 1
    fi
    echo "[$(date '+%F %T')] Successfully mounted NFS share." >> "$LOG_FILE"
fi

mkdir -p "$BACKUP_DIR"

# === Backup Vaultwarden directory ===
tar -czf "$BACKUP_DIR/vaultwarden_full_$DATE.tar.gz" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
echo "[$(date '+%F %T')] Vaultwarden directory backup complete." >> "$LOG_FILE"

# === Backup PostgreSQL database ===
docker exec -e PGPASSWORD="$DB_PASSWORD" "$DB_CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_DIR/postgres_$DATE.sql.gz"
echo "[$(date '+%F %T')] PostgreSQL dump complete." >> "$LOG_FILE"

# === Save Docker images ===
docker save -o "$BACKUP_DIR/vaultwarden_image_$DATE.tar" "$VAULTWARDEN_IMAGE"
docker save -o "$BACKUP_DIR/postgres_image_$DATE.tar" "$POSTGRES_IMAGE"
echo "[$(date '+%F %T')] Docker images saved (vaultwarden and postgres)." >> "$LOG_FILE"

# === Keep only the latest 7 backups ===
cd "$BACKUP_DIR"
ls -1t vaultwarden_full_*.tar.gz | tail -n +8 | xargs -r rm --
ls -1t postgres_*.sql.gz        | tail -n +8 | xargs -r rm --
ls -1t vaultwarden_image_*.tar | tail -n +8 | xargs -r rm --
ls -1t postgres_image_*.tar    | tail -n +8 | xargs -r rm --
echo "[$(date '+%F %T')] Old backups pruned." >> "$LOG_FILE"

# === Limit log file to 100 MB ===
if [ -f "$LOG_FILE" ]; then
    LOG_SIZE=$(stat -c%s "$LOG_FILE")
    if [ "$LOG_SIZE" -gt "$MAX_LOG_SIZE" ]; then
        echo "[$(date '+%F %T')] Log file exceeded 100MB. Truncating..." >> "$LOG_FILE"
        tail -c $((MAX_LOG_SIZE / 2)) "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
        echo "[$(date '+%F %T')] Log file truncated to ~50MB." >> "$LOG_FILE"
    fi
fi

echo "[$(date '+%F %T')] Backup finished successfully." >> "$LOG_FILE"
echo "------------------------------------------------" >> "$LOG_FILE"
