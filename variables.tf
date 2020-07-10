variable "helm_service_account" {}

variable "helm_namespace" {}

variable "helm_repository" {}

variable "chart_version" {}

variable "dependencies" {
  type = "list"
}

variable "values" {
  default = ""
  type = "string"
}

variable "kubecost_token" {
  description = "The token to use for KubeCost"
}

variable "kubecost_domain_name" {
  description = "The domain name to use for KubeCost"
}

variable "kubecost_cluster_name" {
  description = "The cluster name to use for KubeCost"
}

variable "kubecost_subscription_id" {
  description = "The subscription id to use for KubeCost"
}

variable "kubecost_client_id" {
  description = "The client id to use for KubeCost"
}

variable "kubecost_tenant_id" {
  description = "The tenant id to use for KubeCost"
}

variable "kubecost_product_key" {
  description = "The product key to use for KubeCost"
}
