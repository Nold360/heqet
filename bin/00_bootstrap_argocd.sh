#!/bin/bash

if kubectl get nodes | grep -q '^gke-' ; then
	echo "[GKE] Ensure we are Cluster-Admin..."
  kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=$(gcloud config get-value core/account) || exit 1
fi

echo "Installing ArgoCD..."
helm repo add argo https://argoproj.github.io/argo-helm

kubectl create ns argocd
helm install argo argo/argo-cd --namespace argocd

echo
echo "Bootstrapping Heqet Apps..."
kubectl apply -n argocd -f manifests/heqet-apps.yaml

exit 0
