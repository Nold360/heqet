# NetworkPolicy

NetworkPolicies allow you to control/deny access to or from your application. If you want to learn how NetworkPolices work, check out the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/network-policies/).

## Define Rules

Next you can create/predefine NetworkPolices in `resources/networkpolicy.yaml` like this:

```yaml
networkrPolicy:
  # global config options
  config:
    # Generate NetworkPolicy to allow communication inside of the project namespace?
    # Only gets applied when other networkpolices are active on the project
    allowNamespace: true 

    # policies that get applied by default
    defaults:
      groups: []
      rules: []

  # NetworkPolices can be grouped:
  groups: []

  # Here are our policy definitions:
  rules:
    deny-everything:
      podSelector: {}
      policyTypes:
      - Egress
      - Ingress
```
This rule will deny all out- [Egress] and Ingoing [Ingress] network traffic.

We can define more rules ofcurse [even if 'deny-everything' is already included in 'allow-dns']:

``` yaml
networkPolicy:
  # global config options
  config:
    # Generate NetworkPolicy to allow communication inside of the project namespace?
    # Only gets applied when other networkpolices are active on the project
    allowNamespace: true 

    # policies that get applied by default
    defaults:
      groups: 
      - insecure

      rules: []

  # NetworkPolices can be grouped:
  groups:
    insecure:
      - deny-everything
      - allow-dns

  # Here are our policy definitions:
  rules:
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

This will create a group of both of our rules & apply them by default to all projects.

## Apply NetworkPolicies

Finally we can apply the NetworkPolicy to our application project. Currently Heqet is not able to apply NetworkPolcies only to a single App of an project!

*from project.yaml*:
``` yaml
config:
  name: secure-project
  description: I like it secure!

  networkPolicy:
    rules:
    - deny-everything
    - allow-dns
    groups:
    - special-group

apps:
  - name: my-secure-app
    [...]
```

## Allow communication between Heqet projects

Here is a simple way to apply rules containing other heqet apps. Lets say we have two apps:

``` yaml
config:
  name: project-one

  networkPolicy:
    rules:
   	- deny-project-two
apps:
    [...]
```

So we want to deny access from `project-one` to `project-two`. In this case we can use a label that's automatically applied by heqet to every application namespace: `app.heqet.gnu.one/project`

Our policy could look something like this:
``` yaml
networkPolicy:
  rules:
  	deny-project-two:
    	podSelector: {}
    	policyTypes:
      	- Egress
    	egress:
    	- to:
      	- namespaceSelector: 
          	matchLabels:
            	app.heqet.gnu.one/project: project-two
```
