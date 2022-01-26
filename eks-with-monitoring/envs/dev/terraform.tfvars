name                = "demo"
environment         = "dev"
region              = "us-west-2"
aws-region          = "us-west-2"
cluster_name        = "testapp-eks-cluster"
availability_zones  = ["us-west-2a", "us-west-2b", "us-west-2c"]
cidr                = "10.0.0.0/16"
private_subnets     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
public_subnets      = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
tsl_certificate_arn = "arn:aws:acm:us-west-2:604787518005:certificate/73717297-b383-429b-b177-6db06ef8ace3"

