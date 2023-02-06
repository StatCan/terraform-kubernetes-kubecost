variable "helm_namespace" {
  type        = string
  nullable    = false
  default     = "kubecost-system"
  description = "the namespace which should contain resource created by this helm release"
}

variable "helm_repository" {
  default     = "https://kubecost.github.io/cost-analyzer/"
  description = "The repository where the Helm chart is stored"
}

variable "helm_repository_username" {
  default     = ""
  type        = string
  nullable    = false
  description = "The username of the repository where the Helm chart is stored"
  sensitive   = true
}

variable "helm_repository_password" {
  default     = ""
  type        = string
  nullable    = false
  description = "The password of the repository where the Helm chart is stored"
  sensitive   = true
}

variable "chart_version" {
  default = "1.92.0"
}

variable "chart_name" {
  default = "kubecost"
}

variable "values" {
  default     = ""
  type        = string
  description = "Values that represent the configuration for kubecost, based on the upstream helm chart"
}

variable "enable_prometheusrules" {
  type        = bool
  default     = true
  description = "Adds PrometheusRules for kubecost alerts"
}
