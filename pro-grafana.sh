#!/bin/bash

# this script will deploy  both prometheus and grafana deployments and set username and password as admin/admin@321
ansible-playbook ansible.yaml

sleep 480

aws eks --region us-east-1 update-kubeconfig --name eks-cluster-1


kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

sleep 20

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 

helm repo update

kubectl create namespace prometheus

helm install prometheus prometheus-community/prometheus     --namespace prometheus     --set alertmanager.persistentVolume.storageClass="gp2"     --set server.persistentVolume.storageClass="gp2"

echo "###### script will sleep for 90sec, because grafana installation will start after prometheus pods started fully #############"
sleep 90

#echo "###### script will scleep for 90sec, because grafana installation will start after prometheus pods started fully #############"

helm repo add grafana https://grafana.github.io/helm-charts 

helm repo update 

kubectl create namespace grafana

helm install grafana grafana/grafana     --namespace grafana     --set persistence.storageClassName="gp2"     --set persistence.enabled=true     --set adminPassword='admin@321'     --values prometheus-datasource.yaml     --set service.type=LoadBalancer