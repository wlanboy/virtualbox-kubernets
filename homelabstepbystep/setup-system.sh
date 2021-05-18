#!/bin/bash
set -e

# setup cgroups and overlay fs
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# kubernets does not like swap but ubuntu does
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab