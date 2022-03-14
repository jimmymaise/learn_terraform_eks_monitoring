#resource "kubernetes_config_map" "grafana_config_map" {
#  metadata {
#    name = "grafana-config-map"
#  }
#
#  data = {
#    "my_config_file.yml" = file("kubernetes/yaml/grafana/config.yaml")
#  }
#
#}

resource "helm_release" "metric-server" {
  name       = "metric-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  namespace = "kube-system"
  set {
    name  = "apiService.create"
    value = "true"
  }
}


resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "prometheus"
  create_namespace = true

  set {
    name  = "alertmanager.persistentVolume.storageClass"
    value = kubernetes_storage_class.ebs.metadata[0].name
  }
  set {
    name  = "server.persistentVolume.storageClass"
    value = kubernetes_storage_class.ebs.metadata[0].name
  }
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "grafana"
  create_namespace = true
  set {
    name  = "persistence.storageClassName"
    value = kubernetes_storage_class.ebs.metadata[0].name
  }
  set {
    name  = "persistence.enable"
    value = true
  }
  set {
    name  = "adminPassword"
    value = var.grafana_pass
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  values     = [
    file("../modules/kubernetes/yaml/grafana/values.yaml")
  ]
#  depends_on = [helm_release.prometheus]

}