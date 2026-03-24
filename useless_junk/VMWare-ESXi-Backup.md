# ESXi Backup Script | Backups a specific VM to a NFS Share mounted on ESXi (no vCenter needed!!)
> You need a Unix Host as a "jumpserver" to do this
> 

```bash
#!/bin/bash
#
# Automated VMDK Backup Script for standalone ESXi host
# -----------------------------------------------------
# - Creates a snapshot of the VM
# - Clones the VMDK directly to NFS datastore
# - Copies VM metadata files (.vmx, .nvram) with the same timestamp
# - Stores all backups in a single VM folder
# - Keeps only the last 4 backups (VMDK + matching metadata + flat file)
# - Removes the snapshot
#
# Requirements:
# - NFS share mounted on ESXi as datastore (e.g. "Ubuntu-NFS")
# - Run from a Linux VM with SSH access to ESXi host
# - ESXi CLI tools (`vim-cmd`, `vmkfstools`) available on the host
# - SSH key authentication set up (recommended)

# === CONFIGURATION ===
ESXI_HOST="192.168.0.1"                  # ESXi host IP
ESXI_USER="root"                           # ESXi username
VM_NAME="VM-Windows-Server2025"                      # Name of the VM to back up
DATASTORE_PATH="/vmfs/volumes/datastore1/${VM_NAME}"   # Path to VM files
BACKUP_DATASTORE="/vmfs/volumes/NFS-Backup-Dir"          # NFS datastore mounted on ESXi
LOGFILE="$HOME/esxi-vmdk-backup.log"       # Log path

# Rotate logs: keep last 5

# If log exists, rotate it
if [ -f "$LOGFILE" ]; then
    mv "$LOGFILE" "${LOGFILE}.$(date +%F-%H%M)"
fi

# Delete old rotated logs (keep last 5)
ls -1t "${LOGFILE}."* 2>/dev/null | tail -n +6 | xargs -r rm -f


# === FUNCTIONS ===
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

run_esxi_cmd() {
    local cmd="$1"
    log "Running on ESXi: $cmd"
    ssh -o BatchMode=yes "${ESXI_USER}@${ESXI_HOST}" "${cmd}" 2>&1 | tee -a "$LOGFILE"
    return ${PIPESTATUS[0]}
}

# === SCRIPT START ===
log "Starting backup for VM: $VM_NAME"

# Timestamp for filenames (prefix for natural sorting)
TS="$(date +%F-%H%M)"  # e.g., 2025-12-03-1405

# 1. Get VMID (clean parse)
VMID=$(ssh -o BatchMode=yes ${ESXI_USER}@${ESXI_HOST} "vim-cmd vmsvc/getallvms" | awk -v name="$VM_NAME" '$2 == name {print $1; exit}')
if [[ -z "$VMID" || ! "$VMID" =~ ^[0-9]+$ ]]; then
    log "ERROR: Could not find a numeric VMID for ${VM_NAME}. Exiting."
    exit 1
fi
log "VMID for ${VM_NAME} is ${VMID}"

# 2. Create snapshot
SNAPNAME="backup-${TS}"
log "Creating snapshot: $SNAPNAME"
run_esxi_cmd "vim-cmd vmsvc/snapshot.create ${VMID} '${SNAPNAME}' 'Automated backup snapshot' 0 0"
if [ $? -ne 0 ]; then
    log "ERROR: Failed to create snapshot. Exiting."
    exit 1
fi

# 3. Prepare backup folder (single folder per VM)
VM_BACKUP_DIR="${BACKUP_DATASTORE}/${VM_NAME}"
log "Ensuring backup folder exists: ${VM_BACKUP_DIR}"
run_esxi_cmd "mkdir -p '${VM_BACKUP_DIR}'"

# 4. Clone VMDK directly to NFS datastore with timestamp prefix
SRC_VMDK="${DATASTORE_PATH}/${VM_NAME}.vmdk"
DST_VMDK="${VM_BACKUP_DIR}/${TS}-${VM_NAME}.vmdk"

log "Cloning VMDK from ${SRC_VMDK} to ${DST_VMDK}"
run_esxi_cmd "vmkfstools -i '${SRC_VMDK}' '${DST_VMDK}' -d thin"
if [ $? -ne 0 ]; then
    log "ERROR: Failed to clone VMDK. Attempting to remove snapshot."
    run_esxi_cmd "vim-cmd vmsvc/snapshot.removeall ${VMID}"
    exit 1
fi

# 5. Copy metadata files (.vmx, .nvram) with the same timestamp prefix
DST_VMX="${VM_BACKUP_DIR}/${TS}-${VM_NAME}.vmx"
DST_NVRAM="${VM_BACKUP_DIR}/${TS}-${VM_NAME}.nvram"

log "Copying VM metadata files"
run_esxi_cmd "cp '${DATASTORE_PATH}/${VM_NAME}.vmx' '${DST_VMX}'"
# nvram may be absent; ignore errors
run_esxi_cmd "cp '${DATASTORE_PATH}/${VM_NAME}.nvram' '${DST_NVRAM}' 2>/dev/null || true"

# 6. Remove snapshot
log "Removing snapshot"
run_esxi_cmd "vim-cmd vmsvc/snapshot.removeall ${VMID}"
if [ $? -ne 0 ]; then
    log "WARNING: Snapshot removal failed. Please check manually."
else
    log "Snapshot removed successfully."
fi

# 7. Cleanup old backups (keep last 4 by timestamp prefix, remove matching metadata and flat files)
log "Cleaning up old backups, keeping only last 4"
run_esxi_cmd "
set -e
cd '${VM_BACKUP_DIR}' || exit 0
OLD_SETS=\$(ls -1t [0-9]*-${VM_NAME}.vmdk 2>/dev/null | tail -n +5 || true)
for v in \$OLD_SETS; do
  echo 'Deleting old backup set: ' \"\$v\"
  ts=\$(echo \"\$v\" | sed -n 's/^\([0-9-]\{10\}-[0-9]\{4\}\)-${VM_NAME}\\.vmdk$/\\1/p')
  rm -f -- \"\$v\"
  if [ -n \"\$ts\" ]; then
    echo 'Deleting flat disk: ' \"\$ts-${VM_NAME}-flat.vmdk\"
    rm -f -- \"\$ts-${VM_NAME}-flat.vmdk\"
    echo 'Deleting metadata: ' \"\$ts-${VM_NAME}.vmx\"
    rm -f -- \"\$ts-${VM_NAME}.vmx\"
    echo 'Deleting metadata: ' \"\$ts-${VM_NAME}.nvram\"
    rm -f -- \"\$ts-${VM_NAME}.nvram\"
  fi
done
"

log "Backup completed successfully for VM: ${VM_NAME}"
exit 0

```
