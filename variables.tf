variable "helm_namespace" {}

variable "helm_repository" {}
variable "helm_repository_password" {
  default = ""
}
variable "helm_repository_username" {
  default = ""
}

variable "chart" {
  default = "cost-analyzer"
}

variable "chart_version" {
  default = "1.86.0"
}

variable "values" {
  default = ""
  type    = string
}
