resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "prometheus"
  create_namespace = true

  set {
    name  = "alertmanager.persistentVolume.storageClass"
    value = "gp2"
  }
  set {
    name  = "server.persistentVolume.storageClass"
    value = "gp2"
  }
  depends_on = [kubernetes_cluster_role_binding.load_balancer_Controller]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "grafana"
  create_namespace = true

  set {
    name  = "persistence.storageClassName"
    value = "gp2"
  }
  set {
    name  = "persistence.enable"
    value = true
  }
  set {
    name  = "adminPassword"
    value = "justForTest"
  }

    set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  values     = [
    file("kubernetes/yaml/grafana/grafana_helm_values.yaml")
  ]
}