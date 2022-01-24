#
# Variables Configuration
#

variable "region" {
  default = "us-east-1"
}

variable cluster_name {
}

variable "eks-version" {
  default = "1.16"
}

variable "vpc_id" {
  description = "The VPC ID"
}


variable "cidr" {
  description = "The CIDR block for the VPC."
}
variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}

variable "eks_cluster_sg_id" {
  description = "eks_cluster_sg_id"
}

variable "worker_groups" {
  description = "worker_groups"
}
