#!/bin/bash
set -e

mkdir -p ~/.kube
#ssh-keygen -f "~/.ssh/known_hosts" -R "192.168.56.100"
ssh vagrant@192.168.56.100 "cat /home/vagrant/token.txt" > ~/.kube/token.txt
ssh vagrant@192.168.56.100 "cat /home/vagrant/.kube/config" > ~/.kube/config
