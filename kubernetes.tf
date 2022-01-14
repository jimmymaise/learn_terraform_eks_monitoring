# Kubernetes provider
# https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster#optional-configure-terraform-kubernetes-provider
# To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/terraform/kubernetes/deploy-nginx-kubernetes

# The Kubernetes provider is included in this file so the EKS module can complete successfully. Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.
# You should **not** schedule deployments and services in this workspace. This keeps workspaces modular (one for provision EKS, another for scheduling Kubernetes resources) as per best practices.


provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint
  token = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [module.eks]
  provisioner "local-exec" {
    command = "/usr/local/bin/aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_id}"
  }
}
resource "null_resource" "install_scsi_driver" {
  provisioner "local-exec" {
    command = "/usr/local/bin/kubectl apply -k \"github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master\""
  }
  depends_on = [null_resource.update_kubeconfig]
}

//resource "kubernetes_config_map" "aws_auth_configmap" {
//  metadata {
//    name = "aws-auth"
//    namespace = "kube-system"
//  }
//
//  data = {
//
//    mapUsers =  <<YAML
//- userarn: "arn:aws:iam::604787518005:user/jimmymai"
//  username: "jimmymai"
//  groups:
//    - system:masters
//YAML
//
////    mapRoles = {
////      rolearn = "arn:aws:iam::123456789:user/diego"
////      username = "devops"
////      groups = [
////        "system:masters"]
////    }
//  }
//
//}


locals {
  wordpress_labels = {
    App = "wordpress"
    Tier = "frontend"
  }
  mysql_labels = {
    App = "wordpress"
    Tier = "mysql"
  }
}

resource "kubernetes_storage_class" "ebs" {
  depends_on = [null_resource.install_scsi_driver]
  metadata {
    name = "ebs-sc1"
  }
  storage_provisioner = "ebs.csi.aws.com"
  parameters = {
    type = "gp2"
  }
  mount_options = [
    "debug"]
  volume_binding_mode = "Immediate"
}


resource "kubernetes_persistent_volume_claim" "ebs_claim" {
  depends_on = [null_resource.install_scsi_driver]
  metadata {
    name = "ebs-claim1"
  }

  spec {
    storage_class_name = kubernetes_storage_class.ebs.metadata[0].name
    access_modes = [
      "ReadWriteOnce"]
    resources {
      requests = {
        storage = "4Gi"
      }
    }
    volume_name = kubernetes_storage_class.ebs.metadata[0].name
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



resource "kubernetes_deployment" "wordpress" {
  depends_on = [null_resource.install_scsi_driver]
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
          name = "wordpress"
          port {
            container_port = 80
          }
          env {
            name = "WORDPRESS_DB_HOST"
            value = "mysql-service"
          }
          env {
            name = "WORDPRESS_DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-pass"
                key = "password"
              }
            }
          }
          volume_mount {
            mount_path = "/data"
            name = "persistent-storage"
          }
        }
        volume {
          name="persistent-storage"
          persistent_volume_claim {
            claim_name=kubernetes_persistent_volume_claim.ebs_claim.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wordpress-service" {
  depends_on = [null_resource.install_scsi_driver]
  metadata {
    name = "wordpress-service"
  }
  spec {
    selector = local.wordpress_labels
    port {
      port = 80
      target_port = 80
      node_port = 32000
    }
    type = "NodePort"
  }
}

resource "kubernetes_deployment" "mysql" {
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
          name = "mysql"
          port {
            container_port = 3306
          }
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-pass"
                key = "password"
              }
            }
          }
          volume_mount {
            mount_path = "/data"
            name = "persistent-storage"
          }
        }
        volume {
          name="persistent-storage"
          persistent_volume_claim {
            claim_name=kubernetes_persistent_volume_claim.ebs_claim.metadata[0].name
          }
        }
      }
    }
  }
}
  resource "kubernetes_service" "mysql-service" {
    metadata {
      name = "mysql-service"
    }
    spec {
      selector = local.mysql_labels
      port {
        port = 3306
        target_port = 3306
      }
      type = "NodePort"
    }
  }