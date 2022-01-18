variable "vpc_id" {
  description = "The VPC ID"
}

variable "eks_cluster_id" {
  type        = string
  description = "EKS Cluster cluster_id"

}

variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster cluster name"

}
variable "region" {
  default = "us-east-1"
}
variable "eks_cluster_endpoint" {
  type        = string
  description = "EKS Cluster Endpoint"
}

variable "eks_oidc_url" {
  type        = string
  description = "EKS Cluster OIDC Provider URL"
}

variable "eks_ca_certificate" {
  type        = string
  description = "EKS Cluster CA Certificate"
}