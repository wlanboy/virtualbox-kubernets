#!/bin/bash
set -e

echo "installing k3s"
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_CHANNEL=stable INSTALL_K3S_EXEC="--disable=traefik --disable=servicelb --node-external-ip=192.168.178.22" sh -
sudo cp -i /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

echo "installing calico network"
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/custom-resources.yaml
watch kubectl get pods -n calico-system

echo "installing metallb"
cat > metallb-pool.yaml <<EOF
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.170.10-192.168.170.250
EOF

cat > metallb-adv.yaml <<EOF
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: advertisement
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
EOF

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
kubectl apply -f metallb-pool.yaml
kubectl apply -f metallb-adv.yaml

echo "installing istio"
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
kubectl create namespace istio-system

helm install istio-base istio/base -n istio-system
helm ls -n istio-system
helm install istiod istio/istiod -n istio-system --wait

kubectl create namespace istio-ingress
helm install istio-ingress istio/gateway -n istio-ingress --wait
helm install istio-ingressgateway istio/gateway -n istio-ingress
kubectl get all -n istio-ingress

echo "done"
