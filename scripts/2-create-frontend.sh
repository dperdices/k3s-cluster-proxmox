#!/bin/bash
source vars.sh

# Destroy previous frontend
echo "Destroying frontend $FRONTEND_ID"
qm stop $FRONTEND_ID
sleep 5
qm destroy $FRONTEND_ID

echo "Creating frontend $FRONTEND_ID"
# Create frontend
qm create $FRONTEND_ID --name "k3s-frontend" --memory $FRONTEND_MEMORY --cores $FRONTEND_CORES --net0 virtio,bridge=$FRONTEND_BRIDGE_LAN --net1 virtio,bridge=$FRONTEND_BRIDGE_WAN


echo "Importing disk img $IMG into $FRONTEND_STORAGE"
qm importdisk $FRONTEND_ID $IMG $FRONTEND_STORAGE


echo "Configuring frontend..."
# Configure frontend
qm set $FRONTEND_ID --scsihw virtio-scsi-pci --scsi0 $FRONTEND_STORAGE:vm-$FRONTEND_ID-disk-0
qm set $FRONTEND_ID --boot c --bootdisk scsi0
qm set $FRONTEND_ID --ide2 local-lvm:cloudinit
qm set $FRONTEND_ID --serial0 socket --vga serial0
qm set $FRONTEND_ID --agent enabled=1
qm set $FRONTEND_ID --ciuser $USER
qm set $FRONTEND_ID --cipassword $PASSWORD
qm set $FRONTEND_ID --ipconfig0 ip=$FRONTEND_IP_LAN
qm set $FRONTEND_ID --ipconfig1 ip=$FRONTEND_IP_WAN,gw=$FRONTEND_IP_WAN_GW
qm set $FRONTEND_ID --sshkey $SSH_PUBKEY
qm set $FRONTEND_ID --nameserver="1.1.1.1 8.8.8.8"
qm disk resize $FRONTEND_ID scsi0 $FRONTEND_DISKSIZE
echo "Starting frontend..."
qm start $FRONTEND_ID
sleep 60