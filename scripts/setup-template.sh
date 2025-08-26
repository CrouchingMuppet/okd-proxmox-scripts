#!/bin/bash
#Replace the variables if you need

ID=29999
NAME=scos-template
STORAGE=local-lvm
CPU=4
RAM=16384
NET_TYPE=virtio
BRIDGE=vmbr0
ADD_STORAGE=44G

/usr/sbin/qm create $ID --name $NAME --cores $CPU --cpu host,flags="+pdpe1gb" --memory $RAM --net0 $NET_TYPE,bridge=$BRIDGE --agent 1 --onboot 1
/usr/sbin/qm importdisk $ID scos.qcow2 $STORAGE
/usr/sbin/qm set $ID --scsihw virtio-scsi-single --scsi0 $STORAGE:vm-$ID-disk-0,cache=writethrough
/usr/sbin/qm set $ID --boot c --bootdisk scsi0
/usr/sbin/qm resize $ID scsi0 +$ADD_STORAGE
/usr/sbin/qm template $ID
