# Heqet

*Heqet (Egyptian ḥqt, also ḥqtyt "Heqtit") is an Egyptian goddess of fertility.*

I would call it a 'GitOps Kubernetes Development Distribution/Environment' supplying everything you need to get startet with k8s. Heqet heavily relies on a Helm-Chart `charts/heqet` which will generate all applications using ArgoCD's [App-of-Apps-Pattern](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/)

Heqet Keyfeatures:
 * As easy to setup as possible
 * Follow the GitOps principles
 * Supply an independent development environment; incl:
   * Continous Deployment
   * Storage [for bare-metal/on-prem]
   * Ingress
   * ... 

**This project is still in a very early stage of development - WIP**

## Components

Core component is `ArgoCD` which will deploy all of Heqet's apps & your's if you want. All you need is a git-repo & k8s cluster.

Hequet contains / will contain:
  * ArgoCD [Deploys all Applications from Git]
  * Prometheus, Grafana, Loki & fluentd - preconfigured for basic Monitoring and Logging
  * Kubernetes Dashboard
  * Traefik Ingress
  * Jaeger [Tracing]
  * Rook [Block/Object-Strage]
