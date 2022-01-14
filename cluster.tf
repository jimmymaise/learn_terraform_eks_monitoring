locals {
  cluster_name = "testapp-eks-cluster"
}

module "vpc" {
  source = "./vpc"

  name = var.name
  environment = var.environment
  cidr = var.cidr

  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  availability_zones = var.availability_zones

}

module "security_groups" {
  source = "./security-groups"
  name = var.name
  environment = var.environment
  vpc_id = module.vpc.id
}


module "eks" {
  source = "./aws-eks"
  vpc_id = module.vpc.id
  cidr = var.cidr
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  availability_zones = var.availability_zones
  eks_cluster_sg_id = module.security_groups.eks_cluster_sg_id

}


//module "eks" {
//  map_users = [{
//    groups= ["system:masters"],
//    userarn="arn:aws:iam::604787518005:root",
//    username: "jimmymai"
//  }
//  ]
//  source = "terraform-aws-modules/eks/aws"
//  version         = "17.24.0"
//  cluster_version = "1.20"
//  cluster_name = local.cluster_name
//  vpc_id = module.vpc.id
//  subnets = module.vpc.private_subnets
//
//
//  workers_group_defaults = {
//    root_volume_type = "gp2"
//  }
//
//  worker_groups = [
//    {
//      name                          = "worker-group-1"
//      instance_type                 = "t2.medium"
//      additional_userdata           = "echo foo bar"
//      additional_security_group_ids = [module.security_groups.worker_group_mgmt_one_id]
//      asg_max_size          = 1
//    },
//    {
//      name                          = "worker-group-2"
//      instance_type                 = "t2.medium"
//      additional_userdata           = "echo foo bar"
//      additional_security_group_ids = [module.security_groups.worker_group_mgmt_two_id]
//      asg_max_size          = 1
//    }]
//
//}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}



