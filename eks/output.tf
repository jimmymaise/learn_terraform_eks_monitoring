output "cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}
output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}
output "cluster_security_group_id" {
  value = var.eks_cluster_sg_id
}


output "oidc_url" {
  value = data.tls_certificate.certificate.url
}

output "ca_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority.0.data
}

