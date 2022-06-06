#!/bin/bash
set -e

# disable stdin for dpkg
export DEBIAN_FRONTEND=noninteractive

# setup external repros
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# enable apt cache
if [ "$ENABLE_APT_CAHE" = true ] ; then
    echo "Acquire::http::Proxy \"${LOCAL_APT_CACHE_URL}\";" | sudo tee /etc/apt/apt.conf.d/00proxy 

    find /etc/apt/sources.list /etc/apt/sources.list.d/ \
    -type f -exec sed -Ei 's!http://!'${LOCAL_APT_CACHE_URL}'/!g' {} \;

    find /etc/apt/sources.list /etc/apt/sources.list.d/ \
    -type f -exec sed -Ei 's!https://!'${LOCAL_APT_CACHE_URL}'/!g' {} \;
fi

# reload packages
sudo apt-get update
# install dependencies
sudo apt-get install -y nano htop apt-transport-https ca-certificates curl gnupg2 software-properties-common lsb-release wget sshfs openssl net-tools nfs-common

# install container runtime
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo adduser vagrant docker

# fix kubeadm pull image bug with containerd
sudo sed -i '/disabled_plugins/s/^/#/g' /etc/containerd/config.toml
sudo systemctl restart containerd.service

# install kubernetes tools and mark them to be not upgradeable
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# install tools
cd ~

wget https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz
tar -zxvf helm-v3.9.0-linux-amd64.tar.gz
sudo cp linux-amd64/helm /usr/local/bin/helm