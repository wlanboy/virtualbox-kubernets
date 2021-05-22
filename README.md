# virtualbox-kubernets
Virtualbox based, vagrant provisioned Kubernets Homelab from skratch

> Don't use minikube if you want to understand Kubernetes.
This is not for developers searching for an easy way to k8s.

# Content
- directory homelab
  * Single VM with k8 including network, storage, ingress provider
  * Using kubeadm for setup
  * Good start for beginners
- directory homelabrancher
  * Single VM with k3 including network provider
  * Using Arkade, k3sup for setup
- directory homelabstepbystep
  * Single VM with all dependencies, java build tools and kubectl
  * Good start to setup your k8 step by step
- directory homelabwithnodes
  * Multy VM k8 cluster including network, storage, ingress provider
  * You can add VMs by alterting the vagrant var NODE_COUNT 
  * Increase NODE_COUNT and run vagrat up again to add more VMs

# Key points
1. This is a tutorial 
2. This is a playground to get in touch with k3 and k8
3. Normally you have to choose your own network provider, see: https://kubernetes.io/docs/concepts/cluster-administration/networking/
4. Normally you have to choose your own storage provider, see: https://kubernetes.io/docs/concepts/storage/storage-classes/
5. Normally you have to choose your own ingress provider, see: https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/
6. You need an external load balancer provider too, the one from your cloud provider
8. Kubernetes is a framework, not a toolset, see: https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/#what-kubernetes-is-not
9. Consider to use a local apt cache server to minimize traffic

