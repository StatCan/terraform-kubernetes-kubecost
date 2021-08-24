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
  default = "1.85.1"
}

variable "values" {
  default = ""
  type    = string
}
