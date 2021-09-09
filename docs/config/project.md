# Project Definition

Here is a list of available configuration options inside the `apps` array of heqets `values.yaml`.

## Project Config

Project configuration parameters will be merged into application parameters. So basically all application parameters can be used here.

Special project parameters: 

| Parameter | Type   | Default | Example | Description |
|-----------|--------|---------|---------|-------------|
| name      | string | Name of project directory | my-project | Name of project in Argo-CD |
| namespace | string | Name of project | myspace | Name of default Namespace of projects apps |
| description | string | None | "My great project" | Description of project in Argo-CD |
| networkPolicy | dict | None | See [addons/networkpolicy](https://nold360.github.io/heqet/addons/networkpolicy) | |

