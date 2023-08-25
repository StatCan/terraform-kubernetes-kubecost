# Terraform Kubernetes KubeCost

## Introduction

This module deploys and configures KubeCost inside a Kubernetes Cluster.

## Security Controls

The following security controls can be met through configuration of this template:

* TBD

## Dependencies

* None

## Usage

Refer to [examples](./examples).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0.0 |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_grafana"></a> [grafana](#input\_grafana) | Configurations for Grafana. | <pre>object({<br>    domain_name = string<br>  })</pre> | n/a | yes |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Configurations related the Ingress manifest. | <pre>object({<br>    enabled = optional(bool, true)<br>    hosts   = optional(list(string), [])<br>  })</pre> | n/a | yes |
| <a name="input_product_configs"></a> [product\_configs](#input\_product\_configs) | Configurations for the Kubecost instance. | <pre>object({<br>    azure = object({<br>      subscription_id  = string<br>      client_id        = string<br>      client_password  = string<br>      tenant_id        = string<br>      offer_durable_id = string<br>    })<br>    cluster_name                = string<br>    cluster_profile             = optional(string, "production")<br>    grafana_url                 = string<br>    extra_label_mapping_configs = optional(map(string), {})<br>    product_key                 = string<br>    shared_namespaces           = optional(list(string), [])<br>    token                       = string<br>  })</pre> | n/a | yes |
| <a name="input_prometheus"></a> [prometheus](#input\_prometheus) | n/a | <pre>object({<br>    fqdn = string<br>    prometheus_rule = optional(object({<br>      enabled = optional(bool, true)<br>    }), {})<br>    service_monitor = optional(object({<br>      cost_analyzer = optional(object({<br>        enabled            = optional(bool, true)<br>        metric_relabelings = optional(string, "")<br>      }), {})<br>    }), {})<br>  })</pre> | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | n/a | `string` | `"1.105.1"` | no |
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | The repository where the Helm chart is stored | <pre>object({<br>    name     = optional(string, "https://kubecost.github.io/cost-analyzer/")<br>    username = optional(string, "")<br>    password = optional(string, "")<br>  })</pre> | `{}` | no |
| <a name="input_hubs"></a> [hubs](#input\_hubs) | The host to a hub. For example: gcr.io/ | <pre>object({<br>    gcr       = optional(string, "")<br>    dockerhub = optional(string, "")<br>  })</pre> | `{}` | no |
| <a name="input_image_pull_secret_names"></a> [image\_pull\_secret\_names](#input\_image\_pull\_secret\_names) | The names of secrets containing the pull credentials of image repositories. | `list(string)` | `[]` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | the namespace which should contain resource created by this helm release | `string` | `"kubecost-system"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | The node labels which should be used for scheduling. | `map(string)` | `{}` | no |
| <a name="input_notifications"></a> [notifications](#input\_notifications) | n/a | <pre>object({<br>    global_slack_webhook_url = optional(string, "")<br>    alerts                   = optional(string, "")<br>  })</pre> | `{}` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | n/a | <pre>list(object({<br>    effect             = optional(string)<br>    key                = optional(string)<br>    operator           = optional(string)<br>    toleration_seconds = optional(number)<br>    value              = optional(string)<br>    })<br>  )</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
<!-- END_TF_DOCS -->

## History

| Date       | Release | Change                                                                              |
| ---------- | ------- | ----------------------------------------------------------------------------------- |
| 2020-07-10 | v1.0.0  | Initial release                                                                     |
| 2020-07-10 | v1.0.1  | Removed extraneous variables                                                        |
| 2020-10-05 | v2.0.0  | Module modified for Helm 3                                                          |
| 2021-01-13 | v2.0.1  | Remove interpolation syntax                                                         |
| 2021-08-24 | v3.0.0  | Update module for Terraform v0.13                                                   |
| 2022-07-12 | v3.1.0  | Added ability to pass helm credentials                                              |
| 2023-01-05 | v3.2.0  | Add kubecost rules from the cost-analyzer Helm chart                                |
| 2023-02-02 | v3.2.1  | Specify sensitive variables                                                         |
| 2023-04-12 | v3.2.2  | Add `evaluated-by: prometheus` label to alerts so they are picked up by Prometheus. |
| 2023-08-17 | v4.0.0  | Refactor to provide a more opinionated interface for the features used.             |
