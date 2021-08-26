variable "helm_namespace" {}

variable "helm_repository" {}

variable "chart_version" {}

variable "values" {
  default = ""
  type    = string
}
