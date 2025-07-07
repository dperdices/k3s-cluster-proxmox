#!/bin/bash
source vars.sh

cp_to_frontend k3s-ansible/ $USER@$FRONTEND_HOST:k3s-ansible 
cp_to_frontend $SSH_PRIVKEY $USER@$FRONTEND_HOST:.ssh/id_rsa
cp_to_frontend $SSH_PUBKEY $USER@$FRONTEND_HOST:.ssh/id_rsa.pub

run_frontend "rm -rf .ssh/known_hosts"
run_frontend "cd k3s-ansible; ansible-galaxy collection install -r ./collections/requirements.yml"
run_frontend "cd k3s-ansible; ansible-playbook site.yml -i inventory/my-cluster/hosts.ini"