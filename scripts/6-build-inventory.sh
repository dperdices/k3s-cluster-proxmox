#!/bin/bash
source vars.sh

echo "[master]" > $INVENTORY

while IFS=" " read -r host vmname vmid vmip
do
        echo $vmip >> $INVENTORY
done < "masters.txt"


echo "" >> $INVENTORY
echo "[node]" >> $INVENTORY

while IFS=" " read -r host vmname vmid vmip
do
        echo $vmip >> $INVENTORY
done < "workers.txt"



echo "" >> $INVENTORY

echo "[k3s_cluster:children]" >> $INVENTORY
echo "master" >> $INVENTORY
echo "node" >> $INVENTORY