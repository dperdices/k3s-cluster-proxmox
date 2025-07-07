#!/bin/bash
source vars.sh

ID=$1
NAME=$2
IP=$3

## Worker
# Destroy previous worker
qm stop $ID
sleep 5
qm destroy $ID

# Create worker
echo "Creating worker $ID with name $NAME"
qm create $ID --name $NAME --memory $WORKER_RAM --balloon $WORKER_BALLON --cpu $WORKER_CPU_TYPE --cores $WORKER_CORES --cpulimit $WORKER_CPULIMIT  --net0 virtio,bridge=$K3S_LAN 

qm importdisk $ID $IMG $WORKER_STORAGE

# Configure worker
qm set $ID --scsihw virtio-scsi-pci --scsi0 $WORKER_STORAGE:vm-$ID-disk-0
qm set $ID --boot c --bootdisk scsi0
qm set $ID --ide2 $WORKER_STORAGE:cloudinit
qm set $ID --serial0 socket --vga serial0
qm set $ID --agent enabled=1
qm set $ID --ciuser $USER
qm set $ID --cipassword $PASSWORD
qm set $ID --ipconfig0 ip=$3/8,gw=$K3S_GW
qm set $ID --sshkey $SSH_PUBKEY
qm set $ID --nameserver="1.1.1.1 8.8.8.8"
qm disk resize $ID scsi0 $WORKER_DISKSIZE
qm start $ID