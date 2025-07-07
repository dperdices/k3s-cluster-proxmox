#!/bin/bash
source vars.sh

ID=$1
NAME=$2
IP=$3

## Master
# Destroy previous master
qm stop $ID
sleep 10
qm destroy $ID

# Create master
echo "Creating master $ID with name $NAME"
qm create $ID --name $NAME --memory $MASTER_RAM --balloon 1024 --cpu host --cores $MASTER_CORES --cpulimit $MASTER_CPULIMIT  --net0 virtio,bridge=$K3S_LAN 

qm importdisk $ID $IMG $MASTER_STORAGE

# Configure master
qm set $ID --scsihw virtio-scsi-pci --scsi0 $MASTER_STORAGE:vm-$ID-disk-0
qm set $ID --boot c --bootdisk scsi0
qm set $ID --ide2 $MASTER_STORAGE:cloudinit
qm set $ID --serial0 socket --vga serial0
qm set $ID --agent enabled=1
qm set $ID --ciuser $USER
qm set $ID --cipassword $PASSWORD
qm set $ID --ipconfig0 ip=$3/8,gw=$K3S_GW
qm set $ID --sshkey $SSH_PUBKEY
qm set $ID --nameserver="1.1.1.1 8.8.8.8"
qm disk resize $ID scsi0 $MASTER_DISKSIZE
qm start $ID