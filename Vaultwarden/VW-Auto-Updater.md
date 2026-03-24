> Update your Vaultwarden Docker every sunday 3.30am  with this Script
> 
> sudo nano /usr/local/bin/update-vaultwarden-docker.sh
>
> And then paste this Code into the file and save it:
```bash
#!/bin/bash
###############################################################
# Vaultwarden Docker Auto-Update Script
# - Updates Docker Engine + Compose plugin
# - Pulls latest Vaultwarden container images
# - Restarts Vaultwarden stack
# - Logs output with rotation
# - Self-installs cronjob (Sundays 03:30)
###############################################################

LOGFILE="/var/log/vaultwarden-docker-update.log"
CRONFILE="/etc/cron.d/vaultwarden-docker-update"
SCRIPT_PATH="/usr/local/bin/update-vaultwarden-docker.sh"
MAXSIZE=$((35 * 1024 * 1024))   # 35 MB

# Path to your Vaultwarden docker-compose.yaml
DOCKER_COMPOSE_FILE="/home/username/Vault-DIR/docker-compose.yaml"

###############################################################
# Log rotation
###############################################################
if [ -f "$LOGFILE" ]; then
    FILESIZE=$(stat -c%s "$LOGFILE")
    if [ "$FILESIZE" -gt "$MAXSIZE" ]; then
        mv "$LOGFILE" "${LOGFILE}.1"
        touch "$LOGFILE"
        echo "===== LOG ROTATED: $(date) =====" >> "$LOGFILE"
    fi
fi

###############################################################
# Log header
###############################################################
{
echo ""
echo "============================================================"
echo "===== VAULTWARDEN DOCKER UPDATE RUN: $(date) ====="
echo "============================================================"
echo ""
} >> "$LOGFILE"

echo "🐳 Vaultwarden Docker Update Started"
echo "Logfile: $LOGFILE"
echo "--------------------------------------------"

###############################################################
# Update Docker Engine + Compose plugin
###############################################################
echo "→ Updating Docker Engine..." | tee -a "$LOGFILE"
apt update -y >> "$LOGFILE" 2>&1
apt upgrade -y >> "$LOGFILE" 2>&1

###############################################################
# Update Vaultwarden container images
###############################################################
echo "→ Pulling latest Vaultwarden images..." | tee -a "$LOGFILE"
docker compose -f "$DOCKER_COMPOSE_FILE" pull >> "$LOGFILE" 2>&1

###############################################################
# Restart Vaultwarden containers
###############################################################
echo "→ Restarting Vaultwarden containers..." | tee -a "$LOGFILE"
docker compose -f "$DOCKER_COMPOSE_FILE" up -d >> "$LOGFILE" 2>&1

###############################################################
# Footer
###############################################################
echo "✔ Vaultwarden Docker Update Finished" | tee -a "$LOGFILE"

###############################################################
# Install cronjob if missing
###############################################################
if [ ! -f "$CRONFILE" ]; then
    echo "Installing cronjob for Sundays at 03:30..."
    echo "30 3 * * 0 root bash $SCRIPT_PATH >/dev/null 2>&1" > "$CRONFILE"
    chmod 644 "$CRONFILE"
fi
```
> Now run the Vaultwarden-Docker-Updater script once to register cronjob and weekly (sunday 3.30 am) update
```bash
sudo bash /usr/local/bin/update-vaultwarden-docker.sh
tail -f /var/log/vaultwarden-docker-update.log
```

