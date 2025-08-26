#!/bin/bash

MACADDR=$1
ID=29998
TEMPLATE_STORAGE=isos
TEMPLATE_NAME=debian-12-standard_12.7-1_amd64.tar.zst
BRIDGE=vmbr0
STORAGE=local-lvm
PATH=$(pwd)

/usr/bin/pveam download $TEMPLATE_STORAGE $TEMPLATE_NAME

/usr/sbin/pct create $ID $TEMPLATE_STORAGE:vztmpl/$TEMPLATE_NAME --cores 1 --hostname okd-haproxy --net0 name=eth0,bridge=$BRIDGE,ip=dhcp,type=veth,hwaddr=$MACADDR --ostype debian --storage $STORAGE
/usr/sbin/pct start $ID

/usr/sbin/pct exec $ID -- bash -c 'apt-get update | apt-get -y install curl gnupg2'

/usr/sbin/pct exec $ID -- bash -c 'curl https://haproxy.debian.net/haproxy-archive-keyring.gpg --create-dirs --output /etc/apt/keyrings/haproxy-archive-keyring.gpg'
/usr/sbin/pct exec $ID -- base -c 'echo deb "[signed-by=/etc/apt/keyrings/haproxy-archive-keyring.gpg]" https://haproxy.debian.net bookworm-backports-3.2 main > /etc/apt/sources.list.d/haproxy.list'
/usr/sbin/pct exec $ID -- bash -c 'apt-get update | apt-get -y install haproxy'
/usr/sbin/pct push $ID $PATH/extras/haproxy.cfg /etc/haproxy/haproxy.cfg
/usr/sbin/pct exec $ID -- bash -c 'systemctl restart haproxy'
