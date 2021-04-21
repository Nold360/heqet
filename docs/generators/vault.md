# VaultSecret Generator
The VaultSecret generator will create a `VaultSecret` for every secret specified in the `secrets`-hash. It's based on the  [vault-secret-operator](https://github.com/ricoberger/vault-secrets-operator). 

## Values
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

