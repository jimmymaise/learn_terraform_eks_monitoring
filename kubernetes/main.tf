# Kubernetes provider
# https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster#optional-configure-terraform-kubernetes-provider
# To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/terraform/kubernetes/deploy-nginx-kubernetes

# The Kubernetes provider is included in this file so the EKS module can complete successfully. Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.
# You should **not** schedule deployments and services in this workspace. This keeps workspaces modular (one for provision EKS, another for scheduling Kubernetes resources) as per best practices.



resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "/usr/local/bin/aws eks --region ${var.region} update-kubeconfig --name ${var.eks_cluster_id}"
  }
}
resource "null_resource" "install_csi_driver" {
  provisioner "local-exec" {
    command = "/usr/local/bin/kubectl apply -k \"github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master\""
  }
  depends_on = [
    null_resource.update_kubeconfig
  ]
}

resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {

    mapUsers = <<YAML
- userarn: "arn:aws:iam::604787518005:user/jimmymai"
  username: "jimmymai"
  groups:
    - system:masters
YAML

    //    mapRoles = {
    //      rolearn = "arn:aws:iam::123456789:user/diego"
    //      username = "devops"
    //      groups = [
    //        "system:masters"]
    //    }
  }

}





