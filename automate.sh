#!/bin/bash
# from git clone https://github.com/pabloopez/pspSketch.git

#this script is a sketch on how to configure the cluster and install
#sysdig-agent for training porpouse at katacoda. needs reviewing.
#pablopez 2020

kubectl get pods -A

#we'll need to clean this files, we don't need all of them 
#git clone https://github.com/pabloopez/pspSketch.git


mkdir /etc/kubernetes/policies
mv /root/pspSketch/audit-policy.yaml /etc/kubernetes/policies/audit-policy.yaml

#rm /etc/kubernetes/manifests/kube-apiserver.yaml
#mv /root/pspSketch/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml

#sustituye abc por XYZ
#sed -i -e 's/abc/XYZ/g' ./path/to.file
sed -i -e 's/    image:/    - --audit-policy-file=\/etc\/kubernetes\/policies\/audit-policy.yaml\n    - --audit-log-path=-\n    - --audit-dynamic-configuration=true\n    - --feature-gates=DynamicAuditing=true\n    - --runtime-config=auditregistration.k8s.io\/v1alpha1=true\n    image:/g' /etc/kubernetes/manifests/kube-apiserver.yaml
sed -i -e 's/  hostNetwork:/    - mountPath: \/etc\/kubernetes\/policies\n      name: policies\n      readOnly: true\n  hostNetwork:/g' /etc/kubernetes/manifests/kube-apiserver.yaml
sed -i -e 's/status:/  - hostPath:\n      path: \/etc\/kubernetes\/policies\n      type: DirectoryOrCreate\n    name: policies\nstatus:/g' /etc/kubernetes/manifests/kube-apiserver.yaml

#cluster should restart automatically, check with
kubectl get pods -A

curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
kubectl create ns sysdig-agent
helm install training \
    --set sysdig.accessKey=d5ef4566-d0c2-4174-92eb-0727fc0991f3 \
    --set sysdig.settings.tags="role:training\,location:universe" \
    --set auditLog.dynamicBackend.enabled=true \
    --set auditLog.enabled=true \
    --namespace sysdig-agent \
    stable/sysdig