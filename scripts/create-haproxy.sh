#!/bin/bash

MACADDR=$1
ID=29998
TEMPLATE_STORAGE=isos
TEMPLATE_NAME=alpine-3.22-default_20250617_amd64.tar.xz
BRIDGE=vmbr0
STORAGE=local-lvm
PATH=$(pwd)

/usr/bin/pveam download $TEMPLATE_STORAGE $TEMPLATE_NAME

/usr/sbin/pct create $ID $TEMPLATE_STORAGE:vztmpl/$TEMPLATE_NAME \
  --cores 1 --memory 256 --swap 0 --hostname okd-haproxy \
  --net0 name=eth0,bridge=$BRIDGE,ip=dhcp,type=veth,hwaddr=$MACADDR \
  --ostype alpine --storage $STORAGE --onboot 1

/usr/sbin/pct start $ID

/usr/sbin/pct exec $ID -- sh -c 'apk upgrade'
/usr/sbin/pct exec $ID -- sh -c 'apk add haproxy'
/usr/sbin/pct push $ID $PATH/extras/haproxy.cfg /etc/haproxy/haproxy.cfg
/usr/sbin/pct exec $ID -- sh -c 'rc-update add haproxy && rc-service haproxy start'
