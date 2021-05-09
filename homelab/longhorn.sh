#!/bin/bash
set -e
export KUBECONFIG=/etc/kubernetes/admin.conf

# setup longhorn
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.1.1/deploy/longhorn.yaml
# create storage class
#kubectl create -f longhorn-storage-class.yml
#kubectl apply -f longhorn-ingress.yml
