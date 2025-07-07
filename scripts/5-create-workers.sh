#!/bin/bash
source vars.sh

while IFS=" " read -r host vmname vmid vmip
do
        if [ $host = $(hostname) ]
        then
                bash scripts/5-create-k3s-worker.sh $vmid $vmname $vmip
        fi
done < "workers.txt"