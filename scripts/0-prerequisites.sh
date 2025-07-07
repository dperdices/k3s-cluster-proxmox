#!/bin/bash
source vars.sh

# Descargamos la imagen
wget $IMG_URL -O $IMG

# Generamos claves 
ssh-keygen -b 4096 -f $SSH_PRIVKEY -N ""

# Instalamos dependencias
apt update && apt install libguestfs-tools cloud-init