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
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-kubernetes-kubecost.git"

  chart_version = "0.0.1"
  dependencies = [
    "${module.namespace_kubecost.depended_on}",
  ]

  helm_service_account = "tiller"
  helm_namespace = "kubecost"
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
|--------------------------|--------|----------|-------------------------------------------------|
| chart_version            | string | yes      | Version of the Helm Chart                       |
| dependencies             | string | yes      | Dependency name refering to namespace module    |
| helm_service_account     | string | yes      | The service account for Helm to use             |
| helm_namespace           | string | yes      | The namespace Helm will install the chart under |
| helm_repository          | string | yes      | The repository where the Helm chart is stored   |
| values                   | list   | no       | Values to be passed to the Helm Chart           |
| kubecost_token           | list   | no       | The token to use for KubeCost                   |
| kubecost_domain_name     | list   | no       | The domain name to use for KubeCost             |
| kubecost_cluster_name    | list   | no       | The cluster name to use for KubeCost            |
| kubecost_subscription_id | list   | no       | The subscription id to use for KubeCost         |
| kubecost_client_id       | list   | no       | The client id to use for KubeCost               |
| kubecost_tenant_id       | list   | no       | The tenant id to use for KubeCost               |
| kubecost_product_key     | list   | no       | The product key to use for KubeCost             |

## History

| Date     | Release | Change                        |
|----------|---------|-------------------------------|
| 20200710 | v1.0.0  | Initial release               |
| 20200710 | v1.0.1  | Removed extraneous variables  |
