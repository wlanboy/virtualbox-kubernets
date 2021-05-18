#!/bin/bash
set -e

mkdir -p ~/.kube
#ssh-keygen -f "~/.ssh/known_hosts" -R "192.168.56.50"
ssh vagrant@192.168.56.50 "cat /home/vagrant/token.txt" > ~/.kube/token.txt
ssh vagrant@192.168.56.50 "cat /home/vagrant/.kube/config" > ~/.kube/config
