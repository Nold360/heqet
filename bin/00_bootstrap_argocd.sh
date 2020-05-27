#!/bin/bash
echo "Installing ArgoCD..."
kubectl apply -n argocd -f manifests/argocd.yaml

echo
echo "Bootstrapping Heket Apps..."
kubectl apply -n argocd -f manifests/heqet-apps.yaml

exit 0
