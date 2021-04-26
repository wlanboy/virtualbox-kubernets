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

# check deployment and service
```
kubectl describe deployments -n crud crudservice 
kubectl describe services -n crud crudservice-service
```

# expose service and get node port
```
kubectl expose deployment -n crud crudservice --type=NodePort --name=crudservice-serviceexternal --port 8002
kubectl describe services -n crud crudservice-serviceexternal 
```
Result:
```
Name:                     crudservice-serviceexternal
Namespace:                crud
Labels:                   app=crudservice
Annotations:              <none>
Selector:                 app=crudservice
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.108.40.138
IPs:                      10.108.40.138
Port:                     <unset>  8002/TCP
TargetPort:               8002/TCP
NodePort:                 <unset>  30411/TCP  <--- THIS IS THE PORT WE NEED
Endpoints:                10.10.0.6:8002
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

#  call crudservice
* curl http://192.168.56.100:30411/actuator/health
* Result
```
{"status":"UP","groups":["liveness","readiness"]}
```
