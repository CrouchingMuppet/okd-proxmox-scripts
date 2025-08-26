#!/bin/bash

ID=$1
NAME=$2
MACADDR=$3
STORAGE=nvme
NET_TYPE=virtio
BRIDGE=vmbr0

PATH=$(pwd)
BASE=29999
ADD_STORAGE=44G

/usr/sbin/qm clone $BASE $ID --name $NAME
/usr/sbin/qm set $ID --net0 $NET_TYPE,bridge=$BRIDGE,macaddr=$MACADDR

if [ "$NAME" = "okd-bootstrap" ]; then
   IGNITION=bootstrap
else
   IGNITION=master
fi

echo "args: -fw_cfg name=opt/com.coreos/config,file=$PATH/ignitions/$IGNITION.ign" >> /etc/pve/qemu-server/$ID.conf

/usr/sbin/qm start $ID
