# virtualbox-kubernets
Virtualbox based, vagrant provisioned Kubernets Homelab from skratch

> Don't use minikube if you want to understand Kubernetes.
This is not for developers searching for an easy way to k8s.

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
vagrant ssh -c "cat /home/vagrant/config.txt" > ${HOME}/.kube/config
kubectl get nodes
```
# Access kubernetes dashboard
```
cat ${HOME}/.kube/token.txt # <-- this is your token to login
kubectl proxy
```
* use your browser: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

# Get cluster info
```
kubectl cluster-info
Kubernetes control plane is running at https://192.168.56.100:6443
CoreDNS is running at https://192.168.56.100:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

# Check running pods
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

# Key takeaways
* don't install vms by hand
* vms are containers too
* play around and test things, break things early and often
* automate everything to be able to rebuild anything, anytime
* think in roles not in serverboxes
