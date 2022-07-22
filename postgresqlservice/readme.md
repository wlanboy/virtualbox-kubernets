# Install PostgreSQL on Kubernetes

## create namespace
```
kubectl create namespace database
```

## Create configuration and storage
```
kubectl create -f postgres-config.yaml -n database
kubectl create -f postgres-secret.yaml -n database
kubectl create -f postgres-storage.yaml -n database
```

### convert to app/v1
```
kubectl convert -f .\postgres-deployment.yaml --output-version apps/v1
```

## create instance
```
kubectl create -f postgres-deployment.yaml -n database
```

## expose instance with service
```
kubectl create -f postgres-service.yaml -n database
```

## get service information
```
kubectl get svc postgres -n database
NAME       TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)          AGE
postgres   LoadBalancer   10.107.8.78   192.168.59.110   5432:30127/TCP   10m
```

## connect to postgresql
```
$ psql -h 192.168.59.110 -U postgresadmin --password -p 30127 postgresdb
Password for user postgresadmin: 
psql (14.2)
Type "help" for help.
  
postgresdb=#
```

## delete everything
```
kubectl delete service postgres 
kubectl delete deployment postgres
kubectl delete configmap postgres-config
kubectl delete persistentvolumeclaim postgres-pv-claim
kubectl delete persistentvolume postgres-pv-volume
```
