#!/bin/bash

MAC_ADDR_LB=52:54:00:00:00:99
IP_BOOTSTRAP=192.168.0.98
IP_MASTER0=192.168.0.93
IP_MASTER1=192.168.0.94
IP_MASTER2=192.168.0.95

cp extras/haproxy.cfg.ORIG extras/haproxy.cfg

sed -Ezi "s/IP_BOOTSTRAP/$IP_BOOTSTRAP/g" extras/haproxy.cfg
sed -Ezi "s/IP_MASTER0/$IP_MASTER0/g" extras/haproxy.cfg
sed -Ezi "s/IP_MASTER1/$IP_MASTER1/g" extras/haproxy.cfg
sed -Ezi "s/IP_MASTER2/$IP_MASTER2/g" extras/haproxy.cfg

./scripts/create-haproxy.sh $MAC_ADDR_LB
