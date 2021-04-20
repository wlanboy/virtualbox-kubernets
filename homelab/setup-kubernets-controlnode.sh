#!/bin/bash
set -e

# get kubernetes images
kubeadm config images pull

# setup kubernetes controll node
sudo kubeadm init --pod-network-cidr=${KUBE_NETWORK} \
        --token ${TOKEN} --apiserver-advertise-address=${CONTROL_IP} --apiserver-cert-extra-sans=${CONTROL_IP},${PUBLIC_IP}

# we need a network provider for the kubernetes internal network
sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# first step single node, so the master has to run workloads too
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf taint node kube node-role.kubernetes.io/master:NoSchedule-

# add dashboard and role
sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f /home/vagrant/control.yml

# get token from role to access the dashboard
token=$(sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl -n kube-system get secret | grep linuxsysadmins | awk '{print $1}')
sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl -n kube-system describe secret $token |grep token: |awk '{print $2}' > /home/vagrant/token.txt
sudo cat /etc/kubernetes/admin.conf > /home/vagrant/config.txt

# setup kubectl config
sudo echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc