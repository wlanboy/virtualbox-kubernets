#!/bin/bash
set -e

sudo mkdir -p /nfs/data
sudo chown -R vagrant:vagrant /nfs/data

sudo mkdir -p /nfs/test
sudo chown -R vagrant:vagrant /nfs/test

sudo echo "192.168.56.100:/nfssharedata  /nfs/data nfs rw 0 0" >> /etc/fstab
sudo echo "192.168.56.100:/nfssharetest  /nfs/test nfs rw 0 0" >> /etc/fstab

sudo mount -a