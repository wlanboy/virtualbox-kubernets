#!/bin/bash
set -e

sudo kubeadm join ${CONTROL_IP}:6443 --token ${TOKEN} --discovery-token-unsafe-skip-ca-verification --node-name ${NODE_NAME} --v=2
