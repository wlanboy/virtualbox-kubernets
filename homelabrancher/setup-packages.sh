#!/bin/bash
set -e

# setup external repros
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
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
