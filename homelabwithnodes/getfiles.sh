#!/bin/bash
set -e

mkdir -p ~/.kube
#ssh-keygen -f "~/.ssh/known_hosts" -R "192.168.56.100"
ssh vagrant@192.168.56.100 "cat /home/vagrant/token.txt" > ~/.kube/token.txt
ssh vagrant@192.168.56.100 "cat /home/vagrant/.kube/config" > ~/.kube/config
sed -i 's/192.168.50.100/192.168.56.100/g' ${HOME}/.kube/config 
ssh vagrant@192.168.56.100 "sudo iptables -i eth2 -o eth1 -p tcp --dport 6443 -A FORWARD"