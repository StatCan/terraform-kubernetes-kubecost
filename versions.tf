terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">=1.0.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}
