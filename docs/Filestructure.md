# Directory & Filestructure

The configuration is seperated in different files & directories:
 * `projects/` - This directory contains all your Application/Project config
  * `name-of-project/` - This directory name represents the name of our project
    * `project.yaml` - The most important config, containing all our applications of this project
    * `values/` - Every app in our project can have it's own `values.yaml` here, named: `name-of-app.yaml`
      * `name-of-app.yaml` - Values file for the application "name-of-app"
 * `resources/` - This directory contains all global config, like NetworkPolcies, Repos 
   * `manifests/` - Can be used for static YAML-Manifests

## Overview

![Heqet Overview](https://nold360.github.io/heqet/assets/heqet-directory-overview.jpg)
