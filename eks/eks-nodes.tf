#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "eks_worknode" {
  name = "${var.cluster_name}-worknode"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "worknode-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks_worknode.name
}

resource "aws_iam_role_policy_attachment" "worknode-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks_worknode.name
}

resource "aws_iam_role_policy_attachment" "worknode-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks_worknode.name
}


resource "aws_iam_policy" "eks_worknode_ebs_policy" {
  name = "Amazon_EBS_CSI_Driver"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}
# And attach the new policy
resource "aws_iam_role_policy_attachment" "worknode-AmazonEBSCSIDriver" {
  policy_arn = aws_iam_policy.eks_worknode_ebs_policy.arn
  role = aws_iam_role.eks_worknode.name
}

resource "aws_eks_node_group" "eks-worknode-group-1" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-worknode-group"
  node_role_arn = aws_iam_role.eks_worknode.arn
  subnet_ids = var.public_subnets
  //  remote_access {
  //    ec2_ssh_key = var.ssh_key_name
  //  }

  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worknode-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worknode-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.worknode-AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_eks_node_group" "eks-worknode-group-2" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-worknode-group-2"
  node_role_arn = aws_iam_role.eks_worknode.arn
  subnet_ids = var.public_subnets
  //  remote_access {
  //    ec2_ssh_key = var.ssh_key_name
  //  }

  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worknode-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worknode-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.worknode-AmazonEC2ContainerRegistryReadOnly,
  ]
}