# Install Virtualbox on Windows or OS X
* https://www.virtualbox.org/wiki/Downloads
* OSX:
```
wget https://download.virtualbox.org/virtualbox/6.1.18/VirtualBox-6.1.18-142142-OSX.dmg
```
* Windows: (asuming you are using gitbash: https://gitforwindows.org/)
```
wget https://download.virtualbox.org/virtualbox/6.1.18/VirtualBox-6.1.18-142142-Win.exe
```

# Install a package manager
* OS X: homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
* Windows: chocolatey ( with powershell)
```
Set-ExecutionPolicy AllSigned
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

# Install needed tools 
* OS X:
```
brew cask install vagrant
brew install kubernetes-cli
brew install helm
```
* Windows:
```
choco install vagrant
choco install kubernetes-cli
choco install kubernetes-helm
```

# Setup VM
> Please look at the Vagrant file first and adjust the values!
* at least we can now have ONE documentation
```
cd ~
git clone https://github.com/wlanboy/virtualbox-kubernets.git
cd homelab
vagrant up
```

# Destroy VM (if you made something wrong)
```
cd ~/virtualbox-kubernets/homelab
vagrant destroy -f
```

# Start over again
```
cd ~/virtualbox-kubernets/homelab
vagrant up
```

# Configure your local kubectl
```
mkdir -p ${HOME}/.kube
vagrant ssh -c "cat /home/vagrant/token.txt" > ${HOME}/.kube/token.txt
vagrant ssh -c "cat /home/vagrant/.kube/config" > ${HOME}/.kube/config
kubectl cluster-info
kubectl get nodes -o wide
```
# Configure your local kubectl with nodes
```
mkdir -p ${HOME}/.kube
vagrant ssh kubecontrol -c "cat /home/vagrant/token.txt" > ${HOME}/.kube/token.txt
vagrant ssh kubecontrol -c "cat /home/vagrant/.kube/config" > ${HOME}/.kube/config
sed -i 's/192.168.50.100/192.168.56.100/g' ${HOME}/.kube/config 
kubectl cluster-info
kubectl get nodes -o wide
```
# Access kubernetes dashboard
```
cat ${HOME}/.kube/token.txt # <-- this is your token to login
kubectl proxy
```
* use your browser: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

# Access longhorn frontend
```
kubectl apply -f longhorn-ingress.yml
```
* use your browser: http://192.168.56.100:31294/

# Get cluster info
```
kubectl cluster-info
Kubernetes control plane is running at https://192.168.56.100:6443
CoreDNS is running at https://192.168.56.100:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

# Check running pods (single node)
```
kubectl get pods --all-namespaces
NAMESPACE              NAME                                         READY   STATUS      RESTARTS   AGE
ingress-nginx          ingress-nginx-admission-create-vhv8h         0/1     Completed   0          3m48s
ingress-nginx          ingress-nginx-admission-patch-767kf          0/1     Completed   0          3m48s
ingress-nginx          ingress-nginx-controller-75c478c599-6s4d8    1/1     Running     0          3m48s
kube-system            coredns-558bd4d5db-k9nmv                     1/1     Running     0          3m48s
kube-system            coredns-558bd4d5db-qxddh                     1/1     Running     0          3m48s
kube-system            etcd-kube                                    1/1     Running     0          4m3s
kube-system            kube-apiserver-kube                          1/1     Running     0          4m3s
kube-system            kube-controller-manager-kube                 1/1     Running     0          3m59s
kube-system            kube-flannel-ds-fhwxt                        1/1     Running     0          3m48s
kube-system            kube-proxy-cq9ff                             1/1     Running     0          3m48s
kube-system            kube-scheduler-kube                          1/1     Running     0          3m59s
kubernetes-dashboard   dashboard-metrics-scraper-856586f554-xqmls   1/1     Running     0          3m48s
kubernetes-dashboard   kubernetes-dashboard-78c79f97b4-4595v        1/1     Running     0          3m48s
```

# Check running pods (with nodes)
```
kubectl get pods --all-namespaces
NAMESPACE              NAME                                         READY   STATUS      RESTARTS   AGE
ingress-nginx          ingress-nginx-admission-create-r4cns         0/1     Completed   0          5m30s
ingress-nginx          ingress-nginx-admission-patch-mm42b          0/1     Completed   2          5m30s
ingress-nginx          ingress-nginx-controller-75c478c599-6pkr5    1/1     Running     0          5m29s
kube-system            coredns-558bd4d5db-ls6nj                     1/1     Running     0          5m29s
kube-system            coredns-558bd4d5db-nfr6z                     1/1     Running     0          5m29s
kube-system            etcd-kubecontrol                             1/1     Running     0          5m43s
kube-system            kube-apiserver-kubecontrol                   1/1     Running     0          5m43s
kube-system            kube-controller-manager-kubecontrol          1/1     Running     0          5m46s
kube-system            kube-flannel-ds-5wqdp                        1/1     Running     0          2m56s
kube-system            kube-flannel-ds-tfh7d                        1/1     Running     0          5m30s
kube-system            kube-proxy-5rg2s                             1/1     Running     0          5m30s
kube-system            kube-proxy-t447h                             1/1     Running     0          2m56s
kube-system            kube-scheduler-kubecontrol                   1/1     Running     0          5m43s
kubernetes-dashboard   dashboard-metrics-scraper-856586f554-5rrzp   1/1     Running     0          5m29s
kubernetes-dashboard   kubernetes-dashboard-78c79f97b4-x4vwv        1/1     Running     0          5m29s
longhorn-system        csi-attacher-5dcdcd5984-f4qlq                1/1     Running     0          4m25s
longhorn-system        csi-attacher-5dcdcd5984-npclz                1/1     Running     0          4m25s
longhorn-system        csi-attacher-5dcdcd5984-r4k2b                1/1     Running     0          4m25s
longhorn-system        csi-provisioner-5c9dfb6446-rqxvx             1/1     Running     0          4m25s
longhorn-system        csi-provisioner-5c9dfb6446-vwjfc             1/1     Running     0          4m25s
longhorn-system        csi-provisioner-5c9dfb6446-zrds8             1/1     Running     0          4m25s
longhorn-system        csi-resizer-6696d857b6-h9dwc                 1/1     Running     0          4m25s
longhorn-system        csi-resizer-6696d857b6-k4wxw                 1/1     Running     0          4m25s
longhorn-system        csi-resizer-6696d857b6-zgp8x                 1/1     Running     0          4m25s
longhorn-system        csi-snapshotter-96bfff7c9-l2frg              1/1     Running     0          4m24s
longhorn-system        csi-snapshotter-96bfff7c9-q2jzn              1/1     Running     0          4m24s
longhorn-system        csi-snapshotter-96bfff7c9-tpm9c              1/1     Running     0          4m24s
longhorn-system        engine-image-ei-611d1496-5p42w               1/1     Running     0          2m26s
longhorn-system        engine-image-ei-611d1496-wnxvb               1/1     Running     0          4m37s
longhorn-system        instance-manager-e-0dea7bab                  1/1     Running     0          4m37s
longhorn-system        instance-manager-e-8a8af286                  1/1     Running     0          116s
longhorn-system        instance-manager-r-197160bf                  1/1     Running     0          4m36s
longhorn-system        instance-manager-r-bbe3230c                  1/1     Running     0          115s
longhorn-system        longhorn-csi-plugin-262gd                    2/2     Running     0          4m24s
longhorn-system        longhorn-csi-plugin-42hxl                    2/2     Running     0          2m26s
longhorn-system        longhorn-driver-deployer-ccb9974d5-6ghwh     1/1     Running     0          5m29s
longhorn-system        longhorn-manager-4q47x                       1/1     Running     0          2m26s
longhorn-system        longhorn-manager-df55b                       1/1     Running     0          5m13s
longhorn-system        longhorn-ui-5b864949c4-499vx                 1/1     Running     0          5m29s
```

# Get node port of ingress controller
```
kubectl get svc -n ingress-nginx
NAME                                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.104.5.33    <none>        80:30067/TCP,443:32469/TCP   7m52s
ingress-nginx-controller-admission   ClusterIP   10.97.167.38   <none>        443/TCP                      7m52s
```

# Deploy a Spring Boot Microservice
* see: https://github.com/wlanboy/virtualbox-kubernets/blob/main/deploy-a-service.md

# Shutdown VM
```
vagrant ssh
sudo su shutdown -h now
```
# Setup Multinode cluster
* change folder to 'homelabwithnodes'
* use 'vagrant ssh kubecontrol' instead of 'vagrant ssh'
* change NODE_COUNT var in Vagrant file to add additional hosts
* run 'vagrant up' after changing the NODE_COUNT, it will only add new vms

# Setup kubernetes on your own
* change folder to 'homelabsteps'
* everything is prepared. Call each command from https://github.com/wlanboy/virtualbox-kubernets/blob/main/homelab/setup-kubernets-controlnode.sh 

# Setup k3s
* change folder to 'homelabrancher'
* this will install a k3s kubernets server

# Key takeaways
* don't install vms by hand
* vms are containers too
* play around and test things, break things early and often
* automate everything to be able to rebuild anything, anytime
* think in roles not in serverboxes

# Current deprication warings
* policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+, see: https://kubernetes.io/docs/reference/using-api/deprecation-guide/#psp-v125

