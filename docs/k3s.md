# Heqet on K3s

## Bootstrap K3s
See: [K3s Install Options](https://rancher.com/docs/k3s/latest/en/installation/install-options/)

Or if you are feeling lucky:
``` shellsession
curl -sfL https://get.k3s.io | sh -
```

## Bootstrap ArgoCD using Helm

`kubectl apply -f manifests/argocd-helm.yaml` 

``` yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: argocd
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: argocd
  namespace: kube-system
spec:
  chart: argo-cd
  repo: https://argoproj.github.io/argo-helm
  targetNamespace: argocd
  set:
    configs.secret.argocdServerAdminPassword: "$2y$10$IuaM9Ad1mPMycjnStOdNc.wjRlLtI8448F/hS.eA0XJLH9r/ZwRv."
  valuesContent: |-
    controller:
      containerSecurityContext:
        capabilities:
          drop:
           - all
      readOnlyRootFilesystem: true
    dex:
      containerSecurityContext:
        capabilities:
          drop:
           - all
      readOnlyRootFilesystem: true
    redis:
      containerSecurityContext:
        capabilities:
          drop:
           - all
      readOnlyRootFilesystem: true
    server:
      containerSecurityContext:
        capabilities:
          drop:
           - all
      readOnlyRootFilesystem: true
      ingress:
        enabled: true
        hosts:
          - argocd.k3s
      extraArgs:
        - --insecure
    reposerver:
      containerSecurityContext:
        capabilities:
          drop:
           - all
      readOnlyRootFilesystem: true
```

The password in this example is `argocd`.


##  Bootstrap Heqet

`kubectl apply -f manifests/heqet-apps.yaml`

``` yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: heqet
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: heqet
  namespace: argocd
spec:
  destination:
    namespace: heqet
    server: 'https://kubernetes.default.svc'
  source:
    path: .
    repoURL: 'https://github.com/nold360/heqet'
    targetRevision: test
    helm:
      valueFiles:
        - values.yaml
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: false
```

## Profit!

Now K3s should be setup: 

 - ArgoCD should be deployed by K3s-Helm-Operator
 - The Heqet-Application will bootstrap ArgoCD 
 - ArgoCD will take control of all Application configuration in heqet
