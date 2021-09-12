# Heqet

*Heqet (Egyptian ḥqt, also ḥqtyt "Heqtit") is an Egyptian goddess of fertility.*

Heqet is my attempt to make Kubernetes GitOps Deployments as easy as possible. It reduces the need of configuration by generating the required Kubernetes resource definitions for you. Heqet heavily relies on a Helm-Chart which will generate all ArgoCD-Applications, -Projects, Namespaces & more using Argo-CDs [App-of-Apps-Pattern](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/).

## Keyfeatures
 * Easy Setup [Just requires a sane Kubernetes cluster + ArgoCD + PVC-StorageClass]
 * Easy / DRY application definition & configuration
 * Follows the GitOps principles
 * Deploy a whole application environment or cluster from a singe git-repo
 * Addons like generation of `VaultSecret` and `NetworkPolicy` resources

**This project is still in a very early stage of development, but feel free to try it out, give feedback, create an issue and contribute!**

## Overview

![Heqet Overview](https://nold360.github.io/heqet/assets/heqet-overview.jpg)

## Components & Configuration

Core component is `ArgoCD` which will deploy Heqet & also your other apps! All you need is a git-repo & k8s cluster.

The heqet Helm-Chart will generate ArgoCD-Applications & -Projects, Namespaces and if required `VaultSecret`s, `NetworkPolicies`, Argo-CD Repositories and more. 

The configuration is seperated in different files & directories:
 * `projects/` - This directory contains all your Application/Project config
  * `name-of-project/` - This directory name represents the name of our project
    * `project.yaml` - The most important config, containing all our applications of this project
    * `values/` - Every app in our project can have it's own `values.yaml` here, named: `name-of-app.yaml`
      * `name-of-app.yaml` - Values file for the application "name-of-app"
 * `resources/` - This directory contains all global config, like NetworkPolcies, Repos 
   * `manifests/` - Can be used for static YAML-Manifests


## Installation

Installing heqet can't be simpler:

0. Install Argo-CD on your cluster & set it up to your needs
1. Configure `manifests/heqet-apps.yaml` to match your Setup
2. `kubectl apply -f manifests/heqet-apps.yaml`
3. Create your configuration in `projects` and `resources` folders 


## Example Configuration

Check out the `hive`-branch of this repository for the latest deployment configuration in my homelab environment.


## Docs

Check out the full documentation: [here](https://nold360.github.io/heqet)
