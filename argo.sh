#!/bin/bash
# This script will create argocd name space and deploy deployments and services for argocd
sleep 30
aws eks --region us-east-1 update-kubeconfig --name eks-cluster-1

kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

#kubectl get svc -n argocd
touch /home/ubuntu/argo-secret.txt
sleep 30
#kubectl get secrets -n argocd
#sleep 10
kubectl get secret argocd-initial-admin-secret -n argocd -o yaml | grep "password" | echo `cut -d: -f2` | base64 -d >/home/ubuntu/argo-secret.txt

echo "#############ARGO UI Secret PASSWORD##########"

cat /home/ubuntu/argo-secret.txt

echo "#######END OF ARGO SCRIPT###########"
