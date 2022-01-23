data "aws_caller_identity" "current" {}
//[AWS side] Download IAM policy for the AWS Load Balancer Controller
data "http" "iam_policy" {
  url             = "https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/main/docs/install/iam_policy.json"
  request_headers = {
    Accept = "application/json"
  }
}

//[AWS side] Create an IAM policy called AWSLoadBalancerControllerIAMPolicy using downloaded policy document
resource "aws_iam_policy" "aws_load_balancer_controller_iam_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = data.http.iam_policy.body
}


//[AWS side] Make assume role policy document

data "aws_iam_policy_document" "elb_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.eks_oidc_url, "https://", "")}"
      ]
      type        = "Federated"
    }
  }
}

//[AWS side] Create iam role AmazonEKSLoadBalancerControllerRole and with the created assumed role document
resource "aws_iam_role" "eks_lb_controller" {
  assume_role_policy = data.aws_iam_policy_document.elb_assume_role_policy.json
  name               = "AmazonEKSLoadBalancerControllerRole"
}


//[AWS side] Add policy AWSLoadBalancerControllerIAMPolicy to this role iam role AmazonEKSLoadBalancerControllerRole
resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_iam_policy" {
  policy_arn = aws_iam_policy.aws_load_balancer_controller_iam_policy.arn
  role       = aws_iam_role.eks_lb_controller.name
}


//[Kube side] Create a load balance service having aws iam created above.
resource "kubernetes_service_account" "load_balancer_Controller" {
  automount_service_account_token = true
  metadata {
    name        = "aws-load-balancer-controller"
    namespace   = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_lb_controller.arn
    }
    labels      = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

//[Kube side] Create a kubernetes cluster role named load balancer controller. This role can have some permission to
//communicate with kubernetes api
resource "kubernetes_cluster_role" "load_balancer_Controller" {
  metadata {
    name = "aws-load-balancer-controller"

    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs      = ["create", "get", "list", "update", "watch", "patch"]
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}
//[Kube] Add service account to the role so that it has permisson in kube
resource "kubernetes_cluster_role_binding" "load_balancer_Controller" {
  metadata {
    name = "aws-load-balancer-controller"

    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.load_balancer_Controller.metadata[0].name
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.load_balancer_Controller.metadata[0].name
  }
  depends_on = [kubernetes_cluster_role.load_balancer_Controller]
}


//[Kube] Create alb_load_balancer_controller with the created service account

resource "helm_release" "alb_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  atomic     = true

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "region"
    value = var.region
  }
  set {
    name  = "vpcId"
    value = var.vpc_id
  }
    depends_on = [kubernetes_cluster_role_binding.load_balancer_Controller]
}

