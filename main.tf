resource "helm_release" "kubecost" {
  version    = var.chart_version
  name       = "kubecost"
  chart      = "cost-analyzer"
  repository = var.helm_repository
  namespace  = var.helm_namespace

  timeout = 2400

  values = [
    var.values,
  ]
}
