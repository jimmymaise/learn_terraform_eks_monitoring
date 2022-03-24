locals {
  name_space = "my_name_space"
}

resource "kubernetes_service_account" "get_list_pods" {
  metadata {
    name      = "sa-list-pods"
    namespace = local.name_space
    #    annotations = {
    #      "eks.amazonaws.com/role-arn" = var.role_arn
    #    }
  }

  automount_service_account_token = true

}

resource "kubernetes_role" "get_list_pods" {
  metadata {
    name   = "get-list-pods"
    namespace : local.name_space
    labels = {
      test = "MyRole"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_role_binding" "get_list_pods" {
  metadata {
    name      = "get-list-pods"
    namespace = local.name_space
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.get_list_pods.metadata.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.get_list_pods.metadata.name
    namespace = local.name_space
  }
}
