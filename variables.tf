variable "namespace" {
  type        = string
  nullable    = false
  default     = "kubecost-system"
  description = "the namespace which should contain resource created by this helm release"
}

variable "helm_repository" {
  description = "The repository where the Helm chart is stored"
  type = object({
    name     = optional(string, "https://kubecost.github.io/cost-analyzer/")
    username = optional(string, "")
    password = optional(string, "")
  })

  default = {}
}

variable "chart_version" {
  default = "1.106.0"
}

variable "grafana" {
  type = object({
    domain_name = string
  })

  description = "Configurations for Grafana."
}

variable "image_pull_secret_names" {
  type    = list(string)
  default = []

  description = "The names of secrets containing the pull credentials of image repositories."
}

variable "ingress" {
  type = object({
    enabled     = optional(bool, true)
    hosts       = optional(list(string), [])
    annotations = optional(map(string), {})
  })

  description = "Configurations related to the Ingress."
}

variable "notifications" {
  type = object({
    global_slack_webhook_url = optional(string, "")
    alerts                   = optional(string, "")
  })

  default = {}
}

variable "prometheus" {
  type = object({
    fqdn = string
    prometheus_rule = optional(object({
      enabled = optional(bool, true)
    }), {})
    service_monitor = optional(object({
      cost_analyzer = optional(object({
        enabled            = optional(bool, true)
        metric_relabelings = optional(string, "")
      }), {})
    }), {})
  })
}

variable "product_configs" {
  type = object({
    azure = object({
      subscription_id  = string
      client_id        = string
      client_password  = string
      tenant_id        = string
      offer_durable_id = string
    })
    cluster_name                = string
    cluster_profile             = optional(string, "production")
    grafana_url                 = string
    extra_label_mapping_configs = optional(map(string), {})
    product_key                 = string
    shared_namespaces           = optional(list(string), [])
    token                       = string
  })

  description = "Configurations for the Kubecost instance."

  validation {
    condition     = contains(["development", "production", "high-availability"], var.product_configs.cluster_profile)
    error_message = "product_configs.cluster_profile must be one of [ development, production, high-availability ]."
  }
}

variable "hubs" {
  type = object({
    gcr       = optional(string, "")
    dockerhub = optional(string, "")
  })
  description = "The host to a hub. For example: gcr.io/"
  default     = {}

  validation {
    condition     = (var.hubs.gcr == "" || endswith(var.hubs.gcr, "/")) && (var.hubs.dockerhub == "" || endswith(var.hubs.dockerhub, "/"))
    error_message = "Hubs must end with a slash."
  }
}


variable "node_selector" {
  type        = map(string)
  default     = {}
  description = "The node labels which should be used for scheduling."
}

variable "tolerations" {
  type = list(object({
    effect             = optional(string)
    key                = optional(string)
    operator           = optional(string)
    toleration_seconds = optional(number)
    value              = optional(string)
    })
  )
  default = []

  validation {
    condition = alltrue([for t in var.tolerations : t.effect == null ? true : contains(["", "NoSchedule", "PreferNoSchedule", "NoExecute"], t.effect)])

    error_message = "Valid effects are one of: [null, \"\", NoSchedule, PreferNoSchedule, NoExecute]"
  }

  validation {
    condition     = alltrue([for t in var.tolerations : t.operator == null ? true : contains(["", "Equals", "Exists"], t.operator)])
    error_message = "Valid operators are Exists and Equal."
  }

  validation {
    condition     = alltrue([for t in var.tolerations : (t.key == "" || t.key == null) ? t.operator == "Exists" : true])
    error_message = "If key is empty, operator must be Exists."
  }

  validation {
    condition     = alltrue([for t in var.tolerations : t.operator == "Exists" ? t.value == "" || t.value == null : true])
    error_message = "If the operator is Exists, the value should be empty, otherwise just a regular string."
  }
}
