#!/bin/bash
echo "ArgoCD 'admin': $(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)"
echo
echo "Vault:"
kubectl logs vault-0 -n vault | egrep 'Unseal Key|Root Token'

exit 0
