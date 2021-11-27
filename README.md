# Heqet

*Heqet (Egyptian ḥqt, also ḥqtyt "Heqtit") is an Egyptian goddess of fertility.*

Heqet is my attempt to make Kubernetes GitOps Deployments as easy as possible. It's goal is to reduce the need of redundant configuration in a GitOps environment, by generating the required Kubernetes resource definitions for you. Heqet heavily relies on a Helm-Chart which will generate all ArgoCD-Applications, -Projects, Namespaces & more using Argo-CDs [App-of-Apps-Pattern](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/).

## What problem does heqet solve?

Kubernetes allows declarative infrastructure which can be stored in git easily. Argo-CD is used to deploy those configurations. With Argo-CD it's simple to deploy Helm-Charts. But you still need to write a lot of redundant yaml-files.

Heqet reduces the configuration required to deploy Helm-chart-based applications to the bare minimum:
 - What's the name of your app?
 - Which Chart to deploy? 
 - Which values to apply?
 - Do it!

## Keyfeatures
 * Easy Setup [Just requires Kubernetes + Argo-CD]
 * Simple / DRY application definition & configuration
 * Follows the GitOps principles
 * Deploy a whole application environment or cluster from a singe git-repo
 * Addons for simple generation of `VaultSecret` and `NetworkPolicy` resources
 * Include reuseable resources like value snippets & NetworkPolicies into your app
 * Inheritance of configuration options [defaults -> project -> app]


## Overview

![Heqet Overview](https://lib42.github.io/heqet/assets/heqet-overview.jpg)

## Components & Configuration

Core component is `Argo-CD` which will deploy Heqet & also your apps! All you need is a git-repo & k8s cluster.

The heqet Configuration-Management-Plugin [CMP] will generate ArgoCD-Applications & -Projects, Namespaces and if required `VaultSecret`s, `NetworkPolicies`, Argo-CD Repositories and more. 

The user configuration is seperated in different files & directories:

* `projects/` - This directory contains all your Application/Project config
  * `name-of-project/` - This directory name represents the name of our project
    * `project.yaml` - The most important config, containing all our applications of this project
    * `values/` - Every app in our project can have it's own `values.yaml` here, named: `name-of-app.yaml`
      * `name-of-app.yaml` - Values file for the application "name-of-app"
    * `manifests/` - Static yaml manifests for your app
* `resources/` - This directory contains all global config, like NetworkPolcies, Repos 
  * `manifests/` - Can be used for static YAML-Manifests
  * `snippets/` - Value snippets for your apps


## Installation

Installing heqet is quite simple:

0. Install Argo-CD version >= 2.2.0 on your cluster & set it up to your needs
1. Configure Argo-CD Plugin
2. Create your heqet userdata git repository
3. Configure `manifests/heqet-apps.yaml` to match your Setup
4. `kubectl apply -f manifests/heqet-apps.yaml`
5. Create your configuration in `projects` and `resources` folders 


## Example Configuration

FIXME

## Docs

Check out the full documentation: [here](https://lib42.github.io/heqet)
