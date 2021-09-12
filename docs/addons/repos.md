# Repositories

Heqet can add Helm & Git repositories to Argo-CD & resolve the repoURL in your config for you. Private repos are not supported [yet].

## Configuration

Here is a simple example of the configuration file `resources/repos.yml`:

```yaml
# Dict of helm or git repos we want to add to ArgoCD
# Parameters:
# name-of-repo:
#   url: https://...
#   type: [default: helm | git]
#
repos:
  bitnami:
    url: https://charts.bitnami.com/bitnami
    ## default: helm
    #type: helm 
  heqet:
    url: https://git.nold.in/nold/heqet
    type: git
```

## Using Repos

Here is a snipped from a `project.yml`:

```yaml
config: 
  name: myproject

apps:
  - name: myapp
    repo: bitnami
    chart: superappchart
```

As you might guess, the option `repo: bitnami` gets resolved to the `url` in our repos configuration.
