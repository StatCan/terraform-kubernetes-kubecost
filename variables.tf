variable "helm_namespace" {}

variable "helm_repository" {}

variable "chart_version" {}

variable "dependencies" {
  type = list(string)
}

variable "values" {
  default = ""
  type    = string
}
