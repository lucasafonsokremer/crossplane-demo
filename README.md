

kind create cluster --config kind.yaml --kubeconfig ~/.kube/kind-crossplane.yml

export KUBECONFIG="$HOME/.kube/kind-crossplane.yml"

kubectl config view

kubectl get pods -A

kind delete cluster --name kind

# NGINX Ingress installation might differ for your k8s provider
kubectl apply \
    --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml


export AWS_ACCESS_KEY_ID=[...]
export AWS_SECRET_ACCESS_KEY=[...]

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
" | tee /tmp/aws-creds.conf

kubectl --namespace crossplane-system \
    create secret generic aws-creds \
    --from-file creds=/tmp/aws-creds.conf \
    --output json \
    --dry-run=client \
    | kubeseal --format yaml \
    | tee crossplane-configs/aws-creds.yaml

kubectl apply --filename project.yaml

kubectl apply --filename apps.yaml

kubectl port-forward service/argocd-server -n argocd 8080:443

cat examples/cluster.yaml

cp examples/cluster.yaml team-a

kubectl get clusters,nodegroup,iamroles,iamrolepolicyattachments,vpcs,securitygroups,subnets,internetgateways,routetables,providerconfigs.helm.crossplane.io,releases
