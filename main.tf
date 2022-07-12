resource "helm_release" "kubecost" {
  name                = "kubecost"
  repository          = var.helm_repository
  repository_username = var.helm_repository_username
  repository_password = var.helm_repository_password
  chart               = "cost-analyzer"
  version             = var.chart_version
  namespace           = var.helm_namespace

  timeout = 2400

  values = [
    var.values,
  ]
}
