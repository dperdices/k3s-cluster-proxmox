#!/bin/bash
source vars.sh

cp_to_frontend $NGINX_K8S_STREAMMOD $NGINX_K8S_STREAMMOD
cp_to_frontend $NGINX_JHUB_SERVER $NGINX_JHUB_SERVER
run_frontend "sudo mv $NGINX_K8S_STREAMMOD /etc/nginx/modules-enabled/; sudo mv $NGINX_JHUB_SERVER /etc/nginx/sites-enabled/"
run_frontend "sudo systemctl restart nginx"