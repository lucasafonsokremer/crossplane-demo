#!/bin/bash

##############
# crossplane #
##############

helm repo add crossplane-stable https://charts.crossplane.io/stable

helm repo update

helm install crossplane --namespace crossplane-system \
  --create-namespace crossplane-stable/crossplane \
  --version 1.10.0 \
  --wait

##############
# kubevela   #
##############

helm repo add kubevela \
    https://kubevelacharts.oss-cn-hangzhou.aliyuncs.com/core

helm repo update

helm upgrade --install \
    kubevela kubevela/vela-core \
    --namespace vela-system \
    --create-namespace \
    --wait

##############
# sealed     #
##############

kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.20.2/controller.yaml

wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.20.2/kubeseal-0.20.2-linux-amd64.tar.gz
tar -xvzf kubeseal-0.20.2-linux-amd64.tar.gz
sudo install -m 755 kubeseal /usr/local/bin/kubeseal

##############
# argocd     #
##############

helm repo add argo \
    https://argoproj.github.io/argo-helm

helm repo update

helm upgrade --install \
    argocd argo/argo-cd \
    --namespace argocd \
    --create-namespace \
    --set server.ingress.hosts="{argo-cd.$INGRESS_HOST.nip.io}" \
    --set server.ingress.enabled=true \
    --set configs.params.server.insecure=true \
    --set configs.cm.timeout.reconciliation="30s" \
    --wait

export PASS=$(kubectl \
    --namespace argocd \
    get secret argocd-initial-admin-secret \
    --output jsonpath="{.data.password}" \
    | base64 --decode)


