#!/bin/bash
echo 'Starting Portforwarding...'

# This is dirty but whatever...
killall kubectl
sleep 1

kubectl port-forward svc/argocd-server -n argocd 8081:443 &>/dev/null &
kubectl port-forward svc/loki-grafana -n heqet-loki 8082:80 &>/dev/null &
kubectl port-forward svc/heqet-vault-ui -n heqet-vault 8083:8200 &>/dev/null &
kubectl port-forward  service/heqet-jaeger-jaeger-operator-jaeger-query -n heqet-jaeger 8084:8200 &>/dev/null &
exit 0
