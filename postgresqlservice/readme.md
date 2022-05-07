# Install PostgreSQL on Kubernetes

## Create configuration and storage
```
kubectl create -f postgres-configmap.yaml 
kubectl create -f postgres-storage.yaml 
```

## create instance
```
kubectl create -f postgres-deployment.yaml 
```

## expose instance with service
```
kubectl create -f postgres-service.yaml
```

## get service information
```
kubectl get svc postgres
NAME       TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
postgres   NodePort   10.107.71.253   <none>        5432:31070/TCP   5m
```

## connect to postgresql
```
$ psql -h localhost -U postgresadmin --password -p 31070 postgresdb
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
