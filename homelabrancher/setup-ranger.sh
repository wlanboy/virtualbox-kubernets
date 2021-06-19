#!/bin/bash
set -e

# get arkade
cd ~
curl -sSL https://dl.get-arkade.dev | sudo sh

# get kubectl and k3sup
arkade get kubectl
arkade get k3sup

sudo chmod 775 /home/vagrant/.arkade/bin/kubectl
sudo chmod 775 /home/vagrant/.arkade/bin/k3sup
sudo cp /home/vagrant/.arkade/bin/kubectl /usr/local/bin/
sudo cp /home/vagrant/.arkade/bin/k3sup /usr/local/bin/

# prepare self ssh connection
ssh-keygen -b 2048 -t rsa -f /home/vagrant/.ssh/id_rsa -q -N ""
ssh-keyscan -H 127.0.0.1 >> /home/vagrant/.ssh/known_hosts
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

# install k3
k3sup install --user vagrant --k3s-extra-args='--advertise-address 192.168.56.80 --tls-san=192.168.56.80'

echo "export KUBECONFIG=/home/vagrant/kubeconfig" >> /home/vagrant/.bashrc
export KUBECONFIG=/home/vagrant/kubeconfig
kubectl config set-context default
kubectl get node -o wide

echo "setup kubernetes flannel"
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.
kubectl apply -f /home/vagrant/kube-flannel.yml

echo "setup kubernetes dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
kubectl apply -f /home/vagrant/control.yml

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep kubernetes-dashboard-token | awk '{print $1}') > /home/vagrant/token.txt