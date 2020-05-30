#!/bin/bash
echo "Grafana 'admin': $(kubectl get secret -n loki-stack loki-stack-grafana --output jsonpath='{.data.admin-password}' | base64 -d)"
echo "ArgoCD 'admin': $(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)"
echo
echo "Vault:"
kubectl logs vault-0 -n vault | egrep 'Unseal Key|Root Token'

exit 0
