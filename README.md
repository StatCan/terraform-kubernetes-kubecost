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
  source = "https://github.com/canada-ca-terraform-modules/terraform-kubernetes-kubecost?ref=v3.0.0"

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

## Variables Values

| Name                     | Type   | Required | Value                                           |
| ------------------------ | ------ | -------- | ----------------------------------------------- |
| chart_version            | string | yes      | Version of the Helm Chart                       |
| helm_namespace           | string | yes      | The namespace Helm will install the chart under |
| helm_repository          | string | yes      | The repository where the Helm chart is stored   |
| values                   | list   | no       | Values to be passed to the Helm Chart           |

## History

| Date     | Release | Change                            |
| -------- | ------- | --------------------------------- |
| 20200710 | v1.0.0  | Initial release                   |
| 20200710 | v1.0.1  | Removed extraneous variables      |
| 20201005 | v2.0.0  | Module modified for Helm 3        |
| 20210113 | v2.0.1  | Remove interpolation syntax       |
| 20210824 | v3.0.0  | Update module for Terraform v0.13 |

