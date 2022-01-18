locals {
  cluster_name = "testapp-eks-cluster"
}

module "vpc" {
  source           = "./vpc"
  eks_cluster_name = var.cluster_name
  name             = var.name
  environment      = var.environment
  cidr             = var.cidr

  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones

}

module "security_groups" {
  source      = "./security-groups"
  name        = var.name
  environment = var.environment
  vpc_id      = module.vpc.id
}


module "eks" {

  source             = "./eks"
  vpc_id             = module.vpc.id
  cidr               = var.cidr
  public_subnets     = module.vpc.public_subnets
  private_subnets    = module.vpc.private_subnets
  availability_zones = var.availability_zones
  eks_cluster_sg_id  = module.security_groups.eks_cluster_sg_id
  cluster_name       = var.cluster_name

}

module "kubernetes" {
  source               = "./kubernetes"
  vpc_id               = module.vpc.id
  eks_cluster_id       = module.eks.cluster_id
  eks_cluster_name     = module.eks.cluster_name
  region               = var.region
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_url         = module.eks.oidc_url
  eks_ca_certificate   = module.eks.ca_certificate
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}



