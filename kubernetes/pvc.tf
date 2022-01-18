resource "kubernetes_storage_class" "ebs" {
  depends_on          = [
    null_resource.install_csi_driver
  ]
  volume_binding_mode = "WaitForFirstConsumer"
  metadata {
    name = "ebs-sc"
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
  parameters          = {
    type = "gp2"
  }
  mount_options       = [
    "debug"
  ]
}


resource "kubernetes_persistent_volume_claim" "ebs_claim_for_wp_web" {
  depends_on       = [
    null_resource.install_csi_driver
  ]
  metadata {
    name = "ebs-claim-for-wp-web"
  }
  wait_until_bound = false
  spec {
    storage_class_name = kubernetes_storage_class.ebs.metadata[0].name
    access_modes       = [
      "ReadWriteOnce"
    ]
    resources {
      requests = {
        storage = "4Gi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "ebs_claim_for_wp_mysql" {
  depends_on       = [
    null_resource.install_csi_driver
  ]
  metadata {
    name = "ebs-claim-for-wp-mysql"
  }
  wait_until_bound = false
  spec {
    storage_class_name = kubernetes_storage_class.ebs.metadata[0].name
    access_modes       = [
      "ReadWriteOnce"
    ]
    resources {
      requests = {
        storage = "4Gi"
      }
    }
  }
}
