#!/bin/bash

ID_BOOTSTRAP=30000
ID_MASTER0=30001
ID_MASTER1=30002
ID_MASTER2=30003
ID_TEMPLATE=29999

ID_HAPROXY=29998

vm_array=( $ID_BOOTSTRAP $ID_MASTER0 $ID_MASTER1 $ID_MASTER2 $ID_TEMPLATE )
ct_array=( $ID_HAPROXY )

for i in "${vm_array[@]}"
do
  qm stop $i
  qm destroy $i
done

for i in "${ct_array[@]}"
do
  pct stop $i
  pct destroy $i
done
