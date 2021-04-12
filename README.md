# Heqet

*Heqet (Egyptian ḥqt, also ḥqtyt "Heqtit") is an Egyptian goddess of fertility.*

Heqet is my attempt to make Kubernetes GitOps Deployments as easy as possible. It reduces the need of configuration by generating the required Application definitions for you. Heqet heavily relies on a Helm-Chart which will generate all applications, namespaces & more using ArgoCDs [App-of-Apps-Pattern](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/).

## Keyfeatures
 * Easy Setup [Sane Kubernetes cluster + PVC-StorageClass]
 * Easy application definition & configuration
 * Follows the GitOps principles
 * Deploy a whole application environment or cluster from a singe git-repo

**This project is still in a very early stage of development, but feel free to try it out & contribute!**

## Components & Configuration

Core component is `ArgoCD` which will deploy Heqet & also your apps! All you need is a git-repo & k8s cluster.

The heqet Helm-Chart will generate ArgoCD Applications, namespaces and if required vault Secrets. All you need to do if add your Helm-Application to heqet's `values.yaml`. 

If more configuration values are required, simply throw your applications `values.yaml` into heqets `values.d` folder, named as the application [e.g. `values.d/argocd.yaml`.

## Installation

Installing heqet can't be simpler, after configuring your apps, argocd and pushing it to your git repo:
1. Configure `manifests/heqet-apps.yaml` to match your Setup
2. `kubectl apply -f manifests/argocd.yaml`
3. `kubectl apply -f manifests/heqet-apps.yaml`
 
ArgoCD will start and bootstrap heqet. 

## Application Definition

Here is a list of available configuration options inside the `apps` array.o

### Required

| Parameter | Type   | Example | Description |
|-----------|--------|---------|-------------|
| name      | string | `"argocd"` | Name of your application & namespace [if not specified] | 
| repoURL   | string | `"https://github.com/nold360/heqet"` | URL to git or Helmchart repo |      
| path      | string | `"charts/heqet"` | Path to chart if using git in `repoURL` |
| chart     | string | `"heqet"` | Chart name [ only use either `path` or `chart` ] |
| targetRevision | string | `"1.2.3"` or `"master"` | Version of Helm-Chart or Branch/Tag of git |

### Optional 

| Parameter | Type   | Default | Example | Description |
|-----------|--------|---------|---------|-------------|
| disabled  | bool   | false   | `true`  | Disable App |
| noCreateNamespace | bool | false | `true` | Don't create namespace for app |
| namespace | string | .Values.name | `"superns"` | Name of application namespace |
| annotations | hash |         | `my.anno.org/stuff: is-awesome` | Namespace annotations |
| syncWave | string | `"0"`    | `"-2" | ArgoCD SyncWave | 
| project  | string | `"default"` | `"myproject"` | Name of ArgoCD Project |
| server   | string | `"https://kubernetes.default.svc"` | `https://my.external.cluster:8443` | K8s Cluster to deploy to |
| prune | bool | `false` | `true` | ArgoCD automatic prune app |
| selfHeal | bool | `false` | `true` | ArgoCD automatic self-heal app |
| ignoreDiff | array |     | See ArgoCD docs | ArgoCD [ignoreDifferences](https://argoproj.github.io/argo-cd/user-guide/diffing/)
| parameters | array |     |- name: ingress.host<br>value: awesome.url | Parameters override values of app |

### Generators
Heqet contains a "generators" feature which will create additional resources for you. Currently only one generator is implemented. 

#### VaultSecret 
The VaultSecret generator will create `VaultSecret` for the secrets specified in `secrets`. It's based on the  [vault-secret-operator](https://github.com/ricoberger/vault-secrets-operator). 

##### Values
Here is an example for a simple secret:
``` yaml
apps:
  - name: myapp
    secrets:
    - name: my-secret
      keys: 
       - username
       - password
      # default:
      type: Opaque 
```

This will result in following resource. Notice that the path inside of Vault is `/heqet/<name-of-app>/<name-of-secret>`.
``` yaml
apiVersion: ricoberger.de/v1alpha1
kind: VaultSecret
metadata:
  name: vpn-config
  namespace: "myapp"
  labels:
    app: myapp
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
spec:
  keys:
    - username
    - password
  path: heqet/myapp/my-secret
  type: Opaque
```

## Custom Resource Definitions
CRDs might be required before applying application configuration. If so, copy the `crd.yaml` into heqets `templates/crds`-Directory.

## Full Example
Check out the `test`-Branch of this repo for my current testing setup.
