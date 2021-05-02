#!/bin/bash
set -e

sudo mkdir -p /nfssharedata
sudo mkdir -p /nfssharetest

sudo chown nobody:nogroup /nfssharedata
sudo chown nobody:nogroup /nfssharetest

sudo chmod 776 /nfssharedata
sudo chmod 776 /nfssharetest

sudo apt-get install nfs-kernel-server -y

sudo echo "/nfssharedata 192.168.56.0/255.255.255.0(rw,no_root_squash,insecure,async,no_subtree_check,anonuid=1001,anongid=1001)" >> /etc/exports
sudo echo "/nfssharetest 192.168.56.0/255.255.255.0(rw,no_root_squash,insecure,async,no_subtree_check,anonuid=1001,anongid=1001)" >> /etc/exports

sudo exportfs -ra
sudo systemctl restart nfs-kernel-server
