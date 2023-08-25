resource "helm_release" "kubecost" {
  name                = "kubecost"
  repository          = var.helm_repository.name
  repository_username = var.helm_repository.username
  repository_password = sensitive(var.helm_repository.password)
  chart               = "cost-analyzer"
  version             = var.chart_version
  namespace           = var.namespace

  timeout = 2400

  values = [
    <<END_OF_SENSITIVE
global:
  %{if length(var.notifications.global_slack_webhook_url) > 0}
  notifications:
    alertConfigs:
      globalSlackWebhookUrl: ${sensitive(var.notifications.global_slack_webhook_url)}
  %{endif~}

kubecostToken: "${sensitive(var.product_configs.token)}"
kubecostProductConfigs:
  productKey:
    enabled: true
    key: ${sensitive(var.product_configs.product_key)}
  azureSubscriptionID: ${sensitive(var.product_configs.azure.subscription_id)}
  azureClientID: ${sensitive(var.product_configs.azure.client_id)}
  azureClientPassword: ${sensitive(var.product_configs.azure.client_password)}
  azureTenantID: ${sensitive(var.product_configs.azure.tenant_id)}
  azureOfferDurableID: ${sensitive(var.product_configs.azure.offer_durable_id)}
END_OF_SENSITIVE
    ,
    <<END_OF_VALUES
global:
  prometheus:
    enabled: false
    fqdn: ${var.prometheus.fqdn}
  grafana:
    enabled: false
    domainName: ${var.grafana.domain_name}
    proxy: false
  %{if length(var.notifications.global_slack_webhook_url) > 0 || length(var.notifications.alerts) > 0}
  notifications:
    alertConfigs:
      alerts:
        ${trimspace(indent(8, var.notifications.alerts))}
  %{endif~}

%{if length(var.image_pull_secret_names) > 0~}
imagePullSecrets:
  ${indent(2, yamlencode([for name in var.image_pull_secret_names : { name : name }]))}
%{endif~}
%{if var.hubs.gcr != ""~}
kubecostFrontend:
  image: "${var.hubs.gcr}kubecost1/frontend"
kubecost:
  image: "${var.hubs.gcr}kubecost1/server"
kubecostModel:
  image: "${var.hubs.gcr}kubecost1/cost-model"
remoteWrite:
  postgres:
    initImage: "${var.hubs.gcr}kubecost1/sql-init"
networkCosts:
  image: "${var.hubs.gcr}kubecost1/kubecost-network-costs:v0.16.7"
clusterController:
  image: "${var.hubs.gcr}kubecost1/cluster-controller:v0.11.0"
%{endif~}
%{if var.hubs.dockerhub != ""~}
initChownDataImage: "${var.hubs.dockerhub}busybox"
%{endif~}

ingress:
  enabled: ${var.ingress.enabled}
  hosts: ${jsonencode(var.ingress.hosts)}
  paths:
  - /
  pathType: Prefix

%{if length(var.tolerations) > 0~}
tolerations: ${jsonencode(var.tolerations)}
%{endif~}
%{if length(var.node_selector) > 0}
nodeSelector: ${jsonencode(var.node_selector)}
%{endif~}

grafana:
  sidecar:
    dashboards:
      enabled: true
    datasources:
      enabled: false

# https://github.com/kubecost/cost-analyzer-helm-chart/blob/8f3381a81fc43be6c3a536992be12dad2f965b48/cost-analyzer/values.yaml#L997
kubecostProductConfigs:
  clusterName: "${var.product_configs.cluster_name}"
  clusterProfile: ${var.product_configs.cluster_profile}
  currencyCode: "CAD"
  azureBillingRegion: CA
  createServiceKeySecret: true
  grafanaURL: ${var.product_configs.grafana_url}
  labelMappingConfigs:
    enabled: true
    owner_label: "project.statcan.gc.ca/lead"
    team_label: "project.statcan.gc.ca/team"
    department_label: "project.statcan.gc.ca/division"
    product_label: "finance.statcan.gc.ca/workload-id"
    environment_label: "project.statcan.gc.ca/environment"
    %{if length(var.product_configs.extra_label_mapping_configs) > 0}${indent(4, yamlencode(var.product_configs.extra_label_mapping_configs))}%{endif}
  gpuLabel: "node.statcan.gc.ca/use"
  gpuLabelValue: "gpu"
  sharedNamespaces: "${join(",", var.product_configs.shared_namespaces)}"

serviceMonitor:
  enabled: ${var.prometheus.service_monitor.cost_analyzer.enabled}
  %{if var.prometheus.service_monitor.cost_analyzer.metric_relabelings != "" && var.prometheus.service_monitor.cost_analyzer.metric_relabelings != null}
  metricRelabelings:
    ${indent(4, var.prometheus.service_monitor.cost_analyzer.metric_relabelings)}
  %{endif~}

prometheusRule:
  enabled: ${var.prometheus.prometheus_rule.enabled}
END_OF_VALUES
  ]
}
