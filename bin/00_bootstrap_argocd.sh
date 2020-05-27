#!/bin/bash
echo "Installing ArgoCD..."
helm repo add argo https://argoproj.github.io/argo-helm

kubectl create ns argocd
helm install argo argo/argo-cd --namespace argocd
#kubectl apply -n argocd -f manifests/argocd.yaml

echo
echo "Bootstrapping Heqet Apps..."
kubectl apply -n argocd -f manifests/heqet-apps.yaml

exit 0
