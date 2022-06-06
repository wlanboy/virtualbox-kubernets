## get root and set vars
```
sudo su
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc
export KUBECONFIG=/etc/kubernetes/admin.conf
```

## pull images and init cluster and taint it
```
kubeadm config images pull

kubeadm init --pod-network-cidr="10.244.0.0/16" \
        --token "qn265f.czo0oiw8o2q5pb7n" --apiserver-advertise-address"192.168.56.100" --apiserver-cert-extra-sans="192.168.56.100,192.168.178.37"

kubectl taint node kube node-role.kubernetes.io/master:NoSchedule-
```

## setup kube config
```
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant -R /home/vagrant/.kube
```

## install flannel
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

## install and setup metallb
```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/metallb.yaml
cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.170.10-192.168.170.254
EOF
```

## install ingress controller and patch it
```
kubectl create ns ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/baremetal/deploy.yaml

cat > nginx-host-networking.yaml <<EOF
spec:
  template:
    spec:
      hostNetwork: true
EOF
kubectl -n ingress-nginx patch deployment ingress-nginx-controller --patch="$(<nginx-host-networking.yaml)"
```
