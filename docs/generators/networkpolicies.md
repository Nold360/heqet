# NetworkPolicy

NetworkPolicies allow you to control/deny access to or from your application. If you want to learn how NetworkPolices work, check out the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/network-policies/).

## Active Generator

To activate the NetPol generator we simply enable it in our `values.yaml`:

``` yaml
generators:
  networkpolicy: true
```

## Define Rules

Next you can create/predefine NetworkPolices in `values.yaml` like this:

```yaml
networkpolicies:
  deny-everything:
    podSelector: {}
    policyTypes:
      - Egress
      - Ingress
```
This rule will deny all out- [Egress] and Ingoing [Ingress] network traffic.


We can define more rules ofcurse [even if 'deny-everything' is already included in 'allow-dns']:

``` yaml
networkpolicies:
  deny-everything:
    podSelector: {}
    policyTypes:
      - Egress
      - Ingress
  allow-dns:
  	podSelector: {}
  	policyTypes:
  	- Egress
  	egress:
  	- ports:
    	- port: 53
      	protocol: UDP
    	to:
    	- namespaceSelector: {}
```



## Apply NetPol to App

Finally we can apply the NetworkPolicy to out application by appending the name of the predefined policy to the `networkpolicies` array:

``` yaml
apps:
  - name: my-secure-app
    [...]
    networkpolicies:
      - deny-everything
      - allow-dns
```

## Allow access to/from Heqet Application

Here is a simple way to apply rules containing other heqet apps. Lets say we have two apps:

``` yaml
apps:
  - name: app-one
    [...]
    networkpolicies:
      - deny-app-two

  - name: app-two
    [...]
```

So we want to deny access from `app-one` to `app-two`. In this case we can use a label that's automatically applied by heqet to every application namespace: `app.heqet.gnu.one/name`

Our policy could look something like this:
``` yaml
networkpolicies:
  deny-app-two:
    podSelector: {}
    policyTypes:
      - Egress
    egress:
    - to:
      - namespaceSelector: 
          matchLabels:
            app.heqet.gnu.one/app: app-two
```
