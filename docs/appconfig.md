## Application Definition

Here is a list of available configuration options inside the `apps` array of heqets `values.yaml`.

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
| existingNamespace | string | none | `"default"` | Don't create namespace, instead use an existing one |
| namespace | string | .Values.name | `"superns"` | Name of application namespace |
| annotations | hash |         | `my.anno.org/stuff: is-awesome` | Namespace annotations |
| syncWave | string | `"0"`    | `"-2" | ArgoCD SyncWave | 
| project  | string | `"heqet"` | `"myproject"` | Name of ArgoCD Project |
| server   | string | `"https://kubernetes.default.svc"` | `https://my.external.cluster:8443` | K8s Cluster to deploy to |
| prune | bool | `false` | `true` | ArgoCD automatic prune app |
| selfHeal | bool | `false` | `true` | ArgoCD automatic self-heal app |
| ignoreDiff | array |     | See ArgoCD docs | ArgoCD [ignoreDifferences](https://argoproj.github.io/argo-cd/user-guide/diffing/)
| parameters | array |     |- name: ingress.host<br>value: awesome.url | Parameters override values of app |

## Custom Resource Definitions
CRDs might be required before applying application configuration. If so, copy the `crd.yaml` into the `/crds`-Directory.

## Full Example
Check out the `test`-Branch of this repo for my current testing setup.
