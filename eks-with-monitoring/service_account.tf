#Test command
# kubectl auth can-i list pods --as=system:serviceaccount:my-name-space:sa-list-pods -n my-name-space

locals {
  name_space           = "my-name-space"
  service_account_name = "sa-list-pods"
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
    }

    name = local.name_space
  }
}

resource "kubernetes_service_account" "get_list_pods" {
  metadata {
    name      = local.service_account_name
    namespace = local.name_space
    #    annotations = {
    #      "eks.amazonaws.com/role-arn" = var.role_arn
    #    }
  }

  automount_service_account_token = true

}

resource "kubernetes_role" "get_list_pods" {
  metadata {
    name      = "get-list-pods"
    namespace = local.name_space
    labels    = {
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
    name      = kubernetes_role.get_list_pods.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.get_list_pods.metadata[0].name
    namespace = local.name_space
  }
}
