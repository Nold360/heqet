#!/bin/bash
#kubectl create namespace argocd
kubectl apply -n argocd -f manifests/argocd.yaml

while ! type argocd &>/dev/null ; do
	echo Go and get the argocd commandline tool - https://github.com/argoproj/argo-cd/releases
	read -p'Press ENTER when you are done..'
done

echo
echo 'Starting Portforwarding...'

kubectl port-forward svc/argocd-server -n argocd 8080:443 &>/dev/null &

echo
echo "ArgoCD 'admin' Password: $(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)"

echo
echo "Bootstrapping Hekey Apps..."
kubectl apply -n argocd -f manifests/heket-apps.yaml
