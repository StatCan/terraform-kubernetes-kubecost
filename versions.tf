terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 1.3.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.10.0"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}
