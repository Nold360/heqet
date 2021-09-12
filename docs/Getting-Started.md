# Getting Started

## Fork heqet

Since currently there is no way i know of, to seperate heqets config from it's code. I guess it's best you fork the whole github repo & start your config in `charts/heqet`. This way you should be able to "easily" rebase the fork on the current upstream in case of code changed. [If you don't mess with the code itself that is].

## Creating a new project

Copy the `example/project` folder to `charts/heqet/projects/name-of-your-project`. It contains a template for the `project.yaml` and also the `values` directory.

In the `values` directory you can simple create a new .yaml file, this the name of the app it belongs to. [same name as defined in the `project.yaml` by you. 

