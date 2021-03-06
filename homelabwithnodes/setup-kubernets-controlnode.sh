#!/bin/bash
set -e

# get kubernetes images
kubeadm config images pull

# setup kubectl config
sudo echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc
# setup kubernetes controll node
echo "setup kubernetes controll node"
sudo kubeadm init --pod-network-cidr=${KUBE_NETWORK} \
        --token ${TOKEN} --apiserver-advertise-address=${CONTROL_IP} --apiserver-cert-extra-sans=${CONTROL_IP},${PUBLIC_IP}

echo "setup kube config"
export KUBECONFIG=/etc/kubernetes/admin.conf
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant -R /home/vagrant/.kube

# we need a network provider for the kubernetes internal network
echo "setup kubernetes network"
kubectl apply -f /home/vagrant/kube-flannel.yml 
#kubectl apply -f https://cloud.weave.works/k8s/net

# first step single node, so the master has to run workloads too
kubectl taint node kubecontrol node-role.kubernetes.io/master:NoSchedule-

# add dashboard and role
echo "setup kubernetes dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
kubectl apply -f /home/vagrant/control.yml

# get token from role to access the dashboard
token=$(kubectl -n kube-system get secret | grep linuxsysadmins | awk '{print $1}')
kubectl -n kube-system describe secret $token |grep token: |awk '{print $2}' > /home/vagrant/token.txt

# add ingress controller
echo "setup kubernetes ingress controller"
kubectl create ns ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/baremetal/deploy.yaml

# setup ingress controller
cat > nginx-host-networking.yaml <<EOF
spec:
  template:
    spec:
      hostNetwork: true
EOF
kubectl -n ingress-nginx patch deployment ingress-nginx-controller --patch="$(<nginx-host-networking.yaml)"

# forward second ip to apiserver
#sudo iptables -i eth2 -o eth1 -p tcp --dport 6443 -A FORWARD