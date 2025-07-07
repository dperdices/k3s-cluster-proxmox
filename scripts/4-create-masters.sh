#!/bin/bash
source vars.sh

while IFS=" " read -r host vmname vmid vmip
do
        if [ $host = $(hostname) ]
        then
                bash scripts/4-create-k3s-master.sh $vmid $vmname $vmip
        fi
done < "masters.txt"