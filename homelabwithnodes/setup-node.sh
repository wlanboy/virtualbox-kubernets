#!/bin/bash
set -e

sudo kubeadm join ${CONTROL_IP}:6443 --token ${TOKEN} --discovery-token-unsafe-skip-ca-verification --v=4
