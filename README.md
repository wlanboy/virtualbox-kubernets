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
* OS X:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
* Windows: (powershell)
```
Set-ExecutionPolicy AllSigned
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

# Install tools
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
* at least we can now have ONE documentation
```
cd ~
git clone https://github.com/wlanboy/virtualbox-kubernets.git
cd homelab
vagrant up
```
