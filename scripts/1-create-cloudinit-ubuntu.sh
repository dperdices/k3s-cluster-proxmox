#!/bin/bash
source vars.sh

virt-customize -a $IMG --update
virt-customize -a $IMG --install qemu-guest-agent
virt-customize -a $IMG --ssh-inject root:file:$SSH_PUBKEY
virt-customize -a $IMG --root-password password:$PASSWORD
virt-customize -a $IMG --password $USER:password:$PASSWORD