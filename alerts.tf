locals {
  common_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/part-of"    = "kubecost"
    "app.kubernetes.io/version"    = "v3.2.0"
  }
}

resource "kubernetes_manifest" "prometheusrule_kubecost_alerts" {
  count = var.enable_prometheusrules ? 1 : 0
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "name"      = "kubecost-alerts"
      "namespace" = var.helm_namespace
      "labels"    = merge(local.common_labels, { "app.kubernetes.io/name" = "kubecost-alerts" })
      "annotations" = {
        "rules-definition" = "https://gitlab.k8s.cloud.statcan.ca/cloudnative/terraform/modules/terraform-kubernetes-kubecost/-/tree/master/prometheus_rules/kubecost_rules.yaml"
      }
    }
    "spec" = yamldecode(file("${path.module}/prometheus_rules/kubecost_rules.yaml"))
  }
}
