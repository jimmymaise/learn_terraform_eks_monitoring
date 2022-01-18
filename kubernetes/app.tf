locals {
  wordpress_labels = {
    App  = "wordpress"
    Tier = "frontend"
  }
  mysql_labels     = {
    App  = "wordpress"
    Tier = "mysql"
  }
}


resource "kubernetes_secret" "mysql-pass" {
  metadata {
    name = "mysql-pass"
  }
  data = {
    password = "root"
  }
}


resource "kubernetes_deployment" "wordpress_web" {
  depends_on = [
    kubernetes_persistent_volume_claim.ebs_claim_for_wp_web
  ]
  metadata {
    name = "wordpress"
  }
  spec {
    replicas = 1
    selector {
      match_labels = local.wordpress_labels
    }
    template {
      metadata {
        labels = local.wordpress_labels
      }
      spec {
        container {
          image = "wordpress:4.8-apache"
          name  = "wordpress"
          port {
            container_port = 80
          }
          env {
            name  = "WORDPRESS_DB_HOST"
            value = "mysql-service"
          }
          env {
            name = "WORDPRESS_DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-pass"
                key  = "password"
              }
            }
          }
          volume_mount {
            mount_path = "/var/www/html"
            name       = "persistent-storage"
          }
        }
        volume {
          name = "persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.ebs_claim_for_wp_web.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wordpress_web-service" {
  metadata {
    name = "wordpress-service"
  }
  spec {
    selector = local.wordpress_labels
    port {
      port        = 80
      target_port = 80
      node_port   = 32000
    }
    type     = "NodePort"
  }
}


resource "kubernetes_ingress" "wordpress" {
  metadata {
    name        = "kube-ingress-wordpress"
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    backend {
      service_name = kubernetes_service.wordpress_web-service.metadata[0].name
      service_port = kubernetes_service.wordpress_web-service.spec[0].port[0].port
    }
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.wordpress_web-service.metadata[0].name
            service_port = kubernetes_service.wordpress_web-service.spec[0].port[0].port
          }
        }
      }
    }
  }
  wait_for_load_balancer = true
  depends_on             = [kubernetes_service.wordpress_web-service, helm_release.alb_load_balancer_controller]
}


resource "kubernetes_deployment" "wp_mysql" {
  depends_on = [
    kubernetes_persistent_volume_claim.ebs_claim_for_wp_mysql
  ]

  metadata {
    name = "mysql"
  }
  spec {
    replicas = 1
    selector {
      match_labels = local.mysql_labels
    }
    template {
      metadata {
        labels = local.mysql_labels
      }
      spec {
        container {
          image = "mysql:5.6"
          name  = "mysql"
          port {
            container_port = 3306
          }
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-pass"
                key  = "password"
              }
            }
          }
          volume_mount {
            mount_path = "/var/lib/mysql"
            name       = "persistent-storage"
          }
        }
        volume {
          name = "persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.ebs_claim_for_wp_mysql.metadata[0].name
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "wp_mysql-service" {
  metadata {
    name = "mysql-service"
  }
  spec {
    selector = local.mysql_labels
    port {
      port        = 3306
      target_port = 3306
    }
    type     = "NodePort"
  }
}