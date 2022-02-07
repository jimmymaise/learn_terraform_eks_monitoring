resource "kubernetes_deployment" "quote_fe_v1" {
  metadata {
    name = "quote-fe-v1"
  }
  spec {
    replicas = 1
    selector {
      match_labels = local.quote_fe_v1_labels
    }
    template {
      metadata {
        labels = local.quote_fe_v1_labels
      }
      spec {
        container {
          image = "604787518005.dkr.ecr.us-west-2.amazonaws.com/prod-ecr-quote-fe-v1"
          name  = "quote-fe-v1"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "quote_fe_v1_autoscaler" {
  metadata {
    name = "test"
  }

  spec {
    min_replicas = 2
    max_replicas = 10

    scale_target_ref {
      kind = "Deployment"
      name = "quote-fe-v1"
    }
    metric {
      type = "resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 20
        }
      }
    }

    behavior {
      scale_down {
        stabilization_window_seconds = 300
        select_policy                = "Min"
        policy {
          period_seconds = 120
          type           = "Pods"
          value          = 1
        }

        policy {
          period_seconds = 310
          type           = "Percent"
          value          = 30
        }
      }
    }
  }
}