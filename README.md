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

# Key takeaways
* don't install vms by hand
* vms are containers too
* play around and test things, break things early and often
* automate everthing to be able to test anything, anytime
* think in roles
