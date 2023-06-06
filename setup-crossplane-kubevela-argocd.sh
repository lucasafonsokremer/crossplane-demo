#!/bin/bash

export INGRESS_HOST=$(kubectl get -o template service/ingress-nginx-controller -n ingress-nginx --template='{{.spec.clusterIP}}')

export GITHUB_ORG=lucasafonsokremer

gh repo fork lucasafonsokremer/crossplane-demo \
    --clone

cd crossplane-demo

export REPO_URL=https://github.com/$GITHUB_ORG/crossplane-demo
