####### Globals
# SSH keys to all VMs
# These are generated
SSH_PUBKEY=k3s_id_rsa.pub
SSH_PRIVKEY=k3s_id_rsa
# Image to use as base for all VMs
IMG=jammy-server-cloudimg-amd64.img
IMG_URL=https://cloud-images.ubuntu.com/jammy/current/$IMG
# User and password to access the VMs
USER=hpcn
PASSWORD=TODO
# Ansible inventory file
# This file is generated
INVENTORY=k3s-ansible/inventory/my-cluster/hosts.ini

####### Frontend
# Frontend id in proxmox
FRONTEND_ID=1000
# Brigde for the cluster (it should be a private network)
FRONTEND_BRIDGE_LAN=k8s
# Bridge for the WAN (it should be a public network)
# This bridge should be connected to the internet
FRONTEND_BRIDGE_WAN=vmbr1
# Hostname and IPs for the frontend
FRONTEND_HOST=TODO
FRONTEND_IP_LAN=10.0.0.1/8
FRONTEND_CIDR_LAN=10.0.0.0/8
# WAN IP is the public IP of the frontend
FRONTEND_IP_WAN=TODO
# Gateway for the WAN
FRONTEND_IP_WAN_GW=TODO
# Storage for the frontend VM disk
FRONTEND_STORAGE=vms
# Memory, cores and disk size for the frontend VM
FRONTEND_MEMORY=2048
FRONTEND_CORES=2
FRONTEND_DISKSIZE=100G
# Domain name and mail for the frontend (certbot)
FRONTEND_DOMAIN_NAME=TODO
FRONTEND_DOMAIN_MAIL=TODO

####### Nodes
# Masters & workers shared variables
# LAN network for the cluster
# This network should be a private network
# It should be the same as FRONTEND_BRIDGE_LAN
K3S_LAN=k8s
K3S_GW=10.0.0.1 # Must be the same as FRONTEND_IP_LAN

####### Masters
MASTER_CORES=4
MASTER_CPULIMIT=4
MASTER_RAM=16384
MASTER_STORAGE=local-lvm
MASTER_DISKSIZE=50G

####### Workers
WORKER_CORES=8
WORKER_CPULIMIT=8
WORKER_RAM=16384
WORKER_BALLON=1024
WORKER_STORAGE=local-lvm
WORKER_CPU_TYPE=host
WORKER_DISKSIZE=50G

####### Nginx
# Nginx configuration files for the frontend
# This is generated
NGINX_K8S_STREAMMOD=conf/99-k3s.conf
# This is an example of a service configuration
NGINX_JHUB_SERVER=conf/99-jhub.conf

# Run in frontend given command (requires 1 argument)
function run_frontend() {
  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $SSH_PRIVKEY $USER@$FRONTEND_HOST "$1"
}

# Copy files to the frontend (requires 2 arguments: source and destination)
function cp_to_frontend() {
  scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $SSH_PRIVKEY -r $1 $USER@$FRONTEND_HOST:$2
}