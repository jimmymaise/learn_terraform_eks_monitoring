### blog page frontend
resource "kubernetes_service" "blog_page" {

  metadata {
    name      = "blog-page"
    namespace = kubernetes_namespace.istio-ingress.id
  }
  spec {

    port {
      port     = 5000
      name = "http"
    }
    selector = {
      app = "blog_page"
    }

  }
}


resource "kubernetes_deployment" "blog_page_v1" {
  metadata {
    name      = "blog-page-v1"
    namespace = kubernetes_namespace.istio-ingress.id
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app     = "blog_page"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "blog_page"
          version = "v1"
        }
      }
      spec {
        container {
          image             = "thiv17/blog-service:v1"
          name              = "blog-page"
          image_pull_policy = "Always"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "blog_page_v2" {
  metadata {
    name      = "blog-page-v2"
    namespace = kubernetes_namespace.istio-ingress.id

  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app     = "blog_page"
        version = "v2"
      }
    }
    template {
      metadata {
        labels = {
          app     = "blog_page"
          version = "v2"
        }
      }
      spec {
        container {
          image             = "thiv17/blog-service:v2"
          name              = "blog-page"
          image_pull_policy = "Always"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}
### blog api server

resource "kubernetes_service" "blog_api" {
  metadata {
    name      = "blog-api"
    namespace = kubernetes_namespace.istio-ingress.id

  }
  spec {

    port {
      port     = 5000
      name = "http"
    }
    selector = {
      app = "blog_api"
    }

  }
}

resource "kubernetes_deployment" "blog_api_v1" {
  metadata {
    name      = "blog-api-v1"
    namespace = kubernetes_namespace.istio-ingress.id
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app     = "blog_api"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "blog_api"
          version = "v1"
        }
      }
      spec {
        container {
          image             = "thiv17/bpi-service:latest"
          name              = "blog-api"
          image_pull_policy = "Always"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}


resource "kubernetes_ingress" "istio-app" {
  metadata {
    name        = "istio-app"
    namespace   = kubernetes_namespace.istio-ingress.id
    annotations = {
      "kubernetes.io/ingress.class" = "istio"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.blog_page.metadata[0].name
            service_port = kubernetes_service.blog_page.spec[0].port[0].port
          }
        }
      }
    }
  }
}
