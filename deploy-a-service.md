# Deploy a selfcontained Spring Boot Microservice

We will use my Crudservice: https://github.com/wlanboy/CrudService

It is published on Docker Hub: https://hub.docker.com/repository/docker/wlanboy/crudservice

# Prepare
```
cd ~
git clone https://github.com/wlanboy/CrudService.git
```

# check you local kubectl
```
kubectl cluster-info
kubectl get pods --all-namespaces
```

# deploy service on new namespace
```
cd ~/CrudService
kubectl create namespace crud
kubectl apply -f crudservice-deployment.yaml
kubectl apply -f crudservice-service.yaml
kubectl get pods -n crud -o wide
```
