locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

resource "helm_release" "istio-base" {
  name             = "istio-base"
  repository       = local.istio_charts_url
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = true

}
resource "helm_release" "istiod" {
  name       = "istiod"
  repository = local.istio_charts_url
  chart      = "istiod"
  namespace  = "istio-system"
  depends_on = [helm_release.istio-base]
}


resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }

    name = "istio-ingress"
  }
}

resource "helm_release" "istio-ingress" {
  repository = local.istio_charts_url
  chart      = "gateway"
  name       = "istio-ingress"
  namespace  = kubernetes_namespace.istio-ingress.id
  depends_on = [helm_release.istiod]
  set {
    name  = "service.type"
    value = "NodePort"
  }
}


