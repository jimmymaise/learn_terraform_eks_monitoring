//todo Remove all hard code. Should be configurable and reusable

# IAM role allowing Kubernetes actions to access other AWS services
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
  role       = aws_iam_role.eks_worknode.name
}

resource "aws_iam_role_policy_attachment" "worknode-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worknode.name
}

resource "aws_iam_role_policy_attachment" "worknode-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worknode.name
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
  role       = aws_iam_role.eks_worknode.name
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlQk+ars+utu+TNbcXv7ZyTUF9FM5Lv58HvCCpR0oCZm3PTunMVzS04d7S9UBnC2e8UFCyWkqqn7dacve6+EGoZlwjevffZ/Mj0MM8NBQI2CPxKF6grn6zfhL/seQzCpn9Agoo3mN8E5Dz2upi0ii8oabs1xHJAJFC9DhbiSXpjdI925e1Vi/cDt0S8NLagmg1lxrlI/5xcfjfGn1qyqBgBUWOK4aCBR0CbNJkFa9pp8kclES9+8B/tiJfGF4y+w7rJApZFp3CofFtbpj74R5bH+raGHIzQ/ZqjrM0GbqVZfz2g2xjLfRiPkIUWpcJvdUKY051ywsjwb08toTNUsdP duyetmai@ip-172-24-0-206.us-west-2.compute.internal"
}


#EKS Node Group to launch worker nodes
resource "aws_eks_node_group" "eks-worknode-groups" {
  for_each        = var.worker_groups
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-worknode-group-${each.key}"
  node_role_arn   = aws_iam_role.eks_worknode.arn
  subnet_ids      = each.value["subnet_ids"]
  instance_types  = each.value["instance_types"]
  remote_access {
    ec2_ssh_key = each.value["ec2_ssh_key"]
  }

  scaling_config {
    desired_size = each.value["asg_desired_size"]
    max_size     = each.value["asg_max_size"]
    min_size     = each.value["asg_min_size"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.worknode-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worknode-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.worknode-AmazonEC2ContainerRegistryReadOnly,
  ]
}




