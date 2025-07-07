#!/bin/bash
source vars.sh

echo "stream {" > $NGINX_K8S_STREAMMOD
echo "  server {" >> $NGINX_K8S_STREAMMOD
echo "    listen 6443; " >> $NGINX_K8S_STREAMMOD
echo "    proxy_pass masters; " >> $NGINX_K8S_STREAMMOD
echo "  }" >> $NGINX_K8S_STREAMMOD
echo "  upstream masters {" >> $NGINX_K8S_STREAMMOD
while IFS=" " read -r host vmname vmid vmip
do
        echo "server $vmip:6443 max_fails=3 fail_timeout=10s;" >> $NGINX_K8S_STREAMMOD
done < "masters.txt"
echo "  }" >> $NGINX_K8S_STREAMMOD
echo "}" >> $NGINX_K8S_STREAMMOD