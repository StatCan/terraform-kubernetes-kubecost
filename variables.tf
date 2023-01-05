variable "helm_namespace" {
  default = "kubecost-system"
}

variable "helm_repository" {
  default = "https://kubecost.github.io/cost-analyzer/"
}

variable "helm_repository_username" {
  default = ""
  type    = string
}

variable "helm_repository_password" {
  default = ""
}

variable "chart_version" {
  default = "1.92.0"
}

variable "chart_name" {
  default = "kubecost"
}

variable "values" {
  default = ""
  type    = string
}

variable "enable_prometheusrules" {
  type        = bool
  default     = true
  description = "Adds PrometheusRules for kubecost alerts"
}
