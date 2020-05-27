#!/bin/bash
echo "Grafana 'admin': $(kubectl get secret -n heket-loki loki-grafana --output jsonpath='{.data.admin-password}' | base64 -d)"
echo "ArgoCD 'admin': $(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)"
exit 0
