#!/bin/bash
VERSION=scos-$(./openshift-install coreos print-stream-json | jq -r '.architectures.x86_64.artifacts.qemu.release')-qemu.x86_64.qcow2
URL=$(./openshift-install coreos print-stream-json | jq -r '.architectures.x86_64.artifacts.qemu.formats."qcow2.gz".disk.location')

if [[ -f "scos.qcow2" ]]; then
    rm scos.qcow2
fi

if [[ ! -f "$VERSION" ]]; then
    wget $URL
    gunzip $VERSION.gz
fi

mv $VERSION scos.qcow2
