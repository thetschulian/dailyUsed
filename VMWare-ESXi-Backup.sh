#!/bin/sh

### Make the script executable:
# chmod +x /vmfs/volumes/datastore1/VMWare-ESXi-Backup.sh

# Prompt to back up all VMs or a specific one
echo "Do you want to backup all VMs or just one? (all/one)"
read -r backup_choice

if [ "$backup_choice" = "all" ]; then
    VM_IDS=$(vim-cmd vmsvc/getallvms | awk '{if(NR>1) print $1}')  # Exclude header
    echo "Backing up all VMs."
else
    # Display a list of VMs with their names and IDs
    echo "Listing all VMs on the host:"
    vim-cmd vmsvc/getallvms | awk '{if(NR==1) print "VM ID\tName"; else print $1 "\t" $2}'

    # Ask the user to specify a VM ID for backup
    echo "Please enter the VM ID of the VM you want to backup:"
    read -r VM_ID

    # Verify the VM ID exists
    if ! vim-cmd vmsvc/get.summary ${VM_ID} >/dev/null 2>&1; then
        echo "Invalid VM ID. Exiting."
        exit 1
    fi

    VM_IDS=$VM_ID
fi

# Define backup date and time
DATE_OF_BACKUP=$(date +%Y-%m-%d)
TIME_OF_BACKUP=$(date +%H%M)
DATETIME_OF_BACKUP="${DATE_OF_BACKUP}-${TIME_OF_BACKUP}"
DIR_TARGET_BASE="/vmfs/volumes/usb-backup"

# Loop through each selected VM and perform backup
for VM_ID in $VM_IDS; do
    # Get VM name for directory structure
    VM_NAME=$(vim-cmd vmsvc/get.summary ${VM_ID} | grep name | awk -F '"' '{print $2}')
    VM_NAME_TRIMMED=$(echo $VM_NAME | sed -e 's/ //g')
    DIR_VM="/vmfs/volumes/datastore1/${VM_NAME}"
    DIR_TARGET="${DIR_TARGET_BASE}/${VM_NAME_TRIMMED}/${DATETIME_OF_BACKUP}"

    # Create the backup directory
    mkdir -p "${DIR_TARGET}"
    echo "Backup directory created at: ${DIR_TARGET}"

    # Copy VM configuration files
    cp -rfp "${DIR_VM}/${VM_NAME}.vmx" "${DIR_TARGET}/"
    cp -rfp "${DIR_VM}/${VM_NAME}.nvram" "${DIR_TARGET}/"
    cp -rfp "${DIR_VM}/${VM_NAME}.vmsd" "${DIR_TARGET}/"
    echo "Configuration files copied for VM ${VM_NAME}."

    # Create a snapshot
    vim-cmd vmsvc/snapshot.create ${VM_ID} "${VM_NAME} ${DATE_OF_BACKUP}" "Snapshot for backup" 1 1
    echo "Snapshot created for VM ${VM_NAME}."

    # Clone the VM disk to USB
    echo "Cloning VM disk to USB device..."
    vmkfstools -i "${DIR_VM}/${VM_NAME}.vmdk" "${DIR_TARGET}/${VM_NAME}.vmdk" -d thin
    echo "VM disk cloned successfully for VM ${VM_NAME}."

    # Remove all snapshots
    echo "Removing all snapshots for VM ID ${VM_ID}..."
    vim-cmd vmsvc/snapshot.removeall ${VM_ID}
    echo "All snapshots removed for VM ${VM_NAME}."

    # Lock check on .vmdk files
    echo "Checking for locks on ${DIR_TARGET}/${VM_NAME}.vmdk:"
    vmfsfilelockinfo -p "${DIR_TARGET}/${VM_NAME}.vmdk"
    echo "Running lock test with vmkfstools:"
    vmkfstools -D "${DIR_TARGET}/${VM_NAME}.vmdk"

    # Verify the backup files
    echo "Verifying backup files for VM ${VM_NAME} in ${DIR_TARGET}:"
    ls -lh "${DIR_TARGET}"
done

echo "Backup process completed."
