# VaultSecret Generator
The VaultSecret generator will create a `VaultSecret` for every secret specified in the `secrets`-hash. It's based on the  [vault-secret-operator](https://github.com/ricoberger/vault-secrets-operator). 

## Parameters

| Parameter | Type   | Example     | Description |
|-----------|--------|-------------|-------------|
| name      | string         | `"my-secret"` | Name of Secret to generate & in vault [requited] |
| keys      | array[string]  | `- password`  | Array of keys that will be pulled from the vault-secret [required] |
| type      | string         | `Opaque`      | Secret type in Kubernetes [default: `Opaque`] |
| fromApp   | string         | `myapp2`      | Pulls secret from another app, e.g. `/heqet/<other-app>/<secret.name>`. This way sharing secrets between apps is easily possible |


## Examples
### Simple
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
  name: my-secret
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

### Sharing Secrets between Apps

Secrets can also be shared & pulled from other apps, by using the `fromApp` parameter:

``` yaml
apps:
  - name: myapp
    secrets:
    - name: my-secret
      keys: 
       - username
       - password
       - shared-key
      # default:
      type: Opaque 

  - name: myapp2
    secrets:
    - name: my-secret
      fromApp: myapp
      keys:
        - shared-key 
```
