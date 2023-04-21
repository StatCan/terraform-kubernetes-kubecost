# Terraform Kubernetes KubeCost

## Introduction

This module deploys and configures KubeCost inside a Kubernetes Cluster.

## Security Controls

The following security controls can be met through configuration of this template:

* TBD

## Dependencies

* None

## Usage

```terraform
module "helm_kubecost" {
  source = "https://github.com/canada-ca-terraform-modules/terraform-kubernetes-kubecost?ref=v3.2.1"

  chart_version = "0.0.1"
  depends_on = [
    module.namespace_kubecost,
  ]

  helm_namespace = module.namespace_kubecost.name
  helm_repository = "kubecost"

  values = <<EOF
cost-analyzer:
  kubecostToken: "${var.kubecost_token}"
  ingress:
    enabled: true
    annotations:
    kubernetes.io/ingress.class: istio
    hosts:
    - "kubecost.${var.kubecost_domain_name}"
    paths:
    - '/*'
  tolerations:
    - key: "dedicated"
      operator: "Equal"
      value: "gpu"
      effect: "NoSchedule"
  prometheus:
    nodeExporter:
      tolerations:
        - key: "dedicated"
          operator: "Equal"
          value: "gpu"
          effect: "NoSchedule"
  kubecostProductConfigs:
    clusterName: "${var.kubecost_cluster_name}"
    currencyCode: "USD"
    azureBillingRegion: CA
    azureSubscriptionID: ${var.kubecost_subscription_id}
    azureClientID: ${var.kubecost_client_id}
    azureTenantID: ${var.kubecost_tenant_id}
    productKey:
      enabled: true
      key: ${var.kubecost_product_key}
EOF
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 1.3.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 1.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 1.3.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 1.10.0 |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | n/a | `string` | `"kubecost"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | n/a | `string` | `"1.92.0"` | no |
| <a name="input_enable_prometheusrules"></a> [enable\_prometheusrules](#input\_enable\_prometheusrules) | Adds PrometheusRules for kubecost alerts | `bool` | `true` | no |
| <a name="input_helm_namespace"></a> [helm\_namespace](#input\_helm\_namespace) | the namespace which should contain resource created by this helm release | `string` | `"kubecost-system"` | no |
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | The repository where the Helm chart is stored | `string` | `"https://kubecost.github.io/cost-analyzer/"` | no |
| <a name="input_helm_repository_password"></a> [helm\_repository\_password](#input\_helm\_repository\_password) | The password of the repository where the Helm chart is stored | `string` | `""` | no |
| <a name="input_helm_repository_username"></a> [helm\_repository\_username](#input\_helm\_repository\_username) | The username of the repository where the Helm chart is stored | `string` | `""` | no |
| <a name="input_values"></a> [values](#input\_values) | Values that represent the configuration for kubecost, based on the upstream helm chart | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_namespace"></a> [helm\_namespace](#output\_helm\_namespace) | n/a |
<!-- END_TF_DOCS -->

## History

| Date     | Release | Change                                                        |
| -------- | ------- | --------------------------------------------------------------|
| 20200710 | v1.0.0  | Initial release                                               |
| 20200710 | v1.0.1  | Removed extraneous variables                                  |
| 20201005 | v2.0.0  | Module modified for Helm 3                                    |
| 20210113 | v2.0.1  | Remove interpolation syntax                                   |
| 20210824 | v3.0.0  | Update module for Terraform v0.13                             |
| 20220712 | v3.1.0  | Added ability to pass helm credentials                        |
| 20230105 | v3.2.0  | Add kubecost rules from the cost-analyzer Helm chart          |
| 20230202 | v3.2.1  | Specify sensitive variables                                   |
| 20230412 | v3.2.2  | Add `evaluated-by: prometheus` label to alerts so they are picked up by Prometheus. |
