#!/bin/bash
set -e

mkdir -p ~/.kube
#ssh-keygen -f "~/.ssh/known_hosts" -R "192.168.56.100"
ssh vagrant@192.168.56.80 "cat /home/vagrant/token.txt" > ~/.kube/token.txt
ssh vagrant@192.168.56.80 "cat /home/vagrant/kubeconfig" > ~/.kube/config
sed -i 's/127.0.0.1/192.168.56.80/g' ${HOME}/.kube/config 
kubectl get nodes -o wide