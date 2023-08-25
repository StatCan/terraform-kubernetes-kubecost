module "helm_kubecost" {
  source = "https://github.com/canada-ca-terraform-modules/terraform-kubernetes-kubecost?ref=v4.0.0"

  grafana = {
    domain_name = "grafana.prometheus-system"
  }

  prometheus = {
    fqdn = "prometheus.prometheus-system"
  }

  ingress = {
    hosts = ["kubecost.example.ca"]
  }

  product_configs = {
    azure = {
      client_id        = "11111111111"
      client_password  = "2222222222222222"
      offer_durable_id = "AZURE-123"
      subscription_id  = "33333333333333"
      tenant_id        = "4444444444444444444"
    }
    cluster_name = "example-cluster"
    grafana_url  = "https://grafana.example.ca"
    product_key  = "12312412412512"
    token        = "token12345"
  }
}
