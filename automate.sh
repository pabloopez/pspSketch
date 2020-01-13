#!/bin/bash
# from git clone https://github.com/pabloopez/pspSketch.git

#this script is a sketch on how to configure the cluster and install
#sysdig-agent for training porpouse at katacoda. needs reviewing.
#pablopez 2020

kubectl get pods --A

#we'll need to clean this files, we don't need all of them 
git clone https://github.com/pabloopez/pspSketch.git


mkdir /etc/kubernetes/policies
mv ./audit-policy.yaml /etc/kubernetes/policies/audit-policy.yaml

mv ./kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml

#cluster should restart automatically, check with
kubectl get pods --A

curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
kubectl create ns sysdig-agent
helm install pablotest \
    --set sysdig.accessKey=d5ef4566-d0c2-4174-92eb-0727fc0991f3 \
    --set sysdig.settings.tags="role:training\,location:universe" \
    --set auditLog.dynamicBackend.enabled=true \
    --set auditLog.enabled=true \
    --namespace sysdig-agent \
    stable/sysdig