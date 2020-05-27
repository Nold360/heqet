#!/bin/bash
echo 'Starting Portforwarding...'

# This is dirty but whatever...
killall kubectl
sleep 1

kubectl port-forward svc/argocd-server -n argocd 8081:443 &>/dev/null &
kubectl port-forward svc/loki-grafana -n heket-loki 8082:80 &>/dev/null &
exit 0
