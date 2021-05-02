#!/bin/bash
set -e

# setup external repros
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# reload packages
sudo apt-get update
# install dependencies
sudo apt-get install -y nano htop apt-transport-https ca-certificates curl gnupg2 software-properties-common lsb-release wget sshfs openssl net-tools nfs-common

# install container runtime
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
